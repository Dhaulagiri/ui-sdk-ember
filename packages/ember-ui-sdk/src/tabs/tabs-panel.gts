import Component from "@glimmer/component"
import { tabs } from "@ui-sdk/core/tabs"
import { usePart, type PartSignature } from "../use-part"

/** The content of the tab with the same `@value`, shown while that tab is selected. */
class TabsPanel extends Component<
  PartSignature<typeof tabs, "panel", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "panel")

  <template>
    {{#if this.part.present}}{{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield
            this.part.yielded
          }}</div>
      {{/if}}{{/if}}
  </template>
}

export default TabsPanel
