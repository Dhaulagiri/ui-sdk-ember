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

const suggestions = [
  { value: "calendar", label: "Calendar", icon: Calendar },
  { value: "emoji", label: "Search Emoji", icon: Smile },
  {
    value: "calculator",
    label: "Calculator",
    icon: Calculator,
    disabled: true,
  },
]

const settings = [
  { value: "profile", label: "Profile", icon: User, shortcut: "mod+p" },
  { value: "billing", label: "Billing", icon: CreditCard, shortcut: "mod+b" },
  { value: "settings", label: "Settings", icon: Settings, shortcut: "mod+s" },
]

<template>
  <Command as |c|>
    <div data-slot="row">
      {{icon Search}}
      <c.Input
        aria-label="Search commands"
        placeholder="Type a command or search…"
      />
    </div>
    <c.Empty>No results found.</c.Empty>
    <c.List>
      <c.Group as |g|>
        <g.Label>Suggestions</g.Label>
        {{#each suggestions key="value" as |suggestion|}}
          <g.Item
            @value={{suggestion.value}}
            @disabled={{suggestion.disabled}}
            as |item|
          >
            <item.Icon>{{icon suggestion.icon}}</item.Icon>
            <span>{{suggestion.label}}</span>
          </g.Item>
        {{/each}}
      </c.Group>
      <c.Separator />
      <c.Group as |g|>
        <g.Label>Settings</g.Label>
        {{#each settings key="value" as |setting|}}
          <g.Item
            @value={{setting.value}}
            @shortcut={{setting.shortcut}}
            as |item|
          >
            <item.Icon>{{icon setting.icon}}</item.Icon>
            <span>{{setting.label}}</span>
            <item.Shortcut />
          </g.Item>
        {{/each}}
      </c.Group>
    </c.List>
  </Command>
</template>
