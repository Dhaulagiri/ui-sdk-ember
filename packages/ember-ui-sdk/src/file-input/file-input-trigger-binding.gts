import Component from "@glimmer/component"
import { fileInput } from "@ui-sdk/core/file-input"
import { usePart, type PartSignature } from "../use-part"

/** The bound trigger, once its file input is known. */
class FileInputTriggerBinding extends Component<
  PartSignature<typeof fileInput, "trigger", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "trigger")

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

export default FileInputTriggerBinding
