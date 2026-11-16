import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronLeft, ChevronRight, Calendar, X } from "lucide"
import type { DatePickerValue } from "@ui-sdk/core/date-picker"
import { DatePicker } from "ember-ui-sdk/date-picker"
import { icon } from "../../../shared/ember/icon"

export default class Dismissible extends Component {
  @tracked value: DatePickerValue = null
  @tracked asking = false

  get hasValue() {
    return this.value !== null
  }

  onValueChange = (next: DatePickerValue) => {
    this.value = next
    this.asking = false
  }

  onOpenChange = (open: boolean) => {
    if (open) this.asking = false
  }

  onDismissAttempt = () => {
    this.asking = true
  }

  <template>
    <DatePicker
      @value={{this.value}}
      @mode="range"
      @defaultMonth="2026-10"
      @dismissible={{this.hasValue}}
      @onValueChange={{this.onValueChange}}
      @onOpenChange={{this.onOpenChange}}
      @onDismissAttempt={{this.onDismissAttempt}}
      as |dp|
    >
      <div data-slot="row">
        <dp.Input aria-label="Check in" placeholder="Check in" />
        <span data-slot="hint">–</span>
        <dp.Input
          @end={{true}}
          aria-label="Check out"
          placeholder="Check out"
        />
        <dp.Trigger data-variant="ghost">{{icon Calendar}}</dp.Trigger>
      </div>
      <dp.Content>
        <div data-slot="row">
          <dp.Previous data-variant="ghost">{{icon ChevronLeft}}</dp.Previous>
          <dp.Heading />
          <dp.Next data-variant="ghost">{{icon ChevronRight}}</dp.Next>
        </div>
        <dp.Grid />
        {{#if this.asking}}
          <p data-slot="hint" role="alert">Pick a check-out date to finish your
            stay.</p>
        {{/if}}
      </dp.Content>
    </DatePicker>
  </template>
}
