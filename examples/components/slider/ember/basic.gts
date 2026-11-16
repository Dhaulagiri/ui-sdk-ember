import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"

<template>
  <Field as |f|>
    <Slider @defaultValue={{75}} @field={{f.field}} as |s|>
      <div data-slot="row">
        <f.Label>Volume</f.Label>
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
