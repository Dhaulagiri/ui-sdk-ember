import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Popover } from "ember-ui-sdk/popover"

<template>
  <Popover as |p|>
    <p.Trigger>Share</p.Trigger>
    <p.Content>
      <p.Title>Share this document</p.Title>
      <p.Description>Anyone with the link can view it.</p.Description>
      <Field as |f|>
        <f.Label>Link</f.Label>
        <Input
          @field={{f.field}}
          readonly
          @defaultValue="acme.app/d/q3-roadmap"
        />
      </Field>
      <div data-slot="row">
        <p.Close>Cancel</p.Close>
        <p.Close data-variant="solid">Copy Link</p.Close>
      </div>
    </p.Content>
  </Popover>
</template>
