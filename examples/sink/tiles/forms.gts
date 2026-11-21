import { concat, fn, get } from "@ember/helper"
import { on } from "@ember/modifier"
import type { TOC } from "@ember/component/template-only"
import { htmlSafe } from "@ember/template"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  Armchair,
  ArrowLeftRight,
  ArrowRight,
  Bed,
  Check,
  ChevronDown,
  CircleCheck,
  Coffee,
  Coins,
  CreditCard,
  Dumbbell,
  Eye,
  EyeOff,
  FileText,
  Heart,
  IdCard,
  Landmark,
  LoaderCircle,
  Lock,
  Luggage,
  Minus,
  Moon,
  PawPrint,
  PlaneLanding,
  PlaneTakeoff,
  Plus,
  Search,
  Sofa,
  Star,
  Ticket,
  Van,
  Waves,
  X,
} from "lucide"
import type { IconNode } from "lucide"
import { formatFileSize } from "ember-ui-sdk/file-input"
import { Button } from "ember-ui-sdk/button"
import { Checkbox, CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Combobox, createComboboxController } from "ember-ui-sdk/combobox"
import { Field } from "ember-ui-sdk/field"
import { FileInput } from "ember-ui-sdk/file-input"
import { Input, InputGroup } from "ember-ui-sdk/input"
import { NumberInput } from "ember-ui-sdk/number-input"
import { OTPInput } from "ember-ui-sdk/otp-input"
import { PasswordInput } from "ember-ui-sdk/password-input"
import { RadioGroup } from "ember-ui-sdk/radio"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"
import { Select } from "ember-ui-sdk/select"
import { Slider } from "ember-ui-sdk/slider"
import { Switch } from "ember-ui-sdk/switch"
import { Textarea } from "ember-ui-sdk/textarea"
import { Toggle, ToggleGroup } from "ember-ui-sdk/toggle"
import "../../../vendor/ui/apps/docs/app/sink/tiles/forms.css"
import { icon } from "../icon.ts"
import type { Tile } from "../types.ts"

/** Phosphor's fill weight, drawn with a Lucide icon. */
const solid = (node: IconNode, size = 16) =>
  icon(node, size, { fill: "currentColor" })

const spinner = (size = 16) => icon(LoaderCircle, size, { class: "fm-spin" })

const wait = (ms: number) =>
  new Promise<void>((resolve) => setTimeout(resolve, ms))

const preventDefault = (event: Event) => event.preventDefault()

/** A press handler for a submit Button: pending only when the form is valid, so invalid forms still show their errors. */
const submitWhenValid = (event: Event, work: () => Promise<void>) => {
  const target = (event.currentTarget ?? event.target) as HTMLElement | null
  const form = target?.closest("form")
  if (form && !form.checkValidity()) {
    return
  }
  return work()
}

const flag = (on: unknown) => (on ? "" : undefined)

/* 1. Checkout card form */

const countries = [
  { value: "pt", label: "Portugal" },
  { value: "jp", label: "Japan" },
  { value: "us", label: "United States" },
  { value: "ca", label: "Canada" },
  { value: "de", label: "Germany" },
]

class Checkout extends Component {
  @tracked card = ""
  @tracked paid = false
  countries = countries

  onCardChange = (value: string, details: { cancel: () => void }) => {
    const digits = value.replace(/\D/g, "")
    if (digits.length > 16) {
      return details.cancel()
    }
    this.card = digits.replace(/(\d{4})(?=\d)/g, "$1 ")
  }

  pay = (event: Event) =>
    submitWhenValid(event, async () => {
      await wait(1200)
      this.paid = true
      setTimeout(() => (this.paid = false), 2400)
    })

  <template>
    <form class="fm-pay" {{on "submit" preventDefault}}>
      <header class="fm-pay-head">
        <div>
          <p class="fm-pay-route">
            Lisbon
            {{icon ArrowRight 14}}
            Tokyo</p>
          <p class="fm-pay-meta">2 travelers · Oct 9 – 23</p>
        </div>
        <p class="fm-pay-total">$1,284.60</p>
      </header>

      <Field @name="cardholder" class="fm-field" as |f|>
        <div class="fm-field-head">
          <f.Label class="b-label">Name on card</f.Label>
          <f.Error class="fm-error" @match="valueMissing">Required</f.Error>
        </div>
        <Input
          class="b-input fm-input"
          autocomplete="cc-name"
          placeholder="Maya Okafor"
          @required={{true}}
          @field={{f.field}}
        />
      </Field>

      <Field @name="card" class="fm-field" as |f|>
        <div class="fm-field-head">
          <f.Label class="b-label">Card number</f.Label>
          <f.Error class="fm-error" @match="valueMissing">Required</f.Error>
          <f.Error class="fm-error" @match="patternMismatch">Needs 16 digits</f.Error>
        </div>
        <InputGroup class="b-input fm-input-group">
          {{icon CreditCard 14}}
          <Input
            class="fm-bare-input fm-mono"
            @value={{this.card}}
            @onValueChange={{this.onCardChange}}
            @required={{true}}
            @field={{f.field}}
            inputmode="numeric"
            autocomplete="cc-number"
            placeholder="1234 1234 1234 1234"
            pattern="\d{4} \d{4} \d{4} \d{4}"
          />
        </InputGroup>
      </Field>

