import Component from "@glimmer/component"
import { pagination } from "@ui-sdk/core/pagination"
import { usePart, type PartSignature } from "../use-part"

/** A page. The current one has `aria-current="page"`. Shows its number unless it has content. */
class PaginationLink extends Component<
  PartSignature<
    typeof pagination,
    "link",
    HTMLAnchorElement | HTMLButtonElement,
    { isLink?: boolean }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "link",
    () => ({ id: String(this.args.page) })
  )

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else if @isLink}}
      <a ...attributes {{this.part.modifier}}>{{#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{@page}}{{/if}}</a>
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{@page}}{{/if}}</button>
    {{/if}}
  </template>
}

export default PaginationLink
