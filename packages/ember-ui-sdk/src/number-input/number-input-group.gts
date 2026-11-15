import Component from "@glimmer/component"
import { numberInput } from "@ui-sdk/core/number-input"
import { usePart, type PartSignature } from "../use-part"

/** Holds the input and its buttons. */
class NumberInputGroup extends Component<
  PartSignature<typeof numberInput, "group", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "group")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{/if}}
  </template>
}

export default NumberInputGroup
