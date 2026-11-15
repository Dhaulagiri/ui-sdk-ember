import Component from "@glimmer/component"
import { inputGroup } from "@ui-sdk/core/input"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import InputClear from "./input-clear.gts"

/** Holds an Input or Textarea with icons, text and buttons around it. Presses on its text and icons focus the field. Yields its `Clear`. */
class InputGroup extends Component<{
  Element: HTMLDivElement
  Args: {
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, inputGroup)
  root = usePart(this, () => this.handle, "group")

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Clear=(component InputClear handle=this.handle)
      )
      as |g|
    }}
      {{#if @render}}
        {{yield g}}
      {{else}}
        <div ...attributes {{this.root.modifier}}>{{yield g}}</div>
      {{/if}}
    {{/let}}
  </template>
}

export default InputGroup
