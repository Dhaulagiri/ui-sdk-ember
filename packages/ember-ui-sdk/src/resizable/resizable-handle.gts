import Component from "@glimmer/component"
import { resizable } from "@ui-sdk/core/resizable"
import { usePart, type PartSignature } from "../use-part"

/** The handle between two panels: a focusable separator to drag or move with keys. */
class ResizableHandle extends Component<
  PartSignature<typeof resizable, "handle", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "handle")

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

export default ResizableHandle
