import Component from "@glimmer/component"
import { command } from "@ui-sdk/core/command"
import { usePart, type PartSignature } from "../use-part"

/** A group's heading, which names it. */
class CommandGroupLabel extends Component<
  PartSignature<
    typeof command,
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

export default CommandGroupLabel
