import { Progress } from "ember-ui-sdk/progress"

<template>
  <Progress @value={{3}} @min={{1}} @max={{5}} as |p|>
    <p.Label>Account setup, step 3 of 5</p.Label>
    <p.Value />
    <p.Track>
      <p.Indicator />
    </p.Track>
  </Progress>
</template>
