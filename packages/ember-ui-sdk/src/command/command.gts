import { hash } from "@ember/helper"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { command } from "@ui-sdk/core/command"
import { registerController } from "../controller-target"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import CommandEmpty from "./command-empty.gts"
import CommandGroup from "./command-group.gts"
import CommandInput from "./command-input.gts"
import CommandItem from "./command-item.gts"
import CommandItems from "./command-items.gts"
import CommandList from "./command-list.gts"
import CommandPage from "./command-page.gts"
import CommandSeparator from "./command-separator.gts"
import CommandStatus from "./command-status.gts"

// Whether the app renders a list of its own, so a data command knows whether to render one.
class Shared {
  lists = 0
}

/**
 * A search field over an always-open list of commands. Renders a `div` around
 * them. Takes Command's options as arguments, and yields its parts.
 */
class Command extends Component<{
  Element: HTMLDivElement
  Args: Record<string, unknown> & {
    /** The commands as data. Renders the list for you. */
    items?: unknown[]
    /** Reads and sets the command from anywhere. */
    controller?: object
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, command)
  root = usePart(this, () => this.handle, "root")
  shared = new Shared()

  constructor(owner: Owner, args: Command["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  get ownList() {
    return !this.args.items || this.shared.lists > 0
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Input=(component CommandInput handle=this.handle)
        List=(component CommandList handle=this.handle shared=this.shared)
        Page=(component CommandPage handle=this.handle)
        Group=(component CommandGroup handle=this.handle)
        Item=(component CommandItem handle=this.handle)
        Items=(component CommandItems handle=this.handle)
        Separator=(component CommandSeparator handle=this.handle)
        Empty=(component CommandEmpty handle=this.handle)
        Status=(component CommandStatus handle=this.handle)
      )
      as |c|
    }}
      {{#if @render}}
        {{yield c}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>
          {{yield c}}
          {{#unless this.ownList}}
            <CommandList
              @handle={{this.handle}}
              @shared={{this.shared}}
              @fromRoot={{true}}
            />
          {{/unless}}
        </div>
      {{/if}}
    {{/let}}
  </template>
}

export default Command
export { Shared }
