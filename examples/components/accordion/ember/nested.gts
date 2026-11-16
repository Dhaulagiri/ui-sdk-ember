import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

const sections = [
  {
    value: "profile",
    label: "Profile",
    content: "Your name, photo and the email address people see.",
  },
  {
    value: "notifications",
    label: "Notifications",
    topics: [
      {
        value: "email",
        label: "Email",
        content: "A weekly digest, and mentions as they happen.",
      },
      {
        value: "push",
        label: "Push",
        content: "Direct messages and replies to your comments.",
      },
    ],
  },
  {
    value: "billing",
    label: "Billing",
    topics: [
      {
        value: "payment",
        label: "Payment methods",
        content: "A Visa card ending in 4242, used for every renewal.",
      },
      {
        value: "invoices",
        label: "Invoices",
        content: "Download a PDF of any invoice from the last two years.",
      },
    ],
  },
]

<template>
  <Accordion @defaultValue={{array "notifications"}} as |a|>
    {{#each sections key="value" as |section|}}
      <a.Item @value={{section.value}} as |i|>
        <i.Header>
          <i.Trigger>
            {{section.label}}
            {{icon ChevronDown}}
          </i.Trigger>
        </i.Header>
        <i.Panel>
          {{#if section.topics}}
            <Accordion @multiple={{true}} as |n|>
              {{#each section.topics key="value" as |topic|}}
                <n.Item @value={{topic.value}} as |ti|>
                  <ti.Header @render={{true}} as |h|>
                    <h4 {{h.part}}>
                      <ti.Trigger>
                        {{topic.label}}
                        {{icon ChevronDown}}
                      </ti.Trigger>
                    </h4>
                  </ti.Header>
                  <ti.Panel>{{topic.content}}</ti.Panel>
                </n.Item>
              {{/each}}
            </Accordion>
          {{else}}
            <div>{{section.content}}</div>
          {{/if}}
        </i.Panel>
      </a.Item>
    {{/each}}
  </Accordion>
</template>
