import Component from "@glimmer/component"
import { collapsible } from "@ui-sdk/core/collapsible"
import { usePart, type PartSignature } from "../use-part"

/** The button that opens and closes the panel. It says whether the panel is open with `aria-expanded`. */
class CollapsibleTrigger extends Component<
  PartSignature<typeof collapsible, "trigger", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

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

export default CollapsibleTrigger
