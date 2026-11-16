import { Toggle } from "ember-ui-sdk/toggle"
import { Star } from "lucide"
import { icon } from "../../../shared/ember/icon"

<template>
  <div data-slot="card">
    <div data-slot="stack">
      <h3>Q3 Roadmap</h3>
      <p data-slot="hint">Edited by Hollis Grant</p>
    </div>
    <Toggle aria-label="Star" as |t|>
      <t.Icon data-variant="fill">{{icon Star}}</t.Icon>
    </Toggle>
  </div>
</template>
