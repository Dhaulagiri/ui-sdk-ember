import { Tooltip } from "ember-ui-sdk/tooltip"

<template>
  <Tooltip as |t|>
    <t.Trigger @render={{true}} as |tr|>
      <a
        {{tr.part}}
        href="https://example.com/changelog"
        data-variant="link"
      >Changelog</a>
    </t.Trigger>
    <t.Content>See what's new in 2.0</t.Content>
  </Tooltip>
</template>
