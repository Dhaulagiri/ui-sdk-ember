import { ColorPicker } from "ember-ui-sdk/color-picker"
import { Popover } from "ember-ui-sdk/popover"

<template>
  <ColorPicker aria-label="Background" @defaultValue="#22c55e" as |c|>
    <Popover as |p|>
      <p.Trigger aria-label="Background">
        <c.Swatch />
      </p.Trigger>
      <p.Content>
        <c.Area as |a|>
          <a.Thumb />
        </c.Area>
        <c.Slider @channel="hue" as |s|>
          <s.Thumb />
        </c.Slider>
        <c.Input aria-label="Hex" />
      </p.Content>
    </Popover>
  </ColorPicker>
</template>
