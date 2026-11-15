import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { navigationMenu } from "@ui-sdk/core/navigation-menu"
import { registerController } from "../controller-target"
import { usePart } from "../use-part"
import {
  syncOptions,
  usePrimitive,
  type PrimitiveHandle,
} from "../use-primitive"
import NavigationMenuIndicator from "./navigation-menu-indicator.gts"
import NavigationMenuItem from "./navigation-menu-item.gts"
import NavigationMenuLink from "./navigation-menu-link.gts"
import NavigationMenuList from "./navigation-menu-list.gts"
import NavigationMenuViewport from "./navigation-menu-viewport.gts"

/**
 * A site's navigation: links, and triggers that open panels of more. Renders a
 * `nav`, or a `div` inside another menu's content. Takes NavigationMenu's
 * options as arguments, and yields its parts.
 */
class NavigationMenu extends Component<{
  Element: HTMLElement
  Args: Record<string, unknown> & {
    /** Reads and sets the menu from anywhere. */
    controller?: object
    /** Renders the popups into this element instead of in place. */
    container?: Element | DocumentFragment | null
    /** @internal The menu a nested menu sits in, from its content's `Menu`. */
    parent?: PrimitiveHandle<typeof navigationMenu>
    /** @internal The item of the parent menu a nested menu sits in. */
    parentItem?: string
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, navigationMenu, () => ({
    parent: (this.args.parent
      ? { api: this.args.parent.api, item: this.args.parentItem }
      : undefined) as never,
  }))
  root = usePart(this, () => this.handle, "root")

  constructor(owner: Owner, args: NavigationMenu["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        List=(component
          NavigationMenuList handle=this.handle rootContainer=@container
        )
        Item=(component
          NavigationMenuItem handle=this.handle rootContainer=@container
        )
        Link=(component NavigationMenuLink handle=this.handle)
        Indicator=(component NavigationMenuIndicator handle=this.handle)
        Viewport=(component
          NavigationMenuViewport handle=this.handle rootContainer=@container
        )
      )
      as |n|
    }}
      {{#if @render}}
        {{yield n}}
      {{else if @parent}}
        <div ...attributes {{this.root.modifier}}>{{yield n}}</div>
      {{else}}
        <nav ...attributes {{this.root.modifier}}>{{yield n}}</nav>
      {{/if}}
    {{/let}}
  </template>
}

export default NavigationMenu
