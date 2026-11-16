import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"

<template>
  <Calendar
    @months={{2}}
    @pageBy="page"
    @defaultValue="2026-10-16"
    @weekdayFormat="narrow"
    @monthFormat="short"
    as |c|
  >
    <div data-slot="row">
      <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
      <c.Heading />
      <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
    </div>
    <div data-slot="row">
      <c.Grid @offset={{0}} />
      <c.Grid @offset={{1}} />
    </div>
  </Calendar>
</template>
