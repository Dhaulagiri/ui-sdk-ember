import Component from "@glimmer/component"
import { numberInput } from "@ui-sdk/core/number-input"
import { usePart, type PartSignature } from "../use-part"

/** Steps down once, then repeats while held. Shift steps by `largeStep`. */
class NumberInputDecrement extends Component<
  PartSignature<typeof numberInput, "decrement", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "decrement")

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

export default NumberInputDecrement
