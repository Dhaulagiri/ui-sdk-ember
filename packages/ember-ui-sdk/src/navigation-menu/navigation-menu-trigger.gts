import Component from "@glimmer/component"
import { navigationMenu } from "@ui-sdk/core/navigation-menu"
import { usePart, type PartSignature } from "../use-part"

/** The button that opens its item's content. Resting the pointer on it opens the content too. */
class NavigationMenuTrigger extends Component<
  PartSignature<
    typeof navigationMenu,
    "trigger",
    HTMLButtonElement,
    { item: string }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "trigger",
    () => ({
      value: this.args.item,
    })
  )

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default NavigationMenuTrigger
