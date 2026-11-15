import Component from "@glimmer/component"
import { usePart } from "./use-part"
import type { PrimitiveHandle } from "./use-primitive"

// The selected item's icon, copied from its item's icon part. Rendered while
// one item is selected and it has an icon. Its content is the copy the core
// writes, so it takes no block.
class ValueIcon extends Component<{
  Element: HTMLSpanElement
  Args: { handle: PrimitiveHandle }
}> {
  part = usePart(this, () => this.args.handle, "value-icon" as never)

  <template>
    {{#if this.part.present}}
      <span ...attributes {{this.part.modifier}}></span>
    {{/if}}
  </template>
}

export default ValueIcon
