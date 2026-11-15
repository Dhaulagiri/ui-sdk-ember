import Component from "@glimmer/component"
import type { toastRegion, Toast as ToastData } from "@ui-sdk/core/toast"
import { usePart, type PartSignature } from "../use-part"
import Content from "./content.gts"

/** The toast's description. Renders the toast's `description` without content of its own, and nothing when it has neither. */
class ToastDescription extends Component<
  PartSignature<
    typeof toastRegion,
    "description",
    HTMLDivElement,
    { toast: ToastData<unknown> }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "description",
    () => ({
      id: this.args.toast.id,
    })
  )

  get content() {
    return this.args.toast.description
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

export default ToastDescription
