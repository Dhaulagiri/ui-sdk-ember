import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "nuxt", label: "Nuxt" },
  { value: "sveltekit", label: "SvelteKit" },
]

<template>
  <Listbox
    @readOnly={{true}}
    @defaultValue="nuxt"
    aria-label="Framework"
    as |l|
  >
    {{#each frameworks key="value" as |framework|}}
      <l.Item @value={{framework.value}} as |i|>
        {{framework.label}}
        <i.Indicator>{{icon Check}}</i.Indicator>
      </l.Item>
    {{/each}}
  </Listbox>
</template>
