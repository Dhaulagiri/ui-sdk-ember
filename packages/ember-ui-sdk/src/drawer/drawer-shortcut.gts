import Component from "@glimmer/component"
import { drawer } from "@ui-sdk/core/drawer"
import { usePart, type PartSignature } from "../use-part"

/** Shows a trigger's shortcut, like ⌘K, inside the trigger. Hidden from screen readers, which hear aria-keyshortcuts. */
class DrawerShortcut extends Component<
  PartSignature<typeof drawer, "shortcut", HTMLSpanElement>
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

export default DrawerShortcut
