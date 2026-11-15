import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import { menuCheckable } from "@ui-sdk/core/renderer"
import { usePart, type PartSignature } from "../use-part"
import { featureProps } from "./feature-props"
import MenuItemIndicator from "./menu-item-indicator.gts"

/** An item that checks and unchecks an option. Yields its `Indicator`. */
class MenuCheckboxItem extends Component<
  PartSignature<typeof menu, "checkbox-item", HTMLDivElement>
> {
  feature = this.args.handle.instance.use(menuCheckable)
  part = usePart(
    this,
    () => this.args.handle,
    "checkbox-item",
    featureProps(menuCheckable, "checkbox-item", () => this.args)
  )

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Indicator=(component
          MenuItemIndicator
          handle=@handle
          item="checkbox-item"
          itemKey=@value
          checked=@checked
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

export default MenuCheckboxItem
