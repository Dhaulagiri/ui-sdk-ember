import { registerDestructor } from "@ember/destroyable"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { portalTarget } from "@ui-sdk/core/renderer"
import { triggerMenu } from "@ui-sdk/core/trigger-menu"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"
import type { Shared } from "./trigger-menu.gts"
import TriggerMenuList from "./trigger-menu-list.gts"

type Container = Element | DocumentFragment | null | undefined

/** The popup that holds the list, positioned at the caret. Without a block, it renders the current trigger's items. */
class TriggerMenuContent extends Component<
  PartSignature<
    typeof triggerMenu,
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
  part = usePart(this, () => this.args.handle, "content")

  constructor(owner: Owner, args: TriggerMenuContent["args"]) {
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

  <template>
    {{#if this.part.present}}
      <Portal @to={{this.target}}>
        {{#if @render}}
          {{yield this.part.yielded}}
        {{else}}
          <div ...attributes {{this.part.modifier}}>
            {{~#if (has-block)}}{{yield
                this.part.yielded
              }}{{else}}<TriggerMenuList @handle={{@handle}} />{{/if~}}
          </div>
        {{/if}}
      </Portal>
    {{/if}}
  </template>
}

export default TriggerMenuContent
