import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"

/** Shows that its item is selected, like a check mark. Rendered while it is. */
class SelectItemIndicator extends Component<
  PartSignature<typeof select, "item-indicator", HTMLSpanElement>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "item-indicator",
    () => ({
      id: this.args.item,
    })
  )

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

export default SelectItemIndicator
