import Component from "@glimmer/component"
import { fileInput } from "@ui-sdk/core/file-input"
import { usePart, type PartSignature } from "../use-part"
import FileInputItem from "./file-input-item.gts"
import FileInputItemRemove from "./file-input-item-remove.gts"

/** The files, as a list. Its block renders once for each file, with the file and its `Item` and `Remove`. */
class FileInputList extends Component<
  PartSignature<typeof fileInput, "list", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "list")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>
        {{~#each this.part.state.value key="@identity" as |file|~}}
          {{~! @glint-expect-error the block gets the file and its parts too ~}}
          {{~yield
            this.part.yielded
            file
            (hash
              Item=(component FileInputItem handle=@handle file=file)
              Remove=(component FileInputItemRemove handle=@handle file=file)
            )
          ~}}
        {{~/each~}}
      </div>
    {{/if}}
  </template>
}

export default FileInputList
