import Component from "@glimmer/component"
import { popover } from "@ui-sdk/core/popover"
import { usePart, type PartSignature } from "../use-part"

/** Shows a trigger's shortcut, like ⌘I, inside the trigger. Hidden from screen readers. */
class PopoverShortcut extends Component<
  PartSignature<typeof popover, "shortcut", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "shortcut")

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

export default PopoverShortcut
