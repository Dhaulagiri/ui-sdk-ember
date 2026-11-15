import Component from "@glimmer/component"
import { tooltip } from "@ui-sdk/core/tooltip"
import { usePart, type PartSignature } from "../use-part"

/** An arrow on the tooltip's edge that points at its trigger. */
class TooltipArrow extends Component<
  PartSignature<typeof tooltip, "arrow", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "arrow")

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

export default TooltipArrow
