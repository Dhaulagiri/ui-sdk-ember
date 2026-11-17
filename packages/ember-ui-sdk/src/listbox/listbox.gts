import { hash } from "@ember/helper"
import Component from "@glimmer/component"
import { listbox } from "@ui-sdk/core/listbox"
import { useFieldControl, type FieldContext } from "../field/context"
import { usePart } from "../use-part"
import { syncOptions, usePrimitive } from "../use-primitive"
import ValueInput from "../value-input.gts"
import ListboxGroup from "./listbox-group.gts"
import ListboxItem from "./listbox-item.gts"
import ListboxItems from "./listbox-items.gts"
import ListboxSeparator from "./listbox-separator.gts"

/**
 * An always-visible list to choose one option from, or several with `@multiple`.
 * Takes Listbox's options as arguments, and yields its parts.
 */
class Listbox extends Component<{
  Element: HTMLDivElement
  Args: Record<string, unknown> & {
    /** The items as data. Renders them for you. */
    items?: unknown[]
    /** Its id, which a Field's label points at. */
    id?: string
    /** The Field around it, as its `field` yields. */
    field?: FieldContext
    /** Renders no element: bind your own with the yielded `part`. */
    render?: boolean
  }
  Blocks: { default: [Record<string, any>] }
}> {
  fieldControl = useFieldControl(this, () => ({ id: this.args.id }))
  handle = usePrimitive(this, listbox, () => ({
    disabled: (this.args.disabled as boolean) || this.fieldControl.disabled,
    name: (this.args.name as string) ?? this.fieldControl.name,
  }))
  root = usePart(this, () => this.handle, "root")
  formInput = usePart(this, () => this.handle, "form-input")

  get values() {
    this.formInput.attrs
    return this.handle.state.multiple
      ? (this.handle.api.internal.serialized() as string[])
      : []
  }

  <template>
    {{syncOptions this.handle}}
    {{#let
      (hash
        part=this.root.modifier
        state=this.root.state
        handle=this.handle
        Item=(component ListboxItem handle=this.handle)
        Items=(component ListboxItems handle=this.handle)
        Group=(component ListboxGroup handle=this.handle)
        Separator=(component ListboxSeparator handle=this.handle)
      )
      as |l|
    }}
      {{#if @render}}
        {{yield l}}
      {{else}}
        <div
          id={{@id}}
          ...attributes
          {{this.root.modifier}}
          {{this.fieldControl.modifier}}
        >
          {{~#if (has-block)}}{{yield l}}{{else if @items}}<ListboxItems
              @handle={{this.handle}}
              @items={{this.root.state.items}}
            />{{/if~}}
        </div>
      {{/if}}
    {{/let}}
    <input {{this.formInput.modifier}} />
    {{#each this.values key="@identity" as |value|}}
      <ValueInput @handle={{this.handle}} @value={{value}} />
    {{/each}}
  </template>
}

export default Listbox
