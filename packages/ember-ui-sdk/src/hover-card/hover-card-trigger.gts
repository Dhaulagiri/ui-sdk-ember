import Component from "@glimmer/component"
import { hoverCard } from "@ui-sdk/core/hover-card"
import { controllerTarget } from "../controller-target"
import type { PartSignature } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import HoverCardTriggerBinding from "./hover-card-trigger-binding.gts"

/** A link by default: pressing it follows the link, and hover or focus opens the card. A trigger outside the card connects through `@controller`. */
class HoverCardTrigger extends Component<
  PartSignature<
    typeof hoverCard,
    "trigger",
    HTMLAnchorElement,
    { controller?: object; handle?: PrimitiveHandle<typeof hoverCard> }
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
      <HoverCardTriggerBinding
        ...attributes
        @handle={{this.handle}}
        @payload={{@payload}}
        @render={{@render}}
        as |trigger|
      >{{yield trigger}}</HoverCardTriggerBinding>
    {{else if @render}}
      {{yield this.plain}}
    {{else}}
      {{! Until the card it names mounts, a trigger outside it is a plain link. }}
      <a ...attributes>{{yield this.plain}}</a>
    {{/if}}
  </template>
}

export default HoverCardTrigger
