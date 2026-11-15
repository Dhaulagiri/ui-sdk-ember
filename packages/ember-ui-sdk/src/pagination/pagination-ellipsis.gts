import Component from "@glimmer/component"
import { pagination } from "@ui-sdk/core/pagination"
import { usePart, type PartSignature } from "../use-part"

/** A gap in the range. Hidden from screen readers, since the links around it say which pages there are. Shows "…" unless it has content. */
class PaginationEllipsis extends Component<
  PartSignature<typeof pagination, "ellipsis", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "ellipsis")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>{{#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}…{{/if}}</span>
    {{/if}}
  </template>
}

export default PaginationEllipsis
