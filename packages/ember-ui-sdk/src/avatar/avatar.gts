import Component from "@glimmer/component"
import {
  avatar,
  type AvatarLoadingStatus,
  type AvatarLoadingStatusChangeReason,
} from "@ui-sdk/core/avatar"
import type { ChangeDetails } from "@ui-sdk/core"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import AvatarFallback from "./avatar-fallback.gts"
import AvatarImage from "./avatar-image.gts"

/** The root: a box for the image and its fallback. Yields its parts. */
class Avatar extends Component<{
  Element: HTMLSpanElement
  Args: {
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when the image's loading status changes. */
    onLoadingStatusChange?: (
      status: AvatarLoadingStatus,
      details: ChangeDetails<AvatarLoadingStatusChangeReason>
    ) => void
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, avatar)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Image=(component AvatarImage handle=this.handle)
        Fallback=(component AvatarFallback handle=this.handle)
      )
      as |a|
    }}
      {{#if @render}}
        {{yield a}}
      {{else}}
        <span ...attributes {{this.root.modifier}}>{{yield a}}</span>
      {{/if}}
    {{/let}}
  </template>
}

export default Avatar
