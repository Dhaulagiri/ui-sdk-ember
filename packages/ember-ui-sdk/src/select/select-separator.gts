import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"

/** A line between items or groups. */
class SelectSeparator extends Component<
  PartSignature<typeof select, "separator", HTMLDivElement>
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

export default SelectSeparator
