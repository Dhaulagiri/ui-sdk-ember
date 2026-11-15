import Component from "@glimmer/component"
import { datePicker } from "@ui-sdk/core/date-picker"
import { usePart, type PartSignature } from "../use-part"

/** Opens the calendar. Named "Choose date" and the date chosen; pass `aria-label` in another language. */
class DatePickerTrigger extends Component<
  PartSignature<typeof datePicker, "trigger", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield this.part.yielded}}{{else}}<svg
            width="16"
            height="16"
            viewBox="0 0 16 16"
            fill="none"
            stroke="currentColor"
            aria-hidden="true"
          ><rect x="2" y="3" width="12" height="11" rx="1.5" /><path
              d="M2 6.5h12M5.5 1.5v3M10.5 1.5v3"
            /></svg>{{/if~}}
      </button>
    {{/if}}
  </template>
}

export default DatePickerTrigger
