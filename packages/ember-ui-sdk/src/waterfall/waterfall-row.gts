import Component from "@glimmer/component"
import { waterfall } from "@ui-sdk/core/waterfall"
import { usePart, type PartSignature } from "../use-part"
import WaterfallBar from "./waterfall-bar.gts"
import WaterfallCell from "./waterfall-cell.gts"
import WaterfallIndicator from "./waterfall-indicator.gts"
import WaterfallRowHeader from "./waterfall-row-header.gts"

/** One span's row. Its `--waterfall-start` and `--waterfall-size` place the span's bar. Yields its parts. */
class WaterfallRow extends Component<
  PartSignature<typeof waterfall, "row", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "row")

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Header=(component WaterfallRowHeader handle=@handle value=@value)
        Indicator=(component WaterfallIndicator handle=@handle value=@value)
        Cell=(component WaterfallCell handle=@handle value=@value)
        Bar=(component WaterfallBar handle=@handle value=@value)
      )
      as |row|
    }}
      {{#if @render}}
        {{yield row}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield row}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default WaterfallRow
