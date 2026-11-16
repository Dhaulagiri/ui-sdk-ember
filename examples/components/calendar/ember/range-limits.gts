import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"

const unavailable = { from: "2026-10-17", to: "2026-10-18" }

<template>
  <Calendar
    @mode="range"
    @minDays={{3}}
    @maxDays={{8}}
    @unavailable={{unavailable}}
    @allowUnavailable={{true}}
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
