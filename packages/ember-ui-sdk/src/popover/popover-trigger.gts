import Component from "@glimmer/component"
import { popover } from "@ui-sdk/core/popover"
import { controllerTarget } from "../controller-target"
import type { PartSignature } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import PopoverTriggerBinding from "./popover-trigger-binding.gts"

/** The button that opens the popover. A trigger outside the popover connects through `@controller`. */
class PopoverTrigger extends Component<
  PartSignature<
    typeof popover,
    "trigger",
    HTMLButtonElement,
    { controller?: object; handle?: PrimitiveHandle<typeof popover> }
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
      <PopoverTriggerBinding
        ...attributes
        @handle={{this.handle}}
        @disabled={{@disabled}}
        @focusableWhenDisabled={{@focusableWhenDisabled}}
        @payload={{@payload}}
        @shortcut={{@shortcut}}
        @render={{@render}}
        as |trigger|
      >{{yield trigger}}</PopoverTriggerBinding>
    {{else if @render}}
      {{yield this.plain.yielded}}
    {{else}}
      {{! Until the popover it names mounts, a trigger outside it is a plain button. }}
      <button
        type="button"
        disabled={{this.plain.disabled}}
        aria-disabled={{this.plain.ariaDisabled}}
        ...attributes
      >{{yield this.plain.yielded}}</button>
    {{/if}}
  </template>
}

export default PopoverTrigger
