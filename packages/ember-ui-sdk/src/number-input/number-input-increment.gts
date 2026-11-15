import Component from "@glimmer/component"
import { numberInput } from "@ui-sdk/core/number-input"
import { usePart, type PartSignature } from "../use-part"

/** Steps up once, then repeats while held. Shift steps by `largeStep`. */
class NumberInputIncrement extends Component<
  PartSignature<typeof numberInput, "increment", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "increment")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default NumberInputIncrement
