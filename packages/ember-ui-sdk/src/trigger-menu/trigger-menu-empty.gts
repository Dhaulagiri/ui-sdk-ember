import Component from "@glimmer/component"
import { triggerMenu } from "@ui-sdk/core/trigger-menu"
import { usePart, type PartSignature } from "../use-part"

/** Shown while no item matches. Its message is announced when it appears. */
class TriggerMenuEmpty extends Component<
  PartSignature<typeof triggerMenu, "empty", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "empty")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>
        {{~#if this.part.state.empty}}{{yield this.part.yielded}}{{/if~}}
      </div>
    {{/if}}
  </template>
}

export default TriggerMenuEmpty
