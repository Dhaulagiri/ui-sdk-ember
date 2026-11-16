import { array } from "@ember/helper"
import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"

const currency = {
  style: "currency",
  currency: "USD",
  maximumFractionDigits: 0,
} as const

<template>
  <Field as |f|>
    <Slider
      @defaultValue={{array 25 50}}
      @step={{5}}
      @format={{currency}}
      @field={{f.field}}
      as |s|
    >
      <div data-slot="row">
        <f.Label>Price</f.Label>
        <s.Value />
      </div>
      <s.Control>
        <s.Track>
          <s.Indicator />
          <s.Thumb @index={{0}} aria-label="Minimum price" />
          <s.Thumb @index={{1}} aria-label="Maximum price" />
        </s.Track>
      </s.Control>
    </Slider>
  </Field>
</template>
