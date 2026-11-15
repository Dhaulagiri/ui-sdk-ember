import Component from "@glimmer/component"
import { input as inputPrimitive } from "@ui-sdk/core/input"
import { useFieldControl } from "../field/context"
import type { TextControlArgs } from "../text-control"
import { usePart, type PartModifier } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"

/** A native <input>, wired to the Field it's in. */
class Input extends Component<{
  Element: HTMLInputElement
  Args: TextControlArgs
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  handle = usePrimitive(this, inputPrimitive)
  root = usePart(
    this,
    () => this.handle,
    "root",
    () => ({
      disabled: this.args.disabled || this.fieldControl.disabled,
    })
  )

  get controlled() {
    return this.args.value !== undefined
  }

  get isDisabled() {
    return this.args.disabled || this.fieldControl.disabled || undefined
  }

  <template>
    {{syncOptions this.handle}}
    {{#if @render}}
      {{yield this.root.yielded}}
    {{else}}
      {{#if this.controlled}}
        <input
          id={{@id}}
          name={{this.fieldControl.name}}
          disabled={{this.isDisabled}}
          readonly={{@readOnly}}
          required={{@required}}
          value={{@value}}
          ...attributes
          {{this.root.modifier}}
          {{this.fieldControl.modifier}}
        />
      {{else}}
        <input
          id={{@id}}
          name={{this.fieldControl.name}}
          disabled={{this.isDisabled}}
          readonly={{@readOnly}}
          required={{@required}}
          {{! @glint-expect-error defaultValue is a property, not an attribute }}
          defaultValue={{@defaultValue}}
          ...attributes
          {{this.root.modifier}}
          {{this.fieldControl.modifier}}
        />
      {{/if}}
    {{/if}}
  </template>
}

export default Input
