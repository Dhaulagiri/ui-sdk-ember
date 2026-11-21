import Component from "@glimmer/component"
import {
  useFieldPart,
  type FieldContext,
  type FieldSetContext,
} from "./context"
import type { PartModifier } from "../use-part"

let count = 0

/** Describes its Field. Right inside a FieldSet, outside any Field, it describes the group, so screen readers say it as focus enters the group. */
class FieldDescription extends Component<{
  Element: HTMLParagraphElement
  Args: {
    /** The Field around it, which its yielded `FieldDescription` passes. */
    field?: FieldContext | FieldSetContext
    /** Its id, which the field's other parts point at. */
    id?: string
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  // Each description is its own part, keyed by a made value, so each gets an
  // id of its own and a control with two is described by both.
  uid = `e-description${++count}`
  part = useFieldPart(this, "description", () => ({
    id: this.args.id,
    value: this.uid,
  }))

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <p ...attributes {{this.part.modifier}}>{{yield this.part.yielded}}</p>
    {{/if}}
  </template>
}

export default FieldDescription
