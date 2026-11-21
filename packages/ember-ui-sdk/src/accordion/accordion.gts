import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import type { ChangeDetails } from "@ui-sdk/core"
import Component from "@glimmer/component"
import {
  accordion,
  type AccordionController,
  type AccordionValueChangeReason,
} from "@ui-sdk/core/accordion"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import AccordionItem from "./accordion-item.gts"

/** A stack of items that each open a section of content. One item is open at a time unless `@multiple` is set. Yields its `Item`. */
class Accordion extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The open items' values. Pass it with `@onValueChange` to control the accordion. */
    value?: string[]
    /** The open items' values at first, when uncontrolled. */
    defaultValue?: string[]
    /** Whether several items can be open at once. */
    multiple?: boolean
    /** Whether the open item can be closed, in a single-open accordion. */
    collapsible?: boolean
    /** Disables every item. */
    disabled?: boolean
    /** Keeps closed panels in the page, hidden. */
    keepMounted?: boolean
    /** Keeps closed panels in the page as `hidden="until-found"`. */
    hiddenUntilFound?: boolean
    /** Opens and closes items from anywhere. Create one with `createAccordionController()`. */
    controller?: AccordionController
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Runs when an item wants to open or close. `details.cancel()` stops it. */
    onValueChange?: (
      value: string[],
      details: ChangeDetails<AccordionValueChangeReason>
    ) => void
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: {
    default: [
      RootYield<typeof accordion> & {
        Item: WithBoundArgs<typeof AccordionItem, "handle">
      },
    ]
  }
}> {
  handle = usePrimitive(this, accordion)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Item=(component AccordionItem handle=this.handle)
      )
      as |a|
    }}
      {{#if @render}}
        {{yield a}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield a}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default Accordion
