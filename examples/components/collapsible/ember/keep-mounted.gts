import { Collapsible } from "ember-ui-sdk/collapsible"
import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Collapsible data-variant="card" as |c|>
    <c.Trigger>
      <span data-slot="stack">
        <span>Add a delivery note</span>
        <span data-slot="hint">Optional, for the courier</span>
      </span>
      {{icon ChevronDown}}
    </c.Trigger>
    <c.Panel @keepMounted={{true}}>
      <Field as |f|>
        <f.Label>Delivery note</f.Label>
        <Textarea
          placeholder="Leave it with the front desk…"
          @field={{f.field}}
        />
      </Field>
    </c.Panel>
  </Collapsible>
</template>
