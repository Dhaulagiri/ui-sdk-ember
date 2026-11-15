import Component from "@glimmer/component"
import { fileInput } from "@ui-sdk/core/file-input"
import { fileKey } from "@ui-sdk/core/renderer"
import { usePart, type PartSignature } from "../use-part"
import FileInputItemRemove from "./file-input-item-remove.gts"

/** One file. Its state has the file, for its name, size and preview. Arrow keys move between items, and Backspace or Delete removes the focused one. Yields its `Remove`. */
class FileInputItem extends Component<
  PartSignature<typeof fileInput, "item", HTMLDivElement, { file: File }>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "item",
    () => {
      const file = this.args.file
      return { file, value: fileKey(file) }
    }
  )

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Remove=(component FileInputItemRemove handle=@handle file=@file)
      )
      as |item|
    }}
      {{#if @render}}
        {{yield item}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield item}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default FileInputItem
