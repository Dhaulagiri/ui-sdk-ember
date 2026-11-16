import { array } from "@ember/helper"
import { ChevronDown, Check } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"

const users = [
  { id: 1, name: "Hollis Grant", username: "hollis", role: "Owner" },
  { id: 2, name: "Inès Moreau", username: "ines", role: "Admin" },
  { id: 3, name: "Kofi Mensah", username: "kofi", role: "Member" },
  { id: 4, name: "Wren Takahashi", username: "wren", role: "Member" },
  { id: 5, name: "Tomasz Wójcik", username: "tomasz", role: "Guest" },
]

const initial = (name: string) => name.slice(0, 1)

<template>
  <Combobox as |c|>
    <div data-slot="stack">
      <c.Label>Owner</c.Label>
      <div data-slot="row">
        <c.Input placeholder="Search people…" />
        <c.Trigger aria-label="Show people">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No people found.</c.Empty>
      <c.List>
        {{#each users key="id" as |user|}}
          <c.Item
            @value={{user.username}}
            @label={{user.name}}
            @keywords={{array user.username}}
            as |item|
          >
            <span data-slot="badge">
              {{initial user.name}}
            </span>
            <span data-slot="stack">
              <span>{{user.name}}</span>
              <span data-slot="hint">@{{user.username}}</span>
            </span>
            <span data-slot="hint">
              {{user.role}}
            </span>
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
