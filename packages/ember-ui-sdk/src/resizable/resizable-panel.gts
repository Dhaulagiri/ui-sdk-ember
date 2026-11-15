import Component from "@glimmer/component"
import { resizable } from "@ui-sdk/core/resizable"
import { usePart, type PartSignature } from "../use-part"

/** A panel. Its size is written to `--resizable-panel-size` on every frame of a drag, so it never renders for a resize unless its block reads `size`. */
class ResizablePanel extends Component<
  PartSignature<typeof resizable, "panel", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "panel")

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

export default ResizablePanel
