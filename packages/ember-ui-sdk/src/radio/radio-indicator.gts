import Component from "@glimmer/component"
import { radioGroup } from "@ui-sdk/core/radio"
import { usePart, type PartSignature } from "../use-part"

/** The dot inside the radio. Rendered while it's checked, or always with `@keepMounted`. */
class RadioIndicator extends Component<
  PartSignature<typeof radioGroup, "indicator", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "indicator")

  <template>
    {{#if this.part.present}}
      {{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <span ...attributes {{this.part.modifier}}>{{yield
            this.part.yielded
          }}</span>
      {{/if}}
    {{/if}}
  </template>
}

export default RadioIndicator
