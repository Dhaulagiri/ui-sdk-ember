import Component from "@glimmer/component"
import { hoverCard } from "@ui-sdk/core/hover-card"
import { usePart, type PartSignature } from "../use-part"

// The bound trigger, once its card is known.
class HoverCardTriggerBinding extends Component<
  PartSignature<typeof hoverCard, "trigger", HTMLAnchorElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <a ...attributes {{this.part.modifier}}>{{yield this.part.yielded}}</a>
    {{/if}}
  </template>
}

export default HoverCardTriggerBinding
