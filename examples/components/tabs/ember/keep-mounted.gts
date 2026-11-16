import { Field } from "ember-ui-sdk/field"
import { Tabs } from "ember-ui-sdk/tabs"
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Tabs @defaultValue="reply" as |t|>
    <t.List aria-label="Comment">
      <t.Tab @value="reply">Reply</t.Tab>
      <t.Tab @value="formatting">Formatting</t.Tab>
      <t.Indicator />
    </t.List>
    <t.Panel @value="reply" @keepMounted={{true}}>
      <Field as |f|>
        <f.Label>Message</f.Label>
        <Textarea @field={{f.field}} rows="3" placeholder="Write a reply…" />
      </Field>
    </t.Panel>
    <t.Panel @value="formatting">
      <p>Use **bold**, _italics_ and `code` to format your reply.</p>
      <p>Paste a link on its own line to show a preview.</p>
    </t.Panel>
  </Tabs>
</template>
