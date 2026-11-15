import Component from "@glimmer/component"
import { toggle } from "@ui-sdk/core/toggle"
import { usePart, type PartSignature } from "../use-part"

/** An icon inside a toggle. A toggle with only an icon needs an `aria-label`. Screen readers skip it, and `@mirror` flips it in right-to-left text. */
class ToggleIcon extends Component<
  PartSignature<typeof toggle, "icon", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "icon")

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

export default ToggleIcon
