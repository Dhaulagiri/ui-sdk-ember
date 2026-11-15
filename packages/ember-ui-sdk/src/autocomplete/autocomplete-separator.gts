import Component from "@glimmer/component"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { usePart, type PartSignature } from "../use-part"

/** A line between items or groups, hidden from screen readers. */
class AutocompleteSeparator extends Component<
  PartSignature<typeof autocomplete, "separator", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "separator")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{/if}}
  </template>
}

export default AutocompleteSeparator
