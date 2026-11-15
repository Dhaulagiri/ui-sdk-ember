import Component from "@glimmer/component"
import { tooltip } from "@ui-sdk/core/tooltip"
import { controllerTarget } from "../controller-target"
import type { PartSignature } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import TooltipTriggerBinding from "./tooltip-trigger-binding.gts"

/** The element the tooltip names or describes, usually a button. A trigger outside the tooltip connects through `@controller`. */
class TooltipTrigger extends Component<
  PartSignature<
    typeof tooltip,
    "trigger",
    HTMLButtonElement,
    { controller?: object; handle?: PrimitiveHandle<typeof tooltip> }
  >
> {
  get handle() {
    return controllerTarget(this.args.controller, this.args.handle)
  }

  get plain() {
    return { state: { open: false } } as never
  }

  <template>
    {{#if this.handle}}
      <TooltipTriggerBinding
        ...attributes
        @handle={{this.handle}}
        @payload={{@payload}}
        @render={{@render}}
        as |trigger|
      >{{yield trigger}}</TooltipTriggerBinding>
    {{else if @render}}
      {{yield this.plain}}
    {{else}}
      {{! Until the tooltip it names mounts, a trigger outside it is a plain button. }}
      <button type="button" ...attributes>{{yield this.plain}}</button>
    {{/if}}
  </template>
}

export default TooltipTrigger
