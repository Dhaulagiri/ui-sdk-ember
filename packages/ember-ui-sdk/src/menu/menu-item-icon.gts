import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import { menuItemIcons } from "@ui-sdk/core/renderer"
import { featureProps } from "./feature-props"
import { usePart, type PartSignature } from "../use-part"

/** An icon inside an item or a submenu trigger. Screen readers and typeahead skip it, and `@mirror` flips it in right-to-left text. */
class MenuItemIcon extends Component<
  PartSignature<typeof menu, "item-icon", HTMLSpanElement>
> {
  feature = this.args.handle.instance.use(menuItemIcons)
  part = usePart(
    this,
    () => this.args.handle,
    "item-icon",
    featureProps(menuItemIcons, "item-icon", () => this.args)
  )

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

export default MenuItemIcon
