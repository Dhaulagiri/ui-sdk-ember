import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"

<template>
  <Calendar
    @defaultValue="2026-10-16"
    @min="2026-10-05"
    @max="2026-11-20"
    as |c|
  >
    <div data-slot="row">
      <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
      <c.Heading />
      <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
    </div>
    <c.Grid />
  </Calendar>
</template>
