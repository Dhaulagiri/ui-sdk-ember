import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable as |r|>
    <r.Panel @defaultSize={{35}} @minSize={{20}}>
      <h3>Channels</h3>
      <ul>
        <li>general</li>
        <li>design</li>
        <li>releases</li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize channels">
      <div></div>
    </r.Handle>
    <r.Panel @defaultSize={{65}} @minSize={{20}}>
      <h3>general</h3>
      <span data-slot="hint">Kofi Mensah: The release notes are ready.</span>
    </r.Panel>
  </Resizable>
</template>
