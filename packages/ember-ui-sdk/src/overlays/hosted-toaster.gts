import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { registerDestructor } from "@ember/destroyable"
import { toasterInternals, type Toaster } from "@ui-sdk/core/renderer"
import ToastRegion from "../toast/toast-region.gts"
import type { OverlayHostToastProps } from "./types"

/** A toaster's region, unless the app placed one of its own. */
class HostedToaster extends Component<{
  Args: { toaster: Toaster; regionProps?: OverlayHostToastProps }
  Blocks: { default: [any, any, any] }
}> {
  internals = toasterInternals(this.args.toaster)
  @tracked placed = this.internals.hasPlacedRegion()

  constructor(owner: Owner, args: HostedToaster["args"]) {
    super(owner, args)
    const stop = args.toaster.subscribe(() => {
      this.placed = this.internals.hasPlacedRegion()
    })
    registerDestructor(this, stop)
  }

  <template>
    {{#unless this.placed}}
      {{#if (has-block)}}
        <ToastRegion
          class={{@regionProps.class}}
          @toaster={{@toaster}}
          @placed={{false}}
          @side={{@regionProps.side}}
          @align={{@regionProps.align}}
          @maxVisible={{@regionProps.maxVisible}}
          @expanded={{@regionProps.expanded}}
          @shortcut={{@regionProps.shortcut}}
          as |toast item parts|
        >{{yield toast item parts}}</ToastRegion>
      {{else}}
        <ToastRegion
          class={{@regionProps.class}}
          @toaster={{@toaster}}
          @placed={{false}}
          @side={{@regionProps.side}}
          @align={{@regionProps.align}}
          @maxVisible={{@regionProps.maxVisible}}
          @expanded={{@regionProps.expanded}}
          @shortcut={{@regionProps.shortcut}}
        />
      {{/if}}
    {{/unless}}
  </template>
}

export default HostedToaster
