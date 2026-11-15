import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"

/** A button that clears the value. Shown while something is selected. */
class SelectClear extends Component<
  PartSignature<typeof select, "clear", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "clear")

  <template>
    {{#if this.part.present}}{{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <button ...attributes {{this.part.modifier}}>{{yield
            this.part.yielded
          }}</button>
      {{/if}}{{/if}}
  </template>
}

export default SelectClear
