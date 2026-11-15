import Component from "@glimmer/component"
import { segmentedControl } from "@ui-sdk/core/segmented-control"
import { usePart, type PartSignature } from "../use-part"

/** One option, and the hidden native radio that takes part in the form. */
class SegmentedControlItem extends Component<
  PartSignature<typeof segmentedControl, "item", HTMLButtonElement>
> {
  button = usePart(this, () => this.args.handle, "item")
  input = usePart(this, () => this.args.handle, "input")

  <template>
    {{#if @render}}
      {{yield this.button.yielded}}
    {{else}}
      <button ...attributes {{this.button.modifier}}>{{yield
          this.button.yielded
        }}</button>
    {{/if}}
    <input {{this.input.modifier}} />
  </template>
}

export default SegmentedControlItem
