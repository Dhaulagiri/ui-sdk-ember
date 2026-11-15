import Component from "@glimmer/component"
import { meter } from "@ui-sdk/core/meter"
import { usePart, type PartSignature } from "../use-part"

/** Names the meter. */
class MeterLabel extends Component<
  PartSignature<typeof meter, "label", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "label")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</span>
    {{/if}}
  </template>
}

export default MeterLabel
