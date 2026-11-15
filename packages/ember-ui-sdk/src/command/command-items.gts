import Component from "@glimmer/component"
import type { command, CommandData } from "@ui-sdk/core/command"
import type { PrimitiveHandle } from "../use-primitive"
import CommandGroup from "./command-group.gts"
import CommandItem from "./command-item.gts"
import CommandSeparator from "./command-separator.gts"

type Entry = CommandData[number]

/** Renders data commands. Used by data command lists, and available for custom layouts. */
class CommandItems extends Component<{
  Args: {
    handle: PrimitiveHandle<typeof command>
    items: CommandData
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
        <CommandItem
          @handle={{@handle}}
          @data={{true}}
          @value={{entry}}
        >{{entry}}</CommandItem>
      {{else if (this.isSeparator entry)}}
        <CommandSeparator @handle={{@handle}} />
      {{else if (this.isGroup entry)}}
        <CommandGroup @handle={{@handle}} @data={{true}} as |group|>
          {{#if entry.label}}<group.Label>{{entry.label}}</group.Label>{{/if}}
          <CommandItems @handle={{@handle}} @items={{entry.items}} />
        </CommandGroup>
      {{else}}
        <CommandItem
          @handle={{@handle}}
          @data={{true}}
          @value={{entry.value}}
          @label={{entry.label}}
          @keywords={{entry.keywords}}
          @disabled={{entry.disabled}}
          @shortcut={{entry.shortcut}}
        >{{entry.label}}</CommandItem>
      {{/if}}
    {{/each}}
  </template>
}

export default CommandItems
