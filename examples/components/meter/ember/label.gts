import { Meter } from "ember-ui-sdk/meter"

<template>
  <Meter @value={{42}} as |m|>
    <m.Label>Battery</m.Label>
    <m.Value />
    <m.Track>
      <m.Indicator />
    </m.Track>
  </Meter>
</template>
