import { registerDestructor } from "@ember/destroyable"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { portalTarget } from "@ui-sdk/core/renderer"
import { onInsert } from "../on-insert"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"
import { afterRender } from "../use-primitive"
import type { Shared } from "./autocomplete.gts"
import AutocompleteList from "./autocomplete-list.gts"

type Container = Element | DocumentFragment | null | undefined

/** The popup that holds the list, positioned against the input. */
class AutocompleteContent extends Component<
  PartSignature<
    typeof autocomplete,
    "content",
    HTMLDivElement,
    {
      container?: Container
      rootContainer?: Container
      shared: Shared
      fromRoot?: boolean
    }
  >
> {
  viewport = usePart(this, () => this.args.handle, "viewport")
  header = usePart(this, () => this.args.handle, "header")
  part = usePart(this, () => this.args.handle, "content")

  constructor(owner: Owner, args: AutocompleteContent["args"]) {
    super(owner, args)
    const { shared } = args
    if (!args.fromRoot) {
      shared.contents++
      registerDestructor(this, () => shared.contents--)
    }
  }

  get target() {
    return portalTarget(this.args.container ?? this.args.rootContainer)
  }

  recordHeader = (el: Element) => {
    const { shared } = this.args
    afterRender(() => (shared.header = el as HTMLElement))
    return () => {
      if (shared.header === el) {
        afterRender(() => (shared.header = null))
      }
    }
  }

  <template>
    {{#if this.part.present}}
      <Portal @to={{this.target}}>
        {{#if this.viewport.present}}
          <div {{this.viewport.modifier}}>
            <div ...attributes {{this.part.modifier}}>
              {{#if this.header.present}}<div
                  {{this.header.modifier}}
                  {{onInsert this.recordHeader}}
                ></div>{{/if}}
              {{#if (has-block)}}{{yield this.part.yielded}}{{else if
                @handle.state.items
              }}<AutocompleteList @handle={{@handle}} />{{/if}}
            </div>
          </div>
        {{else}}
          <div ...attributes {{this.part.modifier}}>
            {{~#if (has-block)}}{{yield this.part.yielded}}{{else if
              @handle.state.items
            }}<AutocompleteList @handle={{@handle}} />{{/if~}}
          </div>
        {{/if}}
      </Portal>
    {{/if}}
  </template>
}

export default AutocompleteContent
