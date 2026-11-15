import Component from "@glimmer/component"
import { portalTarget } from "@ui-sdk/core/renderer"
import { select } from "@ui-sdk/core/select"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"
import SelectItems from "./select-items.gts"

type Container = Element | DocumentFragment | null | undefined

/** The popup that holds the items, positioned against the trigger. */
class SelectContent extends Component<
  PartSignature<
    typeof select,
    "content",
    HTMLDivElement,
    { container?: Container; rootContainer?: Container }
  >
> {
  viewport = usePart(this, () => this.args.handle, "viewport")
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
              <div ...attributes {{this.part.modifier}}>{{#if
                  (has-block)
                }}{{yield this.part.yielded}}{{else if
                  @handle.state.items
                }}<SelectItems
                    @handle={{@handle}}
                    @items={{this.part.state.items}}
                  />{{/if}}</div>
            {{/if}}
          </div>
        {{else if @render}}
          {{yield this.part.yielded}}
        {{else}}
          <div ...attributes {{this.part.modifier}}>{{#if (has-block)}}{{yield
                this.part.yielded
              }}{{else if @handle.state.items}}<SelectItems
                @handle={{@handle}}
                @items={{this.part.state.items}}
              />{{/if}}</div>
        {{/if}}
      </Portal>
    {{/if}}
  </template>
}

export default SelectContent
