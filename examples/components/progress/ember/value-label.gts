import { Progress } from "ember-ui-sdk/progress"

const valueLabel = (
  value: number | null,
  details: { max: number; formatted: string }
) => `${value} of ${details.max} files, ${details.formatted}`

<template>
  <Progress @value={{3}} @max={{12}} @getValueLabel={{valueLabel}} as |p|>
    <p.Label>Copying files</p.Label>
    <p.Value>3 of 12</p.Value>
    <p.Track>
      <p.Indicator />
    </p.Track>
  </Progress>
</template>
