import Component from "@glimmer/component"
import { useFieldPart, type FieldContext } from "./context"
import type { PartModifier } from "../use-part"

/** The field's label, which names its control. Outside a Field it's a plain <label>, which labels the control inside it, like a card around a whole Field. */
class FieldLabel extends Component<{
  Element: HTMLLabelElement
  Args: {
    /** The Field around it, which its yielded `FieldLabel` passes. */
    field?: FieldContext
    /** Its id, which the field's other parts point at. */
    id?: string
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  part = useFieldPart(this, "label", () => ({ id: this.args.id }))

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <label ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</label>
    {{/if}}
  </template>
}

export default FieldLabel
