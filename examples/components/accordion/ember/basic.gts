import { array } from "@ember/helper"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

const items = [
  {
    value: "shipping",
    label: "What are your shipping options?",
    content: [
      "We offer standard (5 to 7 days), express (2 to 3 days) and overnight shipping.",
      "Every order ships with tracking, and orders over $50 ship free.",
    ],
  },
  {
    value: "returns",
    label: "What is your return policy?",
    content: [
      "Return any unused item in its original packaging within 30 days. Refunds arrive within 5 to 7 business days.",
    ],
  },
  {
    value: "support",
    label: "How can I reach support?",
    content: [
      "Write to us by email or chat, or call us. We answer within 24 hours on business days.",
    ],
  },
]

<template>
  <Accordion @defaultValue={{array "shipping"}} as |a|>
    {{#each items key="value" as |item|}}
      <a.Item @value={{item.value}} as |i|>
        <i.Header>
          <i.Trigger>
            {{item.label}}
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>
          {{#each item.content as |paragraph|}}
            <p>{{paragraph}}</p>
          {{/each}}
        </i.Panel>
      </a.Item>
    {{/each}}
  </Accordion>
</template>
