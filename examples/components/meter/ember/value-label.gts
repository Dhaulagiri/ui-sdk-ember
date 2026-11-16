import { Meter } from "ember-ui-sdk/meter"

const valueLabel = (
  value: number,
  details: { max: number; formatted: string }
) => `${value} of ${details.max} requests, ${details.formatted}`

<template>
  <Meter @value={{750}} @max={{1000}} @getValueLabel={{valueLabel}} as |m|>
    <m.Label>API requests</m.Label>
    <m.Value>750 / 1,000</m.Value>
    <m.Track>
      <m.Indicator />
    </m.Track>
  </Meter>
</template>
