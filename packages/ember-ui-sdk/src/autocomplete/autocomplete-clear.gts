import Component from "@glimmer/component"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { usePart, type PartSignature } from "../use-part"

/** A button that empties the field. Shown while there's text to clear, or always with `keepMounted`. Name it with `aria-label`. */
class AutocompleteClear extends Component<
  PartSignature<typeof autocomplete, "clear", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "clear")

  <template>
    {{#if this.part.present}}
      {{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <button ...attributes {{this.part.modifier}}>{{yield
            this.part.yielded
          }}</button>
      {{/if}}
    {{/if}}
  </template>
}

export default AutocompleteClear
