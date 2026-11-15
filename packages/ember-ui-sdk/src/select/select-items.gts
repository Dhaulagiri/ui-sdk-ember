import Component from "@glimmer/component"
import type { select, ListData } from "@ui-sdk/core/select"
import type { PrimitiveHandle } from "../use-primitive"
import SelectGroup from "./select-group.gts"
import SelectItem from "./select-item.gts"
import SelectSeparator from "./select-separator.gts"

type Entry = ListData<unknown>[number]

/** Renders data items. Used by data selectes, and available for custom layouts. */
class SelectItems extends Component<{
  Args: {
    handle: PrimitiveHandle<typeof select>
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
        <SelectItem
          @handle={{@handle}}
          @group={{@group}}
          @value={{entry}}
        >{{entry}}</SelectItem>
      {{else if (this.isSeparator entry)}}
        <SelectSeparator @handle={{@handle}} />
      {{else if (this.isGroup entry)}}
        <SelectGroup @handle={{@handle}} as |group|>
          {{#if entry.label}}<group.Label>{{entry.label}}</group.Label>{{/if}}
          <group.Items @items={{entry.items}} />
        </SelectGroup>
      {{else}}
        <SelectItem
          @handle={{@handle}}
          @group={{@group}}
          @value={{entry.value}}
          @label={{entry.label}}
          @disabled={{entry.disabled}}
        >{{entry.label}}</SelectItem>
      {{/if}}
    {{/each}}
  </template>
}

export default SelectItems
