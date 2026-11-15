import Component from "@glimmer/component"
import { fileInput } from "@ui-sdk/core/file-input"
import { usePart, type PartSignature } from "../use-part"

/** Takes dropped and pasted files. Put the trigger inside it, which is how keyboard and screen reader users choose files. */
class FileInputDropzone extends Component<
  PartSignature<typeof fileInput, "dropzone", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "dropzone")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{/if}}
  </template>
}

export default FileInputDropzone
