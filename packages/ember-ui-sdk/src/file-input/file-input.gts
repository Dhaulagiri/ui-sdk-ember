import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { fileInput } from "@ui-sdk/core/file-input"
import { registerController } from "../controller-target"
import { useFieldValues, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import FileInputDropzone from "./file-input-dropzone.gts"
import FileInputItem from "./file-input-item.gts"
import FileInputItemRemove from "./file-input-item-remove.gts"
import FileInputList from "./file-input-list.gts"
import FileInputTrigger from "./file-input-trigger.gts"

/**
 * The root: it holds the files, and renders the hidden file input that opens
 * the picker and that a form submits. Takes FileInput's options as arguments,
 * and yields its parts.
 */
class FileInput extends Component<{
  Element: HTMLDivElement
  Args: Record<string, unknown> & {
    /** Reads and sets the file input from anywhere. */
    controller?: object
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  field = useFieldValues(this)
  handle = usePrimitive(this, fileInput, () => ({
    disabled: (this.args.disabled as boolean) || this.field.disabled,
    name: (this.args.name as string) ?? this.field.name,
  }))
  root = usePart(this, () => this.handle, "root")
  input = usePart(this, () => this.handle, "input")

  constructor(owner: Owner, args: FileInput["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Dropzone=(component FileInputDropzone handle=this.handle)
        Trigger=(component FileInputTrigger handle=this.handle field=@field)
        List=(component FileInputList handle=this.handle)
        Item=(component FileInputItem handle=this.handle)
        Remove=(component FileInputItemRemove handle=this.handle)
      )
      as |f|
    }}
      {{#if @render}}
        {{yield f}}
        <input {{this.input.modifier}} />
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield f}}<input
            {{this.input.modifier}}
          /></div>
      {{/if}}
    {{/let}}
  </template>
}

export default FileInput
