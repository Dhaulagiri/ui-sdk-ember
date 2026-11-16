import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"

<template>
  <Calendar
    @fixedWeeks={{true}}
    @showOutsideDays={{false}}
    @defaultMonth="2026-02"
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
