import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import { usePart, type PartSignature } from "../use-part"

/** The group's heading, which names the group. */
class MenuGroupLabel extends Component<
  PartSignature<typeof menu, "group-label", HTMLDivElement, { group: string }>
> {
  part = usePart(
    this,
    () => this.args.handle,
    "group-label",
    () => ({
      id: this.args.group,
      group: this.args.group,
    })
  )

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

export default MenuGroupLabel
