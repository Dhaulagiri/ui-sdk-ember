import Component from "@glimmer/component"
import { inputGroup } from "@ui-sdk/core/input"
import { usePart, type PartSignature } from "../use-part"

/** Empties the field in its group and focuses it. Shown while there's text to clear. */
class InputClear extends Component<
  PartSignature<typeof inputGroup, "clear", HTMLButtonElement>
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

export default InputClear
