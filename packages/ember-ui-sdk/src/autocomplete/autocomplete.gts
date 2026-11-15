import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { autocomplete } from "@ui-sdk/core/autocomplete"
import { registerController } from "../controller-target"
import { useFieldValues, type FieldContext } from "../field/context"
import { syncOptions, usePrimitive } from "../use-primitive"
import AutocompleteArrow from "./autocomplete-arrow.gts"
import AutocompleteClear from "./autocomplete-clear.gts"
import AutocompleteContent from "./autocomplete-content.gts"
import AutocompleteEmpty from "./autocomplete-empty.gts"
import AutocompleteGroup from "./autocomplete-group.gts"
import AutocompleteInput from "./autocomplete-input.gts"
import AutocompleteItem from "./autocomplete-item.gts"
import AutocompleteItems from "./autocomplete-items.gts"
import AutocompleteLabel from "./autocomplete-label.gts"
import AutocompleteList from "./autocomplete-list.gts"
import AutocompleteSeparator from "./autocomplete-separator.gts"
import AutocompleteStatus from "./autocomplete-status.gts"
import AutocompleteTrigger from "./autocomplete-trigger.gts"

// What the content and the input share: whether the app renders a content of
// its own, and the sheet header the input moves into while the list is a sheet.
class Shared {
  contents = 0
  @tracked header: HTMLElement | null = null
}

/**
 * A text field that suggests as you type. The text is the value. It renders no
 * element of its own. Takes Autocomplete's options as arguments, and yields its parts.
 */
class Autocomplete extends Component<{
  Args: Record<string, unknown> & {
    /** The items as data. Renders them for you. */
    items?: unknown[]
    /** Reads and sets the autocomplete from anywhere. */
    controller?: object
    /** Renders the list into this element instead of in place. */
    container?: Element | DocumentFragment | null
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
  }
  Blocks: { default: [Record<string, any>] }
}> {
  field = useFieldValues(this)
  handle = usePrimitive(this, autocomplete, () => ({
    disabled: (this.args.disabled as boolean) || this.field.disabled,
    name: (this.args.name as string) ?? this.field.name,
  }))
  shared = new Shared()

  constructor(owner: Owner, args: Autocomplete["args"]) {
    super(owner, args)
    registerController(this, () => this.args.controller, this.handle)
  }

  get ownContent() {
    return !this.args.items || this.shared.contents > 0
  }

  <template>
    {{syncOptions this.handle}}
    {{yield
      (hash
        handle=this.handle
        Label=(component AutocompleteLabel handle=this.handle)
        Input=(component
          AutocompleteInput handle=this.handle shared=this.shared field=@field
        )
        Trigger=(component AutocompleteTrigger handle=this.handle)
        Clear=(component AutocompleteClear handle=this.handle)
        Content=(component
          AutocompleteContent
          handle=this.handle
          shared=this.shared
          rootContainer=@container
        )
        List=(component AutocompleteList handle=this.handle)
        Items=(component AutocompleteItems handle=this.handle)
        Item=(component AutocompleteItem handle=this.handle)
        Group=(component AutocompleteGroup handle=this.handle)
        Separator=(component AutocompleteSeparator handle=this.handle)
        Empty=(component AutocompleteEmpty handle=this.handle)
        Status=(component AutocompleteStatus handle=this.handle)
        Arrow=(component AutocompleteArrow handle=this.handle)
      )
    }}
    {{#unless this.ownContent}}
      <AutocompleteContent
        @handle={{this.handle}}
        @shared={{this.shared}}
        @rootContainer={{@container}}
        @fromRoot={{true}}
      />
    {{/unless}}
  </template>
}

export default Autocomplete
export { Shared }
