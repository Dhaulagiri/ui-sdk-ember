import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Popover } from "ember-ui-sdk/popover"

<template>
  <Popover as |p|>
    <p.Trigger @shortcut="mod+i">
      Invite
      <p.Shortcut />
    </p.Trigger>
    <p.Content>
      <p.Title>Invite people</p.Title>
      <p.Description>They'll get an email with a link to join.</p.Description>
      <Field as |f|>
        <f.Label>Email</f.Label>
        <Input @field={{f.field}} type="email" placeholder="wren@example.com" />
      </Field>
      <div data-slot="row">
        <p.Close>Cancel</p.Close>
        <p.Close data-variant="solid">Send Invite</p.Close>
      </div>
    </p.Content>
  </Popover>
</template>
