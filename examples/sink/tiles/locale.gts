import { registerDestructor } from "@ember/destroyable"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { guidFor } from "@ember/object/internals"
import { schedule } from "@ember/runloop"
import { htmlSafe } from "@ember/template"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  Bot,
  Check,
  ChevronDown,
  ClipboardPaste,
  Play,
  RotateCcw,
  X,
} from "lucide"
import { isRTL } from "@ui-sdk/core"
import {
  addDays,
  addMonths,
  addYears,
  clampDate,
  daysBetween,
  endOfMonth,
  endOfWeek,
  firstDayOfWeek,
  formatDate,
  formatDateRange,
  isSameMonth,
  monthGrid,
  startOfMonth,
  startOfWeek,
  todayDate,
  weekdayNames,
} from "@ui-sdk/core/date"
import {
  decimalsOf,
  formatNumber,
  formatNumberRange,
  formatNumberToParts,
  fractionOf,
  isPartialNumber,
  parseNumber,
  roundTo,
  scrubTo,
  stepBy,
  stepFromKey,
  valueAt,
  wrap,
} from "@ui-sdk/core/number"
import { createAgent, type AgentComponent } from "ember-ui-sdk/agent"
import { elementOf } from "ember-ui-sdk/observe"
import { Button } from "ember-ui-sdk/button"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { RadioGroup } from "ember-ui-sdk/radio"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"
import { Select } from "ember-ui-sdk/select"
import { Switch } from "ember-ui-sdk/switch"
import {
  createTokenInputController,
  fromText,
  toText,
  TokenInput,
  type TokenCodec,
  type TokenInputValue,
} from "ember-ui-sdk/token-input"
import "../../../vendor/ui/apps/docs/app/sink/tiles/locale.css"
import { icon } from "../icon.ts"
import { onInsert } from "../on-insert.ts"
import type { Tile } from "../types.ts"

