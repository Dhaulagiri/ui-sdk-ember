import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"

const priceOf = (date: string) => 80 + ((Number(date.slice(8)) * 7) % 5) * 10

const priceShown = (state: { outside: boolean; disabled: boolean }) =>
  !state.outside && !state.disabled

const isWeekend = (weekday: number) =>
  weekday === 0 || weekday === 6 ? true : undefined

<template>
  <Calendar @today="2026-10-16" @defaultValue="2026-10-16" as |c|>
    <div data-slot="row">
      <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
      <c.Heading />
      <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
    </div>
    <c.Grid as |grid|>
      <grid.Weekdays as |Weekday|>
        <Weekday as |wd|>
          <abbr
            title={{wd.state.name}}
            data-weekend={{isWeekend wd.state.weekday}}
          >
            {{wd.state.label}}
          </abbr>
        </Weekday>
      </grid.Weekdays>
      <grid.Weeks as |week|>
        <week.Day as |d|>
          <span data-slot="stack">
            <span>
              {{d.state.label}}
            </span>
            {{#if (priceShown d.state)}}
              <span data-slot="hint">
                ${{priceOf d.state.date}}
              </span>
            {{/if}}
          </span>
        </week.Day>
      </grid.Weeks>
    </c.Grid>
  </Calendar>
</template>
