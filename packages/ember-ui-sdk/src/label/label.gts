import Component from "@glimmer/component"
import { label as labelPrimitive } from "@ui-sdk/core/label"
import { usePart, type RootYield } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"

/**
 * A native <label> that names any control, by `for` or by wrapping it. A
 * control a <label> can't reach, like a radio group or a slider, takes it as
 * its name, and a press on the label activates it.
 */
class Label extends Component<{
  Element: HTMLLabelElement
  Args: {
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: {
    default: [Pick<RootYield<typeof labelPrimitive>, "part" | "state">]
  }
}> {
  handle = usePrimitive(this, labelPrimitive)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#if @render}}
      {{yield this.root.yielded}}
    {{else}}
      <label ...attributes {{this.root.modifier}}>{{yield
          this.root.yielded
        }}</label>
    {{/if}}
  </template>
}

export default Label
