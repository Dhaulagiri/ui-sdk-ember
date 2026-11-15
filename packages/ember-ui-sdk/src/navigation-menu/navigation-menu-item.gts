import Component from "@glimmer/component"
import { navigationMenu } from "@ui-sdk/core/navigation-menu"
import { usePart, type PartSignature } from "../use-part"
import NavigationMenuContent from "./navigation-menu-content.gts"
import NavigationMenuLink from "./navigation-menu-link.gts"
import NavigationMenuTrigger from "./navigation-menu-trigger.gts"

let count = 0

/** One entry of the menu: a link, or a trigger with its content. Yields its `Trigger`, `Content` and `Link`. */
class NavigationMenuItem extends Component<
  PartSignature<
    typeof navigationMenu,
    "item",
    HTMLLIElement,
    { rootContainer?: Element | DocumentFragment | null }
  >
> {
  generated = `ui-sdk-e-nav${++count}`

  get value() {
    return (this.args.value as string | undefined) ?? this.generated
  }

  part = usePart(
    this,
    () => this.args.handle,
    "item",
    () => ({
      value: this.value,
    })
  )

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Trigger=(component NavigationMenuTrigger handle=@handle item=this.value)
        Content=(component
          NavigationMenuContent
          handle=@handle
          item=this.value
          rootContainer=@rootContainer
        )
        Link=(component NavigationMenuLink handle=@handle)
      )
      as |item|
    }}
      {{#if @render}}
        {{yield item}}
      {{else}}
        <li ...attributes {{this.part.modifier}}>{{yield item}}</li>
      {{/if}}
    {{/let}}
  </template>
}

export default NavigationMenuItem
