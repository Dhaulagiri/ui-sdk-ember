import Component from "@glimmer/component"
import { waterfall } from "@ui-sdk/core/waterfall"
import { usePart, type PartSignature } from "../use-part"
import WaterfallTick from "./waterfall-tick.gts"

/** The ruler of round times above the bars, hidden from screen readers. Without a block, it renders its ticks. Yields its `Tick`. */
class WaterfallAxis extends Component<
  PartSignature<typeof waterfall, "axis", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "axis")

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Tick=(component WaterfallTick handle=@handle)
      )
      as |axis|
    }}
      {{#if @render}}
        {{yield axis}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>
          {{~#if (has-block)}}{{yield axis}}{{else}}
            {{~#each this.part.state.ticks key="time" as |tick|~}}
              <WaterfallTick @handle={{@handle}} @time={{tick.time}} />
            {{~/each~}}
          {{/if~}}
        </div>
      {{/if}}
    {{/let}}
  </template>
}

export default WaterfallAxis
