import Component from "@glimmer/component"
import type { toastRegion, Toast as ToastData } from "@ui-sdk/core/toast"
import { usePart, type PartSignature } from "../use-part"

/** Closes the toast. With an `@action`, runs it first, and a returned Promise keeps the toast open until it settles. */
class ToastClose extends Component<
  PartSignature<
    typeof toastRegion,
    "close",
    HTMLButtonElement,
    { toast: ToastData<unknown> }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "close",
    () => ({
      toast: this.args.toast.id,
      action: this.args.action,
    })
  )

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button type="button" ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default ToastClose
