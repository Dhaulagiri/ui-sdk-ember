import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import { menuCheckable } from "@ui-sdk/core/renderer"
import { featureProps } from "./feature-props"
import { usePart, type PartSignature } from "../use-part"

/** The check or dot inside a checkbox or radio item. Rendered while the item is checked, or always with `@keepMounted`. */
class MenuItemIndicator extends Component<
  PartSignature<
    typeof menu,
    "item-indicator",
    HTMLSpanElement,
    {
      item: "checkbox-item" | "radio-item"
      itemKey: string
      group?: string
      checked?: unknown
    }
  >
> {
  feature = this.args.handle.instance.use(menuCheckable)
  // A controlled `checked` or group value is read from the item's props, so
  // the indicator reads it to render again when it changes.
  props = featureProps(menuCheckable, "item-indicator", () => this.args)
  part = usePart(
    this,
    () => this.args.handle,
    "item-indicator",
    () => (this.args.checked, this.props())
  )

  <template>
    {{#if this.part.present}}
      {{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <span ...attributes {{this.part.modifier}}>{{yield
            this.part.yielded
          }}</span>
      {{/if}}
    {{/if}}
  </template>
}

export default MenuItemIndicator
