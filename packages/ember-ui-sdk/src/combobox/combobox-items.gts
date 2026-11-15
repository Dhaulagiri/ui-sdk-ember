import Component from "@glimmer/component"
import type { combobox, ListData } from "@ui-sdk/core/combobox"
import type { PrimitiveHandle } from "../use-primitive"
import ComboboxGroup from "./combobox-group.gts"
import ComboboxItem from "./combobox-item.gts"
import ComboboxSeparator from "./combobox-separator.gts"

type Entry = ListData<unknown>[number]

/** Renders data items. Used by data comboboxes, and available for custom layouts. */
class ComboboxItems extends Component<{
  Args: {
    handle: PrimitiveHandle<typeof combobox>
    items: ListData<unknown>
    group?: string
  }
}> {
  isString = (entry: Entry) => typeof entry === "string"
  isSeparator = (entry: Entry) =>
    typeof entry === "object" && "type" in entry && entry.type === "separator"
  isGroup = (entry: Entry) =>
    typeof entry === "object" && "type" in entry && entry.type === "group"

  <template>
    {{#each @items as |entry|}}
      {{#if (this.isString entry)}}
        <ComboboxItem
          @handle={{@handle}}
          @group={{@group}}
          @value={{entry}}
        >{{entry}}</ComboboxItem>
      {{else if (this.isSeparator entry)}}
        <ComboboxSeparator @handle={{@handle}} />
      {{else if (this.isGroup entry)}}
        <ComboboxGroup @handle={{@handle}} as |group|>
          {{#if entry.label}}<group.Label>{{entry.label}}</group.Label>{{/if}}
          <group.Items @items={{entry.items}} />
        </ComboboxGroup>
      {{else}}
        <ComboboxItem
          @handle={{@handle}}
          @group={{@group}}
          @value={{entry.value}}
          @label={{entry.label}}
          @keywords={{entry.keywords}}
          @disabled={{entry.disabled}}
        >{{entry.label}}</ComboboxItem>
      {{/if}}
    {{/each}}
  </template>
}

export default ComboboxItems
