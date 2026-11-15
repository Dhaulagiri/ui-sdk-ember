import Component from "@glimmer/component"
import { datePicker } from "@ui-sdk/core/date-picker"
import { usePart, type PartSignature } from "../use-part"

/** Clears the value and focuses the input. */
class DatePickerClear extends Component<
  PartSignature<typeof datePicker, "clear", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "clear")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default DatePickerClear
