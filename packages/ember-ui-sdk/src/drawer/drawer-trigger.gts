import Component from "@glimmer/component"
import { drawer } from "@ui-sdk/core/drawer"
import { controllerTarget } from "../controller-target"
import type { PartSignature } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import DrawerTriggerBinding from "./drawer-trigger-binding.gts"

/** The button that opens the drawer. A trigger outside the drawer, like one per table row, connects through `@controller`. */
class DrawerTrigger extends Component<
  PartSignature<
    typeof drawer,
    "trigger",
    HTMLButtonElement,
    { controller?: object; handle?: PrimitiveHandle<typeof drawer> }
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
      <DrawerTriggerBinding
        ...attributes
        @handle={{this.handle}}
        @disabled={{@disabled}}
        @focusableWhenDisabled={{@focusableWhenDisabled}}
        @payload={{@payload}}
        @shortcut={{@shortcut}}
        @render={{@render}}
        as |trigger|
      >{{yield trigger}}</DrawerTriggerBinding>
    {{else if @render}}
      {{yield this.plain.yielded}}
    {{else}}
      {{! Until the drawer it names mounts, a trigger outside it is a plain button. }}
      <button
        type="button"
        disabled={{this.plain.disabled}}
        aria-disabled={{this.plain.ariaDisabled}}
        ...attributes
      >{{yield this.plain.yielded}}</button>
    {{/if}}
  </template>
}

export default DrawerTrigger
