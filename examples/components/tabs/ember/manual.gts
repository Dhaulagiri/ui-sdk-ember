import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Tabs } from "ember-ui-sdk/tabs"

<template>
  <Tabs @defaultValue="preview" @activation="manual" as |t|>
    <t.List aria-label="Snippet">
      <t.Tab @value="preview">Preview</t.Tab>
      <t.Tab @value="code">Code</t.Tab>
    </t.List>
    <t.Panel @value="preview">Welcome back, Hollis. You have 3 unread messages.</t.Panel>
    <t.Panel @value="code">
      <Field as |f|>
        <f.Label>Source</f.Label>
        <Input
          @field={{f.field}}
          @defaultValue='<Welcome name="Hollis" unread={3} />'
        />
      </Field>
    </t.Panel>
  </Tabs>
</template>
