import Component from "@glimmer/component"
import { pagination } from "@ui-sdk/core/pagination"
import { usePart, type PartSignature } from "../use-part"

/** Goes to the first page. `aria-disabled` there. */
class PaginationFirst extends Component<
  PartSignature<
    typeof pagination,
    "first",
    HTMLAnchorElement | HTMLButtonElement,
    { isLink?: boolean }
  >
> {
  part = usePart(this, () => this.args.handle, "first")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else if @isLink}}
      <a ...attributes {{this.part.modifier}}>{{yield this.part.yielded}}</a>
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default PaginationFirst
