import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"

const years = { useGrouping: false } as const
const nine = Array.from({ length: 9 }, (_, index) => index)
const twentyOne = Array.from({ length: 21 }, (_, index) => index)

<template>
  <div data-slot="stack">
    <Field as |f|>
      <Slider
        @defaultValue={{2010}}
        @min={{1990}}
        @max={{2030}}
        @step={{5}}
        @format={{years}}
        @field={{f.field}}
        as |s|
      >
        <div data-slot="row">
          <f.Label>Year</f.Label>
          <s.Value />
        </div>
        <s.Control>
          <s.Track>
            <s.Indicator />
            <s.Thumb />
          </s.Track>
        </s.Control>
        <div data-slot="ticks" aria-hidden="true">
          {{#each nine as |tick|}}
            <span></span>
          {{/each}}
        </div>
      </Slider>
    </Field>
    <Field as |f|>
      <Slider
        @defaultValue={{0.5}}
        @min={{0}}
        @max={{1}}
        @step={{0.05}}
        @field={{f.field}}
        as |s|
      >
        <div data-slot="row">
          <f.Label>Opacity</f.Label>
          <s.Value />
        </div>
        <s.Control>
          <s.Track>
            <s.Indicator />
            <s.Thumb />
          </s.Track>
        </s.Control>
        <div data-slot="ticks" aria-hidden="true">
          {{#each twentyOne as |tick|}}
            <span></span>
          {{/each}}
        </div>
      </Slider>
    </Field>
  </div>
</template>
