import Component from "@glimmer/component"
import { selectAllKey, selectSelectAll } from "@ui-sdk/core/renderer"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

/** An item that selects every item, or every item of its group, with `multiple`. */
class SelectSelectAll extends Component<{
  Element: HTMLDivElement
  Args: { handle: PrimitiveHandle<typeof select>; group?: string }
  Blocks: { default: [{ part: PartModifier; state: object }] }
}> {
  // The slot comes with a feature, which the instance takes before the part.
  feature = this.args.handle.instance.use(selectSelectAll)
  part = usePart(
    this,
    () => this.args.handle,
    "select-all" as never,
    () =>
      ({
        id: selectAllKey(this.args.group),
      }) as never
  )

  <template>
    {{#if this.part.present}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{/if}}
  </template>
}

export default SelectSelectAll
