import Component from "@glimmer/component"
import { command } from "@ui-sdk/core/command"
import { usePart, type PartSignature } from "../use-part"

/** The keys of a command's shortcut, formatted for the platform. Inside a command, its `shortcut`. */
class CommandShortcut extends Component<
  PartSignature<
    typeof command,
    "shortcut",
    HTMLSpanElement,
    { inherited?: string }
  >
> {
  part = usePart(
    this,
    () => this.args.handle,
    "shortcut",
    () => ({
      shortcut: this.args.shortcut ?? this.args.inherited,
    })
  )

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>
        {{~#if (has-block)}}{{yield
            this.part.yielded
          }}{{else}}{{this.part.state.text}}{{/if~}}
      </span>
    {{/if}}
  </template>
}

export default CommandShortcut
