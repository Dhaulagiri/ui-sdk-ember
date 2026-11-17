import { hash } from "@ember/helper"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { WithBoundArgs } from "@glint/template"
import { combobox } from "@ui-sdk/core/combobox"
import { registerController } from "../controller-target"
import { useFieldValues, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import {
  syncOptions,
  usePrimitive,
  type PrimitiveHandle,
} from "../use-primitive"
import ValueInput from "../value-input.gts"
import ComboboxArrow from "./combobox-arrow.gts"
import ComboboxChip from "./combobox-chip.gts"
import ComboboxChips from "./combobox-chips.gts"
import ComboboxChipsOverflow from "./combobox-chips-overflow.gts"
import ComboboxClear from "./combobox-clear.gts"
import ComboboxContent from "./combobox-content.gts"
import ComboboxCreate from "./combobox-create.gts"
import ComboboxEmpty from "./combobox-empty.gts"
import ComboboxGroup from "./combobox-group.gts"
import ComboboxInput from "./combobox-input.gts"
import ComboboxItem from "./combobox-item.gts"
import ComboboxItems from "./combobox-items.gts"
import ComboboxLabel from "./combobox-label.gts"
import ComboboxList from "./combobox-list.gts"
import ComboboxSelectAll from "./combobox-select-all.gts"
import ComboboxSeparator from "./combobox-separator.gts"
import ComboboxStatus from "./combobox-status.gts"
import ComboboxTrigger from "./combobox-trigger.gts"
import ComboboxValue from "./combobox-value.gts"
import ComboboxValueIcon from "./combobox-value-icon.gts"

// What the content and the input share: whether the app renders a content of
// its own, and the sheet header the input moves into while the list is a sheet.
class Shared {
  contents = 0
  @tracked header: HTMLElement | null = null
}

/**
 * A text input that filters a list as you type. It renders no element of its
 * own: the input, the chips and the list are its parts. Takes Combobox's
 * options as arguments, and yields its parts.
 */
class Combobox extends Component<{
  Args: Record<string, unknown> & {
    /** The items as data. Renders them for you. */
    items?: unknown[]
    /** Reads and sets the combobox from anywhere. */
    controller?: object
    /** Renders the list into this element instead of in place. */
    container?: Element | DocumentFragment | null
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
  }
  Blocks: {
    default: [
      {
        handle: PrimitiveHandle<typeof combobox>
        Label: WithBoundArgs<typeof ComboboxLabel, "handle">
        Input: WithBoundArgs<
          typeof ComboboxInput,
          "handle" | "shared" | "field"
        >
        Trigger: WithBoundArgs<typeof ComboboxTrigger, "handle">
        Clear: WithBoundArgs<typeof ComboboxClear, "handle">
        Value: WithBoundArgs<typeof ComboboxValue, "handle">
        ValueIcon: WithBoundArgs<typeof ComboboxValueIcon, "handle">
        Chips: WithBoundArgs<typeof ComboboxChips, "handle">
        Chip: WithBoundArgs<typeof ComboboxChip, "handle">
        ChipsOverflow: WithBoundArgs<typeof ComboboxChipsOverflow, "handle">
        Content: WithBoundArgs<
          typeof ComboboxContent,
          "handle" | "shared" | "rootContainer"
        >
        List: WithBoundArgs<typeof ComboboxList, "handle">
        Items: WithBoundArgs<typeof ComboboxItems, "handle">
        Item: WithBoundArgs<typeof ComboboxItem, "handle">
        Group: WithBoundArgs<typeof ComboboxGroup, "handle">
        Separator: WithBoundArgs<typeof ComboboxSeparator, "handle">
        SelectAll: WithBoundArgs<typeof ComboboxSelectAll, "handle">
        Create: WithBoundArgs<typeof ComboboxCreate, "handle">
        Empty: WithBoundArgs<typeof ComboboxEmpty, "handle">
        Status: WithBoundArgs<typeof ComboboxStatus, "handle">
        Arrow: WithBoundArgs<typeof ComboboxArrow, "handle">
      },
    ]
  }
}> {
  field = useFieldValues(this)
  handle = usePrimitive(this, combobox, () => ({
    disabled: (this.args.disabled as boolean) || this.field.disabled,
    name: (this.args.name as string) ?? this.field.name,
  }))
  formInput = usePart(this, () => this.handle, "form-input")
  shared = new Shared()

  constructor(owner: Owner, args: Combobox["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  get values() {
    this.formInput.attrs
    return this.handle.state.multiple
      ? (this.handle.api.internal.serialized() as string[])
      : []
  }

  get ownContent() {
    return !this.args.items || this.shared.contents > 0
  }

  <template>
    {{syncOptions this.handle}}
    {{yield
      (hash
        handle=this.handle
        Label=(component ComboboxLabel handle=this.handle)
        Input=(component
          ComboboxInput handle=this.handle shared=this.shared field=@field
        )
        Trigger=(component ComboboxTrigger handle=this.handle)
        Clear=(component ComboboxClear handle=this.handle)
        Value=(component ComboboxValue handle=this.handle)
        ValueIcon=(component ComboboxValueIcon handle=this.handle)
        Chips=(component ComboboxChips handle=this.handle)
        Chip=(component ComboboxChip handle=this.handle)
        ChipsOverflow=(component ComboboxChipsOverflow handle=this.handle)
        Content=(component
          ComboboxContent
          handle=this.handle
          shared=this.shared
          rootContainer=@container
        )
        List=(component ComboboxList handle=this.handle)
        Items=(component ComboboxItems handle=this.handle)
        Item=(component ComboboxItem handle=this.handle)
        Group=(component ComboboxGroup handle=this.handle)
        Separator=(component ComboboxSeparator handle=this.handle)
        SelectAll=(component ComboboxSelectAll handle=this.handle)
        Create=(component ComboboxCreate handle=this.handle)
        Empty=(component ComboboxEmpty handle=this.handle)
        Status=(component ComboboxStatus handle=this.handle)
        Arrow=(component ComboboxArrow handle=this.handle)
      )
    }}
    {{#unless this.ownContent}}
      <ComboboxContent
        @handle={{this.handle}}
        @shared={{this.shared}}
        @rootContainer={{@container}}
        @fromRoot={{true}}
      />
    {{/unless}}
    <input {{this.formInput.modifier}} />
    {{#each this.values key="@identity" as |value|}}
      <ValueInput @handle={{this.handle}} @value={{value}} />
    {{/each}}
  </template>
}

export default Combobox
export { Shared }
