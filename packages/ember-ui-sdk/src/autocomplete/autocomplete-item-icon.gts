import Component from "@glimmer/component"
import type { autocomplete } from "@ui-sdk/core/autocomplete"
import ItemIcon from "../item-icon.gts"
import type { PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

/**
 * An icon inside a suggestion. Screen readers, typeahead and filtering skip it, and `@mirror`
 * flips it in right-to-left text.
 */
class AutocompleteItemIcon extends Component<{
  Element: HTMLSpanElement
  Args: {
    handle: PrimitiveHandle<typeof autocomplete>
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

export default AutocompleteItemIcon
