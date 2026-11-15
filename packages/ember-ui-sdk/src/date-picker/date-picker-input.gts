import Component from "@glimmer/component"
import { datePicker } from "@ui-sdk/core/date-picker"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart, type PartSignature } from "../use-part"

/** A text input that reads a date typed in the page's language on Enter or blur. `end` makes it a range's end. The core writes its text. */
class DatePickerInput extends Component<
  PartSignature<
    typeof datePicker,
    "input",
    HTMLInputElement,
    { id?: string; field?: FieldContext }
  >
> {
  isEnd = !!this.args.end
  part = usePart(
    this,
    () => this.args.handle,
    "input",
    () => ({
      end: this.isEnd,
      id: this.isEnd ? "end" : "start",
    })
  )
  fieldControl = this.isEnd
    ? undefined
    : useFieldControl(this, () => ({
        id: this.args.id,
        describedBy: this.part.attrs["aria-describedby"],
      }))

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else if this.fieldControl}}
      <input
        id={{@id}}
        ...attributes
        {{this.part.modifier}}
        {{this.fieldControl.modifier}}
      />
    {{else}}
      <input id={{@id}} ...attributes {{this.part.modifier}} />
    {{/if}}
  </template>
}

export default DatePickerInput
