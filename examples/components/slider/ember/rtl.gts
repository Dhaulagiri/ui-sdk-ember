import { array } from "@ember/helper"
import { Slider } from "ember-ui-sdk/slider"

<template>
  <div dir="rtl" data-slot="stack">
    <Slider
      @defaultValue={{array 20 60}}
      @locale="ar-EG"
      aria-label="نطاق السعر"
      as |s|
    >
      <div data-slot="row">
        <span data-slot="label">نطاق السعر</span>
        <s.Value />
      </div>
      <s.Control>
        <s.Track>
          <s.Indicator />
          <s.Thumb @index={{0}} aria-label="الحد الأدنى" />
          <s.Thumb @index={{1}} aria-label="الحد الأقصى" />
        </s.Track>
      </s.Control>
    </Slider>
  </div>
</template>
