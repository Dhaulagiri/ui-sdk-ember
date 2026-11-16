import { array } from "@ember/helper"
import { ChevronLeft, ChevronRight, Calendar, X } from "lucide"
import { DatePicker } from "ember-ui-sdk/date-picker"
import { icon } from "../../../shared/ember/icon"

<template>
  <DatePicker @mode="range" @today="2026-10-16" as |dp|>
    <div data-slot="row">
      <dp.Input aria-label="Check in" placeholder="Check in" />
      <span data-slot="hint">–</span>
      <dp.Input @end={{true}} aria-label="Check out" placeholder="Check out" />
      <dp.Trigger data-variant="ghost">{{icon Calendar}}</dp.Trigger>
    </div>
    <dp.Content>
      <div data-slot="row">
        <dp.Previous data-variant="ghost">{{icon ChevronLeft}}</dp.Previous>
        <dp.Heading />
        <dp.Next data-variant="ghost">{{icon ChevronRight}}</dp.Next>
      </div>
      <div data-slot="row">
        <dp.Preset
          data-variant="ghost"
          @value={{array "2026-10-10" "2026-10-16"}}
        >Last 7 Days</dp.Preset>
        <dp.Preset
          data-variant="ghost"
          @value={{array "2026-09-17" "2026-10-16"}}
        >Last 30 Days</dp.Preset>
        <dp.Preset
          data-variant="ghost"
          @value={{array "2026-10-01" "2026-10-31"}}
        >This Month</dp.Preset>
      </div>
      <dp.Grid />
    </dp.Content>
  </DatePicker>
</template>
