import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"

const sliders = [
  {
    label: "Budget",
    defaultValue: 40,
    max: 100,
    step: 1,
    format: { style: "currency", currency: "USD", maximumFractionDigits: 0 },
  },
  {
    label: "Opacity",
    defaultValue: 0.6,
    max: 1,
    step: 0.01,
    format: { style: "percent" },
  },
  {
    label: "Weight",
    defaultValue: 20,
    max: 50,
    step: 0.5,
    format: { style: "unit", unit: "kilogram" },
  },
  {
    label: "Duration",
    defaultValue: 90,
    max: 600,
    step: 15,
    format: (seconds: number) =>
      `${Math.floor(seconds / 60)} min ${seconds % 60} s`,
  },
  {
    label: "Preis",
    defaultValue: 40,
    max: 100,
    step: 1,
    format: { style: "currency", currency: "EUR" },
    locale: "de-DE",
  },
]

<template>
  <div data-slot="stack">
    {{#each sliders key="label" as |slider|}}
      <Field as |f|>
        <Slider
          @defaultValue={{slider.defaultValue}}
          @max={{slider.max}}
          @step={{slider.step}}
          @format={{slider.format}}
          @locale={{slider.locale}}
          @field={{f.field}}
          as |s|
        >
          <div data-slot="row">
            <f.Label>{{slider.label}}</f.Label>
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
    {{/each}}
  </div>
</template>
