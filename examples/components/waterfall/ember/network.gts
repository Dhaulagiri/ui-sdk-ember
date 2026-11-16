import { Waterfall } from "ember-ui-sdk/waterfall"

const requests = [
  { value: "document", label: "/", start: 0, duration: 182 },
  { value: "styles", label: "app.css", start: 190, duration: 96 },
  { value: "script", label: "app.js", start: 192, duration: 410 },
  { value: "font", label: "inter.woff2", start: 300, duration: 220 },
  { value: "user", label: "api/user", start: 610, duration: 240 },
  { value: "avatar", label: "avatar.png", start: 860, duration: 150 },
]

const sizes: Record<string, string> = {
  document: "14 kB",
  styles: "8 kB",
  script: "212 kB",
  font: "48 kB",
  user: "1 kB",
  avatar: "36 kB",
}

const barLabel = (
  request: { value: string },
  { start, duration }: { start: string; duration: string }
) => `${sizes[request.value]}, starts at ${start}, takes ${duration}`

const sizeOf = (value: string) => sizes[value]

<template>
  <Waterfall
    aria-label="Network requests"
    @items={{requests}}
    @getBarLabel={{barLabel}}
    as |w|
  >
    <w.HeaderRow>
      <w.ColumnHeader>Name</w.ColumnHeader>
      <w.ColumnHeader>Size</w.ColumnHeader>
      <w.ColumnHeader aria-label="Timeline">
        <w.Axis @maxTicks={{5}} />
        <w.Mark @time={{620}}>DOMContentLoaded</w.Mark>
      </w.ColumnHeader>
    </w.HeaderRow>
    {{#each requests key="value" as |request|}}
      <w.Row @value={{request.value}} as |row|>
        <row.Header>{{request.label}}</row.Header>
        <row.Cell>{{sizeOf request.value}}</row.Cell>
        <row.Bar />
      </w.Row>
    {{/each}}
  </Waterfall>
</template>
