import Component from "@glimmer/component"
import { pagination } from "@ui-sdk/core/pagination"
import { usePart, type PartSignature } from "../use-part"

/** Goes to the last page. `aria-disabled` there. */
class PaginationLast extends Component<
  PartSignature<
    typeof pagination,
    "last",
    HTMLAnchorElement | HTMLButtonElement,
    { isLink?: boolean }
  >
> {
  part = usePart(this, () => this.args.handle, "last")

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

export default PaginationLast
