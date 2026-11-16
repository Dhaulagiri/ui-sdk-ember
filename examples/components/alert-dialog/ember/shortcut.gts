import { AlertDialog } from "ember-ui-sdk/alert-dialog"

<template>
  <AlertDialog as |d|>
    <d.Trigger @shortcut="mod+shift+h">
      Clear History
      <d.Shortcut />
    </d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="stack">
        <d.Title>Clear your history?</d.Title>
        <d.Description>
          Recent searches and visited pages are removed from this device.
        </d.Description>
      </div>
      <div data-slot="row">
        <d.Close>Cancel</d.Close>
        <d.Close data-variant="solid" @value="confirm">Clear</d.Close>
      </div>
    </d.Content>
  </AlertDialog>
</template>
