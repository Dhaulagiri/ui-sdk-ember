import { Progress } from "ember-ui-sdk/progress"

<template>
  <Progress @value={{null}} as |p|>
    <p.Label>Connecting to server</p.Label>
    <p.Track>
      <p.Indicator />
    </p.Track>
  </Progress>
</template>
