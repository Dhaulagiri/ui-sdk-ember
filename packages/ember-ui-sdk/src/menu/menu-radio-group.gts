import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import { menuCheckable } from "@ui-sdk/core/renderer"
import { usePart, type PartSignature } from "../use-part"
import { featureProps } from "./feature-props"
import MenuGroupLabel from "./menu-group-label.gts"
import MenuRadioItem from "./menu-radio-item.gts"

let count = 0

/** Radio items that share one value. Yields its `Label` and `Item`. */
class MenuRadioGroup extends Component<
  PartSignature<typeof menu, "radio-group", HTMLDivElement>
> {
  feature = this.args.handle.instance.use(menuCheckable)
  // The name identifies the group for its life, so it's read once.
  group = this.args.name ?? `ui-sdk-e-radio-group${++count}`
  props = featureProps(menuCheckable, "radio-group", () => this.args)
  part = usePart(
    this,
    () => this.args.handle,
    "radio-group",
    () => ({
      ...this.props(),
      id: this.group,
      name: this.group,
    })
  )

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Label=(component MenuGroupLabel handle=@handle group=this.group)
        Item=(component
          MenuRadioItem handle=@handle group=this.group groupValue=@value
        )
      )
      as |group|
    }}
      {{#if @render}}
        {{yield group}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield group}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default MenuRadioGroup
