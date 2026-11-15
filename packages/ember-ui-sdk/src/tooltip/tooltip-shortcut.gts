import Component from "@glimmer/component"
import { tooltip } from "@ui-sdk/core/tooltip"
import { usePart, type PartSignature } from "../use-part"

/** Shows the tooltip's shortcut, like ⌘S, formatted for the platform. */
class TooltipShortcut extends Component<
  PartSignature<typeof tooltip, "shortcut", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "shortcut")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{this.part.state.text}}{{/if~}}
      </span>
    {{/if}}
  </template>
}

export default TooltipShortcut
