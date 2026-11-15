import Component from "@glimmer/component"
import { dialog } from "@ui-sdk/core/dialog"
import { portalTarget } from "@ui-sdk/core/renderer"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"

type Container = Element | DocumentFragment | null | undefined

/** The dialog itself, named by its title and described by its description. */
class DialogContent extends Component<
  PartSignature<
    typeof dialog,
    "content",
    HTMLDivElement,
    { container?: Container; rootContainer?: Container; sheet?: boolean }
  >
> {
  // An alert dialog never presents as a sheet, so it has no viewport to bind.
  viewport = this.args.sheet
    ? usePart(this, () => this.args.handle, "viewport")
    : undefined
  part = usePart(this, () => this.args.handle, "content")

  get target() {
    return portalTarget(this.args.container ?? this.args.rootContainer)
  }

  <template>
    {{#if this.part.present}}
      <Portal @to={{this.target}}>
        {{#if this.viewport.present}}
          <div {{this.viewport.modifier}}>
            {{#if @render}}
              {{yield this.part.yielded}}
            {{else}}
              <div ...attributes {{this.part.modifier}}>{{yield
                  this.part.yielded
                }}</div>
            {{/if}}
          </div>
        {{else if @render}}
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

export default DialogContent
