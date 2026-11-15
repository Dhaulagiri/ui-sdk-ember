import Component from "@glimmer/component"
import { numberInput } from "@ui-sdk/core/number-input"
import Portal from "../portal.gts"
import { usePart, type PartSignature } from "../use-part"

/** Stands in for the mouse cursor while a scrub locks the pointer. Rendered in the body, so transformed ancestors can't move it. */
class NumberInputScrubAreaCursor extends Component<
  PartSignature<typeof numberInput, "scrub-area-cursor", HTMLSpanElement>
> {
  part = usePart(this, () => this.args.handle, "scrub-area-cursor")

  get target() {
    return document.body
  }

  <template>
    {{#if this.part.present}}
      <Portal @to={{this.target}}>
        {{#if @render}}
          {{yield this.part.yielded}}
        {{else}}
          <span ...attributes {{this.part.modifier}}>{{yield
              this.part.yielded
            }}</span>
        {{/if}}
      </Portal>
    {{/if}}
  </template>
}

export default NumberInputScrubAreaCursor
