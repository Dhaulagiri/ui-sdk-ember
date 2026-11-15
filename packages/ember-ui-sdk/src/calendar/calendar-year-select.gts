import Component from "@glimmer/component"
import { calendar } from "@ui-sdk/core/calendar"
import { usePart, type PartSignature } from "../use-part"

/** A native select of the years from the minimum to the maximum, or 10 either side of the year shown. */
class CalendarYearSelect extends Component<
  PartSignature<typeof calendar, "year-select", HTMLSelectElement>
> {
  part = usePart(this, () => this.args.handle, "year-select")

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

export default CalendarYearSelect
