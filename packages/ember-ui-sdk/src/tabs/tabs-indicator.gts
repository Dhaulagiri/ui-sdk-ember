import Component from "@glimmer/component"
import { tabs } from "@ui-sdk/core/tabs"
import { usePart, type PartSignature } from "../use-part"

/** Marks the selected tab. Its box comes from the `--active-tab-*` variables. */
class TabsIndicator extends Component<
  PartSignature<typeof tabs, "indicator", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "indicator")

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

export default TabsIndicator
