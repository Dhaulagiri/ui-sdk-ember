import { Folder, Search, Settings } from "lucide"
import { Resizable } from "ember-ui-sdk/resizable"
import { icon } from "../../../shared/ember/icon"

<template>
  <Resizable as |r|>
    <r.Panel
      @defaultSize={{30}}
      @minSize={{25}}
      @collapsible={{true}}
      @collapsedSize="48px"
    >
      <ul>
        <li data-slot="row">
          {{icon Folder}}
          <span>Files</span>
        </li>
        <li data-slot="row">
          {{icon Search}}
          <span>Search</span>
        </li>
        <li data-slot="row">
          {{icon Settings}}
          <span>Settings</span>
        </li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize sidebar">
      <div></div>
    </r.Handle>
    <r.Panel @minSize={{40}}>
      <h3>README.md</h3>
      <span data-slot="hint">Edited by Inès Moreau</span>
    </r.Panel>
  </Resizable>
</template>
