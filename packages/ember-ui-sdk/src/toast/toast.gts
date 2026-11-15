import Component from "@glimmer/component"
import type { toastRegion, Toast as ToastData } from "@ui-sdk/core/toast"
import { usePart, type PartSignature } from "../use-part"

/** One toast. Swipe it toward the region's side, or press Escape on it, to dismiss it. */
class Toast extends Component<
  PartSignature<
    typeof toastRegion,
    "root",
    HTMLLIElement,
    { toast: ToastData<unknown> }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "root",
    () => ({
      id: this.args.toast.id,
    })
  )

  <template>
    {{#if this.part.present}}
      {{#if @render}}
        {{yield this.part.yielded}}
      {{else}}
        <li ...attributes {{this.part.modifier}}>{{yield
            this.part.yielded
          }}</li>
      {{/if}}
    {{/if}}
  </template>
}

export default Toast
