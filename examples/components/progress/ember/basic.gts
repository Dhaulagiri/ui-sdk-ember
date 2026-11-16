import { Progress } from "ember-ui-sdk/progress"

<template>
  <Progress @value={{60}} as |p|>
    <p.Label>Exporting video</p.Label>
    <p.Value />
    <p.Track>
      <p.Indicator />
    </p.Track>
  </Progress>
</template>
