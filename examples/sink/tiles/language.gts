import { registerDestructor } from "@ember/destroyable"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import type { TOC } from "@ember/component/template-only"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Calendar as CalendarIcon, ChevronLeft, ChevronRight } from "lucide"
import { formatShortcut, matchesShortcut } from "@ui-sdk/core"
import { daysBetween, formatDateRange } from "@ui-sdk/core/date"
import { Calendar } from "ember-ui-sdk/calendar"
import { DatePicker } from "ember-ui-sdk/date-picker"
import { useShortcutHint, ariaKeyshortcuts } from "ember-ui-sdk/shortcuts"
import "../../../vendor/ui/apps/docs/app/sink/tiles/language.css"
import { icon } from "../icon.ts"
import type { Tile } from "../types.ts"

/* Shared bits */

const Kbd: TOC<{ Blocks: { default: [] } }> = <template>
  <kbd class="lg-kbd">{{yield}}</kbd>
</template>

/* 6. Calendar: a range for a stay */

class Stay extends Component {
  @tracked range: [string, string] | null = ["2026-11-12", "2026-11-16"]
  @tracked narrow = false

  constructor(owner: unknown, args: object) {
    super(owner as never, args)
    if (typeof matchMedia === "undefined") {
      return
    }
    const list = matchMedia("(max-width: 640px)")
    const sync = () => {
      this.narrow = list.matches
    }
    queueMicrotask(sync)
    list.addEventListener("change", sync)
    registerDestructor(this, () => list.removeEventListener("change", sync))
  }

  get months() {
    return this.narrow ? 1 : 2
  }

  get nights() {
    const { range } = this
    return range ? daysBetween(range[0], range[1]) : 0
  }

  get nightWord() {
    return this.nights === 1 ? " night" : " nights"
  }

  get dates() {
    const { range } = this
    return range
      ? formatDateRange(range[0], range[1], "en-GB")
      : "Pick check-in, then check-out"
  }

  onValueChange = (value: unknown) => {
    this.range =
      Array.isArray(value) && value.length === 2 ? [value[0], value[1]] : null
  }

  <template>
    <div class="lg-stay">
      <Calendar
        @mode="range"
        @months={{this.months}}
        @locale="en-GB"
        @weekStartsOn={{0}}
        @weekdayFormat="narrow"
        @fixedWeeks={{false}}
        @defaultMonth="2026-11"
        @value={{this.range}}
        @onValueChange={{this.onValueChange}}
        class="lg-cal"
        as |c|
      >
        <div class="lg-cal-head">
          <c.Previous class="lg-cal-nav" aria-label="Previous month">{{icon
              ChevronLeft
              14
            }}</c.Previous>
          <c.Heading class="lg-cal-heading" />
          <c.Next class="lg-cal-nav" aria-label="Next month">{{icon
              ChevronRight
              14
            }}</c.Next>
        </div>
        <div class="lg-cal-months">
          <c.Grid @offset={{0}} class="lg-cal-grid" as |grid|>
            <grid.Weekdays as |Weekday|>
              <Weekday class="lg-cal-weekday" />
            </grid.Weekdays>
            <grid.Weeks as |w|>
              <w.Day class="lg-cal-day" />
            </grid.Weeks>
          </c.Grid>
          {{#unless this.narrow}}
            <c.Grid @offset={{1}} class="lg-cal-grid" as |grid|>
              <grid.Weekdays as |Weekday|>
                <Weekday class="lg-cal-weekday" />
              </grid.Weekdays>
              <grid.Weeks as |w|>
                <w.Day class="lg-cal-day" />
              </grid.Weeks>
            </c.Grid>
          {{/unless}}
        </div>
      </Calendar>
      <div class="lg-stay-sum" aria-live="polite">
        <p class="lg-stay-place">Alfama, Lisbon</p>
        <p class="lg-stay-nights">
          {{this.nights}}<span>{{this.nightWord}}</span>
        </p>
        <p class="lg-stay-dates">{{this.dates}}</p>
      </div>
    </div>
  </template>
}

/* 7. Date Picker */

const Departure = <template>
  <DatePicker @locale="de-CH" @defaultValue="2026-12-18" class="lg-dp" as |dp|>
    <p class="lg-dp-label" id="lg-departure-label">Train from Zürich</p>
    <div class="lg-dp-field">
      <dp.Input aria-labelledby="lg-departure-label" class="lg-dp-input" />
      <dp.Trigger class="lg-dp-trigger" aria-label="Open calendar">{{icon
          CalendarIcon
          16
        }}</dp.Trigger>
    </div>
    <dp.Hint class="lg-dp-hint" as |h|>Type it like
      {{h.state.example}}</dp.Hint>
    <dp.Content class="b-pop lg-dp-pop">
      <div class="lg-cal-head">
        <dp.Previous class="lg-cal-nav" aria-label="Previous month">{{icon
            ChevronLeft
            16
          }}</dp.Previous>
        <dp.Heading class="lg-cal-heading" />
        <dp.Next class="lg-cal-nav" aria-label="Next month">{{icon
            ChevronRight
            16
          }}</dp.Next>
      </div>
      <dp.Grid class="lg-cal-grid" as |grid|>
        <grid.Weekdays as |Weekday|>
          <Weekday class="lg-cal-weekday" />
        </grid.Weekdays>
        <grid.Weeks as |w|>
          <w.Day class="lg-cal-day lg-dp-day" />
        </grid.Weeks>
      </dp.Grid>
    </dp.Content>
  </DatePicker>
</template>

/* 16. Shortcuts per platform */

const SHORTCUTS = [
  { keys: "mod+d", label: "Fill down" },
  { keys: "mod+;", label: "Insert today" },
  { keys: "mod+shift+l", label: "Toggle filters" },
]

class Shortcuts extends Component {
  @tracked chosen: boolean | null = null
  @tracked hit: string | null = null
  detected = useShortcutHint("mod+k")
  timer: ReturnType<typeof setTimeout> | undefined

  constructor(owner: unknown, args: object) {
    super(owner as never, args)
    registerDestructor(this, () => clearTimeout(this.timer))
  }

  get apple() {
    return this.chosen ?? this.detected.ariaKeyshortcuts.startsWith("Meta")
  }

  get rows() {
    return SHORTCUTS.map((item) => ({
      ...item,
      aria: ariaKeyshortcuts(item.keys, this.apple),
      hit: this.hit === item.label,
      caps: this.capsOf(item.keys),
    }))
  }

  get message() {
    return this.hit ? `${this.hit} matched` : "Focus a row, then press its keys"
  }

  capsOf(shortcut: string) {
    const { apple } = this
    // The label is wrapped in direction isolates so it reads left to right; keycaps don't need them.
    const label = formatShortcut(shortcut, apple).replace(/[‎‏⁦-⁩]/g, "")
    return (apple ? [...label] : label.split("+")).filter(Boolean)
  }

  setApple = (apple: boolean) => {
    this.chosen = apple
  }

  flash = (label: string) => {
    this.hit = label
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      this.hit = null
    }, 900)
  }

