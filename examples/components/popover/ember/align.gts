import { Popover } from "ember-ui-sdk/popover"

const aligns = [
  { value: "start", label: "Start" },
  { value: "center", label: "Center" },
  { value: "end", label: "End" },
] as const

<template>
  <div data-slot="row">
    {{#each aligns key="value" as |align|}}
      <Popover as |p|>
        <p.Trigger>{{align.label}}</p.Trigger>
        <p.Content @align={{align.value}} @sideOffset={{8}}>
          <p.Title>Delivery window</p.Title>
          <p.Description>Arrives Tuesday between 9 AM and noon.</p.Description>
        </p.Content>
      </Popover>
    {{/each}}
  </div>
</template>
