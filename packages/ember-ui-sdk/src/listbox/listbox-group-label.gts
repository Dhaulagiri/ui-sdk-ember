import Component from "@glimmer/component"
import { listbox } from "@ui-sdk/core/listbox"
import { usePart, type PartSignature } from "../use-part"

/** The group's heading, which names the group. */
class ListboxGroupLabel extends Component<
  PartSignature<
    typeof listbox,
    "group-label",
    HTMLDivElement,
    { group: string }
  >
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

export default ListboxGroupLabel
