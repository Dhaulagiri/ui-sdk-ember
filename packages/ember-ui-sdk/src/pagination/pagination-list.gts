import Component from "@glimmer/component"
import { pagination } from "@ui-sdk/core/pagination"
import { usePart, type PartSignature } from "../use-part"

/** The list of pages and steps. Its children get the state, whose `items` are the pages to show. */
class PaginationList extends Component<
  PartSignature<typeof pagination, "list", HTMLUListElement>
> {
  part = usePart(this, () => this.args.handle, "list")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <ul ...attributes {{this.part.modifier}}>{{yield this.part.yielded}}</ul>
    {{/if}}
  </template>
}

export default PaginationList
