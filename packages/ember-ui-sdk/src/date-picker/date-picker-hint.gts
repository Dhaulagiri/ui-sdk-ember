import Component from "@glimmer/component"
import { datePicker } from "@ui-sdk/core/date-picker"
import { usePart, type PartSignature } from "../use-part"

/** The format to type, like "MM/DD/YYYY". The inputs are described by it. */
class DatePickerHint extends Component<
  PartSignature<typeof datePicker, "hint", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "hint")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{this.part.state.placeholder}}{{/if~}}
      </span>
    {{/if}}
  </template>
}

export default DatePickerHint
