import Component from "@glimmer/component"
import { useFieldPart, type FieldContext } from "./context"
import type { PartModifier } from "../use-part"

/** A native control: an <input> by default, or anything through `@render`. */
class FieldControl extends Component<{
  Element: HTMLInputElement
  Args: {
    /** The Field around it, which its yielded `Control` passes. */
    field?: FieldContext
    /** Its id. */
    id?: string
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  part = useFieldPart(this, "control", () => ({
    id: this.args.id,
  }))

  get name() {
    return this.args.field?.name
  }

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <input name={{this.name}} ...attributes {{this.part.modifier}} />
    {{/if}}
  </template>
}

export default FieldControl
