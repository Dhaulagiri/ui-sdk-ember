import { stringValues } from "../../../shared/ember/combobox"
import { array } from "@ember/helper"
import { Check, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"

const labels = [
  "Bug",
  "Feature",
  "Documentation",
  "Design",
  "Performance",
  "Security",
  "Testing",
]

<template>
  <Combobox
    @multiple={{true}}
    @maxSelected={{3}}
    @defaultValue={{array "Bug" "Design"}}
    as |c|
  >
    <div data-slot="stack">
      <c.Label>Labels (up to 3)</c.Label>
      <c.Chips>
        <c.Value as |state|>
          {{#each (stringValues state.value) key="@identity" as |label|}}
            <c.Chip @value={{label}} as |chip|>
              {{label}}
              <chip.Remove aria-label="Remove {{label}}">{{icon
                  X
                }}</chip.Remove>
            </c.Chip>
          {{/each}}
        </c.Value>
        <c.Input placeholder="Add labels…" />
      </c.Chips>
    </div>
    <c.Content>
      <c.List>
        {{#each labels key="@identity" as |label|}}
          <c.Item @value={{label}} as |item|>
            {{label}}
            {{#if item.state.maxReached}}
              <span data-slot="hint">Limit reached</span>
            {{/if}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
