import { registerDestructor } from "@ember/destroyable"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { command } from "@ui-sdk/core/command"
import { usePart, type PartSignature } from "../use-part"
import type { Shared } from "./command.gts"
import CommandItems from "./command-items.gts"

/** The listbox. Without a block, it renders the command's `items`, ranked as the user types. */
class CommandList extends Component<
  PartSignature<
    typeof command,
    "list",
    HTMLDivElement,
    { shared: Shared; fromRoot?: boolean }
  >
> {
  part = usePart(this, () => this.args.handle, "list")

  constructor(owner: Owner, args: CommandList["args"]) {
    super(owner, args)
    const { shared } = args
    if (!args.fromRoot) {
      shared.lists++
      registerDestructor(this, () => shared.lists--)
    }
  }

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield this.part.yielded}}{{else if
          @handle.state.items
        }}<CommandItems
            @handle={{@handle}}
            @items={{this.part.state.items}}
          />{{/if~}}
      </div>
    {{/if}}
  </template>
}

export default CommandList
