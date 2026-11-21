import { Dialog } from "ember-ui-sdk/dialog"

<template>
  <div data-slot="dialog-frame">
    <Dialog @modal="trap-focus" @closeOnOutsidePress={{false}} as |d|>
      <d.Trigger>Delete Draft</d.Trigger>
      <d.Backdrop />
      <d.Content @inline={{true}}>
        <div data-slot="stack">
          <d.Title>Delete this draft?</d.Title>
          <d.Description>The preview keeps its dialog inside the frame.</d.Description>
        </div>
        <div data-slot="row">
          <d.Close>Cancel</d.Close>
          <d.Close data-variant="destructive">Delete</d.Close>
        </div>
      </d.Content>
    </Dialog>
  </div>
</template>
