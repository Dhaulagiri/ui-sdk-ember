import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { usePart, type PartSignature } from "../use-part"

/** An arrow on the list's edge that points at the trigger. */
class SelectArrow extends Component<
  PartSignature<typeof select, "arrow", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "arrow")

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

export default SelectArrow
