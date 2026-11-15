import Component from "@glimmer/component"
import { datePicker } from "@ui-sdk/core/date-picker"
import { usePart, type PartSignature } from "../use-part"

/** Selects the value it holds, like the last 7 days. */
class DatePickerPreset extends Component<
  PartSignature<typeof datePicker, "preset", HTMLButtonElement>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "preset",
    () => ({
      value: this.args.value,
      id: JSON.stringify(this.args.value),
    })
  )

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

export default DatePickerPreset
