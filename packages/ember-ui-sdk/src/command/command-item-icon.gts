import Component from "@glimmer/component"
import type { command } from "@ui-sdk/core/command"
import ItemIcon from "../item-icon.gts"
import type { PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

/**
 * An icon inside a command. Screen readers, typeahead and filtering skip it, and `@mirror`
 * flips it in right-to-left text.
 */
class CommandItemIcon extends Component<{
  Element: HTMLSpanElement
  Args: {
    handle: PrimitiveHandle<typeof command>
    item?: string
    mirror?: boolean
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  <template>
    <ItemIcon
      ...attributes
      @handle={{@handle}}
      @partName="item-icon"
      @item={{@item}}
      @mirror={{@mirror}}
      @render={{@render}}
      as |icon|
    >{{yield icon}}</ItemIcon>
  </template>
}

export default CommandItemIcon
