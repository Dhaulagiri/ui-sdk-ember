import Component from "@glimmer/component"
import { fieldSet } from "@ui-sdk/core/field"
import { usePart, type PartSignature } from "../use-part"

/** Names the field set. Keep it the set's first child, where a <legend> names it natively. */
class FieldLegend extends Component<
  PartSignature<typeof fieldSet, "legend", HTMLLegendElement, { id?: string }>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "legend",
    () => ({
      id: this.args.id,
    })
  )

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <legend ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</legend>
    {{/if}}
  </template>
}

export default FieldLegend