      <div class="fm-pay-row">
        <Field @name="expiry" class="fm-field" as |f|>
          <div class="fm-field-head">
            <f.Label class="b-label">Expires</f.Label>
            <f.Error class="fm-error">Invalid</f.Error>
          </div>
          <Input
            class="b-input fm-input fm-mono"
            autocomplete="cc-exp"
            placeholder="MM / YY"
            pattern="(0[1-9]|1[0-2]) ?/ ?\d{2}"
            maxlength="7"
            @required={{true}}
            @field={{f.field}}
          />
        </Field>
        <Field @name="cvc" class="fm-field" as |f|>
          <div class="fm-field-head">
            <f.Label class="b-label">CVC</f.Label>
            <f.Error class="fm-error">Invalid</f.Error>
          </div>
          <Input
            class="b-input fm-input fm-mono"
            autocomplete="cc-csc"
            inputmode="numeric"
            placeholder="123"
            pattern="\d{3,4}"
            maxlength="4"
            @required={{true}}
            @field={{f.field}}
          />
        </Field>
        <Field @name="country" class="fm-field fm-pay-country" as |f|>
          <div class="fm-field-head">
            <f.Label class="b-label">Billing country</f.Label>
            <f.Error class="fm-error" @match="valueMissing">Required</f.Error>
          </div>
          <Select
            @items={{this.countries}}
            @required={{true}}
            @placeholder="Choose"
            @field={{f.field}}
            as |s|
          >
            <s.Trigger class="b-input fm-trigger">
              <s.Value class="fm-trigger-value" />
              {{icon ChevronDown 14}}
            </s.Trigger>
            <s.Content class="b-pop fm-pop" @sideOffset={{6}}>
              {{#each this.countries key="value" as |country|}}
                <s.Item
                  @value={{country.value}}
                  class="b-item fm-option"
                  as |item|
                >
                  {{country.label}}
                  <item.Indicator class="fm-option-check">{{icon
                      Check
                      14
                    }}</item.Indicator>
                </s.Item>
              {{/each}}
            </s.Content>
          </Select>
        </Field>
      </div>

      <label class="fm-check-row">
        <Checkbox
          @name="save-card"
          @defaultChecked={{true}}
          class="fm-box"
          as |c|
        >
          <c.Indicator class="fm-box-mark">{{icon Check 14}}</c.Indicator>
        </Checkbox>
        Save card for future bookings
      </label>

      <Button
        class="b-btn fm-pay-btn"
        data-variant="primary"
        data-done={{flag this.paid}}
        @type="submit"
        @pendingAnnouncement="Processing payment"
        @onClick={{this.pay}}
        as |b|
      >
        {{#if b.state.pending}}
          {{spinner 14}}
          Processing…
        {{else if this.paid}}
          {{icon Check 14}}
          Payment approved
        {{else}}
          {{solid Lock 14}}
          Pay now
        {{/if}}
      </Button>
    </form>
  </template>
}

/* 2. Flight search: two airport comboboxes, a trip type and a search button */

const airports = [
  { code: "SFO", city: "San Francisco", country: "United States" },
  { code: "SEA", city: "Seattle", country: "United States" },
  { code: "JFK", city: "New York", country: "United States" },
  { code: "MEX", city: "Mexico City", country: "Mexico" },
  { code: "CDG", city: "Paris", country: "France" },
  { code: "AMS", city: "Amsterdam", country: "Netherlands" },
  { code: "KEF", city: "Reykjavík", country: "Iceland" },
  { code: "CPT", city: "Cape Town", country: "South Africa" },
  { code: "ICN", city: "Seoul", country: "South Korea" },
  { code: "SYD", city: "Sydney", country: "Australia" },
]
const airportLabel = (code: string | null) => {
  const airport = airports.find((item) => item.code === code)
  return airport ? `${airport.city} (${airport.code})` : ""
}
const airportRows = airports.map((airport) => ({
  ...airport,
  label: airportLabel(airport.code),
  keywords: [airport.code, airport.country],
}))

const AirportField: TOC<{
  Args: {
    label: string
    icon: IconNode
    anchor: string
    value: string | null
    query: string
    onValueChange: (value: string | null) => void
    onQueryChange: (query: string) => void
    controller?: ReturnType<typeof createComboboxController<string>>
  }
}> = <template>
  <Combobox
    @value={{@value}}
    @onValueChange={{@onValueChange}}
    @query={{@query}}
    @onQueryChange={{@onQueryChange}}
    @itemToLabel={{airportLabel}}
    @autoHighlight={{true}}
    @controller={{@controller}}
    as |c|
  >
    <div class="fm-ap" id={{@anchor}}>
      {{icon @icon 16}}
      <div class="fm-ap-text">
        <c.Label class="fm-ap-label">{{@label}}</c.Label>
        <c.Input class="fm-ap-input" placeholder="City or airport" />
      </div>
    </div>
    <c.Content
      @anchor={{concat "#" @anchor}}
      @sideOffset={{6}}
      @align="start"
      class="b-pop fm-ap-pop"
    >
      <c.Empty class="fm-empty">No airports match.</c.Empty>
      <c.List class="fm-list">
        {{#each airportRows key="code" as |airport|}}
          <c.Item
            @value={{airport.code}}
            @label={{airport.label}}
            @keywords={{airport.keywords}}
            class="b-item fm-ap-item"
          >
            <span class="fm-ap-code">{{airport.code}}</span>
            <span class="fm-ap-city">
              {{airport.city}}
              <span>{{airport.country}}</span>
            </span>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>

class FlightSearch extends Component {
  @tracked trip = "round"
  @tracked from: string | null = "SFO"
  @tracked fromQuery = airportLabel("SFO")
  @tracked to: string | null = null
  @tracked toQuery = ""
  @tracked result = ""
  toController = createComboboxController<string>()
  TakeOff = PlaneTakeoff
  Landing = PlaneLanding
  Swap = ArrowLeftRight

  setTrip = (value: string | null) => {
    if (value) {
      this.trip = value
    }
  }
  setFrom = (value: string | null) => {
    this.from = value
    this.result = ""
  }
  setTo = (value: string | null) => {
    this.to = value
    this.result = ""
  }
  setFromQuery = (query: string) => {
    this.fromQuery = query
  }
  setToQuery = (query: string) => {
    this.toQuery = query
  }

  swap = () => {
    const { from, to, fromQuery, toQuery } = this
    this.from = to
    this.to = from
    this.fromQuery = toQuery
    this.toQuery = fromQuery
    this.result = ""
  }

  search = async () => {
    const { from, to } = this
    if (!from || !to) {
      this.result = "Choose both airports first."
      if (!to) {
        this.toController.focus()
      }
      return
    }
    this.result = ""
    await wait(1000)
    const seed = [...from, ...to].reduce(
      (sum, char) => sum + char.charCodeAt(0),
      0
    )
    const way =
      this.trip === "oneway"
        ? "one-way"
        : this.trip === "multi"
          ? "multi-city"
          : "round-trip"
    this.result = `${(seed % 40) + 14} ${way} fares from $${300 + ((seed * 7) % 520)}`
  }

  <template>
    <div class="fm-search">
      <SegmentedControl
        aria-label="Trip type"
        @value={{this.trip}}
        @onValueChange={{this.setTrip}}
        class="fm-seg"
        as |s|
      >
        <s.Indicator class="fm-seg-indicator" />
        <s.Item @value="round" class="fm-seg-item">Round trip</s.Item>
        <s.Item @value="oneway" class="fm-seg-item">One way</s.Item>
        <s.Item @value="multi" class="fm-seg-item">Multi-city</s.Item>
      </SegmentedControl>
      <div class="fm-search-bar">
        <AirportField
          @label="From"
          @icon={{this.TakeOff}}
          @anchor="fm-ap-from"
          @value={{this.from}}
          @query={{this.fromQuery}}
          @onValueChange={{this.setFrom}}
          @onQueryChange={{this.setFromQuery}}
        />
        <button
          type="button"
          class="fm-swap"
          aria-label="Swap origin and destination"
          {{on "click" this.swap}}
        >{{icon this.Swap 16}}</button>
        <AirportField
          @label="To"
          @icon={{this.Landing}}
          @anchor="fm-ap-to"
          @value={{this.to}}
          @query={{this.toQuery}}
          @onValueChange={{this.setTo}}
          @onQueryChange={{this.setToQuery}}
          @controller={{this.toController}}
        />
        <Button
          class="b-btn fm-search-btn"
          data-variant="primary"
          @pendingAnnouncement="Searching flights"
          @onClick={{this.search}}
          as |b|
        >
          {{#if b.state.pending}}
            {{spinner}}
            Searching
          {{else}}
            {{icon Search 16}}
            Search
          {{/if}}
        </Button>
      </div>
      <p class="fm-search-status" role="status">{{this.result}}</p>
    </div>
  </template>
}

/* 3. Seat map: a single-select toggle group laid out like a cabin */

const seatRows = Array.from({ length: 14 }, (_, index) => index + 11)
const seatLetters = ["A", "B", "C", "D", "E", "F"]
const takenSeats = new Set(
  "11A 11B 12C 12D 13B 13F 14A 14B 15E 16F 17C 17D 17E 18A 18F 19B 19F 20A 20C 21D 21E 22A 22F 23B 23C 24D 24E".split(
    " "
  )
)
const legroomRows = new Set([11, 16])
const seatInfo = (id: string) => {
  const row = Number(id.slice(0, -1))
  const letter = id.slice(-1)
  const kind = "AF".includes(letter)
    ? "Window"
    : "CD".includes(letter)
      ? "Aisle"
      : "Middle"
  const price = legroomRows.has(row) ? 46 : kind === "Middle" ? 18 : 24
  return { kind, price, legroom: legroomRows.has(row) }
}

const seatLetterCells = seatLetters.map((letter, line) => ({
  letter,
  style: htmlSafe(`grid-row: ${line < 3 ? line + 1 : line + 2}`),
}))
const seatRowCells = seatRows.map((row) => ({
  row,
  far: row > 16,
  style: htmlSafe(`grid-column: ${row - 9}; grid-row: 4`),
}))
const seatCells = seatLetters.flatMap((letter, line) =>
  seatRows.map((row) => {
    const id = `${row}${letter}`
    const taken = takenSeats.has(id)
    return {
      id,
      taken,
      legroom: legroomRows.has(row),
      far: row > 16,
      label: `Seat ${id}, ${seatInfo(id).kind.toLowerCase()}${taken ? ", taken" : ""}`,
      style: htmlSafe(
        `grid-column: ${row - 9}; grid-row: ${line < 3 ? line + 1 : line + 2}`
      ),
    }
  })
)

class SeatMap extends Component {
  @tracked seat: string[] = ["16C"]
  @tracked held = ""
  letters = seatLetterCells
  rowCells = seatRowCells
  cells = seatCells

  get chosen() {
    return this.seat[0]
  }

  get info() {
    return this.chosen ? seatInfo(this.chosen) : null
  }

  get kind() {
    const { info } = this
    return info
      ? `${info.kind}${info.legroom ? " · extra legroom" : ""}`
      : "Pick an open seat"
  }

  get price() {
    return this.info ? `$${this.info.price}` : ""
  }

  get seatId() {
    return this.chosen ?? "—"
  }

  get isHeld() {
    return Boolean(this.held) && this.held === this.chosen
  }

  setSeat = (value: string[]) => {
    this.seat = value
    this.held = ""
  }

  hold = async () => {
    await wait(900)
    this.held = this.chosen ?? ""
  }

  <template>
    <div class="fm-cabin-map">
      <div class="fm-plane">
        <ToggleGroup
          aria-label="Seats, rows 11 to 24"
          @value={{this.seat}}
          @onValueChange={{this.setSeat}}
          class="fm-seats"
          as |g|
        >
          {{#each this.letters key="letter" as |cell|}}
            <span
              aria-hidden="true"
              class="fm-seat-letter"
              style={{cell.style}}
            >{{cell.letter}}</span>
          {{/each}}
          {{#each this.rowCells key="row" as |cell|}}
            <span
              aria-hidden="true"
              class="fm-seat-row"
              data-far={{flag cell.far}}
              style={{cell.style}}
            >{{cell.row}}</span>
          {{/each}}
          {{#each this.cells key="id" as |cell|}}
            <g.Toggle
              @value={{cell.id}}
              @disabled={{cell.taken}}
              aria-label={{cell.label}}
              class="fm-seat"
              data-legroom={{flag cell.legroom}}
              data-far={{flag cell.far}}
              style={{cell.style}}
            />
          {{/each}}
        </ToggleGroup>
      </div>
      <div class="fm-seat-panel">
        <p class="fm-seat-id">{{this.seatId}}</p>
        <p class="fm-seat-kind">{{this.kind}}</p>
        <p class="fm-seat-price">{{this.price}}</p>
        <Button
          class="b-btn fm-seat-btn"
          data-variant="primary"
          @disabled={{if this.chosen false true}}
          @onClick={{this.hold}}
          as |b|
        >
          {{#if b.state.pending}}
            {{spinner}}
            Holding
          {{else if this.isHeld}}
            {{icon Check 16}}
            Seat held
          {{else}}
            Hold seat
          {{/if}}
        </Button>
      </div>
    </div>
  </template>
}

/* 4. Alerts: checkbox groups with a parent, a switch and an async save */

type Option = { value: string; label: string }

class AlertGroup extends Component<{
  Args: { title: string; items: Option[]; initial: string[] }
}> {
  @tracked value: string[] = this.args.initial

  get allValues() {
    return this.args.items.map((item) => item.value)
  }

  setValue = (value: string[]) => {
    this.value = value
  }

  <template>
    <CheckboxGroup
      aria-label={{@title}}
      @value={{this.value}}
      @onValueChange={{this.setValue}}
      @allValues={{this.allValues}}
      class="fm-al-group"
      as |g|
    >
      <label class="fm-al-parent">
        <g.Checkbox @parent={{true}} class="fm-box" as |c|>
          <c.Indicator class="fm-box-mark" as |i|>
            {{#if i.state.indeterminate}}
              {{icon Minus 14}}
            {{else}}
              {{icon Check 14}}
            {{/if}}
          </c.Indicator>
        </g.Checkbox>
        <span class="fm-al-title">{{@title}}</span>
        <span class="fm-al-count">{{this.value.length}}
          of
          {{@items.length}}</span>
      </label>
      <div class="fm-al-children">
        {{#each @items key="value" as |item|}}
          <label class="fm-al-row">
            <g.Checkbox @value={{item.value}} class="fm-box" as |c|>
              <c.Indicator class="fm-box-mark">{{icon Check 14}}</c.Indicator>
            </g.Checkbox>
            {{item.label}}
          </label>
        {{/each}}
      </div>
    </CheckboxGroup>
  </template>
}

const tripItems = [
  { value: "gate", label: "Gate changes" },
  { value: "delay", label: "Delays over 30 min" },
  { value: "boarding", label: "Boarding calls" },
  { value: "belt", label: "Baggage belt" },
]
const tripInitial = ["gate", "delay", "boarding"]
const priceItems = [
  { value: "routes", label: "Watched routes" },
  { value: "stays", label: "Hotels on your list" },
]
const priceInitial: string[] = []

class Alerts extends Component {
  @tracked quiet = true
  @tracked saved = false
  tripItems = tripItems
  tripInitial = tripInitial
  priceItems = priceItems
  priceInitial = priceInitial

  setQuiet = (next: boolean) => {
    this.quiet = next
    this.saved = false
  }

  save = async () => {
    await wait(900)
    this.saved = true
  }

  <template>
    <div class="fm-alerts">
      <div class="fm-alerts-head">
        <p class="fm-alerts-title">Notifications</p>
        <p class="fm-alerts-sub">Sent to your phone and inbox</p>
      </div>
      <AlertGroup
        @title="Trip updates"
        @initial={{this.tripInitial}}
        @items={{this.tripItems}}
      />
      <AlertGroup
        @title="Price drops"
        @initial={{this.priceInitial}}
        @items={{this.priceItems}}
      />
      <label class="fm-quiet">
        <span class="fm-quiet-text">
          <span>Quiet hours</span>
          <span class="fm-quiet-detail">Hold alerts 10 pm – 7 am</span>
        </span>
        <Switch
          @checked={{this.quiet}}
          @onCheckedChange={{this.setQuiet}}
          class="fm-sq-switch"
          as |s|
        >
          <s.Thumb class="fm-sq-thumb">{{solid Moon 14}}</s.Thumb>
        </Switch>
      </label>
      <Button
        class="b-btn fm-alerts-save"
        data-variant="primary"
        @onClick={{this.save}}
        as |b|
      >
        {{#if b.state.pending}}
          {{spinner 14}}
          Saving
        {{else if this.saved}}
          {{icon Check 14}}
          Preferences saved
        {{else}}
          Save preferences
        {{/if}}
      </Button>
    </div>
  </template>
}

/* 5. Cabin: card radios */

const cabins = [
  { value: "economy", label: "Economy", price: "$412", icon: Armchair },
  { value: "premium", label: "Premium", price: "$689", icon: Sofa },
  { value: "business", label: "Business", price: "$1,940", icon: Bed },
]

const Cabin = <template>
  <RadioGroup
    @defaultValue="premium"
    aria-label="Cabin"
    class="fm-cabins"
    as |g|
  >
    {{#each cabins key="value" as |cabin|}}
      <label class="fm-cabin">
        <span class="fm-cabin-top">
          {{solid cabin.icon 16}}
          <g.Radio @value={{cabin.value}} class="fm-dot" as |r|>
            <r.Indicator class="fm-dot-in" />
          </g.Radio>
        </span>
        <span class="fm-cabin-name">{{cabin.label}}</span>
        <span class="fm-cabin-price">{{cabin.price}}</span>
      </label>
    {{/each}}
  </RadioGroup>
</template>

/* 6. Verify: OTP with auto-check on complete and an async resend */

class Verify extends Component {
  @tracked status: "idle" | "checking" | "ok" = "idle"

  reset = () => {
    this.status = "idle"
  }

  commit = () => {
    this.status = "checking"
    setTimeout(() => {
      if (this.status === "checking") {
        this.status = "ok"
      }
    }, 900)
  }

  resend = () => wait(900)

  get checking() {
    return this.status === "checking"
  }

  get ok() {
    return this.status === "ok"
  }

  <template>
    <div class="fm-otp">
      <p class="fm-otp-lead">Code sent to +1 415 ••• 0192</p>
      <OTPInput
        @maxLength={{6}}
        @ariaLabel="Verification code"
        class="fm-otp-root"
        @onValueChange={{this.reset}}
        @onValueCommit={{this.commit}}
        as |o|
      >
        <o.Group class="fm-otp-group">
          <o.Slot @index={{0}} class="fm-slot" />
          <o.Slot @index={{1}} class="fm-slot" />
          <o.Slot @index={{2}} class="fm-slot" />
        </o.Group>
        <o.Separator class="fm-otp-sep" />
        <o.Group class="fm-otp-group">
          <o.Slot @index={{3}} class="fm-slot" />
          <o.Slot @index={{4}} class="fm-slot" />
          <o.Slot @index={{5}} class="fm-slot" />
        </o.Group>
      </OTPInput>
      <div class="fm-otp-foot">
        <p class="fm-otp-status" role="status" data-state={{this.status}}>
          {{#if this.checking}}
            {{spinner 14}}
            Checking
          {{else if this.ok}}
            {{solid CircleCheck 14}}
            Verified
          {{else}}
            Didn’t get it?
          {{/if}}
        </p>
        <Button
          class="b-btn fm-otp-resend"
          data-variant="ghost"
          @onClick={{this.resend}}
          as |b|
        >
          {{#if b.state.pending}}
            {{spinner 14}}
            Sending
          {{else}}
            Resend code
          {{/if}}
        </Button>
      </div>
    </div>
  </template>
}

/* 7. New password */

const passwordRules = [
  { label: "8+ characters", test: (value: string) => value.length >= 8 },
  { label: "A number", test: (value: string) => /\d/.test(value) },
  { label: "A symbol", test: (value: string) => /[^\w\s]/.test(value) },
]
const strengthWords = ["Too short", "Weak", "Fair", "Good", "Strong"]

class NewPassword extends Component {
  @tracked password = "lagos2026"

  setPassword = (value: string) => {
    this.password = value
  }

  get rules() {
    return passwordRules.map((rule) => ({
      label: rule.label,
      met: rule.test(this.password),
    }))
  }

  get score() {
    const passed = this.rules.filter((rule) => rule.met).length
    return this.password
      ? Math.min(4, passed + (this.password.length >= 12 ? 1 : 0))
      : 0
  }

  get word() {
    return strengthWords[this.score]
  }

  <template>
    <Field @name="new-password" class="fm-pw" as |f|>
      <div class="fm-field-head">
        <f.Label class="b-label">New password</f.Label>
        <span class="fm-pw-word" data-score={{this.score}}>{{this.word}}</span>
      </div>
      <PasswordInput
        @value={{this.password}}
        @onValueChange={{this.setPassword}}
        @autoComplete="new-password"
        class="fm-pw-box"
        as |p|
      >
        <p.Control class="fm-bare-input fm-pw-input" @field={{f.field}} />
        <p.Toggle aria-label="Show password" class="fm-pw-eye" as |t|>
          {{#if t.state.visible}}
            {{icon EyeOff 16}}
          {{else}}
            {{icon Eye 16}}
          {{/if}}
        </p.Toggle>
      </PasswordInput>
      <div class="fm-pw-meter" data-score={{this.score}} aria-hidden="true">
        <i></i>
        <i></i>
        <i></i>
        <i></i>
      </div>
      <ul class="fm-pw-rules" aria-label="Password rules">
        {{#each this.rules key="label" as |rule|}}
          <li data-met={{flag rule.met}}>
            {{#if rule.met}}
              {{icon Check 16}}
            {{else}}
              <span class="fm-pw-dot" aria-hidden="true"></span>
            {{/if}}
            <span class="fm-sr">{{if rule.met "Done: " "To do: "}}</span>
            {{rule.label}}
          </li>
        {{/each}}
      </ul>
    </Field>
  </template>
}

/* 8. Nights: a big stepper */

const checkIn = new Date(2026, 7, 14)
const shortDate = (date: Date) =>
  date.toLocaleDateString("en-US", {
    weekday: "short",
    month: "short",
    day: "numeric",
  })

class Nights extends Component {
  @tracked nights: number | null = 3

  setNights = (value: number | null) => {
    this.nights = value
  }

  get unit() {
    return this.nights === 1 ? "night" : "nights"
  }

  get dates() {
    const checkOut = new Date(checkIn)
    checkOut.setDate(checkIn.getDate() + (this.nights ?? 0))
    return `${shortDate(checkIn)} → ${this.nights ? shortDate(checkOut) : "…"}`
  }

  <template>
    <div class="fm-nights">
      <NumberInput
        @value={{this.nights}}
        @onValueChange={{this.setNights}}
        @min={{1}}
        @max={{21}}
        class="fm-nights-root"
        as |n|
      >
        <n.Group class="fm-nights-group">
          <n.Decrement aria-label="One night fewer" class="fm-round">{{icon
              Minus
              16
            }}</n.Decrement>
          <span class="fm-nights-num">
            <n.Control aria-label="Nights" class="fm-nights-input" />
            <span class="fm-nights-unit">{{this.unit}}</span>
          </span>
          <n.Increment aria-label="One more night" class="fm-round">{{icon
              Plus
              16
            }}</n.Increment>
        </n.Group>
      </NumberInput>
      <p class="fm-nights-dates">{{this.dates}}</p>
    </div>
  </template>
}

/* 9. Fare range: a two-thumb slider over a histogram */

const fareBuckets = [
  3, 6, 11, 18, 26, 31, 28, 34, 30, 24, 21, 17, 19, 14, 11, 9, 8, 6, 7, 5, 4, 3,
  4, 2, 2, 1, 1, 1,
]
const fareMin = 100
const fareStep = 50
const fareMax = fareMin + fareBuckets.length * fareStep
const fareFormat = {
  style: "currency",
  currency: "USD",
  maximumFractionDigits: 0,
} as const

class FareRange extends Component {
  @tracked range = [300, 850]
  fareMin = fareMin
  fareMax = fareMax
  fareStep = fareStep
  fareFormat = fareFormat

  setRange = (value: number | number[]) => {
    this.range = value as number[]
  }

  inRange = (index: number) => {
    const price = fareMin + index * fareStep
    return price >= this.range[0]! && price < this.range[1]!
  }

  get bars() {
    const peak = Math.max(...fareBuckets)
    return fareBuckets.map((count, index) => ({
      index,
      style: htmlSafe(`height: ${(count / peak) * 100}%`),
      in: this.inRange(index),
    }))
  }

  get shown() {
    return fareBuckets.reduce(
      (sum, count, index) => sum + (this.inRange(index) ? count : 0),
      0
    )
  }

  get total() {
    return fareBuckets.reduce((sum, count) => sum + count, 0)
  }

  <template>
    <Field class="fm-fare" as |f|>
      <Slider
        @value={{this.range}}
        @onValueChange={{this.setRange}}
        @min={{this.fareMin}}
        @max={{this.fareMax}}
        @step={{this.fareStep}}
        @minStepsBetweenThumbs={{2}}
        @format={{this.fareFormat}}
        @locale="en-US"
        @field={{f.field}}
        class="fm-fare-slider"
        as |s|
      >
        <div class="fm-field-head">
          <f.Label class="b-label">Fare per person</f.Label>
          <s.Value class="fm-fare-value" />
        </div>
        <div class="fm-hist" aria-hidden="true">
          {{#each this.bars key="index" as |bar|}}
            <i style={{bar.style}} data-in={{flag bar.in}}></i>
          {{/each}}
        </div>
        <s.Control class="fm-fare-control">
          <s.Track class="fm-fare-track">
            <s.Indicator class="fm-fare-fill" />
            <s.Thumb
              @index={{0}}
              @ariaLabel="Lowest fare"
              class="fm-fare-thumb"
            />
            <s.Thumb
              @index={{1}}
              @ariaLabel="Highest fare"
              class="fm-fare-thumb"
            />
          </s.Track>
        </s.Control>
      </Slider>
      <f.Description class="fm-fare-count">
        {{this.shown}}
        of
        {{this.total}}
        flights in range
      </f.Description>
    </Field>
  </template>
}

/* 10. Requests: a growing textarea with a counter and quick adds */

const requestChips = ["Late check-in", "Quiet room", "Extra pillows"]

class Requests extends Component {
  @tracked note = "Arriving on the 23:40 train from Milan."

  setNote = (value: string) => {
    this.note = value
  }

  get full() {
    return this.note.length >= 180
  }

  get chips() {
    return requestChips.map((chip) => ({
      chip,
      added: this.note.includes(chip),
    }))
  }

  add = (chip: string) => {
    this.note = `${this.note.trim()} ${chip}.`.trim().slice(0, 200)
  }

  <template>
    <Field @name="requests" class="fm-req" as |f|>
      <div class="fm-field-head">
        <f.Label class="b-label">Special requests</f.Label>
        <f.Description class="fm-req-count" data-full={{flag this.full}}>
          {{this.note.length}}/200
        </f.Description>
      </div>
      <Textarea
        @value={{this.note}}
        @onValueChange={{this.setNote}}
        @autoResize={{true}}
        @field={{f.field}}
        maxlength="200"
        placeholder="Anything that helps the hotel prepare"
        class="b-input fm-req-area"
      />
      <div class="fm-req-chips">
        {{#each this.chips key="chip" as |entry|}}
          <button
            type="button"
            class="fm-chip"
            disabled={{entry.added}}
            {{on "click" (fn this.add entry.chip)}}
          >
            {{#if entry.added}}
              {{icon Check 14}}
            {{else}}
              {{icon Plus 14}}
            {{/if}}
            {{entry.chip}}
          </button>
        {{/each}}
      </div>
    </Field>
  </template>
}

/* 11. Passport upload */

const passportAccept = ["image/*", ".pdf"]

const Passport = <template>
  <Field class="fm-doc" as |f|>
    <f.Label class="b-label">Passport photo page</f.Label>
    <FileInput
      @name="passport"
      @accept={{passportAccept}}
      @maxSize={{10000000}}
      @field={{f.field}}
      class="fm-doc-root"
      as |i|
    >
      {{#if i.state.value.length}}
        <i.List
          aria-label="Passport scan"
          class="fm-doc-list"
          as |list file row|
        >
          <row.Item class="fm-doc-file" as |item|>
            <span class="fm-doc-icon">{{solid FileText 16}}</span>
            <span class="fm-doc-name">
              {{file.name}}
              <span>{{formatFileSize file.size}} · ready to send</span>
            </span>
            <item.Remove class="fm-icon-btn">{{icon X 16}}</item.Remove>
          </row.Item>
        </i.List>
      {{else}}
        <i.Dropzone class="fm-doc-drop">
          <span class="fm-doc-glyph">{{solid IdCard 16}}</span>
          <span class="fm-doc-hint">Drop a scan here</span>
          <i.Trigger class="b-btn fm-doc-browse">Browse</i.Trigger>
        </i.Dropzone>
      {{/if}}
    </FileInput>
    <f.Description class="fm-doc-desc">
      JPG, PNG or PDF, up to 10 MB.
    </f.Description>
  </Field>
</template>

/* 12. Amenities: a multiple select */

const amenities = [
  {
    value: "breakfast",
    label: "Breakfast included",
    icon: Coffee,
    share: 0.58,
  },
  { value: "pool", label: "Pool", icon: Waves, share: 0.34 },
  { value: "gym", label: "Gym", icon: Dumbbell, share: 0.61 },
  { value: "pets", label: "Pets welcome", icon: PawPrint, share: 0.27 },
  { value: "shuttle", label: "Airport shuttle", icon: Van, share: 0.22 },
]
const amenityItems = amenities.map(({ value, label }) => ({ value, label }))

type ValueState = { placeholder: boolean; label: string; labels: string[] }

const amenitySummary = (state: ValueState) =>
  state.placeholder
    ? "Any amenities"
    : state.labels.length > 2
      ? `${state.labels.slice(0, 2).join(", ")} +${state.labels.length - 2}`
      : state.label

class Amenities extends Component {
  @tracked value: string[] = ["breakfast", "pool"]
  items = amenityItems
  amenities = amenities
  summary = amenitySummary

  setValue = (value: string[]) => {
    this.value = value
  }

  get count() {
    return Math.round(
      amenities.reduce(
        (total, item) =>
          this.value.includes(item.value) ? total * item.share : total,
        640
      )
    )
  }

  <template>
    <div class="fm-am">
      <Select
        @multiple={{true}}
        @items={{this.items}}
        @value={{this.value}}
        @onValueChange={{this.setValue}}
        @placeholder="Any amenities"
        as |s|
      >
        <s.Label class="b-label">Hotel amenities</s.Label>
        <s.Trigger class="fm-am-trigger">
          <s.Value class="fm-trigger-value" as |v|>{{this.summary
              v.state
            }}</s.Value>
          {{icon ChevronDown 16}}
        </s.Trigger>
        <s.Content class="b-pop fm-pop" @sideOffset={{6}}>
          {{#each this.amenities key="value" as |amenity|}}
            <s.Item @value={{amenity.value}} class="b-item fm-option" as |item|>
              <item.Icon class="fm-option-icon">{{solid
                  amenity.icon
                  16
                }}</item.Icon>
              {{amenity.label}}
              <item.Indicator class="fm-option-check">{{icon
                  Check
                  16
                }}</item.Indicator>
            </s.Item>
          {{/each}}
        </s.Content>
      </Select>
      <p class="fm-am-count"><strong>{{this.count}}</strong>
        stays in Kyoto match</p>
    </div>
  </template>
}

/* 13. Save a hotel: a lone toggle */

class SaveHotel extends Component {
  @tracked saved = false

  setSaved = (next: boolean) => {
    this.saved = next
  }

  get status() {
    return this.saved ? "Saved to Summer in Portugal" : ""
  }

  <template>
    <article class="fm-hotel">
      <div class="fm-hotel-top">
        <div>
          <p class="fm-hotel-name">Casa Albergaria Dona Sofia</p>
          <p class="fm-hotel-place">
            Porto, Ribeira ·
            {{solid Star 16}}
            4.8</p>
        </div>
        <Toggle
          @pressed={{this.saved}}
          @onPressedChange={{this.setSaved}}
          @render={{true}}
          as |t|
        >
          <button
            {{t.part}}
            type="button"
            aria-label="Save hotel"
            class="fm-heart"
          >
            {{#if t.state.pressed}}
              {{solid Heart 16}}
            {{else}}
              {{icon Heart 16}}
            {{/if}}
          </button>
        </Toggle>
      </div>
      <div class="fm-hotel-foot">
        <p class="fm-hotel-price">€186<span> / night</span></p>
        <p class="fm-hotel-status" role="status">{{this.status}}</p>
      </div>
    </article>
  </template>
}

/* 14. Name on ticket: a native form with submit and reset */

class TicketName extends Component {
  @tracked status = ""

  submit = (event: Event) => {
    event.preventDefault()
    this.status = "Saved"
  }

  clear = () => {
    this.status = ""
  }

  <template>
    <form class="fm-stub" {{on "submit" this.submit}} {{on "reset" this.clear}}>
      <Field @name="ticket-name" class="fm-field" as |f|>
        <div class="fm-field-head">
          <f.Label class="b-label">Name on ticket</f.Label>
          <f.Error class="fm-error" @match="valueMissing">Required</f.Error>
          <f.Error class="fm-error" @match="patternMismatch">Letters only</f.Error>
        </div>
        <Input
          class="b-input fm-stub-input"
          @defaultValue="AMARA J NWOSU"
          @required={{true}}
          @field={{f.field}}
          @onValueChange={{this.clear}}
          pattern="[A-Za-z ]+"
          autocomplete="name"
          spellcheck="false"
        />
        <f.Description class="fm-stub-desc">
          Exactly as printed in your passport.
        </f.Description>
      </Field>
      <div class="fm-stub-actions">
        <span class="fm-stub-status" role="status">
          {{#if this.status}}{{icon Check 14}}{{/if}}
          {{this.status}}
        </span>
        <button type="reset" class="b-btn" data-variant="ghost">Reset</button>
        <button type="submit" class="b-btn" data-variant="primary">Save</button>
      </div>
    </form>
  </template>
}

/* 15. Promo code: Field validation from an async check */

class Promo extends Component {
  @tracked code = "SPRING10"
  @tracked error: string | null = null
  @tracked applied = false

  get invalid() {
    return this.error ? true : undefined
  }

  setCode = (value: string) => {
    this.code = value.toUpperCase()
    this.error = null
    this.applied = false
  }

  apply = (event: Event) =>
    submitWhenValid(event, async () => {
      await wait(900)
      if (this.code === "WANDER15") {
        this.applied = true
      } else {
        this.error =
          this.code === "SPRING10" ? "Expired Apr 30" : "Not a valid code"
      }
    })

  <template>
    <form class="fm-promo" {{on "submit" preventDefault}}>
      <Field @name="promo" @invalid={{this.invalid}} class="fm-field" as |f|>
        <div class="fm-field-head">
          <f.Label class="b-label">Promo code</f.Label>
          <f.Error class="fm-error" @match="valueMissing">Enter a code</f.Error>
          {{#if this.error}}
            <f.Error class="fm-error" @match={{true}}>{{this.error}}</f.Error>
          {{/if}}
        </div>
        <div class="fm-promo-row">
          <InputGroup class="b-input fm-input-group fm-promo-group" as |g|>
            {{solid Ticket 16}}
            <Input
              class="fm-bare-input fm-mono"
              @value={{this.code}}
              @onValueChange={{this.setCode}}
              @required={{true}}
              @field={{f.field}}
              autocomplete="off"
              spellcheck="false"
              placeholder="CODE"
            />
            <g.Clear aria-label="Clear code" class="fm-icon-btn">{{icon
                X
                16
              }}</g.Clear>
          </InputGroup>
          <Button
            class="b-btn fm-promo-btn"
            data-variant="primary"
            @type="submit"
            @pendingAnnouncement="Checking code"
            @onClick={{this.apply}}
            as |b|
          >
            {{#if b.state.pending}}{{spinner}}{{else}}Apply{{/if}}
          </Button>
        </div>
      </Field>
      <p class="fm-promo-result" data-applied={{flag this.applied}}>
        {{#if this.applied}}
          {{solid CircleCheck 16}}
          15% off · −$63.30
        {{else}}
          Try
          <span class="fm-mono">WANDER15</span>
        {{/if}}
      </p>
    </form>
  </template>
}

/* 16. Automatic check-in: a big switch in a Field */

class AutoCheckIn extends Component {
  @tracked on = true

  setOn = (next: boolean) => {
    this.on = next
  }

  get description() {
    return this.on
      ? "Boarding pass lands 24 h before takeoff."
      : "You’ll check in yourself at the desk."
  }

  <template>
    <Field class="fm-auto" as |f|>
      <div class="fm-auto-text">
        <f.Label class="fm-auto-label">Automatic check-in</f.Label>
        <f.Description class="fm-auto-desc">{{this.description}}</f.Description>
      </div>
      <Switch
        @checked={{this.on}}
        @onCheckedChange={{this.setOn}}
        @field={{f.field}}
        class="fm-big-switch"
        as |s|
      >
        <s.Thumb class="fm-big-thumb">
          {{#if this.on}}
            {{icon Check 16}}
          {{else}}
            {{icon X 16}}
          {{/if}}
        </s.Thumb>
      </Switch>
    </Field>
  </template>
}

/* 17. Room type: a single select in a Field */

const rooms = [
  { value: "king", label: "Deluxe king", note: "City view", price: 289 },
  { value: "twin", label: "Twin garden", note: "Ground floor", price: 264 },
  { value: "suite", label: "Junior suite", note: "Soaking tub", price: 412 },
  {
    value: "loft",
    label: "Family loft",
    note: "Sold out",
    price: 455,
    disabled: true,
  },
]

class RoomType extends Component {
  @tracked room: string | null = "king"
  rooms = rooms

  setRoom = (value: string | null) => {
    this.room = value
  }

  get chosen() {
    return rooms.find((item) => item.value === this.room)
  }

  get price() {
    return this.chosen ? `$${this.chosen.price}` : ""
  }

  get total() {
    return this.chosen ? `$${this.chosen.price * 2}` : "—"
  }

  <template>
    <div class="fm-room">
      <Field @name="room" class="fm-field" as |f|>
        <f.Label class="b-label">Room type</f.Label>
        <Select
          @items={{this.rooms}}
          @value={{this.room}}
          @onValueChange={{this.setRoom}}
          @field={{f.field}}
          as |s|
        >
          <s.Trigger class="b-input fm-trigger fm-room-trigger">
            <s.Value class="fm-trigger-value" />
            <span class="fm-room-price">{{this.price}}</span>
            {{icon ChevronDown 16}}
          </s.Trigger>
          <s.Content class="b-pop fm-pop fm-room-pop" @sideOffset={{6}}>
            {{#each this.rooms key="value" as |item|}}
              <s.Item
                @value={{item.value}}
                @label={{item.label}}
                @disabled={{item.disabled}}
                class="b-item fm-room-item"
              >
                <span class="fm-room-text">
                  {{item.label}}
                  <span>{{item.note}}</span>
                </span>
                <span class="fm-room-item-price">${{item.price}}</span>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </Field>
      <p class="fm-room-total">
        <span>2 nights</span>
        <strong>{{this.total}}</strong>
      </p>
    </div>
  </template>
}

/* 18. Bags: a compact stepper and a checkbox that price as they change */

class Bags extends Component {
  @tracked bags: number | null = 1
  @tracked priority = false

  setBags = (value: number | null) => {
    this.bags = value
  }

  setPriority = (next: boolean | "indeterminate") => {
    this.priority = next === true
  }

  get total() {
    return (this.bags ?? 0) * 35 + (this.priority ? 18 : 0)
  }

  <template>
    <div class="fm-bags">
      <div class="fm-bags-row">
        <span class="fm-bags-icon">{{solid Luggage 16}}</span>
        <span class="fm-bags-text">
          Checked bags
          <span>23 kg each · $35</span>
        </span>
        <NumberInput
          @value={{this.bags}}
          @onValueChange={{this.setBags}}
          @min={{0}}
          @max={{3}}
          class="fm-mini"
          as |n|
        >
          <n.Group class="fm-mini-group">
            <n.Decrement aria-label="Remove a bag" class="fm-mini-btn">{{icon
                Minus
                16
              }}</n.Decrement>
            <n.Control aria-label="Checked bags" class="fm-mini-input" />
            <n.Increment aria-label="Add a bag" class="fm-mini-btn">{{icon
                Plus
                16
              }}</n.Increment>
          </n.Group>
        </NumberInput>
      </div>
      <label class="fm-bags-row fm-bags-check">
        <Checkbox
          @checked={{this.priority}}
          @onCheckedChange={{this.setPriority}}
          class="fm-box"
          as |c|
        >
          <c.Indicator class="fm-box-mark">{{icon Check 16}}</c.Indicator>
        </Checkbox>
        <span class="fm-bags-text">Priority boarding</span>
        <span class="fm-bags-add">+$18</span>
      </label>
      <p class="fm-bags-total">
        <span>Extras</span>
        <strong>${{this.total}}</strong>
      </p>
    </div>
  </template>
}

/* 19. Payment method: a required radio group in a Field */

const methods = [
  {
    value: "card",
    label: "Card ending 4417",
    detail: "Exp 08/28",
    icon: CreditCard,
  },
  {
    value: "credit",
    label: "Travel credit",
    detail: "$120 left",
    icon: Coins,
  },
  { value: "bank", label: "Bank transfer", detail: "2–3 days", icon: Landmark },
]

class PaymentMethod extends Component {
  @tracked done = false
  methods = methods

  reset = () => {
    this.done = false
  }

  submit = (event: Event) =>
    submitWhenValid(event, async () => {
      await wait(900)
      this.done = true
    })

  <template>
    <form class="fm-pm" {{on "submit" preventDefault}}>
      <Field @name="method" class="fm-field" as |f|>
        <f.Label class="b-label">Pay with</f.Label>
        <RadioGroup
          @required={{true}}
          @onValueChange={{this.reset}}
          @field={{f.field}}
          class="fm-pm-list"
          as |g|
        >
          {{#each this.methods key="value" as |method|}}
            <label class="fm-pm-row">
              {{solid method.icon 14}}
              <span class="fm-pm-label">{{method.label}}</span>
              <span class="fm-pm-detail">{{method.detail}}</span>
              <g.Radio @value={{method.value}} class="fm-dot" as |r|>
                <r.Indicator class="fm-dot-in" />
              </g.Radio>
            </label>
          {{/each}}
        </RadioGroup>
        <div class="fm-pm-foot">
          <f.Error class="fm-error" @match="valueMissing">Choose how to pay</f.Error>
          <Button
            class="b-btn fm-pm-btn"
            data-variant="primary"
            @type="submit"
            @onClick={{this.submit}}
            as |b|
          >
            {{#if b.state.pending}}
              {{spinner 14}}
            {{else if this.done}}
              {{icon Check 14}}
              Confirmed
            {{else}}
              Continue
            {{/if}}
          </Button>
        </div>
      </Field>
    </form>
  </template>
}

/* 20. Preferred airlines: a multiple combobox with chips */

const airlines = [
  { value: "aer-lingus", label: "Aer Lingus" },
  { value: "air-nz", label: "Air New Zealand" },
  { value: "alaska", label: "Alaska Airlines" },
  { value: "emirates", label: "Emirates" },
  { value: "finnair", label: "Finnair" },
  { value: "klm", label: "KLM" },
  { value: "qantas", label: "Qantas" },
  { value: "singapore", label: "Singapore Airlines" },
  { value: "turkish", label: "Turkish Airlines" },
]
const airlineLabel = (value: string) =>
  airlines.find((item) => item.value === value)?.label ?? value

const strings = (value: unknown) => value as string[]

class Airlines extends Component {
  @tracked value: string[] = ["finnair", "qantas"]
  airlines = airlines
  itemToLabel = airlineLabel
  strings = strings

  setValue = (next: unknown) => {
    this.value = next as string[]
  }

  get placeholder() {
    return this.value.length >= 4 ? "" : "Add an airline"
  }

  <template>
    <div class="fm-air">
      <Combobox
        @multiple={{true}}
        @value={{this.value}}
        @onValueChange={{this.setValue}}
        @itemToLabel={{this.itemToLabel}}
        @maxSelected={{4}}
        as |c|
      >
        <div class="fm-field-head">
          <c.Label class="b-label">Preferred airlines</c.Label>
          <span class="fm-air-count">{{this.value.length}} of 4</span>
        </div>
        <c.Chips class="b-input fm-chips">
          <c.Value as |state|>
            {{#each (this.strings state.value) key="@identity" as |item index|}}
              <c.Chip @value={{item}} class="fm-air-chip" as |chip|>
                {{get state.labels index}}
                <chip.Remove
                  aria-label="Remove {{get state.labels index}}"
                  class="fm-air-remove"
                >{{icon X 14}}</chip.Remove>
              </c.Chip>
            {{/each}}
          </c.Value>
          <c.Input class="fm-chips-input" placeholder={{this.placeholder}} />
        </c.Chips>
        <c.Content class="b-pop fm-pop" @sideOffset={{6}}>
          <c.Empty class="fm-empty">No airline by that name.</c.Empty>
          <c.List class="fm-list">
            {{#each this.airlines key="value" as |airline|}}
              <c.Item
                @value={{airline.value}}
                @label={{airline.label}}
                class="b-item fm-option"
                as |item|
              >
                <item.Text class="fm-match" />
                <item.Indicator class="fm-option-check">{{icon
                    Check
                    14
                  }}</item.Indicator>
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Combobox>
      <p class="fm-air-note">Their fares show first in results.</p>
    </div>
  </template>
}

export const tiles: Tile[] = [
  {
    id: "forms-checkout",
    title: "Pay for the trip.",
    blurb: "Every field checks itself before you pay.",
    size: "large",
    Demo: Checkout,
  },
  {
    id: "forms-cabin",
    title: "Choose your cabin.",
    blurb: "Whole cards select, arrows included.",
    Demo: Cabin,
  },
  {
    id: "forms-verify",
    title: "Prove it’s you.",
    blurb: "Paste or type; it checks itself.",
    tone: "sky",
    Demo: Verify,
  },
  {
    id: "forms-flight-search",
    title: "Plan the route.",
    blurb: "Type a city or a code to find airports.",
    size: "wide",
    tone: "paper",
    Demo: FlightSearch,
  },
  {
    id: "forms-alerts",
    title: "Choose your alerts.",
    blurb: "One parent box checks its whole group.",
    size: "tall",
    Demo: Alerts,
  },
  {
    id: "forms-new-password",
    title: "Make it strong.",
    blurb: "Rules tick off as you type.",
    tone: "paper",
    Demo: NewPassword,
  },
  {
    id: "forms-nights",
    title: "Stay a little longer.",
    blurb: "A stepper that clamps to your stay.",
    tone: "butter",
    Demo: Nights,
  },
  {
    id: "forms-fare-range",
    title: "Set a price window.",
    blurb: "Two thumbs frame the fares you want.",
    tone: "ink",
    Demo: FareRange,
  },
  {
    id: "forms-seat-map",
    title: "Pick a seat.",
    blurb: "Arrow through the cabin, press to choose.",
    size: "wide",
    Demo: SeatMap,
  },
  {
    id: "forms-requests",
    title: "Note for the hotel.",
    blurb: "Grows with your text and counts it.",
    Demo: Requests,
  },
  {
    id: "forms-passport",
    title: "Add your passport.",
    blurb: "Drop a scan or browse for one.",
    Demo: Passport,
  },
  {
    id: "forms-amenities",
    title: "Must-haves only.",
    blurb: "Pick several; the trigger sums them up.",
    tone: "sage",
    Demo: Amenities,
  },
  {
    id: "forms-save-hotel",
    title: "Save it for later.",
    blurb: "A pressed state that stays put.",
    tone: "paper",
    Demo: SaveHotel,
  },
  {
    id: "forms-ticket-name",
    title: "Match your passport.",
    blurb: "Reset brings back the saved name.",
    Demo: TicketName,
  },
  {
    id: "forms-promo",
    title: "Apply a promo code.",
    blurb: "Bad codes explain themselves inline.",
    tone: "blueprint",
    Demo: Promo,
  },
  {
    id: "forms-auto-check-in",
    title: "Check in on time.",
    blurb: "Flip it by tap, label or Space.",
    tone: "signal",
    Demo: AutoCheckIn,
  },
  {
    id: "forms-room-type",
    title: "Choose a room.",
    blurb: "Prices ride along in the list.",
    tone: "paper",
    Demo: RoomType,
  },
  {
    id: "forms-bags",
    title: "Add checked bags.",
    blurb: "Extras price themselves as you count.",
    Demo: Bags,
  },
  {
    id: "forms-payment-method",
    title: "Pick how to pay.",
    blurb: "Skipping a required choice gets flagged.",
    tone: "paper",
    Demo: PaymentMethod,
  },
  {
    id: "forms-airlines",
    title: "Fly who you like.",
    blurb: "Type to add airlines as chips.",
    Demo: Airlines,
  },
]
