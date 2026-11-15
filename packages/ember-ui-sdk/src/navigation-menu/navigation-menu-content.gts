import Component from "@glimmer/component"
import { navigationMenu } from "@ui-sdk/core/navigation-menu"
import { portalTarget } from "@ui-sdk/core/renderer"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"
import NavigationMenu from "./navigation-menu.gts"
import NavigationMenuLink from "./navigation-menu-link.gts"

type Container = Element | DocumentFragment | null | undefined

/** The panel an item opens. Renders in the viewport when there is one, else as its own popup. Yields a nested `Menu` and its `Link`. */
class NavigationMenuContent extends Component<
  PartSignature<
    typeof navigationMenu,
    "content",
    HTMLDivElement,
    { item: string; container?: Container; rootContainer?: Container }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "content",
    () => ({
      value: this.args.item,
    })
  )

  get destination() {
    this.part.attrs
    const { api, state } = this.args.handle
    const viewport = api.internal.viewportElement()
    if (viewport && api.internal.inViewport(this.args.item)) {
      return viewport
    }
    return state.viewport
      ? null
      : portalTarget(this.args.container ?? this.args.rootContainer)
  }

  <template>
    {{#if this.part.present}}
      {{#let
        (hash
          part=this.part.modifier
          state=this.part.state
          Menu=(component
            NavigationMenu
            parent=@handle
            parentItem=@item
            container=@rootContainer
          )
          Link=(component NavigationMenuLink handle=@handle)
        )
        as |content|
      }}
        <Portal @to={{this.destination}}>
          {{#if @render}}
            {{yield content}}
          {{else}}
            <div ...attributes {{this.part.modifier}}>{{yield content}}</div>
          {{/if}}
        </Portal>
      {{/let}}
    {{/if}}
  </template>
}

export default NavigationMenuContent
