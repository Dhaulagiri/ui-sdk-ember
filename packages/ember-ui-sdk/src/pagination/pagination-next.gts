import Component from "@glimmer/component"
import { pagination } from "@ui-sdk/core/pagination"
import { usePart, type PartSignature } from "../use-part"

/** Goes to the next page. `aria-disabled` on the last page, where it stays focusable. */
class PaginationNext extends Component<
  PartSignature<
    typeof pagination,
    "next",
    HTMLAnchorElement | HTMLButtonElement,
    { isLink?: boolean }
  >
> {
  part = usePart(this, () => this.args.handle, "next")

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

export default PaginationNext
