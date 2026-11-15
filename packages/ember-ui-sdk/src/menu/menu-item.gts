import Component from "@glimmer/component"
import { formatShortcut } from "@ui-sdk/core"
import { menu } from "@ui-sdk/core/menu"
import { usePart, type PartSignature } from "../use-part"
import MenuShortcut from "./menu-shortcut.gts"

/** An action. Pressing it runs its `@onSelect` and closes the menu, unless `@closeOnSelect` is false. */
class MenuItem extends Component<
  PartSignature<typeof menu, "item", HTMLDivElement>
> {
  part = usePart(this, () => this.args.handle, "item")

  // The platform shows in `aria-keyshortcuts`, so reading the attributes
  // keeps the hint current once the client knows it.
  get shortcut() {
    const { shortcut, handle } = this.args
    if (!shortcut) {
      return undefined
    }
    this.part.attrs
    return formatShortcut(shortcut, handle.state.apple)
  }

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <div ...attributes {{this.part.modifier}}>
        {{~yield this.part.yielded~}}
        {{~#if this.shortcut}}<MenuShortcut
            @handle={{@handle}}
          >{{this.shortcut}}</MenuShortcut>{{/if~}}
      </div>
    {{/if}}
  </template>
}

export default MenuItem