class LocaleSwitch extends Component<{
  Args: {
    locales: readonly string[]
    value: string
    onChange: (locale: string) => void
  }
}> {
  onValueChange = (next: string | null) => {
    if (next) {
      this.args.onChange(next)
    }
  }

  <template>
    <SegmentedControl
      aria-label="Locale"
      class="lc-locales"
      @value={{@value}}
      @onValueChange={{this.onValueChange}}
      as |s|
    >
      <s.Indicator class="lc-locales-indicator" />
      {{#each @locales as |tag|}}
        <s.Item @value={{tag}} class="lc-locale">
          {{tag}}
        </s.Item>
      {{/each}}
    </SegmentedControl>
  </template>
}

/* 1. An amount typed the local way */

const AMOUNT_LOCALES = ["en-US", "de-DE", "fr-FR", "hi-IN"] as const
const CURRENCY_OF: Record<string, string> = {
  "en-US": "USD",
  "de-DE": "EUR",
  "fr-FR": "EUR",
  "hi-IN": "INR",
}

function separatorsOf(locale: string) {
  const parts = formatNumberToParts(1234567.5, locale)
  const shown = (type: string) => {
    const value = parts.find((part) => part.type === type)?.value ?? ""
    return value.trim() ? value : "space"
  }
  return { group: shown("group"), decimal: shown("decimal") }
}

class Amount extends Component {
  @tracked locale = "de-DE"
  @tracked text = "1.234,5"
  @tracked rejected: string | null = null
  id = guidFor(this)
  amountLocales = AMOUNT_LOCALES

  get value() {
    return parseNumber(this.text, this.locale)
  }

  get group() {
    return separatorsOf(this.locale).group
  }

  get decimal() {
    return separatorsOf(this.locale).decimal
  }

  get currency() {
    return CURRENCY_OF[this.locale]
  }

  get rejectedAttr() {
    return this.rejected ?? undefined
  }

  get describedBy() {
    return `${this.id}-out`
  }

  get valueText() {
    return this.value ?? "—"
  }

  get formatted() {
    const { value } = this
    return value === null
      ? "Keep typing"
      : formatNumber(value, this.locale, {
          style: "currency",
          currency: this.currency,
        })
  }

  setLocale = (next: string) => {
    const { value } = this
    this.locale = next
    this.rejected = null
    if (value !== null) {
      this.text = formatNumber(value, next, { maximumFractionDigits: 2 })
    }
  }

  onInput = (event: Event) => {
    const next = (event.target as HTMLInputElement).value
    if (isPartialNumber(next, this.locale, {}, { allowNegative: false })) {
      this.text = next
      this.rejected = null
    } else {
      this.rejected = next.slice(-1) || null
      ;(event.target as HTMLInputElement).value = this.text
    }
  }

  onBlur = () => {
    const { value } = this
    if (value !== null) {
      this.text = formatNumber(value, this.locale, {
        maximumFractionDigits: 2,
      })
    }
  }

  <template>
    <div class="lc-amount">
      <LocaleSwitch
        @locales={{this.amountLocales}}
        @value={{this.locale}}
        @onChange={{this.setLocale}}
      />
      <label class="lc-amount-field" data-rejected={{this.rejectedAttr}}>
        <span class="b-label">Transfer amount</span>
        <span class="lc-amount-box">
          <input
            class="lc-amount-input"
            inputmode="decimal"
            value={{this.text}}
            spellcheck="false"
            autocomplete="off"
            aria-describedby={{this.describedBy}}
            {{on "input" this.onInput}}
            {{on "blur" this.onBlur}}
          />
          <span class="lc-amount-code">{{this.currency}}</span>
        </span>
      </label>
      <p class="lc-amount-seps">
        {{#if this.rejected}}
          <span>
            “{{this.rejected}}” has no place in a
            {{this.locale}}
            number
          </span>
        {{else}}
          Groups
          <kbd>{{this.group}}</kbd>
          Decimal
          <kbd>{{this.decimal}}</kbd>
        {{/if}}
      </p>
      <p class="lc-amount-out" id={{this.describedBy}} aria-live="polite">
        <code>{{this.valueText}}</code>
        <span>
          {{this.formatted}}
        </span>
      </p>
    </div>
  </template>
}

/* 2. A price styled from its parts */

const PRICES = [
  { locale: "en-US", currency: "USD", night: 1249.99, low: 120, high: 340 },
  { locale: "de-DE", currency: "EUR", night: 1149.5, low: 110, high: 315 },
  { locale: "ja-JP", currency: "JPY", night: 186400, low: 17900, high: 50800 },
  { locale: "hi-IN", currency: "INR", night: 104250, low: 9990, high: 28400 },
]

class Price extends Component {
  @tracked locale = "en-US"
  locales = PRICES.map((entry) => entry.locale)

  get price() {
    return PRICES.find((entry) => entry.locale === this.locale) ?? PRICES[0]
  }

  get format() {
    return { style: "currency", currency: this.price.currency } as const
  }

  get label() {
    return formatNumber(this.price.night, this.locale, this.format)
  }

  get parts() {
    let afterDecimal = false
    return formatNumberToParts(this.price.night, this.locale, this.format).map(
      (part) => {
        afterDecimal ||= part.type === "decimal"
        return {
          type: part.type,
          value: part.value,
          small: afterDecimal || part.type === "currency",
        }
      }
    )
  }

  get range() {
    return formatNumberRange(this.price.low, this.price.high, this.locale, {
      ...this.format,
      maximumFractionDigits: 0,
    })
  }

  setLocale = (next: string) => {
    this.locale = next
  }

  <template>
    <div class="lc-price">
      <LocaleSwitch
        @locales={{this.locales}}
        @value={{this.locale}}
        @onChange={{this.setLocale}}
      />
      <div class="lc-price-card">
        <p class="lc-price-room">Ocean suite</p>
        <p class="lc-price-amount" aria-label={{this.label}}>
          {{~#each this.parts as |part|~}}
            <span
              aria-hidden="true"
              data-part={{part.type}}
              data-small={{if part.small "" undefined}}
            >{{part.value}}</span>
          {{~/each~}}
          <span class="lc-price-per">/ night</span>
        </p>
        <p class="lc-price-range">
          Other rooms
          <strong>{{this.range}}</strong>
        </p>
      </div>
    </div>
  </template>
}

/* 3. A dial that snaps to quarter hours */

const HOURS = { min: 0, max: 8, step: 0.25, largeStep: 1 }
const SWEEP = 270
const TICKS = Array.from(
  { length: HOURS.max / HOURS.step + 1 },
  (_, index) => index * HOURS.step
)

class Hours extends Component {
  @tracked value = 6.75
  hours = HOURS

  get turn() {
    return fractionOf(this.value, HOURS) * SWEEP - SWEEP / 2
  }

  get style() {
    return htmlSafe(`--turn: ${this.turn}deg`)
  }

  get wholeHours() {
    return Math.floor(this.value)
  }

  get minutes() {
    return roundTo((this.value - this.wholeHours) * 60, 0)
  }

  get minutesText() {
    return String(this.minutes).padStart(2, "0")
  }

  get valueText() {
    return `${this.wholeHours} hours ${this.minutes} minutes`
  }

  get note() {
    return `${this.value.toFixed(decimalsOf(HOURS.step))} of 8.00 h`
  }

  get ticks() {
    return TICKS.map((tick) => ({
      tick,
      hour: Number.isInteger(tick) ? "" : undefined,
      on: tick <= this.value ? "" : undefined,
      style: htmlSafe(
        `--at: ${fractionOf(tick, HOURS) * SWEEP - SWEEP / 2}deg`
      ),
    }))
  }

  moveTo(event: PointerEvent) {
    const box = (event.currentTarget as HTMLElement).getBoundingClientRect()
    const x = event.clientX - box.left - box.width / 2
    const y = event.clientY - box.top - box.height / 2
    const angle = wrap((Math.atan2(x, -y) * 180) / Math.PI, -180, 180)
    if (Math.abs(angle) > SWEEP / 2) {
      return
    }
    const raw = valueAt(angle / SWEEP + 0.5, HOURS)
    this.value = scrubTo(raw, HOURS).value
  }

  onKeyDown = (event: KeyboardEvent) => {
    const move = stepFromKey(event, {
      dir: isRTL(event.currentTarget as HTMLElement) ? "rtl" : "ltr",
    })
    if (move) {
      event.preventDefault()
      this.value = stepBy(this.value, move, HOURS)
    }
  }

  onPointerDown = (event: PointerEvent) => {
    ;(event.currentTarget as HTMLElement).setPointerCapture(event.pointerId)
    this.moveTo(event)
  }

  onPointerMove = (event: PointerEvent) => {
    if (
      (event.currentTarget as HTMLElement).hasPointerCapture(event.pointerId)
    ) {
      this.moveTo(event)
    }
  }

  <template>
    <div class="lc-hours">
      <p class="lc-hours-task">
        Lantern redesign
        <span>Tue</span>
      </p>
      {{! template-lint-disable }}
      <div
        class="lc-dial"
        role="slider"
        tabindex="0"
        aria-label="Hours on Lantern redesign"
        aria-valuemin={{this.hours.min}}
        aria-valuemax={{this.hours.max}}
        aria-valuenow={{this.value}}
        aria-valuetext={{this.valueText}}
        style={{this.style}}
        {{on "keydown" this.onKeyDown}}
        {{on "pointerdown" this.onPointerDown}}
        {{on "pointermove" this.onPointerMove}}
      >
        {{#each this.ticks key="tick" as |tick|}}
          <span
            class="lc-dial-tick"
            data-hour={{tick.hour}}
            data-on={{tick.on}}
            style={{tick.style}}
          ></span>
        {{/each}}
        <span class="lc-dial-pointer" aria-hidden="true"></span>
        <span class="lc-dial-face" aria-hidden="true">
          <span class="lc-dial-read">
            {{~this.wholeHours~}}
            <small>h</small>
            {{~this.minutesText~}}
            <small>m</small>
          </span>
        </span>
      </div>
      <p class="lc-hours-note">
        {{this.note}}
      </p>
    </div>
  </template>
}

/* 4. Quick date ranges */

const RANGE_LOCALES = ["en-US", "en-GB", "ar-EG"] as const

const PRESETS = [
  {
    label: "This week",
    range: (today: string, first: number) => [
      clampDate(startOfWeek(today, first), today),
      endOfWeek(today, first),
    ],
  },
  {
    label: "Next week",
    range: (today: string, first: number) => [
      startOfWeek(addDays(today, 7), first),
      endOfWeek(addDays(today, 7), first),
    ],
  },
  {
    label: "This month",
    range: (today: string) => [today, endOfMonth(today)],
  },
  {
    label: "Next month",
    range: (today: string) => [
      startOfMonth(addMonths(today, 1)),
      endOfMonth(addMonths(today, 1)),
    ],
  },
  {
    label: "A year out",
    range: (today: string, first: number) => [
      startOfWeek(addYears(today, 1), first),
      endOfWeek(addYears(today, 1), first),
    ],
  },
]

class Ranges extends Component {
  @tracked locale = "en-GB"
  @tracked preset = "Next week"
  today = todayDate()
  rangeLocales = RANGE_LOCALES

  get first() {
    return firstDayOfWeek(this.locale)
  }

  get rtl() {
    return this.locale.startsWith("ar")
  }

  get dir() {
    return this.rtl ? "rtl" : undefined
  }

  get monthDir() {
    return this.rtl ? "rtl" : "ltr"
  }

  get chips() {
    return PRESETS.map((entry) => ({
      label: entry.label,
      pressed: entry.label === this.preset ? "true" : "false",
    }))
  }

  get range() {
    const chosen =
      PRESETS.find((entry) => entry.label === this.preset) ?? PRESETS[0]
    const [start, end] = chosen.range(this.today, this.first)
    return { start, end }
  }

  get dates() {
    const { start, end } = this.range
    return formatDateRange(start, end, this.locale, {
      weekday: "short",
      day: "numeric",
      month: "short",
    })
  }

  get meta() {
    const { start, end } = this.range
    return [
      `${daysBetween(start, end) + 1} days`,
      isSameMonth(start, end)
        ? formatDate(start, this.locale, { month: "long" })
        : "Across two months",
      start === this.today ? "From today" : null,
    ]
      .filter(Boolean)
      .join(" · ")
  }

  get weekdays() {
    return weekdayNames(this.locale, "narrow", this.first).map(
      (name, index) => ({ name, index })
    )
  }

  get days() {
    const { start, end } = this.range
    const weeks = monthGrid(start, {
      weekStartsOn: this.first,
      fixedWeeks: true,
    })
    return weeks.flat().map((day) => ({
      day,
      text: formatDate(day, this.locale, { day: "numeric" }),
      outside: !isSameMonth(day, start) ? "" : undefined,
      inside: day >= start && day <= end ? "" : undefined,
      edge: day === start || day === end ? "" : undefined,
      today: day === this.today ? "" : undefined,
    }))
  }

  setLocale = (next: string) => {
    this.locale = next
  }

  setPreset = (label: string) => {
    this.preset = label
  }

  <template>
    <div class="lc-ranges">
      <LocaleSwitch
        @locales={{this.rangeLocales}}
        @value={{this.locale}}
        @onChange={{this.setLocale}}
      />
      <div class="lc-chips" role="group" aria-label="Out of office">
        {{#each this.chips key="label" as |chip|}}
          <button
            type="button"
            class="lc-chip"
            aria-pressed={{chip.pressed}}
            {{on "click" (fn this.setPreset chip.label)}}
          >
            {{chip.label}}
          </button>
        {{/each}}
      </div>
      <div class="lc-ranges-out" aria-live="polite">
        <p class="lc-ranges-dates" dir={{this.dir}}>
          {{this.dates}}
        </p>
        <p class="lc-ranges-meta">
          {{this.meta}}
        </p>
      </div>
      <div class="lc-month" dir={{this.monthDir}} aria-hidden="true">
        {{#each this.weekdays key="index" as |weekday|}}
          <span class="lc-month-weekday">
            {{weekday.name}}
          </span>
        {{/each}}
        {{#each this.days key="day" as |day|}}
          <span
            class="lc-month-day"
            data-outside={{day.outside}}
            data-in={{day.inside}}
            data-edge={{day.edge}}
            data-today={{day.today}}
          >
            {{day.text}}
          </span>
        {{/each}}
      </div>
    </div>
  </template>
}

/* 5. Pasted emails become tokens */

const EMAIL = /^(?:"?([^"<]*?)"?\s*<)?([^\s<>@,;]+@[^\s<>@,;]+\.[a-z]{2,})>?$/i

const emailCodec: TokenCodec = {
  format: (token) =>
    token.label === token.value
      ? token.value
      : `${token.label} <${token.value}>`,
  escape: (text, next) => (text.trim() ? text : next ? ", " : ""),
  parse(text) {
    const value: TokenInputValue = []
    for (const piece of text.split(/[,;\n\t]+/)) {
      const trimmed = piece.trim()
      const match = EMAIL.exec(trimmed)
      if (match) {
        const [, name, address] = match
        value.push(
          { type: "email", value: address, label: name?.trim() || address },
          " "
        )
      } else if (trimmed) {
        value.push(`${trimmed} `)
      }
    }
    return value
  },
}

const SHEET = `Grace Hopper <grace@navy.mil>
Katherine Johnson <kj@nasa.gov>, alan@bletchley.uk
not-an-email; margaret@apollo.org`

class Recipients extends Component {
  recipients = createTokenInputController()
  @tracked value: TokenInputValue = fromText(
    "Ada Lovelace <ada@engine.org>",
    emailCodec
  )
  sheet = SHEET
  codec = emailCodec

  get tokens() {
    return this.value.filter((part) => typeof part !== "string")
  }

  get stray() {
    return this.value
      .filter((part) => typeof part === "string")
      .join("")
      .trim()
  }

  get count() {
    const { length } = this.tokens
    return `${length} ${length === 1 ? "recipient" : "recipients"}`
  }

  get empty() {
    return !this.value.length
  }

  get sends() {
    return toText(this.value, emailCodec) || " "
  }

  setValue = (value: TokenInputValue) => {
    this.value = value
  }

  keepFocus = (event: MouseEvent) => event.preventDefault()

  paste = () => {
    this.recipients.insert(fromText(SHEET, emailCodec), { at: "end" })
  }

  clear = () => {
    this.recipients.clear()
  }

  <template>
    <div class="lc-mail">
      <div class="lc-mail-sheet">
        <pre class="lc-mail-text" dir="ltr">{{this.sheet}}</pre>
        <button
          type="button"
          class="b-btn lc-mail-paste"
          {{on "mousedown" this.keepFocus}}
          {{on "click" this.paste}}
        >
          {{icon ClipboardPaste 14}}
          Paste these
        </button>
      </div>
      <TokenInput
        @controller={{this.recipients}}
        @value={{this.value}}
        @onValueChange={{this.setValue}}
        @codec={{this.codec}}
        as |t|
      >
        <t.Tokens as |token parts|>
          <parts.Token class="lc-mail-token" title={{token.value}}>
            {{token.label}}
            <parts.Remove class="lc-mail-remove">
              {{icon X 11}}
            </parts.Remove>
          </parts.Token>
        </t.Tokens>
        <div class="lc-mail-box">
          <span class="lc-mail-to" aria-hidden="true">
            To
          </span>
          <t.Editor
            aria-label="Recipients"
            placeholder="Paste names and emails"
            class="lc-mail-editor"
          />
        </div>
      </TokenInput>
      <p class="lc-mail-foot" aria-live="polite">
        <span>
          {{this.count}}
          {{#if this.stray}}<em> · “{{this.stray}}” isn’t an email</em>{{/if}}
        </span>
        <button
          type="button"
          class="lc-mail-clear"
          disabled={{this.empty}}
          {{on "click" this.clear}}
        >
          Clear
        </button>
      </p>
      <p class="lc-mail-sends" dir="ltr">
        {{this.sends}}
      </p>
    </div>
  </template>
}

/* 6. An agent fills the form through snapshot and act */

const TEAMS = [
  { value: "research", label: "Research" },
  { value: "design", label: "Design" },
  { value: "platform", label: "Platform" },
  { value: "growth", label: "Growth" },
]

const ROLES = [
  { value: "viewer", label: "Viewer" },
  { value: "editor", label: "Editor" },
  { value: "admin", label: "Admin" },
]

const TASK = "Invite ada@engine.org to Research as an editor, with a welcome."

const SCRIPT = [
  { label: "Teammate email", action: "setValue", args: ["ada@engine.org"] },
  { label: "Team", action: "setValue", args: ["Research"] },
  { label: "Role", action: "setValue", args: ["Editor"] },
  { label: "Send welcome email", action: "setChecked", args: [true] },
  { label: "Send invite", action: "press", args: [] },
]

type LogLine = {
  kind: "task" | "call" | "seen" | "done" | "error"
  text: string
}

let pageAgent: ReturnType<typeof createAgent> | undefined
const agentOf = () => (pageAgent ??= createAgent())
const pause = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms))
const quoted = (value: unknown) =>
  typeof value === "string" ? `"${value}"` : String(value)

function snapshotLine(component: AgentComponent) {
  const state =
    "checked" in component
      ? quoted(component.checked)
      : "value" in component
        ? quoted(component.value)
        : null
  return [component.ref, component.component, quoted(component.label), state]
    .filter(Boolean)
    .join(" ")
}

class AgentFill extends Component {
  form: HTMLFormElement | null = null
  logList: HTMLOListElement | null = null
  run = 0
  @tracked formKey = 0
  @tracked log: LogLine[] = []
  @tracked target: string | null = null
  @tracked running = false
  @tracked sent: string | null = null
  id = guidFor(this)
  teams = TEAMS
  roles = ROLES

  constructor(owner: ConstructorParameters<typeof Component>[0], args: {}) {
    super(owner, args)
    registerDestructor(this, () => this.run++)
  }

  get roleLabelId() {
    return `${this.id}-role`
  }

  get formKeys() {
    return [this.formKey]
  }

  get hasLog() {
    return this.log.length > 0
  }

  get runLabel() {
    return this.running ? "Running" : this.hasLog ? "Run again" : "Run"
  }

  targetOf = (label: string) => (this.target === label ? "" : undefined)

  get targetEmail() {
    return this.targetOf("Teammate email")
  }

  get targetTeam() {
    return this.targetOf("Team")
  }

  get targetRole() {
    return this.targetOf("Role")
  }

  get targetWelcome() {
    return this.targetOf("Send welcome email")
  }

  get targetSend() {
    return this.targetOf("Send invite")
  }

  setForm = (el: Element) => {
    this.form = el as HTMLFormElement
    return () => {
      if (this.form === el) {
        this.form = null
      }
    }
  }

  setLogList = (el: Element) => {
    this.logList = el as HTMLOListElement
    return () => {
      if (this.logList === el) {
        this.logList = null
      }
    }
  }

  say = (line: LogLine) => {
    this.log = [...this.log, line]
    schedule("afterRender", () => {
      const list = this.logList
      if (list) {
        list.scrollTop = list.scrollHeight
      }
    })
  }

  preventSubmit = (event: Event) => event.preventDefault()

  send = () => {
    const data = new FormData(this.form ?? undefined)
    const email = String(data.get("email") ?? "")
    this.sent = email ? `Sent to ${email}` : "Add an email first"
  }

  start = async () => {
    const id = ++this.run
    const { say } = this
    const stale = () => this.run !== id
    this.running = true
    this.sent = null
    this.log = [{ kind: "task", text: TASK }]
    this.formKey++
    await pause(500)
    const agent = agentOf()
    say({ kind: "call", text: "snapshot()" })
    await pause(350)
    const mine = new Map<string, AgentComponent>()
    const keep = (found: AgentComponent[]) => {
      for (const component of found) {
        const el = elementOf(component.ref)
        if (el && this.form?.contains(el) && component.label) {
          mine.set(component.label, component)
          say({ kind: "seen", text: snapshotLine(component) })
        }
      }
    }
    const page = agent.snapshot()
    keep(page)
    const more = page.find((component) => component.ref === "more")
    if (more) {
      say({ kind: "seen", text: `…${more.more} more on the page` })
    }
    for (const { label } of SCRIPT) {
      if (!mine.has(label)) {
        say({ kind: "call", text: `query({ text: ${quoted(label)} })` })
        const found = await agent.query({ text: label })
        keep(Array.isArray(found) ? found : [])
      }
    }
    let completed = true
    for (const step of SCRIPT) {
      await pause(700)
      if (stale()) {
        return
      }
      const ref = mine.get(step.label)?.ref ?? step.label
      this.target = step.label
      say({
        kind: "call",
        text: `act ${ref}.${step.action}(${step.args.map(quoted).join(", ")})`,
      })
      const result = await agent.act({
        steps: [{ ref, action: step.action, args: step.args }],
      })
      if (!result.ok) {
        say({ kind: "error", text: result.error?.message ?? "Failed" })
        completed = false
        break
      }
      const changes = result.steps[0]?.changes ?? []
      say({
        kind: "seen",
        text: changes.length
          ? changes
              .map((change) => `${change.key} → ${quoted(change.value)}`)
              .join(", ")
          : "pressed",
      })
    }
    await pause(500)
    if (stale()) {
      return
    }
    if (completed) {
      say({ kind: "done", text: "Done. The invite is on its way." })
    }
    this.target = null
    this.running = false
  }

  <template>
    <div class="lc-agent">
      {{#each this.formKeys key="@identity" as |key|}}
        <form
          class="lc-agent-form"
          {{on "submit" this.preventSubmit}}
          {{onInsert this.setForm}}
        >
          <p class="lc-agent-title">Invite a teammate</p>
          <Field
            @name="email"
            class="lc-agent-field"
            data-target={{this.targetEmail}}
            as |f|
          >
            <f.Label class="b-label">Teammate email</f.Label>
            <Input
              class="b-input"
              type="email"
              placeholder="name@company.com"
              autocomplete="off"
              @field={{f.field}}
            />
          </Field>
          <div class="lc-agent-field" data-target={{this.targetTeam}}>
            <Select
              @name="team"
              @items={{this.teams}}
              @placeholder="Choose a team"
              as |s|
            >
              <s.Label class="b-label">Team</s.Label>
              <s.Trigger class="b-input lc-agent-trigger">
                <s.Value />
                {{icon ChevronDown 14}}
              </s.Trigger>
              <s.Content class="b-pop lc-agent-pop" @sideOffset={{6}}>
                {{#each this.teams key="value" as |team|}}
                  <s.Item
                    @value={{team.value}}
                    class="b-item lc-agent-option"
                    as |item|
                  >
                    {{team.label}}
                    <item.Indicator class="lc-agent-check">
                      {{icon Check 14}}
                    </item.Indicator>
                  </s.Item>
                {{/each}}
              </s.Content>
            </Select>
          </div>
          <div class="lc-agent-field" data-target={{this.targetRole}}>
            <span class="b-label" id={{this.roleLabelId}}>
              Role
            </span>
            <RadioGroup
              @name="role"
              @defaultValue="viewer"
              aria-labelledby={{this.roleLabelId}}
              class="lc-agent-roles"
              as |g|
            >
              {{#each this.roles key="value" as |role|}}
                <label class="lc-agent-role">
                  <g.Radio @value={{role.value}} class="lc-agent-radio" as |r|>
                    <r.Indicator class="lc-agent-radio-dot" />
                  </g.Radio>
                  {{role.label}}
                </label>
              {{/each}}
            </RadioGroup>
          </div>
          <label
            class="lc-agent-field lc-agent-welcome"
            data-target={{this.targetWelcome}}
          >
            Send welcome email
            <Switch @name="welcome" class="lc-agent-switch" as |s|>
              <s.Thumb class="lc-agent-thumb" />
            </Switch>
          </label>
          <div class="lc-agent-submit" data-target={{this.targetSend}}>
            <Button class="b-btn" data-variant="primary" @onClick={{this.send}}>
              Send invite
            </Button>
            <span class="lc-agent-sent" aria-live="polite">
              {{this.sent}}
            </span>
          </div>
        </form>
      {{/each}}
      <section class="lc-agent-console" aria-label="Agent">
        <header class="lc-agent-head">
          {{icon Bot 16}}
          <span>Scripted agent</span>
          <button
            type="button"
            class="lc-agent-run"
            disabled={{this.running}}
            {{on "click" this.start}}
          >
            {{#if this.hasLog}}
              {{icon RotateCcw 13}}
            {{else}}
              {{icon Play 13}}
            {{/if}}
            {{this.runLabel}}
          </button>
        </header>
        <ol
          class="lc-agent-log"
          dir="ltr"
          aria-live="polite"
          {{onInsert this.setLogList}}
        >
          {{#each this.log as |line|}}
            <li data-kind={{line.kind}}>
              {{line.text}}
            </li>
          {{else}}
            <li data-kind="hint">
              Run reads the form with snapshot(), then fills it with act().
            </li>
          {{/each}}
        </ol>
      </section>
    </div>
  </template>
}

const tiles: Tile[] = [
  {
    id: "language-amount",
    title: "Type 1.234,5 in German.",
    blurb: "Each locale reads its own separators.",
    Demo: Amount,
  },
  {
    id: "language-price",
    title: "Big dollars, small cents.",
    blurb: "A price styled from its parts.",
    tone: "butter",
    Demo: Price,
  },
  {
    id: "language-hours",
    title: "Snap to a quarter.",
    blurb: "A dial on the step grid, by drag or arrows.",
    tone: "ink",
    Demo: Hours,
  },
  {
    id: "language-ranges",
    title: "This week, next month.",
    blurb: "Quick ranges that start where the locale's week does.",
    size: "tall",
    tone: "sage",
    Demo: Ranges,
  },
  {
    id: "language-recipients",
    title: "Paste a list of emails.",
    blurb: "A codec turns pasted text into tokens.",
    size: "wide",
    tone: "sky",
    Demo: Recipients,
  },
  {
    id: "language-agent",
    title: "Let the agent fill it.",
    blurb: "A scripted agent reads the form and acts through its api.",
    size: "large",
    Demo: AgentFill,
  },
]

export { tiles }
