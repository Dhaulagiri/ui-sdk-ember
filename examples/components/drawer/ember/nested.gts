import { Drawer } from "ember-ui-sdk/drawer"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"

<template>
  <Drawer as |d|>
    <d.Trigger>Account</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="grip" aria-hidden="true"></div>
      <div data-slot="stack">
        <d.Title>Account</d.Title>
        <d.Description>Manage how you sign in.</d.Description>
      </div>
      <dl>
        <div data-slot="row">
          <dt>Email</dt>
          <dd>hollis@example.com</dd>
        </div>
        <div data-slot="row">
          <dt>Password</dt>
          <dd>Changed 3 months ago</dd>
        </div>
        <div data-slot="row">
          <dt>Two-factor</dt>
          <dd>On</dd>
        </div>
      </dl>
      <div data-slot="stack">
        <Drawer as |inner|>
          <inner.Trigger>Change Password</inner.Trigger>
          <inner.Backdrop />
          <inner.Content>
            <div data-slot="grip" aria-hidden="true"></div>
            <div data-slot="stack">
              <inner.Title>Change password</inner.Title>
              <inner.Description>Use at least 12 characters.</inner.Description>
            </div>
            <Field as |f|>
              <f.Label>New password</f.Label>
              <Input type="password" @field={{f.field}} />
            </Field>
            <div data-slot="stack">
              <inner.Close data-variant="solid">Update</inner.Close>
            </div>
          </inner.Content>
        </Drawer>
        <d.Close data-variant="solid">Done</d.Close>
      </div>
    </d.Content>
  </Drawer>
</template>
