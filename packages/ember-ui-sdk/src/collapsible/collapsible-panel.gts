import Component from "@glimmer/component"
import { collapsible } from "@ui-sdk/core/collapsible"
import { usePart, type PartSignature } from "../use-part"

/** The content the trigger shows and hides. Closed, it leaves the page unless `@keepMounted` or `@hiddenUntilFound` keeps it. */
class CollapsiblePanel extends Component<
  PartSignature<typeof collapsible, "panel", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "panel")

  <template>
    {{#if this.part.present}}
      {{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield
            this.part.yielded
          }}</div>
      {{/if}}
    {{/if}}
  </template>
}

export default CollapsiblePanel
