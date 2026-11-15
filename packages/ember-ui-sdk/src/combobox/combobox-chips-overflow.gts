import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { comboboxChips } from "@ui-sdk/core/renderer"
import { usePart, type PartSignature } from "../use-part"

/** How many chips don't fit on the chips' line, once some collapse. Rendering it inside `Chips` turns collapsing on. Without a block, "+2 more". */
class ComboboxChipsOverflow extends Component<
  PartSignature<typeof combobox, "chips-overflow", HTMLSpanElement>
> {
  feature = this.args.handle.instance.use(comboboxChips)
  part = usePart(this, () => this.args.handle, "chips-overflow")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}+{{this.part.state.count}} more{{/if~}}
      </span>
    {{/if}}
  </template>
}

export default ComboboxChipsOverflow
