import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"

const percent = { style: "percent" } as const

<template>
  <Field as |f|>
    <Slider
      @defaultValue={{0.3}}
      @format={{percent}}
      @min={{0}}
      @max={{1}}
      @step={{0.01}}
      @field={{f.field}}
      as |s|
    >
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
    <f.Description>How loud notifications play.</f.Description>
  </Field>
</template>
