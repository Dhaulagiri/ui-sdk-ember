import { array } from "@ember/helper"
import { Field } from "ember-ui-sdk/field"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "../../../shared/ember/icon"

const topics = [
  { value: "comments", label: "Comments" },
  { value: "mentions", label: "Mentions" },
  { value: "reactions", label: "Reactions" },
  { value: "sign-ins", label: "New sign-ins" },
  { value: "billing", label: "Billing" },
]

<template>
  <Field as |f|>
    <f.Label>Email me about</f.Label>
    <Listbox
      @multiple={{true}}
      @activation="automatic"
      @defaultValue={{array "mentions"}}
      @field={{f.field}}
      as |l|
    >
      {{#each topics key="value" as |topic|}}
        <l.Item @value={{topic.value}} as |i|>
          {{topic.label}}
          <i.Indicator>{{icon Check}}</i.Indicator>
        </l.Item>
      {{/each}}
    </Listbox>
    <f.Description>Hold Shift to select a range, or Ctrl or ⌘ to add one.</f.Description>
  </Field>
</template>
