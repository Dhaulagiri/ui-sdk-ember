import { Pipette } from "lucide"
import { ColorPicker } from "ember-ui-sdk/color-picker"
import { icon } from "../../../shared/ember/icon"

const presets = [
  "#ef4444",
  "#f97316",
  "#eab308",
  "#22c55e",
  "#0ea5e9",
  "#6366f1",
  "#a855f7",
  "#ec4899",
]

<template>
  <ColorPicker
    aria-label="Label color"
    @space="srgb"
    @format="hex"
    @defaultValue="#0ea5e9"
    as |c|
  >
    <c.Swatches aria-label="Presets">
      {{#each presets key="@identity" as |preset|}}
        <c.SwatchItem @value={{preset}} />
      {{/each}}
    </c.Swatches>
    <div data-slot="row">
      <c.ChannelInput @channel="red" />
      <c.ChannelInput @channel="green" />
      <c.ChannelInput @channel="blue" />
      <c.EyeDropper aria-label="Pick from screen">{{icon
          Pipette
        }}</c.EyeDropper>
    </div>
  </ColorPicker>
</template>
