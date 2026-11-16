import { array } from "@ember/helper"
import { Accordion } from "ember-ui-sdk/accordion"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

const items = [
  {
    value: "overview",
    label: "Overview",
    content: "A summary of the project, its goals and its owners.",
  },
  {
    value: "timeline",
    label: "Timeline",
    content: "Kickoff in March, beta in June and launch in September.",
  },
  {
    value: "budget",
    label: "Budget",
    content: "Approved for two engineers and one designer for six months.",
  },
]

<template>
  <Accordion @collapsible={{false}} @defaultValue={{array "overview"}} as |a|>
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
