import Component from "@glimmer/component"
import { tabs } from "@ui-sdk/core/tabs"
import { usePart, type PartSignature } from "../use-part"

/** A tab. Selecting it shows the panel with the same `@value`. */
class TabsTab extends Component<
  PartSignature<typeof tabs, "tab", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "tab")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default TabsTab
