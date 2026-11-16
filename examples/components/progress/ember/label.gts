import { Progress } from "ember-ui-sdk/progress"

<template>
  <Progress @value={{56}} as |p|>
    <p.Label>Upload progress</p.Label>
    <p.Value />
    <p.Track>
      <p.Indicator />
    </p.Track>
  </Progress>
</template>
