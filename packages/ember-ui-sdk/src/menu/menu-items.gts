import Component from "@glimmer/component"
import type { MenuData, MenuDataItem } from "@ui-sdk/core/menu"
import { menu } from "@ui-sdk/core/menu"
import type { PrimitiveHandle } from "../use-primitive"
import MenuCheckboxItem from "./menu-checkbox-item.gts"
import MenuContent from "./menu-content.gts"
import MenuGroup from "./menu-group.gts"
import MenuItem from "./menu-item.gts"
import MenuRadioGroup from "./menu-radio-group.gts"
import MenuSeparator from "./menu-separator.gts"
import MenuSub from "./menu-sub.gts"
import MenuSubTrigger from "./menu-sub-trigger.gts"

function keyOf(item: MenuDataItem, index: number) {
  switch (item.type) {
    case undefined:
    case "item":
    case "checkbox":
      return item.value
    case "radio-group":
      return item.name
    default:
      return `${item.type}-${index}`
  }
}

/** Renders a data menu's items as bare parts. Used by `<Menu @items>` when you place no `Content` of your own. */
class MenuItems extends Component<{
  Args: { handle: PrimitiveHandle<typeof menu>; items: MenuData }
}> {
  get entries() {
    return this.args.items.map((entry, index) => {
      const item: MenuDataItem =
        typeof entry === "string" ? { value: entry, label: entry } : entry
      const type = (item.type ?? "item").replace(/-(\w)/g, (_, c) =>
        c.toUpperCase()
      )
      return {
        key: keyOf(item, index),
        item: item as any,
        is: { [type]: true },
      }
    })
  }

  <template>
    {{#each this.entries key="key" as |entry|}}
      {{#let entry.item as |item|}}
        {{#if entry.is.item}}
          <MenuItem
            @handle={{@handle}}
            @value={{item.value}}
            @disabled={{item.disabled}}
            @shortcut={{item.shortcut}}
            @closeOnSelect={{item.closeOnSelect}}
            @destructive={{item.destructive}}
          >{{item.label}}</MenuItem>
        {{else if entry.is.separator}}
          <MenuSeparator @handle={{@handle}} />
        {{else if entry.is.group}}
          <MenuGroup @handle={{@handle}} as |group|>
            {{#if item.label}}<group.Label>{{item.label}}</group.Label>{{/if}}
            <MenuItems @handle={{@handle}} @items={{item.items}} />
          </MenuGroup>
        {{else if entry.is.checkbox}}
          <MenuCheckboxItem
            @handle={{@handle}}
            @value={{item.value}}
            @disabled={{item.disabled}}
            @checked={{item.checked}}
            @defaultChecked={{item.defaultChecked}}
            @closeOnSelect={{item.closeOnSelect}}
          >{{item.label}}</MenuCheckboxItem>
        {{else if entry.is.radioGroup}}
          <MenuRadioGroup
            @handle={{@handle}}
            @name={{item.name}}
            @value={{item.value}}
            @defaultValue={{item.defaultValue}}
            as |group|
          >
            {{#if item.label}}<group.Label>{{item.label}}</group.Label>{{/if}}
            {{#each item.items key="value" as |radio|}}
              <group.Item
                @value={{radio.value}}
                @disabled={{radio.disabled}}
              >{{radio.label}}</group.Item>
            {{/each}}
          </MenuRadioGroup>
        {{else if entry.is.submenu}}
          <MenuSub @parent={{@handle}} as |sub|>
            <MenuSubTrigger
              @handle={{sub.handle}}
              @disabled={{item.disabled}}
            >{{item.label}}</MenuSubTrigger>
            <MenuContent @handle={{sub.handle}}>
              <MenuItems @handle={{sub.handle}} @items={{item.items}} />
            </MenuContent>
          </MenuSub>
        {{/if}}
      {{/let}}
    {{/each}}
  </template>
}

export default MenuItems
