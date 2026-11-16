import { array } from "@ember/helper"
import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"

const thumbs = ["Low", "Medium", "High"]
const percent = { style: "unit", unit: "percent" } as const

<template>
  <Field as |f|>
    <Slider
      @defaultValue={{array 10 20 70}}
      @step={{10}}
      @format={{percent}}
      @field={{f.field}}
      as |s|
    >
      <div data-slot="row">
        <f.Label>Alert thresholds</f.Label>
        <s.Value />
      </div>
      <s.Control>
        <s.Track>
          <s.Indicator />
          {{#each thumbs as |label index|}}
            <s.Thumb @index={{index}} aria-label={{label}} />
          {{/each}}
        </s.Track>
      </s.Control>
    </Slider>
  </Field>
</template>
