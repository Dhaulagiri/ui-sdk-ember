import Component from "@glimmer/component"
import { rating, ratingItemValues } from "@ui-sdk/core/rating"
import { usePart, type PartSignature } from "../use-part"
import RatingRadio from "./rating-radio.gts"

/** One star. Put its icon inside: the block gets how full it is, and the radios that pick its score sit over it. */
class RatingItem extends Component<
  PartSignature<typeof rating, "item", HTMLSpanElement, { step?: number }>
> {
  part = usePart(this, () => this.args.handle, "item")

  get scores() {
    return ratingItemValues(this.args.index!, this.args.step).map(String)
  }

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>
        {{yield this.part.yielded}}
        {{#each this.scores key="@identity" as |score|}}
          <RatingRadio @handle={{@handle}} @value={{score}} />
        {{/each}}
      </span>
    {{/if}}
  </template>
}

export default RatingItem
