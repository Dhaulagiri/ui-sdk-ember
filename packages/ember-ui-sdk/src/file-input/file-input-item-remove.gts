import Component from "@glimmer/component"
import { fileInput } from "@ui-sdk/core/file-input"
import { fileKey } from "@ui-sdk/core/renderer"
import { usePart, type PartSignature } from "../use-part"

/** Removes its item's file, or the `file` it's given. It's named "Remove <file name>" unless you name it. */
class FileInputItemRemove extends Component<
  PartSignature<
    typeof fileInput,
    "item-remove",
    HTMLButtonElement,
    { file?: File }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "item-remove",
    () => {
      const file = this.args.file as File
      return { file, value: fileKey(file) }
    }
  )

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default FileInputItemRemove
