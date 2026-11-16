import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"

const unavailable = [
  "2026-10-08",
  { from: "2026-10-20", to: "2026-10-23" },
  { weekday: [0, 6] },
]

<template>
  <Calendar @unavailable={{unavailable}} as |c|>
    <div data-slot="row">
      <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
      <c.Heading />
      <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
    </div>
    <c.Grid />
  </Calendar>
</template>
