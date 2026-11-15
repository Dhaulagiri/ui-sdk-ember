import Component from "@glimmer/component"
import { popover } from "@ui-sdk/core/popover"
import { usePart, type PartSignature } from "../use-part"

/** A button that closes the popover. */
class PopoverClose extends Component<
  PartSignature<typeof popover, "close", HTMLButtonElement>
> {
  part = usePart(this, () => this.args.handle, "close")

  <template>
    {{#if @render}}
      {{yield this.part.yielded}}
    {{else}}
      <button ...attributes {{this.part.modifier}}>{{yield
          this.part.yielded
        }}</button>
    {{/if}}
  </template>
}

export default PopoverClose
