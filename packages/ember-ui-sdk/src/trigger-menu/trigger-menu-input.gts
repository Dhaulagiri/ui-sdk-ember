import Component from "@glimmer/component"
import { triggerMenu } from "@ui-sdk/core/trigger-menu"
import { usePart, type PartSignature } from "../use-part"

/** The text field the menu suggests into: a `<textarea>`, or an `<input>` from `render`. */
class TriggerMenuInput extends Component<
  PartSignature<typeof triggerMenu, "input", HTMLElement>
> {
  part = usePart(this, () => this.args.handle, "input")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <textarea ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</textarea>
    {{/if}}
  </template>
}

export default TriggerMenuInput
