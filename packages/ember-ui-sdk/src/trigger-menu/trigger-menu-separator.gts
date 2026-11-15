import Component from "@glimmer/component"
import { triggerMenu } from "@ui-sdk/core/trigger-menu"
import { usePart, type PartSignature } from "../use-part"

/** A line between items or groups, hidden from screen readers. */
class TriggerMenuSeparator extends Component<
  PartSignature<typeof triggerMenu, "separator", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "separator")

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

export default TriggerMenuSeparator
