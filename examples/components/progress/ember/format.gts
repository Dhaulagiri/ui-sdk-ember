import { Progress } from "ember-ui-sdk/progress"

const bars = [
  {
    label: "Download",
    value: 120,
    max: 250,
    format: { style: "unit" as const, unit: "gigabyte" },
  },
  {
    label: "Video render",
    value: 87.25,
    format: { style: "percent" as const, maximumFractionDigits: 1 },
  },
  {
    label: "Backup",
    value: 45,
    max: 60,
    format: (minutes: number) => `${60 - minutes} min left`,
  },
  { label: "Synchronisierung", value: 40, locale: "de-DE" },
]

<template>
  <div data-slot="stack">
    {{#each bars key="label" as |item|}}
      <Progress
        @value={{item.value}}
        @max={{item.max}}
        @format={{item.format}}
        @locale={{item.locale}}
        as |p|
      >
        <p.Label>{{item.label}}</p.Label>
        <p.Value />
        <p.Track>
          <p.Indicator />
        </p.Track>
      </Progress>
    {{/each}}
  </div>
</template>
