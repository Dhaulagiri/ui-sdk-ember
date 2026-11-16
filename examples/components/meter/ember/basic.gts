import { Meter } from "ember-ui-sdk/meter"

<template>
  <Meter @value={{68}} as |m|>
    <m.Label>Storage used</m.Label>
    <m.Value />
    <m.Track>
      <m.Indicator />
    </m.Track>
  </Meter>
</template>
