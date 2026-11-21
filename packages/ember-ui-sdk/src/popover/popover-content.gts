import Component from "@glimmer/component"
import { popover } from "@ui-sdk/core/popover"
import { portalTarget } from "@ui-sdk/core/renderer"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"

type Container = Element | DocumentFragment | null | undefined

/** The panel itself, positioned against its trigger, named by its title and described by its description. */
class PopoverContent extends Component<
  PartSignature<
    typeof popover,
    "content",
    HTMLDivElement,
    { container?: Container; rootContainer?: Container }
  >
> {
  viewport = usePart(this, () => this.args.handle, "viewport")
  part = usePart(this, () => this.args.handle, "content")

  // With `inline`, the content and its viewport stay where they render.
  get target() {
    return this.args.inline
      ? undefined
      : portalTarget(this.args.container ?? this.args.rootContainer)
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

export default PopoverContent
