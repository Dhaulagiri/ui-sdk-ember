import Component from "@glimmer/component"
import { separator, type SeparatorOrientation } from "@ui-sdk/core/separator"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"

/** A line between groups of content, announced as a separator unless it's `@decorative`. */
class Separator extends Component<{
  Element: HTMLDivElement
  Args: {
    /** Which way the line runs. */
    orientation?: SeparatorOrientation
    /** Hides it from screen readers, for a line that is only visual. */
    decorative?: boolean
    /** Logs every state change with its reason. */
    debug?: boolean
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  handle = usePrimitive(this, separator)
  root = usePart(this, () => this.handle, "root")

  <template>
    {{syncOptions this.handle}}
    {{#if @render}}
      {{yield this.root.yielded}}
    {{else}}
      <div ...attributes {{this.root.modifier}}>{{yield
          this.root.yielded
        }}</div>
    {{/if}}
  </template>
}

export default Separator
