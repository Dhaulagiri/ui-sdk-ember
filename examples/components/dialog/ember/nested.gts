import { Dialog } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"

<template>
  <Dialog as |d|>
    <d.Trigger>Account</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="stack">
        <d.Title>Account</d.Title>
        <d.Description>Manage how you sign in.</d.Description>
      </div>
      <div data-slot="card">
        <div data-slot="stack">
          <span>Password</span>
          <span data-slot="hint">Last changed 3 months ago</span>
        </div>
        <Dialog as |inner|>
          <inner.Trigger>Change Password</inner.Trigger>
          <inner.Backdrop />
          <inner.Content>
            <div data-slot="stack">
              <inner.Title>Change password</inner.Title>
              <inner.Description>Use at least 12 characters.</inner.Description>
            </div>
            <Field as |f|>
              <f.Label>New password</f.Label>
              <Input type="password" @field={{f.field}} />
            </Field>
            <div data-slot="row">
              <inner.Close>Cancel</inner.Close>
              <inner.Close data-variant="solid">Update</inner.Close>
            </div>
          </inner.Content>
        </Dialog>
      </div>
      <div data-slot="row">
        <d.Close data-variant="solid">Done</d.Close>
      </div>
    </d.Content>
  </Dialog>
</template>
