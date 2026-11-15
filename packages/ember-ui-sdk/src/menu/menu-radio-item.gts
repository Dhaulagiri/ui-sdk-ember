import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import { menuCheckable } from "@ui-sdk/core/renderer"
import { usePart, type PartSignature } from "../use-part"
import { featureProps } from "./feature-props"
import MenuItemIndicator from "./menu-item-indicator.gts"

/** An item in a radio group. Pressing it checks its value. Yields its `Indicator`. */
class MenuRadioItem extends Component<
  PartSignature<
    typeof menu,
    "radio-item",
    HTMLDivElement,
    { group: string; groupValue?: string | null }
  >
> {
  feature = this.args.handle.instance.use(menuCheckable)
  // Whether the item is checked follows the group's controlled value, which
  // the core reads from the group's props, so the item reads it too.
  props = featureProps(menuCheckable, "radio-item", () => this.args)
  part = usePart(
    this,
    () => this.args.handle,
    "radio-item",
    () => (this.args.groupValue, this.props())
  )

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Indicator=(component
          MenuItemIndicator
          handle=@handle
          item="radio-item"
          itemKey=@value
          group=@group
          checked=@groupValue
        )
      )
      as |item|
    }}
      {{#if @render}}
        {{yield item}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield item}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default MenuRadioItem
