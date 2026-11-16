import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable @step={{5}} @largeStep={{25}} as |r|>
    <r.Panel @defaultSize={{50}} @minSize={{20}}>
      <h3>Original</h3>
      <span data-slot="hint">v1.2.0</span>
    </r.Panel>
    <r.Handle aria-label="Resize original" />
    <r.Panel @defaultSize={{50}} @minSize={{20}}>
      <h3>Changes</h3>
      <span data-slot="hint">v1.3.0</span>
    </r.Panel>
  </Resizable>
</template>
