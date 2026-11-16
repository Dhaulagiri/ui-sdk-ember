import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable as |r|>
    <r.Panel @defaultSize={{35}} @minSize={{20}}>
      <h3>Files</h3>
      <ul>
        <li>page.tsx</li>
        <li>layout.tsx</li>
        <li>globals.css</li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize files" />
    <r.Panel @defaultSize={{65}} @minSize={{40}}>
      <Resizable @orientation="vertical" as |r|>
        <r.Panel @defaultSize={{60}} @minSize={{30}}>
          <h3>page.tsx</h3>
          <span data-slot="hint">Saved just now</span>
        </r.Panel>
        <r.Handle aria-label="Resize editor" />
        <r.Panel @defaultSize={{40}} @minSize={{30}}>
          <h3>Terminal</h3>
          <span data-slot="hint">Ready on port 3000</span>
        </r.Panel>
      </Resizable>
    </r.Panel>
  </Resizable>
</template>
