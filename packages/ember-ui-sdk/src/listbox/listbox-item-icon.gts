import type { TOC } from "@ember/component/template-only"
import type { listbox } from "@ui-sdk/core/listbox"
import ItemIcon from "../item-icon.gts"
import type { PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

/** An icon inside an item. Screen readers and typeahead skip it, and `@mirror` flips it in right-to-left text. */
const ListboxItemIcon: TOC<{
  Element: HTMLSpanElement
  Args: {
    handle: PrimitiveHandle<typeof listbox>
    item?: string
    mirror?: boolean
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> = <template>
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

export default ListboxItemIcon
