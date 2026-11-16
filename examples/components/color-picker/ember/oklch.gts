import { ColorPicker } from "ember-ui-sdk/color-picker"

<template>
  <ColorPicker
    aria-label="Accent"
    @space="oklch"
    @defaultValue="oklch(0.62 0.19 259)"
    as |c|
  >
    <c.Area as |a|>
      <a.Canvas />
      <a.Thumb />
    </c.Area>
    <c.Slider @channel="hue" as |s|>
      <s.Thumb />
    </c.Slider>
    <c.Slider @channel="alpha" as |s|>
      <s.Thumb />
    </c.Slider>
    <div data-slot="row">
      <c.Swatch />
      <c.Input aria-label="OKLCH" />
    </div>
  </ColorPicker>
</template>
