import Component from "@glimmer/component"
import { dialog } from "@ui-sdk/core/dialog"
import { portalTarget } from "@ui-sdk/core/renderer"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"

/** A dim behind the dialog. It's optional: without it, style the content's `::backdrop`. */
class DialogBackdrop extends Component<
  PartSignature<
    typeof dialog,
    "backdrop",
    HTMLDivElement,
    { rootContainer?: Element | DocumentFragment | null }
  >
> {
  part = usePart(this, () => this.args.handle, "backdrop")

  // Rendered where the content renders, so it sits in the top layer just below it.
  get target() {
    return portalTarget(this.args.rootContainer)
  }

  <template>
    {{#if this.part.present}}
      <Portal @to={{this.target}}>
        {{#if @render}}
          {{yield this.part.yielded}}
        {{else}}
          <div ...attributes {{this.part.modifier}}>{{yield
              this.part.yielded
            }}</div>
        {{/if}}
      </Portal>
    {{/if}}
  </template>
}

export default DialogBackdrop
