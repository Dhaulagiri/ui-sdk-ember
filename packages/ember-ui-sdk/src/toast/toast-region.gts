import Component from "@glimmer/component"
import { toastRegion } from "@ui-sdk/core/toast"
import { portalTarget } from "@ui-sdk/core/renderer"
import Portal from "../portal.gts"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import DataToast from "./data-toast.gts"
import ToastAction from "./toast-action.gts"
import ToastClose from "./toast-close.gts"
import ToastDescription from "./toast-description.gts"
import ToastTitle from "./toast-title.gts"
import Toast from "./toast.gts"

/**
 * Shows a toaster's toasts. Place it once, or let `<OverlayHost />` render it.
 * Each toast renders from the block, which gets the toast's data, its item and
 * its parts, else from its data.
 */
class ToastRegion extends Component<{
  Element: HTMLElement
  Args: Record<string, unknown> & {
    /** The toaster whose toasts it shows. Defaults to the shared `toast`. */
    toaster?: object
    /** Renders the region into this element instead of in place. */
    container?: Element | DocumentFragment | null
    /** @internal False for a region the overlay host renders. */
    placed?: boolean
  }
  Blocks: { default: [any, any, any] }
}> {
  handle = usePrimitive(this, toastRegion, () => ({
    placed: this.args.placed ?? true,
  }))
  region = usePart(this, () => this.handle, "region")
  list = usePart(this, () => this.handle, "list")

  get target() {
    return portalTarget(this.args.container)
  }

  <template>
    {{syncOptions this.handle}}
    <Portal @to={{this.target}}>
      <section ...attributes {{this.region.modifier}}>
        <ol {{this.list.modifier}}>
          {{#each this.region.state.toasts key="toast.id" as |item|}}
            {{#if (has-block)}}
              {{yield
                item.toast
                item
                (hash
                  Toast=(component Toast handle=this.handle toast=item.toast)
                  Title=(component
                    ToastTitle handle=this.handle toast=item.toast
                  )
                  Description=(component
                    ToastDescription handle=this.handle toast=item.toast
                  )
                  Action=(component
                    ToastAction handle=this.handle toast=item.toast
                  )
                  Close=(component
                    ToastClose handle=this.handle toast=item.toast
                  )
                )
              }}
            {{else}}
              <DataToast @handle={{this.handle}} @toast={{item.toast}} />
            {{/if}}
          {{/each}}
        </ol>
      </section>
    </Portal>
  </template>
}

export default ToastRegion
