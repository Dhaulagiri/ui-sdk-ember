import Component from "@glimmer/component"
import { triggerMenu } from "@ui-sdk/core/trigger-menu"
import { usePart, type PartSignature } from "../use-part"

/** A polite status, outside the popup. Without children, it says the count and the keys once typing pauses. */
class TriggerMenuStatus extends Component<
  PartSignature<
    typeof triggerMenu,
    "status",
    HTMLDivElement,
    { text?: boolean }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "status",
    () => ({
      text: this.args.text ?? true,
    })
  )

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

export default TriggerMenuStatus
