import { array } from "@ember/helper"
import { Field } from "ember-ui-sdk/field"
import { Slider } from "ember-ui-sdk/slider"

const time = (minutes: number) =>
  `${Math.floor(minutes / 60)}:${String(minutes % 60).padStart(2, "0")}`

<template>
  <Field as |f|>
    <Slider
      @defaultValue={{array 540 1020}}
      @min={{0}}
      @max={{1440}}
      @step={{15}}
      @minStepsBetweenThumbs={{16}}
      @format={{time}}
      @field={{f.field}}
      as |s|
    >
      <div data-slot="row">
        <f.Label>Opening hours</f.Label>
        <s.Value />
      </div>
      <s.Control>
        <s.Track>
          <s.Indicator />
          <s.Thumb @index={{0}} aria-label="Opens" />
          <s.Thumb @index={{1}} aria-label="Closes" />
        </s.Track>
      </s.Control>
    </Slider>
  </Field>
</template>
