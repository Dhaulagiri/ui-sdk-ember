import { fn } from "@ember/helper"
import { registerDestructor } from "@ember/destroyable"
import { on } from "@ember/modifier"
import { htmlSafe } from "@ember/template"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { AlarmClock } from "lucide"
import {
  bindScrollPicker,
  createPointerKind,
  isFocusFromKeyboard,
  sourceOf,
} from "@ui-sdk/core"
import { clamp } from "@ui-sdk/core/number"
import { Listbox } from "ember-ui-sdk/listbox"
import { usePreference } from "ember-ui-sdk/preferences"
import "../../../vendor/ui/apps/docs/app/sink/tiles/gestures.css"
import { icon } from "../icon.ts"
import { onInsert } from "../on-insert.ts"
import type { Tile } from "../types.ts"

/* 3. Alarm wheels: bindScrollPicker */

const HOURS = Array.from({ length: 12 }, (_, index) => String(index + 1))
const MINUTES = Array.from({ length: 12 }, (_, index) =>
  String(index * 5).padStart(2, "0")
)
const PERIODS = ["AM", "PM"]

class Wheel extends Component<{
  Args: {
    label: string
    options: string[]
    value: string
    onValueChange: (value: string) => void
  }
}> {
  bind = (list: HTMLElement) =>
    bindScrollPicker(list, {
      onSelect: (index) => this.args.onValueChange(this.args.options[index]),
    })

  onValueChange = (next: string | null) => {
    if (next) {
      this.args.onValueChange(next)
    }
  }

  <template>
    <Listbox
      class="gs-wheel"
      aria-label={{@label}}
      @keepInView={{false}}
      @value={{@value}}
      @onValueChange={{this.onValueChange}}
      {{onInsert this.bind}}
      as |l|
    >
      {{#each @options key="@identity" as |option|}}
        <l.Item @value={{option}} class="gs-wheel-item">
          {{option}}
        </l.Item>
      {{/each}}
    </Listbox>
  </template>
}

class AlarmWheels extends Component {
  @tracked hour = "7"
  @tracked minute = "30"
  @tracked period = "AM"
  hours = HOURS
  minutes = MINUTES
  periods = PERIODS

  setHour = (value: string) => {
    this.hour = value
  }
  setMinute = (value: string) => {
    this.minute = value
  }
  setPeriod = (value: string) => {
    this.period = value
  }

  <template>
    <div class="gs-alarm">
      <div class="gs-alarm-head">
        {{icon AlarmClock 14}}
        <span>
          Wake up at
          <strong>
            {{this.hour}}:{{this.minute}}
            {{this.period}}
          </strong>
        </span>
      </div>
      <div class="gs-wheels" dir="ltr">
        <Wheel
          @label="Hour"
          @options={{this.hours}}
          @value={{this.hour}}
          @onValueChange={{this.setHour}}
        />
        <span class="gs-wheels-colon" aria-hidden="true">
          :
        </span>
        <Wheel
          @label="Minute"
          @options={{this.minutes}}
          @value={{this.minute}}
          @onValueChange={{this.setMinute}}
        />
        <Wheel
          @label="AM or PM"
          @options={{this.periods}}
          @value={{this.period}}
          @onValueChange={{this.setPeriod}}
        />
      </div>
    </div>
  </template>
}

/* 5. Mention previews: createPointerKind, isFocusFromKeyboard */

const PEOPLE: Record<string, { name: string; role: string; time: string }> = {
  maya: { name: "Maya Chen", role: "Design lead", time: "4:12 PM in Lisbon" },
  jonas: {
    name: "Jonas Weber",
    role: "Infrastructure",
    time: "5:12 PM in Berlin",
  },
  priya: { name: "Priya Raman", role: "Product", time: "8:42 PM in Pune" },
}

const SOURCES: Record<string, string> = {
  mouse: "Opened by hover",
  touch: "Opened by tap",
  pen: "Opened by pen",
  keyboard: "Opened from the keyboard",
  virtual: "Opened by a virtual click",
}

const pointerKind = createPointerKind()

class MentionPreviews extends Component {
  kind = usePreference(this, pointerKind)
  thread: HTMLElement | null = null
  timer = 0
  cardId = "gs-card-" + Math.random().toString(36).slice(2, 8)
  @tracked open: string | null = null
  @tracked pinned = false
  @tracked person = "maya"
  @tracked place = { x: 0, y: 0, fresh: true }
  @tracked source: string | null = null

  clearOnDestroy = registerDestructor(this, () => clearTimeout(this.timer))

  setThread = (el: HTMLElement) => {
    this.thread = el
  }

  get hovers() {
    return this.kind.current.hover === "hover"
  }

  show = (target: HTMLElement, id: string, how: string, pin = false) => {
    clearTimeout(this.timer)
    const box = this.thread!
    const width = Math.min(232, box.clientWidth)
    this.place = {
      x: clamp(target.offsetLeft, 0, box.clientWidth - width),
      y: target.offsetTop + target.offsetHeight + 6,
      fresh: this.open === null,
    }
    this.person = id
    this.open = id
    this.pinned = pin
    this.source = how
  }

  close = () => {
    clearTimeout(this.timer)
    this.open = null
    this.pinned = false
  }

  closeSoon = () => {
    clearTimeout(this.timer)
    if (!this.pinned) {
      this.timer = window.setTimeout(this.close, 220)
    }
  }

  cancelClose = () => clearTimeout(this.timer)

  onPointerEnter = (id: string, event: PointerEvent) => {
    if (!this.hovers || event.pointerType !== "mouse" || this.pinned) {
      return
    }
    const target = event.currentTarget as HTMLElement
    clearTimeout(this.timer)
    this.timer = window.setTimeout(
      () => this.show(target, id, "mouse"),
      this.open ? 0 : 320
    )
  }

  onFocus = (id: string, event: FocusEvent) => {
    if (isFocusFromKeyboard()) {
      this.show(event.currentTarget as HTMLElement, id, "keyboard")
    }
  }

  onBlur = (event: FocusEvent) => {
    const next = event.relatedTarget
    if (!(next instanceof HTMLElement && next.matches(".gs-mention"))) {
      this.close()
    }
  }

  onClick = (id: string, event: MouseEvent) => {
    if (this.open === id && this.pinned) {
      this.close()
      return
    }
    this.show(event.currentTarget as HTMLElement, id, sourceOf(event), true)
  }

  onKeyDown = (event: KeyboardEvent) => {
    if (event.key === "Escape" && this.open) {
      this.close()
    }
  }

  expanded = (id: string) => (this.open === id ? "true" : "false")

  get hint() {
    const { hover } = this.kind.current
    return hover === "hover"
      ? "Hover a name to preview it. Click to pin."
      : hover === "none"
        ? "Tap a name to open it."
        : "Point at a name, tap it, or Tab to it."
  }

  get sourceText() {
    return this.source ? SOURCES[this.source] : null
  }

  get shown() {
    return PEOPLE[this.person]
  }

  get initials() {
    return this.shown.name
      .split(" ")
      .map((part) => part[0])
      .join("")
  }

  get cardStyle() {
    return htmlSafe(`translate: ${this.place.x}px ${this.place.y}px`)
  }

  <template>
    {{! template-lint-disable no-invalid-interactive }}
    <div
      class="gs-thread"
      {{onInsert this.setThread}}
      {{on "keydown" this.onKeyDown}}
    >
      <p class="gs-thread-hint">
        <span>{{this.hint}}</span>
        {{#if this.sourceText}}<span
            class="gs-thread-source"
          >{{this.sourceText}}</span>{{/if}}
      </p>
      <div class="gs-message">
        <span class="gs-message-avatar" aria-hidden="true">
          AL
        </span>
        <div class="gs-message-body">
          <span class="gs-message-meta">
            <strong>Alex Lindqvist</strong>
            10:24
          </span>
          <p class="gs-message-text">
            <button
              type="button"
              class="gs-mention"
              aria-expanded={{this.expanded "maya"}}
              aria-controls={{this.cardId}}
              {{on "pointerenter" (fn this.onPointerEnter "maya")}}
              {{on "pointerleave" this.closeSoon}}
              {{on "focus" (fn this.onFocus "maya")}}
              {{on "blur" this.onBlur}}
              {{on "click" (fn this.onClick "maya")}}
            >@Maya</button>
            can you check the new onboarding with
            <button
              type="button"
              class="gs-mention"
              aria-expanded={{this.expanded "jonas"}}
              aria-controls={{this.cardId}}
              {{on "pointerenter" (fn this.onPointerEnter "jonas")}}
              {{on "pointerleave" this.closeSoon}}
              {{on "focus" (fn this.onFocus "jonas")}}
              {{on "blur" this.onBlur}}
              {{on "click" (fn this.onClick "jonas")}}
            >@Jonas</button>
            before Friday?
            <button
              type="button"
              class="gs-mention"
              aria-expanded={{this.expanded "priya"}}
              aria-controls={{this.cardId}}
              {{on "pointerenter" (fn this.onPointerEnter "priya")}}
              {{on "pointerleave" this.closeSoon}}
              {{on "focus" (fn this.onFocus "priya")}}
              {{on "blur" this.onBlur}}
              {{on "click" (fn this.onClick "priya")}}
            >@Priya</button>
            has the launch checklist.
          </p>
        </div>
      </div>
      <div
        id={{this.cardId}}
        class="gs-card"
        data-open={{if this.open "" undefined}}
        data-fresh={{if this.place.fresh "" undefined}}
        aria-hidden={{if this.open "false" "true"}}
        style={{this.cardStyle}}
        {{on "pointerenter" this.cancelClose}}
        {{on "pointerleave" this.closeSoon}}
      >
        <span class="gs-card-avatar" aria-hidden="true">
          {{this.initials}}
        </span>
        <span class="gs-card-name">{{this.shown.name}}</span>
        <span class="gs-card-role">{{this.shown.role}}</span>
        <span class="gs-card-time">{{this.shown.time}}</span>
      </div>
    </div>
  </template>
}

const tiles: Tile[] = [
  {
    id: "motion-wheel",
    title: "Spin to the hour.",
    blurb: "Flick a wheel, or use the arrow keys.",
    tone: "ink",
    Demo: AlarmWheels,
  },
  {
    id: "motion-mentions",
    title: "Tap opens, hover previews.",
    blurb: "Mentions adapt to a mouse, a finger or the keys.",
    size: "wide",
    Demo: MentionPreviews,
  },
]

export { tiles }
