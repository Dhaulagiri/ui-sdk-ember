import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { comboboxSelectAll, selectAllKey } from "@ui-sdk/core/renderer"
import { usePart, type PartModifier } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

/** An option that selects every item that matches, with `multiple`: in its group inside a `Group`, or in the whole list. */
class ComboboxSelectAll extends Component<{
  Element: HTMLDivElement
  Args: { handle: PrimitiveHandle<typeof combobox>; group?: string }
  Blocks: { default: [{ part: PartModifier; state: object }] }
}> {
  feature = this.args.handle.instance.use(comboboxSelectAll)
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

export default ComboboxSelectAll
