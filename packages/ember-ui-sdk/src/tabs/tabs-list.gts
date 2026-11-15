import Component from "@glimmer/component"
import { tabs } from "@ui-sdk/core/tabs"
import { usePart, type PartSignature } from "../use-part"

/** The row of tabs, a tablist with one tab stop and arrow keys between its tabs. */
class TabsList extends Component<
  PartSignature<typeof tabs, "list", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "list")

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

export default TabsList
