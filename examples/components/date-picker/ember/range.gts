import { array } from "@ember/helper"
import { ChevronLeft, ChevronRight, Calendar, X } from "lucide"
import { DatePicker } from "ember-ui-sdk/date-picker"
import { icon } from "../../../shared/ember/icon"

<template>
  <DatePicker
    @mode="range"
    @months={{2}}
    @monthFormat="short"
    @defaultValue={{array "2026-10-12" "2026-10-16"}}
    as |dp|
  >
    <div id="range-field" data-slot="row">
      <dp.Input aria-label="Check in" placeholder="Check in" />
      <span data-slot="hint">–</span>
      <dp.Input @end={{true}} aria-label="Check out" placeholder="Check out" />
      <dp.Trigger data-variant="ghost">{{icon Calendar}}</dp.Trigger>
    </div>
    <dp.Content @anchor="#range-field" @align="center">
      <div data-slot="row">
        <dp.Previous data-variant="ghost">{{icon ChevronLeft}}</dp.Previous>
        <dp.Heading />
        <dp.Next data-variant="ghost">{{icon ChevronRight}}</dp.Next>
      </div>
      <div data-slot="row">
        <dp.Grid @offset={{0}} />
        <dp.Grid @offset={{1}} />
      </div>
    </dp.Content>
  </DatePicker>
</template>
