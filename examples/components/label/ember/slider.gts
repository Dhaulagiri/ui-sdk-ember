import { Label } from "ember-ui-sdk/label"
import { Slider } from "ember-ui-sdk/slider"

<template>
  <Slider id="volume" @defaultValue={{75}} as |s|>
    <div data-slot="row">
      <Label for="volume">Volume</Label>
      <s.Value />
    </div>
    <s.Control>
      <s.Track>
        <s.Indicator />
        <s.Thumb />
      </s.Track>
    </s.Control>
  </Slider>
</template>
