import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import { menuContextTrigger } from "@ui-sdk/core/renderer"
import { controllerTarget } from "../controller-target"
import type { PartSignature } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import MenuTriggerBinding from "./menu-trigger-binding.gts"

/** An area that opens the menu at the pointer on a right-click or a long press, and on Shift+F10. */
class MenuContextTrigger extends Component<
  PartSignature<
    typeof menu,
    "context-trigger",
    HTMLDivElement,
    { controller?: object; handle?: PrimitiveHandle<typeof menu> }
  >
> {
  feature: typeof menuContextTrigger = menuContextTrigger

  get handle() {
    return controllerTarget(this.args.controller, this.args.handle)
  }

  get plain() {
    return { state: { open: false, disabled: !!this.args.disabled } } as never
  }

  <template>
    {{#if this.handle}}
      <MenuTriggerBinding
        {{! @glint-expect-error the binding renders a button or a div }}
        ...attributes
        @handle={{this.handle}}
        @partName="context-trigger"
        @feature={{this.feature}}
        @tag="div"
        @disabled={{@disabled}}
        @payload={{@payload}}
        @render={{@render}}
        as |trigger|
      >{{yield trigger}}</MenuTriggerBinding>
    {{else if @render}}
      {{yield this.plain}}
    {{else}}
      <div ...attributes>{{yield this.plain}}</div>
    {{/if}}
  </template>
}

export default MenuContextTrigger
