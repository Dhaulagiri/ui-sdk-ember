import { X } from "lucide"
import { Dialog } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { icon } from "../../../shared/ember/icon"

<template>
  <Dialog as |d|>
    <d.Trigger>Share</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="stack">
        <d.Title>Share link</d.Title>
        <d.Description>Anyone who has this link will be able to view this.</d.Description>
      </div>
      <Field as |f|>
        <f.Label>Link</f.Label>
        <Input
          @defaultValue="https://example.com/project"
          readonly
          @field={{f.field}}
        />
      </Field>
      <div data-slot="row">
        <d.Close data-variant="solid">Done</d.Close>
      </div>
      <d.Close aria-label="Close">{{icon X}}</d.Close>
    </d.Content>
  </Dialog>
</template>
