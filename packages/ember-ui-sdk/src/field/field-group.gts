import Component from "@glimmer/component"
import { fieldGroup } from "@ui-sdk/core/field"
import { usePart, type PartModifier } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"

/** Lays fields out. It has no role: a FieldSet is what names and disables a group. */
class FieldGroup extends Component<{
  Element: HTMLDivElement
  Args: {
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [{ part: PartModifier; state: Record<string, unknown> }] }
}> {
  handle = usePrimitive(this, fieldGroup)
  root = usePart(this, () => this.handle, "group")

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

export default FieldGroup
