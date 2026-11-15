import type { TOC } from "@ember/component/template-only"
import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { controllerTarget } from "../controller-target"
import { useFieldControl, type FieldContext } from "../field/context"
import type { PartSignature } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"
import SelectTriggerBinding from "./select-trigger-binding.gts"

const plainState = {
  open: false,
  disabled: false,
  readOnly: false,
  required: false,
  placeholder: true,
}

// The value of a trigger outside its select, before the select mounts.
const PlainValue: TOC<{
  Element: HTMLSpanElement
  Args: { placeholder?: string }
}> = <template>
  <span ...attributes>{{@placeholder}}</span>
</template>

const PlainValueIcon: TOC<{ Args: {} }> = <template></template>

/** The button that opens the list: a combobox named by the label. A trigger outside the select connects through `@controller`. */
class SelectTrigger extends Component<
  PartSignature<
    typeof select,
    "trigger",
    HTMLButtonElement,
    {
      controller?: object
      handle?: PrimitiveHandle<typeof select>
      id?: string
      field?: FieldContext
    }
  >
> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  plain = {
    state: plainState,
    part: this.fieldControl.modifier,
    Value: PlainValue,
    ValueIcon: PlainValueIcon,
  }

  get handle() {
    return controllerTarget(this.args.controller, this.args.handle)
  }

  get named() {
    return this.args.named ?? (this.args.field ? true : undefined)
  }

  <template>
    {{#if this.handle}}
      <SelectTriggerBinding
        ...attributes
        @handle={{this.handle}}
        @disabled={{@disabled}}
        @named={{this.named}}
        @render={{@render}}
        {{this.fieldControl.modifier}}
        as |trigger|
      >{{yield trigger}}</SelectTriggerBinding>
    {{else if @render}}
      {{yield this.plain}}
    {{else}}
      {{! Until the select it names mounts, a trigger outside it is a plain button. }}
      <button
        type="button"
        disabled={{@disabled}}
        ...attributes
        {{this.fieldControl.modifier}}
      >{{yield this.plain}}</button>
    {{/if}}
  </template>
}

export default SelectTrigger
