import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable @autoSaveId="docs-persistence" as |r|>
    <r.Panel @id="docs-sidebar" @defaultSize={{30}} @minSize={{20}}>
      <h3>Outline</h3>
      <ul>
        <li>Introduction</li>
        <li>Installation</li>
        <li>Usage</li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize outline">
      <div></div>
    </r.Handle>
    <r.Panel @id="docs-content" @minSize={{30}}>
      <h3>Introduction</h3>
      <span data-slot="hint">Last edited by Wren Takahashi</span>
    </r.Panel>
  </Resizable>
</template>
