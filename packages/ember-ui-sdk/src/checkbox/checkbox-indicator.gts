import Component from "@glimmer/component"
import { checkbox } from "@ui-sdk/core/checkbox"
import { usePart, type PartSignature } from "../use-part"

/** The check inside the checkbox. Rendered while it's checked or indeterminate, or always with `@keepMounted`. */
class CheckboxIndicator extends Component<
  PartSignature<typeof checkbox, "indicator", HTMLSpanElement>
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

export default CheckboxIndicator
