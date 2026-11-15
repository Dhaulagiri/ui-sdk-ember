import Component from "@glimmer/component"
import type { toastRegion, Toast as ToastData } from "@ui-sdk/core/toast"
import { usePart, type PartSignature } from "../use-part"
import Content from "./content.gts"

/** The toast's action, like Undo. Renders the toast's `action` label without content of its own, as a link when the action has an `href`. A Promise from its handler keeps the toast open and the button pending. */
class ToastAction extends Component<
  PartSignature<
    typeof toastRegion,
    "action",
    HTMLAnchorElement | HTMLButtonElement,
    { toast: ToastData<unknown> }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "action",
    () => ({
      toast: this.args.toast.id,
      onAction: this.args.onAction,
      dismiss: this.args.dismiss,
    })
  )

  get action() {
    return this.args.toast.action
  }

  get href() {
    return this.action?.href as string | undefined
  }

  get shown() {
    return Boolean(this.action || this.args.onAction)
  }

  <template>
    {{#if this.shown}}
      {{#if @render}}
        {{yield this.part.yielded}}
      {{else if this.href}}
        <a href={{this.href}} ...attributes {{this.part.modifier}}>{{#if
            (has-block)
          }}{{yield this.part.yielded}}{{else}}<Content
              @content={{this.action.label}}
            />{{/if}}</a>
      {{else}}
        <button type="button" ...attributes {{this.part.modifier}}>{{#if
            (has-block)
          }}{{yield this.part.yielded}}{{else}}<Content
              @content={{this.action.label}}
            />{{/if}}</button>
      {{/if}}
    {{/if}}
  </template>
}

export default ToastAction
