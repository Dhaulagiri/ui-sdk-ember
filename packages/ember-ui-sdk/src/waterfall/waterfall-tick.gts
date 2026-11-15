import Component from "@glimmer/component"
import { waterfall } from "@ui-sdk/core/waterfall"
import { usePart, type PartSignature } from "../use-part"

/** One time on the axis, placed by `--waterfall-tick`. Without a block, it shows the time. */
class WaterfallTick extends Component<
  PartSignature<typeof waterfall, "tick", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "tick")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{this.part.state.label}}{{/if~}}
      </span>
    {{/if}}
  </template>
}

export default WaterfallTick
