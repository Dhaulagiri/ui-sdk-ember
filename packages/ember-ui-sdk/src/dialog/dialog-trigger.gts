import Component from "@glimmer/component"
import { dialog } from "@ui-sdk/core/dialog"
import { controllerTarget } from "../controller-target"
import type { PartSignature } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import DialogTriggerBinding from "./dialog-trigger-binding.gts"

/** The button that opens the dialog. A trigger outside the dialog, like one per table row, connects through `@controller`. */
class DialogTrigger extends Component<
  PartSignature<
    typeof dialog,
    "trigger",
    HTMLButtonElement,
    { controller?: object; handle?: PrimitiveHandle<typeof dialog> }
  >
> {
  get handle() {
    return controllerTarget(this.args.controller, this.args.handle)
  }

  get plain() {
    const { disabled, focusableWhenDisabled } = this.args
    return {
      disabled: disabled && !focusableWhenDisabled,
      ariaDisabled: (disabled && focusableWhenDisabled) || undefined,
      yielded: { state: { open: false, disabled: !!disabled } } as never,
    }
  }

  <template>
    {{#if this.handle}}
      <DialogTriggerBinding
        ...attributes
        @handle={{this.handle}}
        @disabled={{@disabled}}
        @focusableWhenDisabled={{@focusableWhenDisabled}}
        @payload={{@payload}}
        @shortcut={{@shortcut}}
        @render={{@render}}
        as |trigger|
      >{{yield trigger}}</DialogTriggerBinding>
    {{else if @render}}
      {{yield this.plain.yielded}}
    {{else}}
      {{! Until the dialog it names mounts, a trigger outside it is a plain button. }}
      <button
        type="button"
        disabled={{this.plain.disabled}}
        aria-disabled={{this.plain.ariaDisabled}}
        ...attributes
      >{{yield this.plain.yielded}}</button>
    {{/if}}
  </template>
}

export default DialogTrigger
