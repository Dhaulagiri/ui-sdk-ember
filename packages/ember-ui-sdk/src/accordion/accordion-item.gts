import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { accordion } from "@ui-sdk/core/accordion"
import { usePart, type PartSignature } from "../use-part"
import AccordionHeader from "./accordion-header.gts"
import AccordionPanel from "./accordion-panel.gts"
import AccordionTrigger from "./accordion-trigger.gts"

let count = 0

/** One item: a header with its trigger, and the panel the trigger opens. Yields its `Header`, `Trigger` and `Panel`. */
class AccordionItem extends Component<
  PartSignature<typeof accordion, "item", HTMLDivElement, {}>
> {
  generated = `ui-sdk-e-item${++count}`
  part = usePart(
    this,
    () => this.args.handle,
    "item",
    () => ({
      value: this.value,
    })
  )

  get value() {
    return this.args.value ?? this.generated
  }

  <template>
    {{#let
      (hash
        part=this.part.modifier
        state=this.part.state
        Header=(component AccordionHeader handle=@handle value=this.value)
        Trigger=(component AccordionTrigger handle=@handle value=this.value)
        Panel=(component AccordionPanel handle=@handle value=this.value)
      )
      as |i|
    }}
      {{#if @render}}
        {{yield i}}
      {{else}}
        <div ...attributes {{this.part.modifier}}>{{yield i}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default AccordionItem
