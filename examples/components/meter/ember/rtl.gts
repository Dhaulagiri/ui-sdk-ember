import { Meter } from "ember-ui-sdk/meter"

<template>
  <div dir="rtl">
    <Meter @value={{68}} @locale="ar-EG" as |m|>
      <m.Label>مساحة التخزين</m.Label>
      <m.Value />
      <m.Track>
        <m.Indicator />
      </m.Track>
    </Meter>
  </div>
</template>
