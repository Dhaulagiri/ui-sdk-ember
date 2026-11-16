import { Button } from "ember-ui-sdk/button"

<template>
  <div data-slot="row">
    <Button @render={{true}} as |b|>
      <a {{b.part}} href="#installation">Get Started</a>
    </Button>
    <Button @disabled={{true}} @render={{true}} as |b|>
      <a {{b.part}} href="#changelog">Changelog</a>
    </Button>
  </div>
</template>
