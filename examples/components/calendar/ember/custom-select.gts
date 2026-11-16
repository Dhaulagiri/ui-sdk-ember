import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown, ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
].map((label, index) => ({
  value: String(index + 1).padStart(2, "0"),
  label,
}))

const years = ["2024", "2025", "2026", "2027", "2028"].map((year) => ({
  value: year,
  label: year,
}))

export default class CustomSelect extends Component {
  months = months
  years = years
  @tracked month = "2026-10"

  get year() {
    return this.month.split("-")[0]
  }

  get monthOfYear() {
    return this.month.split("-")[1]
  }

  onMonthChange = (next: string | null) => {
    if (next) this.month = `${this.year}-${next}`
  }

  onYearChange = (next: string | null) => {
    if (next) this.month = `${next}-${this.monthOfYear}`
  }

  setMonth = (next: string) => {
    this.month = next
  }

  <template>
    <Calendar
      @month={{this.month}}
      @onMonthChange={{this.setMonth}}
      @defaultValue="2026-10-16"
      @min="2024-01-01"
      @max="2028-12-31"
      as |c|
    >
      <div data-slot="row">
        <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
        <c.Heading />
        <Select
          @items={{this.months}}
          @value={{this.monthOfYear}}
          @onValueChange={{this.onMonthChange}}
          as |s|
        >
          <s.Trigger aria-label="Month">
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.months key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <Select
          @items={{this.years}}
          @value={{this.year}}
          @onValueChange={{this.onYearChange}}
          as |s|
        >
          <s.Trigger aria-label="Year">
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.years key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
      </div>
      <c.Grid />
    </Calendar>
  </template>
}
