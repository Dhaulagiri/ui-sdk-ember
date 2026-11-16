import { Listbox } from "ember-ui-sdk/listbox"

const sizes = [
  { value: "xs", label: "XS" },
  { value: "s", label: "S" },
  { value: "m", label: "M" },
  { value: "l", label: "L" },
  { value: "xl", label: "XL", disabled: true },
]

<template>
  <Listbox
    @orientation="horizontal"
    @loop={{false}}
    @defaultValue="m"
    aria-label="Size"
    as |l|
  >
    {{#each sizes key="value" as |size|}}
      <l.Item @value={{size.value}} @disabled={{size.disabled}}>
        {{size.label}}
      </l.Item>
    {{/each}}
  </Listbox>
</template>
