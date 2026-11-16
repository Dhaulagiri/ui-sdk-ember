import { Meter } from "ember-ui-sdk/meter"

const meters = [
  {
    label: "Storage",
    value: 120,
    max: 250,
    format: { style: "unit" as const, unit: "gigabyte" },
  },
  {
    label: "Budget",
    value: 1840,
    max: 2500,
    format: {
      style: "currency" as const,
      currency: "USD",
      maximumFractionDigits: 0,
    },
  },
  {
    label: "Seats",
    value: 18,
    max: 25,
    format: (seats: number) => `${seats} of 25 seats`,
  },
  { label: "Auslastung", value: 40, locale: "de-DE" },
]

<template>
  <div data-slot="stack">
    {{#each meters key="label" as |item|}}
      <Meter
        @value={{item.value}}
        @max={{item.max}}
        @format={{item.format}}
        @locale={{item.locale}}
        as |m|
      >
        <m.Label>{{item.label}}</m.Label>
        <m.Value />
        <m.Track>
          <m.Indicator />
        </m.Track>
      </Meter>
    {{/each}}
  </div>
</template>
