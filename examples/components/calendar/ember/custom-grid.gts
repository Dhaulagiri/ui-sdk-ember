import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar, CalendarDay, CalendarWeekday } from "ember-ui-sdk/calendar"
import { icon } from "../../../shared/ember/icon"

function isoWeek(date: string) {
  const day = new Date(`${date}T00:00:00Z`)
  day.setUTCDate(day.getUTCDate() + 3 - ((day.getUTCDay() + 6) % 7))
  const firstThursday = new Date(Date.UTC(day.getUTCFullYear(), 0, 4))
  const days = (day.getTime() - firstThursday.getTime()) / 86400000
  return 1 + Math.round((days - 3 + ((firstThursday.getUTCDay() + 6) % 7)) / 7)
}

const weekNumber = (week: { date: string }[]) => isoWeek(week[0].date)

<template>
  <Calendar @defaultValue="2026-10-16" @weekStartsOn={{1}} as |c|>
    <div data-slot="row">
      <c.Previous data-variant="ghost" @render={{true}} as |p|>
        <button {{p.part}} title="Show {{p.state.month}}">{{icon
            ChevronLeft
          }}</button>
      </c.Previous>
      <c.Heading />
      <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
    </div>
    <c.Grid as |grid|>
      <thead>
        <tr>
          <th scope="col">
            <abbr title="Week">Wk</abbr>
          </th>
          {{#each grid.state.weekdays key="@index" as |weekday index|}}
            <CalendarWeekday @handle={{c.handle}} @index={{index}} />
          {{/each}}
        </tr>
      </thead>
      <tbody>
        {{#each grid.state.weeks key="@index" as |week|}}
          <tr>
            <th scope="row" data-slot="hint">{{weekNumber week}}</th>
            {{#each week key="date" as |cell|}}
              {{#if cell.hidden}}
                <td></td>
              {{else}}
                <CalendarDay @handle={{c.handle}} @value={{cell.date}} />
              {{/if}}
            {{/each}}
          </tr>
        {{/each}}
      </tbody>
    </c.Grid>
  </Calendar>
</template>
