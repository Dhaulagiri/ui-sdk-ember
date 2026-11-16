import { Tooltip } from "ember-ui-sdk/tooltip"

const sides = [
  { side: "right", label: "يمين" },
  { side: "top", label: "أعلى" },
  { side: "bottom", label: "أسفل" },
  { side: "left", label: "يسار" },
]

<template>
  <div dir="rtl" data-slot="row">
    {{#each sides key="side" as |entry|}}
      <Tooltip as |t|>
        <t.Trigger>{{entry.label}}</t.Trigger>
        <t.Content @side={{entry.side}} @align="start" @sideOffset={{8}}>
          <t.Arrow />
          أضف إلى المكتبة
        </t.Content>
      </Tooltip>
    {{/each}}
  </div>
</template>
