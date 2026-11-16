import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

const items = [
  {
    value: "fruit",
    label: "Which fruit do you stock?",
    content: "Apples, pears, mangoes and, in summer, pineapple.",
  },
  {
    value: "organic",
    label: "Is it organic?",
    content: "Everything we stock is certified organic.",
  },
  {
    value: "delivery",
    label: "When do you deliver?",
    content: "Every weekday morning before 10.",
  },
]

<template>
  <Accordion @hiddenUntilFound={{true}} as |a|>
    {{#each items key="value" as |item|}}
      <a.Item @value={{item.value}} as |i|>
        <i.Header>
          <i.Trigger>
            {{item.label}}
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>{{item.content}}</i.Panel>
      </a.Item>
    {{/each}}
  </Accordion>
</template>
