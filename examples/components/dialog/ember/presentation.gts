import { Dialog } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"

<template>
  <Dialog @presentation="sheet" as |d|>
    <d.Trigger>Edit Profile</d.Trigger>
    <d.Content>
      <div data-slot="stack">
        <d.Title>Edit profile</d.Title>
        <d.Description>Make changes to your profile here. Save when you're done.</d.Description>
      </div>
      <Field as |f|>
        <f.Label>Name</f.Label>
        <Input @defaultValue="Hollis Grant" @field={{f.field}} />
      </Field>
      <Field as |f|>
        <f.Label>Username</f.Label>
        <Input @defaultValue="@hollis" @field={{f.field}} />
      </Field>
      <div data-slot="row">
        <d.Close>Cancel</d.Close>
        <d.Close data-variant="solid" @value="save">Save Changes</d.Close>
      </div>
    </d.Content>
  </Dialog>
</template>
