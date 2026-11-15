import Component from "@glimmer/component"
import { pagination } from "@ui-sdk/core/pagination"
import { usePart, type PartSignature } from "../use-part"

/** One entry in the list, around a link, a step or an ellipsis. */
class PaginationItem extends Component<
  PartSignature<typeof pagination, "item", HTMLLIElement>
> {
  part = usePart(this, () => this.args.handle, "item")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <li ...attributes {{this.part.modifier}}>{{yield this.part.yielded}}</li>
    {{/if}}
  </template>
}

export default PaginationItem
