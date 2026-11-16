import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Popover } from "ember-ui-sdk/popover"

<template>
  <Popover @presentation="sheet" as |p|>
    <p.Trigger>Add Reminder</p.Trigger>
    <p.Content>
      <p.Title>New reminder</p.Title>
      <p.Description>We'll notify you at the time you pick.</p.Description>
      <Field as |f|>
        <f.Label>Remind me to</f.Label>
        <Input @field={{f.field}} @defaultValue="Send the Q3 roadmap" />
      </Field>
      <div data-slot="row">
        <p.Close>Cancel</p.Close>
        <p.Close data-variant="solid">Save</p.Close>
      </div>
    </p.Content>
  </Popover>
</template>
