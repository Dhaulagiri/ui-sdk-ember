import Component from "@glimmer/component"
import { calendar } from "@ui-sdk/core/calendar"
import { usePart, type PartSignature } from "../use-part"

/** A native select of the months, in the locale, that turns the first month shown. */
class CalendarMonthSelect extends Component<
  PartSignature<typeof calendar, "month-select", HTMLSelectElement>
> {
  part = usePart(this, () => this.args.handle, "month-select")

  isSelected = (value: unknown) => value === this.part.state.value

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <select ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield this.part.yielded}}{{else}}{{~#each
            this.part.state.options key="value"
            as |choice|
          ~}}<option
              value={{choice.value}}
              disabled={{choice.disabled}}
              selected={{this.isSelected choice.value}}
            >{{choice.label}}</option>{{~/each~}}{{/if~}}
      </select>
    {{/if}}
  </template>
}

export default CalendarMonthSelect
