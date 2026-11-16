import { ChevronLeft, ChevronRight, Calendar, X } from "lucide"
import { DatePicker } from "ember-ui-sdk/date-picker"
import { icon } from "../../../shared/ember/icon"

const unavailable = [{ weekday: [0, 6] }]

<template>
  <DatePicker
    @min="2026-10-05"
    @max="2026-11-20"
    @unavailable={{unavailable}}
    @defaultValue="2026-10-16"
    as |dp|
  >
    <div data-slot="row">
      <dp.Input aria-label="Delivery date" />
      <dp.Trigger data-variant="ghost">{{icon Calendar}}</dp.Trigger>
    </div>
    <dp.Hint />
    <dp.Content>
      <div data-slot="row">
        <dp.Previous data-variant="ghost">{{icon ChevronLeft}}</dp.Previous>
        <dp.Heading />
        <dp.Next data-variant="ghost">{{icon ChevronRight}}</dp.Next>
      </div>
      <dp.Grid />
    </dp.Content>
  </DatePicker>
</template>
