import { registerDestructor } from "@ember/destroyable"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ConfirmEntry } from "@ui-sdk/core/dialog"
import type { Toaster } from "@ui-sdk/core/renderer"
import {
  overlays as sharedOverlays,
  type OverlayEntry,
  type Overlays,
} from "@ui-sdk/core/overlays"
import HostedConfirm from "./hosted-confirm.gts"
import HostedToaster from "./hosted-toaster.gts"
import type { OverlayHostToastProps } from "./types"

const isToaster = (entry: OverlayEntry) => entry.type === "toaster"
const isConfirm = (entry: OverlayEntry) => entry.type === "confirm"
const toasterOf = (entry: OverlayEntry) =>
  (entry.data as { toaster: Toaster }).toaster
const confirmOf = (entry: OverlayEntry) => entry.data as ConfirmEntry

/**
 * Renders what `toast()` and `confirm()` open, from anywhere in the app. Mount
 * it once, near the root. A `ToastRegion` you place yourself takes over its
 * toaster. Its block renders each toast, like a region's.
 */
class OverlayHost extends Component<{
  Args: {
    /** The registry it renders. Defaults to the shared `overlays`. */
    overlays?: Overlays
    /** Arguments for the toast regions it renders, like `side` and `class`. */
    toast?: OverlayHostToastProps
  }
  Blocks: { default: [any, any, any] }
}> {
  @tracked entries: readonly OverlayEntry[] = []
  isToaster = isToaster
  isConfirm = isConfirm
  toasterOf = toasterOf
  confirmOf = confirmOf

  constructor(owner: Owner, args: OverlayHost["args"]) {
    super(owner, args)
    const registry = args.overlays ?? sharedOverlays
    this.entries = registry.entries()
    const unsubscribe = registry.subscribe(
      () => (this.entries = registry.entries())
    )
    const release = registry.attachHost()
    registerDestructor(this, () => {
      unsubscribe()
      release()
    })
  }

  <template>
    {{#each this.entries key="id" as |entry|}}
      {{#if (this.isToaster entry)}}
        {{#if (has-block)}}
          <HostedToaster
            @toaster={{this.toasterOf entry}}
            @regionProps={{@toast}}
            as |toast item parts|
          >{{yield toast item parts}}</HostedToaster>
        {{else}}
          <HostedToaster
            @toaster={{this.toasterOf entry}}
            @regionProps={{@toast}}
          />
        {{/if}}
      {{else if (this.isConfirm entry)}}
        <HostedConfirm @entry={{this.confirmOf entry}} />
      {{/if}}
    {{/each}}
  </template>
}

export default OverlayHost
