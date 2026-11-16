import { array } from "@ember/helper"
import { Accordion } from "ember-ui-sdk/accordion"
import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <Accordion @defaultValue={{array "reply"}} as |a|>
    <a.Item @value="reply" as |i|>
      <i.Header>
        <i.Trigger>
          Reply to this thread
          {{icon ChevronDown}}
        </i.Trigger>
      </i.Header>
      <i.Panel @keepMounted={{true}}>
        <Field as |f|>
          <f.Label>Message</f.Label>
          <Textarea rows="3" placeholder="Write a reply…" @field={{f.field}} />
        </Field>
      </i.Panel>
    </a.Item>
    <a.Item @value="formatting" as |i|>
      <i.Header>
        <i.Trigger>
          Formatting
          {{icon ChevronDown}}
        </i.Trigger>
      </i.Header>
      <i.Panel>
        <p>Use **bold**, _italics_ and `code`. Links paste as previews.</p>
      </i.Panel>
    </a.Item>
  </Accordion>
</template>
