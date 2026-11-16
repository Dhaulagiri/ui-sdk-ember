import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"

const percent = { style: "unit", unit: "percent" } as const

<template>
  <Field as |f|>
    <Slider
      @defaultValue={{100}}
      @min={{25}}
      @max={{400}}
      @largeStep={{25}}
      @format={{percent}}
      @field={{f.field}}
      as |s|
    >
      <div data-slot="row">
        <f.Label>Zoom</f.Label>
        <s.Value />
      </div>
      <s.Control>
        <s.Track>
          <s.Indicator />
          <s.Thumb />
        </s.Track>
      </s.Control>
    </Slider>
  </Field>
</template>
