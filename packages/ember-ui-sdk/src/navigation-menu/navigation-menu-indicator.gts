import Component from "@glimmer/component"
import { navigationMenu } from "@ui-sdk/core/navigation-menu"
import { usePart, type PartSignature } from "../use-part"

/** Sits under the open trigger, or under the link with `current` while every panel is closed. Screen readers skip it. */
class NavigationMenuIndicator extends Component<
  PartSignature<typeof navigationMenu, "indicator", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "indicator")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</div>
    {{/if}}
  </template>
}

export default NavigationMenuIndicator