  onKeyDown = (event: KeyboardEvent) => {
    const match = SHORTCUTS.find((item) =>
      matchesShortcut(event, item.keys, this.apple)
    )
    if (!match) {
      return
    }
    event.preventDefault()
    this.flash(match.label)
  }

  <template>
    {{! template-lint-disable no-invalid-interactive }}
    <div class="lg-sc" {{on "keydown" this.onKeyDown}}>
      <div class="lg-sc-platforms" role="group" aria-label="Platform">
        <button
          type="button"
          class="lg-sc-platform"
          aria-pressed={{if this.apple "true" "false"}}
          {{on "click" (fn this.setApple true)}}
        >Mac</button>
        <button
          type="button"
          class="lg-sc-platform"
          aria-pressed={{if this.apple "false" "true"}}
          {{on "click" (fn this.setApple false)}}
        >Windows</button>
      </div>
      <ul class="lg-sc-list">
        {{#each this.rows key="keys" as |item|}}
          <li>
            <button
              type="button"
              class="lg-sc-row"
              aria-keyshortcuts={{item.aria}}
              data-hit={{if item.hit ""}}
              {{on "click" (fn this.flash item.label)}}
            >
              <span>{{item.label}}</span>
              <span class="lg-sc-caps" aria-hidden="true">
                {{#each item.caps key="@index" as |cap|}}
                  <Kbd>{{cap}}</Kbd>
                {{/each}}
              </span>
            </button>
          </li>
        {{/each}}
      </ul>
      <p class="lg-hint" aria-live="polite">{{this.message}}</p>
    </div>
  </template>
}

export const tiles: Tile[] = [
  {
    id: "language-stay",
    title: "Book the stay.",
    blurb: "A two-month range with a live night count.",
    size: "wide",
    tone: "sky",
    Demo: Stay,
  },
  {
    id: "language-departure",
    title: "Type or pick.",
    blurb: "Swiss date order, calendar on demand.",
    Demo: Departure,
  },
  {
    id: "language-shortcuts",
    title: "Shortcuts per platform.",
    blurb: "⌘ on a Mac, Ctrl elsewhere.",
    Demo: Shortcuts,
  },
]
