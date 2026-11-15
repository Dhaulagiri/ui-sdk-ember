import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"

/** The select's visible label, which names its trigger. */
class SelectLabel extends Component<
  PartSignature<typeof select, "label", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "label")

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

export default SelectLabel
