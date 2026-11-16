import { array } from "@ember/helper"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"

<template>
  <Calendar
    @mode="range"
    @months={{2}}
    @monthFormat="short"
    @defaultValue={{array "2026-10-12" "2026-10-16"}}
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
