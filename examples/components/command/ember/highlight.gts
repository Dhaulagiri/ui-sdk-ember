import {
  Calculator,
  Calendar,
  CreditCard,
  Search,
  Settings,
  Smile,
  User,
} from "lucide"
import { Command } from "ember-ui-sdk/command"
import { icon } from "../../../shared/ember/icon"

const commands = [
  { value: "calendar", label: "Calendar", icon: Calendar },
  { value: "emoji", label: "Search Emoji", icon: Smile },
  {
    value: "calculator",
    label: "Calculator",
    icon: Calculator,
    disabled: true,
  },
  { value: "profile", label: "Profile", icon: User },
  { value: "billing", label: "Billing", icon: CreditCard },
  { value: "settings", label: "Settings", icon: Settings },
]

<template>
  <Command as |c|>
    <div data-slot="row">
      {{icon Search}}
      <c.Input aria-label="Search commands" placeholder="Try “prf” or “emo”…" />
    </div>
    <c.Empty>No results found.</c.Empty>
    <c.List>
      {{#each commands key="value" as |command|}}
        <c.Item
          @value={{command.value}}
          @label={{command.label}}
          @disabled={{command.disabled}}
          as |item|
        >
          <item.Icon>{{icon command.icon}}</item.Icon>
          <item.Text />
        </c.Item>
      {{/each}}
    </c.List>
  </Command>
</template>
