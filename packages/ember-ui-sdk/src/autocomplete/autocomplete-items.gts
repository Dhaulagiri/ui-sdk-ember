import Component from "@glimmer/component"
import type { autocomplete, ListData } from "@ui-sdk/core/autocomplete"
import type { PrimitiveHandle } from "../use-primitive"
import AutocompleteGroup from "./autocomplete-group.gts"
import AutocompleteItem from "./autocomplete-item.gts"
import AutocompleteSeparator from "./autocomplete-separator.gts"

type Entry = ListData<string>[number]

/** Renders data items. Used by data autocompletees, and available for custom layouts. */
class AutocompleteItems extends Component<{
  Args: {
    handle: PrimitiveHandle<typeof autocomplete>
    items: ListData<string>
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
        <AutocompleteItem
          @handle={{@handle}}
          @group={{@group}}
          @value={{entry}}
        >{{entry}}</AutocompleteItem>
      {{else if (this.isSeparator entry)}}
        <AutocompleteSeparator @handle={{@handle}} />
      {{else if (this.isGroup entry)}}
        <AutocompleteGroup @handle={{@handle}} as |group|>
          {{#if entry.label}}<group.Label>{{entry.label}}</group.Label>{{/if}}
          <group.Items @items={{entry.items}} />
        </AutocompleteGroup>
      {{else}}
        <AutocompleteItem
          @handle={{@handle}}
          @group={{@group}}
          @value={{entry.value}}
          @label={{entry.label}}
          @keywords={{entry.keywords}}
          @disabled={{entry.disabled}}
        >{{entry.label}}</AutocompleteItem>
      {{/if}}
    {{/each}}
  </template>
}

export default AutocompleteItems
