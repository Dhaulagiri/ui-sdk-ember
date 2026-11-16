import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable @orientation="vertical" as |r|>
    <r.Panel @defaultSize={{45}} @minSize={{25}}>
      <h3>Inbox</h3>
      <span data-slot="hint">3 unread messages</span>
    </r.Panel>
    <r.Handle aria-label="Resize inbox" />
    <r.Panel @defaultSize={{55}} @minSize={{25}}>
      <h3>Quarterly report</h3>
      <span data-slot="hint">From Hollis Grant</span>
    </r.Panel>
  </Resizable>
</template>
