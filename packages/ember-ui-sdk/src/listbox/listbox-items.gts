import Component from "@glimmer/component"
import type { listbox, ListData } from "@ui-sdk/core/listbox"
import type { PrimitiveHandle } from "../use-primitive"
import ListboxGroup from "./listbox-group.gts"
import ListboxItem from "./listbox-item.gts"
import ListboxSeparator from "./listbox-separator.gts"

type Entry = ListData<unknown>[number]

/** Renders data items. Used by data listboxes, and available for custom layouts. */
class ListboxItems extends Component<{
  Args: {
    handle: PrimitiveHandle<typeof listbox>
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
        <ListboxItem
          @handle={{@handle}}
          @group={{@group}}
          @value={{entry}}
        >{{entry}}</ListboxItem>
      {{else if (this.isSeparator entry)}}
        <ListboxSeparator @handle={{@handle}} />
      {{else if (this.isGroup entry)}}
        <ListboxGroup @handle={{@handle}} as |group|>
          {{#if entry.label}}<group.Label>{{entry.label}}</group.Label>{{/if}}
          <group.Items @items={{entry.items}} />
        </ListboxGroup>
      {{else}}
        <ListboxItem
          @handle={{@handle}}
          @group={{@group}}
          @value={{entry.value}}
          @label={{entry.label}}
          @disabled={{entry.disabled}}
        >{{entry.label}}</ListboxItem>
      {{/if}}
    {{/each}}
  </template>
}

export default ListboxItems
