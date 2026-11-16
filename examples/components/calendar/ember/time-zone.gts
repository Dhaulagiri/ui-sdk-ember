import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"

<template>
  <div>
    <Calendar @timeZone="Pacific/Kiritimati" as |c|>
      <div data-slot="row">
        <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
        <c.Heading />
        <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
      </div>
      <c.Grid />
    </Calendar>
    <p data-slot="hint">
      Today is marked as it is in Kiritimati, the first place to see each new
      day.
    </p>
  </div>
</template>
