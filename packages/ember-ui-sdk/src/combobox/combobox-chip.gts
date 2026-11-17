import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import type { WithBoundArgs } from "@glint/template"
import { combobox } from "@ui-sdk/core/combobox"
import { comboboxChips } from "@ui-sdk/core/renderer"
import { usePart, type PartSignature } from "../use-part"
import ComboboxChipRemove from "./combobox-chip-remove.gts"

/** One selected value. Without a block, it shows the value's label. Yields its `Remove`. */
class ComboboxChip extends Component<
  PartSignature<
    typeof combobox,
    "chip",
    HTMLDivElement,
    {},
    { Remove: WithBoundArgs<typeof ComboboxChipRemove, "handle" | "value"> }
  >
> {
  feature = this.args.handle.instance.use(comboboxChips)
  part = usePart(
    this,
    () => this.args.handle,
    "chip",
    () => ({
      id: this.args.handle.api.internal.keyOf(this.args.value) as string,
      value: this.args.value,
    })
  )

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Remove=(component ComboboxChipRemove handle=@handle value=@value)
      )
      as |chip|
    }}
      {{#if @render}}
        {{yield chip}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>
          {{~#if (has-block)}}{{yield
              chip
            }}{{else}}{{this.part.state.label}}{{/if~}}
        </div>
      {{/if}}
    {{/let}}
  </template>
}

export default ComboboxChip
