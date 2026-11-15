import Component from "@glimmer/component"
import type { toastRegion, Toast as ToastData } from "@ui-sdk/core/toast"
import { usePart, type PartSignature } from "../use-part"
import Content from "./content.gts"

/** The toast's title. Renders the toast's `title` without content of its own, and nothing when it has neither. */
class ToastTitle extends Component<
  PartSignature<
    typeof toastRegion,
    "title",
    HTMLDivElement,
    { toast: ToastData<unknown> }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "title",
    () => ({
      id: this.args.toast.id,
    })
  )

  get content() {
    return this.args.toast.title
  }

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else if (has-block)}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{else if this.content}}
      <div ...attributes {{this.part.modifier}}><Content
          @content={{this.content}}
        /></div>
    {{/if}}
  </template>
}

export default ToastTitle
