import { Meter } from "ember-ui-sdk/meter"

const decimal = { style: "decimal" } as const

<template>
  <Meter @value={{720}} @min={{300}} @max={{850}} @format={{decimal}} as |m|>
    <m.Label>Credit score</m.Label>
    <m.Value />
    <m.Track>
      <m.Indicator />
    </m.Track>
  </Meter>
</template>
