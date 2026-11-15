import Component from "@glimmer/component"
import { numberInput } from "@ui-sdk/core/number-input"
import { usePart, type PartSignature } from "../use-part"

class NumberInputScrubAreaBinding extends Component<
  PartSignature<typeof numberInput, "scrub-area", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "scrub-area")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</span>
    {{/if}}
  </template>
}

export default NumberInputScrubAreaBinding
