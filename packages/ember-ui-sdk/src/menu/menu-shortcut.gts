import Component from "@glimmer/component"
import { menu } from "@ui-sdk/core/menu"
import { usePart, type PartSignature } from "../use-part"

/** Shows the keys of an item's shortcut, like `⌘S`, inside the item. Hidden from screen readers. */
class MenuShortcut extends Component<
  PartSignature<typeof menu, "shortcut", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "shortcut")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <span ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</span>
    {{/if}}
  </template>
}

export default MenuShortcut
