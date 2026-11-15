import Component from "@glimmer/component"
import { pagination } from "@ui-sdk/core/pagination"
import { usePart, type PartSignature } from "../use-part"

/** Goes to the previous page. `aria-disabled` on the first page, where it stays focusable. */
class PaginationPrevious extends Component<
  PartSignature<
    typeof pagination,
    "previous",
    HTMLAnchorElement | HTMLButtonElement,
    { isLink?: boolean }
  >
> {
  part = usePart(this, () => this.args.handle, "previous")

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

export default PaginationPrevious
