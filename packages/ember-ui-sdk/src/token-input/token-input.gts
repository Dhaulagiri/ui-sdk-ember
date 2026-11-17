import { hash } from "@ember/helper"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tokenInput } from "@ui-sdk/core/token-input"
import { registerController } from "../controller-target"
import { useFieldValues, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import TokenInputEditor from "./token-input-editor.gts"
import TokenInputToken from "./token-input-token.gts"
import TokenInputTokenRemove from "./token-input-token-remove.gts"
import TokenInputTokens from "./token-input-tokens.gts"

/**
 * A text field with atomic tokens. A TriggerMenu inside it suggests into it,
 * given its `editor`. `Tokens` renders each token's content. Takes
 * TokenInput's options as arguments, and yields its parts.
 */
class TokenInput extends Component<{
  Args: Record<string, unknown> & {
    /** Reads and sets the input from anywhere. */
    controller?: object
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
  }
  Blocks: { default: [Record<string, any>] }
}> {
  field = useFieldValues(this)

  // A controlled value has to reach the core before it checks that the owner took it.
  onValueChange = (...args: unknown[]) => {
    const change = this.args.onValueChange as
      ((...args: unknown[]) => void) | undefined
    change?.(...args)
    queueMicrotask(() => this.handle.sync())
  }

  handle = usePrimitive(this, tokenInput, () => ({
    disabled: (this.args.disabled as boolean) || this.field.disabled,
    name: (this.args.name as string) ?? this.field.name,
    onValueChange: this.onValueChange,
  }))
  formInput = usePart(this, () => this.handle, "form-input")

  constructor(owner: Owner, args: TokenInput["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  get editor() {
    return this.handle.api.editor
  }

  get formName() {
    return this.formInput.attrs.name
  }

  get formText() {
    return this.formInput.attrs.value as string | undefined
  }

  <template>
    {{syncOptions this.handle}}
    {{yield
      (hash
        handle=this.handle
        editor=this.editor
        Editor=(component TokenInputEditor handle=this.handle field=@field)
        Tokens=(component TokenInputTokens handle=this.handle)
        Token=(component TokenInputToken handle=this.handle)
        TokenRemove=(component TokenInputTokenRemove handle=this.handle)
      )
    }}
    {{#if this.formName}}
      <textarea {{this.formInput.modifier}}>{{this.formText}}</textarea>
    {{/if}}
  </template>
}

export default TokenInput
