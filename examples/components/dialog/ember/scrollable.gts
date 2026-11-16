import { Dialog } from "ember-ui-sdk/dialog"

const paragraphs = [
  "These terms govern your use of the service. By creating an account, you agree to them and to the privacy policy that explains how we handle your data.",
  "You're responsible for the content you upload and for keeping your password safe. Tell us right away if you think someone else has used your account.",
  "We may change the service, and these terms, as the product grows. When a change affects you, we'll let you know by email at least 30 days before it takes effect.",
  "You can stop using the service at any time. We'll keep your data for 30 days after you close your account, so you can export it, and then delete it.",
  "The service is provided as is. To the extent the law allows, we aren't liable for indirect damages, lost profits or lost data.",
  "If you have questions about these terms, write to us. We read every message and reply within two working days.",
]

<template>
  <Dialog as |d|>
    <d.Trigger>Scrollable Content</d.Trigger>
    <d.Backdrop />
    <d.Content @initialFocus="content">
      <div data-slot="stack">
        <d.Title>Terms of service</d.Title>
        <d.Description>Please read before you continue.</d.Description>
      </div>
      <div data-slot="scroll">
        {{#each paragraphs key="@identity" as |paragraph|}}
          <p>{{paragraph}}</p>
        {{/each}}
      </div>
      <div data-slot="row">
        <d.Close>Decline</d.Close>
        <d.Close data-variant="solid" @value="accept">Accept</d.Close>
      </div>
    </d.Content>
  </Dialog>
</template>
