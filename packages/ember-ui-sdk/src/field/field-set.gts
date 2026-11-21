import { hash } from "@ember/helper"
import type { WithBoundArgs } from "@glint/template"
import Component from "@glimmer/component"
import { fieldSet } from "@ui-sdk/core/field"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import FieldDescription from "./field-description.gts"
import FieldLegend from "./field-legend.gts"

/** A native <fieldset>, so `@disabled` disables every control inside it. Yields its `Legend` and `Description`. */
class FieldSet extends Component<{
  Element: HTMLFieldSetElement
  Args: {
    /** Disables every control inside it. */
    disabled?: boolean
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: {
    default: [
      RootYield<typeof fieldSet, "set"> & {
        Legend: WithBoundArgs<typeof FieldLegend, "handle">
        Description: WithBoundArgs<typeof FieldDescription, "field">
      },
    ]
  }
}> {
  handle = usePrimitive(this, fieldSet)
  root = usePart(this, () => this.handle, "set")
  set = { handle: this.handle }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Legend=(component FieldLegend handle=this.handle)
        Description=(component FieldDescription field=this.set)
      )
      as |s|
    }}
      {{#if @render}}
        {{yield s}}
      {{else}}
        <fieldset ...attributes {{this.root.modifier}}>{{yield s}}</fieldset>
      {{/if}}
    {{/let}}
  </template>
}

export default FieldSet
