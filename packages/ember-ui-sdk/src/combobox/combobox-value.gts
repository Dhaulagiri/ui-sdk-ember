import Component from "@glimmer/component"
import type { StateOf } from "@ui-sdk/core"
import { combobox } from "@ui-sdk/core/combobox"
import { usePart, type PartSignature } from "../use-part"

/** The selected value, for rendering chips or a summary. The block gets its state. Without a block, it shows the label. Renders no element. */
class ComboboxValue extends Component<{
  Element: HTMLElement
  Args: PartSignature<typeof combobox, "value", HTMLElement>["Args"]
  Blocks: { default: [StateOf<typeof combobox, "value">] }
}> {
  part = usePart(this, () => this.args.handle, "value")

  <template>
    {{~#if (has-block)}}{{yield
        this.part.state
      }}{{else}}{{this.part.state.label}}{{/if~}}
  </template>
}

export default ComboboxValue
