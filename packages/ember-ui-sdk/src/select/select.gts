import { hash } from "@ember/helper"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { select } from "@ui-sdk/core/select"
import { registerController } from "../controller-target"
import { useFieldValues, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import SelectArrow from "./select-arrow.gts"
import SelectClear from "./select-clear.gts"
import SelectContent from "./select-content.gts"
import SelectEmpty from "./select-empty.gts"
import SelectGroup from "./select-group.gts"
import SelectInput from "./select-input.gts"
import SelectItem from "./select-item.gts"
import SelectLabel from "./select-label.gts"
import SelectList from "./select-list.gts"
import SelectSelectAll from "./select-select-all.gts"
import SelectItems from "./select-items.gts"
import SelectSeparator from "./select-separator.gts"
import SelectStatus from "./select-status.gts"
import SelectTrigger from "./select-trigger.gts"
import SelectValue from "./select-value.gts"
import SelectValueIcon from "./select-value-icon.gts"
import SelectValueInput from "./select-value-input.gts"

/**
 * Picks one value, or several with `@multiple`, from a list in a popup.
 * Takes Select's options as arguments, and yields its parts.
 */
class Select extends Component<{
  Args: Record<string, unknown> & {
    /** Reads and sets the select from anywhere, and connects triggers outside it. */
    controller?: object
    /** Renders the list into this element instead of in place. */
    container?: Element | DocumentFragment | null
    /** The Field around it, as its `field` yields. Its trigger and name follow it. */
    field?: FieldContext
  }
  Blocks: { default: [Record<string, any>] }
}> {
  field = useFieldValues(this)
  handle = usePrimitive(this, select, () => ({
    disabled: (this.args.disabled as boolean) || this.field.disabled,
    name: (this.args.name as string) ?? this.field.name,
  }))
  formInput = usePart(this, () => this.handle, "form-input")

  constructor(owner: Owner, args: Select["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  // One more hidden input per value with `multiple`. The form input's
  // attributes change with the value, so reading them keeps these current.
  get values() {
    this.formInput.attrs
    return this.handle.state.multiple
      ? (this.handle.api.internal.serialized() as string[])
      : []
  }

  <template>
    {{syncOptions this.handle}}
    {{yield
      (hash
        handle=this.handle
        Label=(component SelectLabel handle=this.handle)
        Trigger=(component SelectTrigger handle=this.handle field=@field)
        Value=(component SelectValue handle=this.handle)
        ValueIcon=(component SelectValueIcon handle=this.handle)
        Clear=(component SelectClear handle=this.handle)
        Content=(component
          SelectContent handle=this.handle rootContainer=@container
        )
        Input=(component SelectInput handle=this.handle)
        Empty=(component SelectEmpty handle=this.handle)
        List=(component SelectList handle=this.handle)
        Item=(component SelectItem handle=this.handle)
        Items=(component SelectItems handle=this.handle)
        Group=(component SelectGroup handle=this.handle)
        Separator=(component SelectSeparator handle=this.handle)
        SelectAll=(component SelectSelectAll handle=this.handle)
        Status=(component SelectStatus handle=this.handle)
        Arrow=(component SelectArrow handle=this.handle)
      )
    }}
    <input {{this.formInput.modifier}} />
    {{#each this.values key="@identity" as |value|}}
      <SelectValueInput @handle={{this.handle}} @value={{value}} />
    {{/each}}
  </template>
}

export default Select
