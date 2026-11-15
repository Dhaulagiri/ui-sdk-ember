import Component from "@glimmer/component"
import { dialog } from "@ui-sdk/core/dialog"
import { usePart, type PartSignature } from "../use-part"

/** A button that closes the dialog. An `action` runs first, and a Promise it returns keeps the dialog open until it settles. */
class DialogClose extends Component<
  PartSignature<typeof dialog, "close", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "close")

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

export default DialogClose
