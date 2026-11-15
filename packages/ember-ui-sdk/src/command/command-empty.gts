import Component from "@glimmer/component"
import { command } from "@ui-sdk/core/command"
import { usePart, type PartSignature } from "../use-part"

/** Shown while no command matches. Its message is announced when it appears. Place it outside the list. */
class CommandEmpty extends Component<
  PartSignature<typeof command, "empty", HTMLDivElement>
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

export default CommandEmpty
