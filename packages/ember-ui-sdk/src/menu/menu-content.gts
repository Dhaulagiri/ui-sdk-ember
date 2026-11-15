import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { registerDestructor } from "@ember/destroyable"
import { menu } from "@ui-sdk/core/menu"
import { portalTarget } from "@ui-sdk/core/renderer"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"

type Container = Element | DocumentFragment | null | undefined

/** The popup that holds the items, positioned against the trigger that opened it. */
class MenuContent extends Component<
  PartSignature<
    typeof menu,
    "content",
    HTMLDivElement,
    {
      container?: Container
      rootContainer?: Container
      claim?: () => () => void
    }
  >
> {
  // A submenu renders inside its parent's popup and moves with it.
  nested = this.args.handle.api.root() !== this.args.handle.api
  viewport = usePart(this, () => this.args.handle, "viewport")
  part = usePart(this, () => this.args.handle, "content")

  constructor(owner: Owner, args: MenuContent["args"]) {
    super(owner, args)
    const release = this.nested ? undefined : args.claim?.()
    if (release) {
      registerDestructor(this, release)
    }
  }

  get target() {
    return this.nested
      ? null
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

export default MenuContent
