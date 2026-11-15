import Component from "@glimmer/component"
import { tabs } from "@ui-sdk/core/tabs"
import { usePart, type PartSignature } from "../use-part"

/** An icon inside a tab. Screen readers skip it, and `@mirror` flips it in right-to-left text. */
class TabsTabIcon extends Component<
  PartSignature<typeof tabs, "tab-icon", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "tab-icon")

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

export default TabsTabIcon
