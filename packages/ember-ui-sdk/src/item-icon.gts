import Component from "@glimmer/component"
import { usePart, type PartModifier } from "./use-part"
import type { PrimitiveHandle } from "./use-primitive"

// The icon part every component with items shares, like ListboxItemIcon and
// SelectItemIcon. The core hides it from screen readers and typeahead.
class ItemIcon extends Component<{
  Element: HTMLSpanElement
  Args: {
    handle: PrimitiveHandle
    partName: string
    item?: string
    mirror?: boolean
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  part = usePart(
    this,
    () => this.args.handle,
    this.args.partName as never,
    () => ({ mirror: this.args.mirror, item: this.args.item }) as never
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

export default ItemIcon
