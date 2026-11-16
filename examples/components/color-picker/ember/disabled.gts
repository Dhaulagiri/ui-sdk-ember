import { ColorPicker } from "ember-ui-sdk/color-picker"

<template>
  <ColorPicker
    aria-label="Brand color"
    @defaultValue="#0ea5e9"
    @disabled={{true}}
    as |c|
  >
    <c.Area as |a|>
      <a.Thumb />
    </c.Area>
    <c.Slider @channel="hue" as |s|>
      <s.Thumb />
    </c.Slider>
    <c.Input aria-label="Hex" />
  </ColorPicker>
</template>
