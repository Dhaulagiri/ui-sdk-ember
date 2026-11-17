import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { navigationMenu } from "@ui-sdk/core/navigation-menu"
import { usePart, type PartSignature } from "../use-part"
import NavigationMenuLinkIcon from "./navigation-menu-link-icon.gts"

/** A link. Pressing it closes the menu, and `current` marks the current page with `aria-current="page"`. */
class NavigationMenuLink extends Component<
  PartSignature<typeof navigationMenu, "link", HTMLAnchorElement>
> {
  part = usePart(this, () => this.args.handle, "link")

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Icon=(component NavigationMenuLinkIcon handle=@handle)
      )
      as |link|
    }}
      {{#if @render}}
        {{yield link}}
      {{else}}
        <a ...attributes {{this.part.modifier}}>{{yield link}}</a>
      {{/if}}
    {{/let}}
  </template>
}

export default NavigationMenuLink
