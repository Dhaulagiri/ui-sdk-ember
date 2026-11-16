import { AlertDialog } from "ember-ui-sdk/alert-dialog"

<template>
  <AlertDialog as |d|>
    <d.Trigger>Leave Workspace</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="stack">
        <d.Title>Leave this workspace?</d.Title>
        <d.Description>
          You'll lose access to its projects until someone invites you again.
        </d.Description>
      </div>
      <div data-slot="row">
        <d.Close>Cancel</d.Close>
        <d.Close data-variant="solid" @value="confirm">Leave</d.Close>
      </div>
    </d.Content>
  </AlertDialog>
</template>
