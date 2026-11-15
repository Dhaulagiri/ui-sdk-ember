import Component from "@glimmer/component"
import {
  textarea as textareaPrimitive,
  type TextareaSubmitDetails,
} from "@ui-sdk/core/input"
import { useFieldControl } from "../field/context"
import type { TextControlArgs } from "../text-control"
import { usePart, type PartModifier } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"

/** A native <textarea>, wired to the Field it's in, that can grow with its text. Its text is its content, so it takes no block. */
class Textarea extends Component<{
  Element: HTMLTextAreaElement
  Args: TextControlArgs & {
    /** Grows the field with its text. */
    autoResize?: boolean
    /** The keys that submit the text: `"enter"`, or `"mod+enter"` to keep Enter for new lines. */
    submitShortcut?: "enter" | "mod+enter"
    /** Runs when the shortcut submits the text. */
    onSubmit?: (value: string, details: TextareaSubmitDetails) => void
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  handle = usePrimitive(this, textareaPrimitive)
  root = usePart(
    this,
    () => this.handle,
    "root",
    () => ({
      disabled: this.args.disabled || this.fieldControl.disabled,
    })
  )

  get isDisabled() {
    return this.args.disabled || this.fieldControl.disabled || undefined
  }

  get text() {
    return this.args.value ?? this.args.defaultValue
  }

  <template>
    {{syncOptions this.handle}}
    {{#if @render}}
      {{yield this.root.yielded}}
    {{else}}
      <textarea
        id={{@id}}
        name={{this.fieldControl.name}}
        disabled={{this.isDisabled}}
        readonly={{@readOnly}}
        required={{@required}}
        ...attributes
        {{this.root.modifier}}
        {{this.fieldControl.modifier}}
      >{{this.text}}</textarea>
    {{/if}}
  </template>
}

export default Textarea
