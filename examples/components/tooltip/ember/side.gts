import { Tooltip } from "ember-ui-sdk/tooltip"

const sides = [
  { side: "top", label: "Top" },
  { side: "left", label: "Left" },
  { side: "right", label: "Right" },
  { side: "bottom", label: "Bottom" },
]

<template>
  <div data-slot="grid">
    {{#each sides key="side" as |entry|}}
      <Tooltip as |t|>
        <t.Trigger>{{entry.label}}</t.Trigger>
        <t.Content @side={{entry.side}}>Add to library</t.Content>
      </Tooltip>
    {{/each}}
  </div>
</template>
