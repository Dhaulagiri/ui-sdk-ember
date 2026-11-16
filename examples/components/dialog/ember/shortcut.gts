import { Plus } from "lucide"
import { Dialog } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { icon } from "../../../shared/ember/icon"

<template>
  <Dialog as |d|>
    <d.Trigger @shortcut="mod+j">
      {{icon Plus}}
      New Contact
      <d.Shortcut />
    </d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="stack">
        <d.Title>New contact</d.Title>
        <d.Description>Add someone to your address book.</d.Description>
      </div>
      <form data-slot="stack" method="dialog">
        <Field as |f|>
          <f.Label>Name</f.Label>
          <Input
            name="name"
            required
            placeholder="Kofi Mensah"
            @field={{f.field}}
          />
        </Field>
        <Field as |f|>
          <f.Label>Email</f.Label>
          <Input
            name="email"
            type="email"
            required
            placeholder="kofi@example.com"
            @field={{f.field}}
          />
        </Field>
        <div data-slot="row">
          <d.Close>Cancel</d.Close>
          <button data-variant="solid" type="submit" value="save">Save Contact</button>
        </div>
      </form>
    </d.Content>
  </Dialog>
</template>
