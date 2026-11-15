import Component from "@glimmer/component"
import { triggerMenu } from "@ui-sdk/core/trigger-menu"
import { usePart, type PartSignature } from "../use-part"

/** Ghost text at the caret for the arguments still to type. Without children, the hints. */
class TriggerMenuHint extends Component<
  PartSignature<typeof triggerMenu, "hint", HTMLSpanElement, { text?: boolean }>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "hint",
    () => ({
      text: this.args.text ?? true,
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

export default TriggerMenuHint
