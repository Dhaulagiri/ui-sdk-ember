import { array } from "@ember/helper"
import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable @defaultLayout={{array 25 35 40}} as |r|>
    <r.Panel @minSize={{15}}>
      <h3>Mail</h3>
      <ul>
        <li>Inbox</li>
        <li>Drafts</li>
        <li>Sent</li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize folders" />
    <r.Panel @minSize={{15}}>
      <h3>Inbox</h3>
      <ul>
        <li>Hollis Grant</li>
        <li>Inès Moreau</li>
        <li>Kofi Mensah</li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize inbox" />
    <r.Panel @minSize={{15}}>
      <h3>Quarterly report</h3>
      <span data-slot="hint">From Hollis Grant</span>
    </r.Panel>
  </Resizable>
</template>
