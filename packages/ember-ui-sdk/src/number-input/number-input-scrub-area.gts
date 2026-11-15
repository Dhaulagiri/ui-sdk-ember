import Component from "@glimmer/component"
import { numberInput } from "@ui-sdk/core/number-input"
import { controllerTarget } from "../controller-target"
import type { PartSignature } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import NumberInputScrubAreaBinding from "./number-input-scrub-area-binding.gts"

/** Drag across it to change the value. It works anywhere inside the number input, and outside it through `@controller`, like an icon in a toolbar. */
class NumberInputScrubArea extends Component<
  PartSignature<
    typeof numberInput,
    "scrub-area",
    HTMLSpanElement,
    { controller?: object; handle?: PrimitiveHandle<typeof numberInput> }
  >
> {
  get handle() {
    return controllerTarget(this.args.controller, this.args.handle)
  }

  <template>
    {{#if this.handle}}
      <NumberInputScrubAreaBinding
        ...attributes
        @handle={{this.handle}}
        @orientation={{@orientation}}
        @pixelsPerStep={{@pixelsPerStep}}
        @render={{@render}}
        as |scrub|
      >{{yield scrub}}</NumberInputScrubAreaBinding>
    {{else if @render}}
      {{! @glint-expect-error an unconnected scrub area has no part to yield }}
      {{yield (hash state=this.unconnected)}}
    {{else}}
      {{! @glint-expect-error an unconnected scrub area has no part to yield }}
      <span ...attributes>{{yield (hash state=this.unconnected)}}</span>
    {{/if}}
  </template>

  unconnected = {
    value: null,
    disabled: false,
    readOnly: false,
    required: false,
    scrubbing: false,
  }
}

export default NumberInputScrubArea
