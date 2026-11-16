import { Separator } from "ember-ui-sdk/separator"

<template>
  <div data-slot="stack">
    <button type="button" data-variant="solid">Sign In with Passkey</button>
    <div data-slot="row">
      <Separator @decorative={{true}} />
      <span>or</span>
      <Separator @decorative={{true}} />
    </div>
    <button type="button">Email Me a Link</button>
  </div>
</template>
