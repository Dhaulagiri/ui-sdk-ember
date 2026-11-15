import Component from "@glimmer/component"
import { combobox } from "@ui-sdk/core/combobox"
import { comboboxCreate } from "@ui-sdk/core/renderer"
import { usePart, type PartSignature } from "../use-part"

/** An option that creates an item from the input's text. Shown while the text matches no item's label exactly. Without a block, `Create “text”`. */
class ComboboxCreate extends Component<
  PartSignature<typeof combobox, "create", HTMLDivElement>
> {
  feature = this.args.handle.instance.use(comboboxCreate)
  part = usePart(
    this,
    () => this.args.handle,
    "create",
    () => ({
      onCreate: this.args.onCreate,
      minLength: this.args.minLength,
    })
  )

  <template>
    {{#if this.part.present}}
      {{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>
          {{~#if (has-block)}}{{yield this.part.yielded}}{{else}}Create “{{this.part.state.query}}”{{/if~}}
        </div>
      {{/if}}
    {{/if}}
  </template>
}

export default ComboboxCreate
