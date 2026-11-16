import { ChevronLeft, ChevronRight, Calendar, X } from "lucide"
import { DatePicker } from "ember-ui-sdk/date-picker"
import { icon } from "../../../shared/ember/icon"

<template>
  <DatePicker @defaultValue="2026-10-16" as |dp|>
    <div data-slot="row">
      <dp.Input aria-label="Due date" />
      <dp.Trigger data-variant="ghost">{{icon Calendar}}</dp.Trigger>
    </div>
    <dp.Content>
      <div data-slot="row">
        <dp.Previous data-variant="ghost">{{icon ChevronLeft}}</dp.Previous>
        <dp.Heading />
        <dp.Next data-variant="ghost">{{icon ChevronRight}}</dp.Next>
      </div>
      <dp.Grid />
    </dp.Content>
    <dp.Hint as |h|>Like {{h.state.example}}</dp.Hint>
  </DatePicker>
</template>
