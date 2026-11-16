import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"

const channels = [
  { label: "Bass", value: 50 },
  { label: "Treble", value: 25 },
]

<template>
  <div data-slot="row">
    {{#each channels key="label" as |channel|}}
      <Field as |f|>
        <Slider
          @orientation="vertical"
          @defaultValue={{channel.value}}
          @field={{f.field}}
          as |s|
        >
          <s.Control>
            <s.Track>
              <s.Indicator />
              <s.Thumb />
            </s.Track>
          </s.Control>
        </Slider>
        <f.Label>{{channel.label}}</f.Label>
      </Field>
    {{/each}}
  </div>
</template>
