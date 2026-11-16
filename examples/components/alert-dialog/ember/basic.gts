import { AlertDialog } from "ember-ui-sdk/alert-dialog"

<template>
  <AlertDialog as |d|>
    <d.Trigger>Delete Project</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="stack">
        <d.Title>Delete this project?</d.Title>
        <d.Description>
          This permanently deletes the project, its files and its deployment
          history for everyone on your team.
        </d.Description>
      </div>
      <div data-slot="row">
        <d.Close>Cancel</d.Close>
        <d.Close data-variant="solid" @value="confirm">Delete</d.Close>
      </div>
    </d.Content>
  </AlertDialog>
</template>
