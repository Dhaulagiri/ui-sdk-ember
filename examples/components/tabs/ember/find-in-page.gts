import { Tabs } from "ember-ui-sdk/tabs"

const policies = [
  {
    value: "shipping",
    label: "Shipping",
    text: "Orders leave our warehouse within two working days. Express delivery arrives the next morning.",
  },
  {
    value: "returns",
    label: "Returns",
    text: "Send anything back within 30 days. Opened electronics carry a restocking fee of 10 percent.",
  },
  {
    value: "warranty",
    label: "Warranty",
    text: "Every product has a two-year warranty. Batteries are covered for one year from delivery.",
  },
]

<template>
  <Tabs @defaultValue="shipping" @hiddenUntilFound={{true}} as |t|>
    <t.List aria-label="Policies">
      {{#each policies key="value" as |policy|}}
        <t.Tab @value={{policy.value}}>{{policy.label}}</t.Tab>
      {{/each}}
    </t.List>
    {{#each policies key="value" as |policy|}}
      <t.Panel @value={{policy.value}}>{{policy.text}}</t.Panel>
    {{/each}}
  </Tabs>
</template>
