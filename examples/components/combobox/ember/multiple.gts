import { stringValues } from "../../../shared/ember/combobox"
import { array, get } from "@ember/helper"
import { Check, ChevronDown, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "sveltekit", label: "SvelteKit" },
  { value: "nuxt", label: "Nuxt" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "solidstart", label: "SolidStart" },
  { value: "qwik", label: "Qwik City" },
]

const frameworkLabel = (value: string) =>
  frameworks.find((framework) => framework.value === value)?.label ?? value

<template>
  <Combobox
    @multiple={{true}}
    @defaultValue={{array "next" "astro"}}
    @itemToLabel={{frameworkLabel}}
    as |c|
  >
    <div data-slot="stack">
      <c.Label>Frameworks</c.Label>
      <div data-slot="row">
        <c.Chips>
          <c.Value as |state|>
            {{#each
              (stringValues state.value) key="@identity"
              as |value index|
            }}
              <c.Chip @value={{value}} as |chip|>
                {{get state.labels index}}
                <chip.Remove
                  aria-label="Remove {{get state.labels index}}"
                >{{icon X}}</chip.Remove>
              </c.Chip>
            {{/each}}
          </c.Value>
          <c.Input placeholder="Add a framework…" />
        </c.Chips>
        <c.Trigger aria-label="Show frameworks">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No frameworks found.</c.Empty>
      <c.List>
        {{#each frameworks key="value" as |framework|}}
          <c.Item
            @value={{framework.value}}
            @label={{framework.label}}
            as |item|
          >
            {{framework.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
