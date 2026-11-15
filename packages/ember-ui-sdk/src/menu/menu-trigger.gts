import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import { controllerTarget } from "../controller-target"
import type { PartSignature } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import MenuTriggerBinding from "./menu-trigger-binding.gts"

/** The button that opens the menu. A trigger outside the menu connects through `@controller`. */
class MenuTrigger extends Component<
  PartSignature<
    typeof menu,
    "trigger",
    HTMLButtonElement,
    { controller?: object; handle?: PrimitiveHandle<typeof menu> }
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
      <MenuTriggerBinding
        {{! @glint-expect-error the binding renders a button or a div }}
        ...attributes
        @handle={{this.handle}}
        @partName="trigger"
        @tag="button"
        @disabled={{@disabled}}
        @focusableWhenDisabled={{@focusableWhenDisabled}}
        @payload={{@payload}}
        @shortcut={{@shortcut}}
        @render={{@render}}
        as |trigger|
      >{{yield trigger}}</MenuTriggerBinding>
    {{else if @render}}
      {{yield this.plain.yielded}}
    {{else}}
      {{! Until the menu it names mounts, a trigger outside it is a plain button. }}
      <button
        type="button"
        disabled={{this.plain.disabled}}
        aria-disabled={{this.plain.ariaDisabled}}
        ...attributes
      >{{yield this.plain.yielded}}</button>
    {{/if}}
  </template>
}

export default MenuTrigger
