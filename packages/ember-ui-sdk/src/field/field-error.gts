import Component from "@glimmer/component"
import type { FieldErrorProps } from "@ui-sdk/core/field"
import { fieldOutsideErrorShown } from "@ui-sdk/core/renderer"
import { useFieldPart, type FieldContext } from "./context"
import type { PartModifier } from "../use-part"

let count = 0

/** Shows while the field shows as invalid. Without content, it shows the browser's message for the current problem. */
class FieldError extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The Field around it, which its yielded `FieldError` passes. */
    field?: FieldContext
    /** Its id, which the field's control points at. */
    id?: string
    /** Which validity problem shows it: a key like `valueMissing`, `true` for any, or a function of the problem. */
    match?: FieldErrorProps["match"]
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  generated = `ui-sdk-e-error${++count}`
  part = useFieldPart(this, "error", () => ({
    id:
      this.args.id ??
      (this.args.match === undefined ? undefined : this.generated),
    match: this.args.match,
  }))

  get shown() {
    return this.args.field
      ? this.part.present
      : fieldOutsideErrorShown({ match: this.args.match })
  }

  <template>
    {{#if this.shown}}
      {{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{#if (has-block)}}{{yield
              this.part.yielded
            }}{{else}}{{this.part.state.message}}{{/if}}</div>
      {{/if}}
    {{/if}}
  </template>
}

export default FieldError
