import { array } from "@ember/helper"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

const items = [
  {
    value: "notifications",
    label: "Notification settings",
    content: "Choose what we email you about, and how often.",
  },
  {
    value: "privacy",
    label: "Privacy and security",
    content: "Turn on two-factor authentication and review signed-in devices.",
  },
  {
    value: "billing",
    label: "Billing and subscription",
    content: "Update your payment method and download past invoices.",
  },
]

<template>
  <Accordion @multiple={{true}} @defaultValue={{array "notifications"}} as |a|>
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
