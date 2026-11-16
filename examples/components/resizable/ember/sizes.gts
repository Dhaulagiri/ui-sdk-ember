import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable as |r|>
    <r.Panel @defaultSize="200px" @minSize="160px" @maxSize="320px">
      <h3>Docs</h3>
      <ul>
        <li>Getting Started</li>
        <li>Components</li>
        <li>Guides</li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize navigation">
      <div></div>
    </r.Handle>
    <r.Panel @minSize={{30}}>
      <h3>Getting Started</h3>
      <span data-slot="hint">Install the packages</span>
    </r.Panel>
  </Resizable>
</template>
