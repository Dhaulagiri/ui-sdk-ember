import { Info } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "../../../shared/ember/icon"

<template>
  <Field as |f|>
    <f.Label>Webhook URL</f.Label>
    <div id="webhook-row" data-slot="row">
      <Input placeholder="https://" @field={{f.field}} />
      <Tooltip as |t|>
        <t.Trigger aria-label="About webhooks">{{icon Info}}</t.Trigger>
        <t.Content @anchor="#webhook-row" @side="bottom" @align="start">
          We send a POST request here for every new order.
        </t.Content>
      </Tooltip>
    </div>
  </Field>
</template>
