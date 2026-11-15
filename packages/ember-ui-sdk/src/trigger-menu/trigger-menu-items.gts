import Component from "@glimmer/component"
import type { triggerMenu, TriggerMenuData } from "@ui-sdk/core/trigger-menu"
import type { PrimitiveHandle } from "../use-primitive"
import TriggerMenuGroup from "./trigger-menu-group.gts"
import TriggerMenuItem from "./trigger-menu-item.gts"
import TriggerMenuSeparator from "./trigger-menu-separator.gts"

type Entry = TriggerMenuData<unknown>[number]

/** Renders data items. Used by the menu's own list, and available for custom layouts. */
class TriggerMenuItems extends Component<{
  Args: {
    handle: PrimitiveHandle<typeof triggerMenu>
    items: TriggerMenuData<unknown>
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
        <TriggerMenuItem
          @handle={{@handle}}
          @group={{@group}}
          @value={{entry}}
        >{{entry}}</TriggerMenuItem>
      {{else if (this.isSeparator entry)}}
        <TriggerMenuSeparator @handle={{@handle}} />
      {{else if (this.isGroup entry)}}
        <TriggerMenuGroup @handle={{@handle}} as |group|>
          {{#if entry.label}}<group.Label>{{entry.label}}</group.Label>{{/if}}
          <group.Items @items={{entry.items}} />
        </TriggerMenuGroup>
      {{else}}
        <TriggerMenuItem
          @handle={{@handle}}
          @group={{@group}}
          @value={{entry.value}}
          @label={{entry.label}}
          @keywords={{entry.keywords}}
          @disabled={{entry.disabled}}
        >{{entry.label}}</TriggerMenuItem>
      {{/if}}
    {{/each}}
  </template>
}

export default TriggerMenuItems
