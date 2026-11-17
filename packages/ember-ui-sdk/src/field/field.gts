import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { field } from "@ui-sdk/core/field"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import type { FieldContext } from "./context"
import FieldControl from "./field-control.gts"
import FieldDescription from "./field-description.gts"
import FieldError from "./field-error.gts"
import FieldLabel from "./field-label.gts"

const fieldContext = (
  handle: FieldContext["handle"],
  args: { name?: string; disabled?: boolean }
) => ({
  handle,
  get name() {
    return args.name
  },
  get disabled() {
    return args.disabled
  },
})

/** Ties a form control to its label, description and error messages. Yields its parts, and the `field` its controls take as `@field`. */
class Field extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The name the field's control submits under. */
    name?: string
    /** Disables the control. */
    disabled?: boolean
    /** Whether the field shows as invalid, when your code decides. Leave it out for the browser's validation. */
    invalid?: boolean
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, field)
  root = usePart(this, () => this.handle, "root")
  field: FieldContext = fieldContext(this.handle, this.args)

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        field=this.field
        Label=(component FieldLabel field=this.field)
        Description=(component FieldDescription field=this.field)
        Error=(component FieldError field=this.field)
        Control=(component FieldControl field=this.field)
      )
      as |f|
    }}
      {{#if @render}}
        {{yield f}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield f}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default Field
