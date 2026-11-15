# Calendar

Choose one date, several dates, or a range from a month grid.

Calendar shows dates directly on the page. Use it for a booking flow, a schedule, or any place where the dates should stay visible. For a text field that opens a calendar, use [Date Picker](./date-picker.md).

```glimmer-ts title="basic.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

<template>
  <Calendar @defaultValue="2026-10-16" as |c|>
    <div data-slot="row">
      <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
      <c.Heading />
      <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
    </div>
    <c.Grid />
  </Calendar>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose a date, then use Previous or Next to change the month. Arrow keys move through the days.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Calendar`:

```text
Calendar as |c|
├── c.Previous
├── c.Heading
├── c.Next
└── c.Grid
```

The heading names the displayed month. Previous and Next change it, and a grid holds its weekday headers and dates. An empty `c.Grid` renders the default headers and weeks. The `CalendarWeekday` and `CalendarDay` parts are also exported, so you can write the table yourself; see [Custom Rendering](#custom-rendering).

Each grid is named by its month and has the `grid` role.

## Usage

Import the root and use the parts it yields:

```gts
import { Calendar } from "ember-ui-sdk/calendar"

<template>
  <Calendar @defaultValue="2026-10-16" as |c|>
    <c.Previous>Previous</c.Previous>
    <c.Heading />
    <c.Next>Next</c.Next>
    <c.Grid />
  </Calendar>
</template>
```

## Values

Dates are ISO strings such as `"2026-10-16"`, with no time or time zone attached. No date library is needed. The date helpers in `@ui-sdk/core/date` handle arithmetic; `Intl` formats names and labels.

| Mode                 | Value                           |
| -------------------- | ------------------------------- |
| `"single"` (default) | A date string or `null`.        |
| `"multiple"`         | A sorted array of date strings. |
| `"range"`            | `[start, end]` or `null`.       |

A value with the wrong shape for its mode is treated as no selection.

## Range

`@mode="range"` chooses a start and then an end. Moving the pointer or focus previews the range; the value changes once both ends are chosen. A date before the start ends it too, and becomes the start. Escape cancels an unfinished range.

```glimmer-ts title="range.gts"
import { array } from "@ember/helper"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

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
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose a start date, then move to an end date to preview the range. Choose the end to finish, or press Escape to cancel the unfinished range.

## Multiple

`@mode="multiple"` toggles each date independently. Its value is a sorted array, even when dates were chosen in another order.

```glimmer-ts title="multiple.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

export default class Multiple extends Component {
  @tracked dates: string[] = ["2026-10-07", "2026-10-16", "2026-10-26"]

  onValueChange = (value: unknown) => {
    this.dates = value as string[]
  }

  <template>
    <div>
      <Calendar @mode="multiple" @value={{this.dates}} @onValueChange={{this.onValueChange}} as |c|>
        <div data-slot="row">
          <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
          <c.Heading />
          <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
        </div>
        <c.Grid />
      </Calendar>
    </div>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose another date to add it, or choose a selected date to remove it.

## Unavailable Dates

`@unavailable` accepts a date, `{ from, to }`, `{ weekday: [0, 6] }` for weekends, `{ before }`, `{ after }`, a predicate, or an array of these matchers. Weekday zero is Sunday.

Unavailable dates cannot be selected, but stay focusable so keyboard and screen reader users can discover them. They expose `aria-disabled` and `data-unavailable`.

```glimmer-ts title="unavailable.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

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
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Try an unavailable date, then choose an available one. Unavailable days remain focusable so their state can be heard.

## Deselect

`@deselectable={{true}}` lets a second press on the selected date clear it, in single mode. Without it, a second press keeps the date selected.

## Min and Max

`@min` and `@max` set the earliest and latest selectable dates. Dates outside those bounds cannot receive focus. Arrow keys stop at the bounds, and Previous and Next stop at their months.

```glimmer-ts title="min-max.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

<template>
  <Calendar @defaultValue="2026-10-16" @min="2026-10-05" @max="2026-11-20" as |c|>
    <div data-slot="row">
      <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
      <c.Heading />
      <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
    </div>
    <c.Grid />
  </Calendar>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Move toward either end of the allowed dates. Keyboard navigation and month buttons stop at the limits.

## Disabled and Read Only

`@disabled={{true}}` prevents focus, selection, and month navigation. `@readOnly={{true}}` allows navigation so dates can be inspected, but keeps the selected value unchanged.

```glimmer-ts title="disabled.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

<template>
  <Calendar @disabled={{true}} @defaultValue="2026-10-16" as |c|>
    <div data-slot="row">
      <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
      <c.Heading />
      <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
    </div>
    <c.Grid />
  </Calendar>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Try choosing a date or changing months. A disabled calendar has no available controls.

```glimmer-ts title="read-only.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

<template>
  <Calendar @readOnly={{true}} @defaultValue="2026-10-16" as |c|>
    <div data-slot="row">
      <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
      <c.Heading />
      <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
    </div>
    <c.Grid />
  </Calendar>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Move through dates and months. The selected value stays unchanged.

## Two Months

Set `@months={{2}}` and render grids with offsets `0` and `1`. Arrow keys move between the grids without turning the page. Dates that another visible month already shows leave an empty cell, so each date appears once.

`@pageBy="page"` makes Previous, Next, and navigation beyond the visible grids move by the full number of months.

```glimmer-ts title="two-months.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

<template>
  <Calendar @months={{2}} @pageBy="page" @monthFormat="short" @defaultValue="2026-10-16" as |c|>
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
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Move between October and November with arrow keys. Next advances both visible months to December and January.

## Fixed Weeks

`@fixedWeeks={{true}}` renders six week rows in every month. Set `@showOutsideDays={{false}}` to leave dates from neighboring months blank.

```glimmer-ts title="fixed-weeks.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

<template>
  <Calendar @fixedWeeks={{true}} @showOutsideDays={{false}} @defaultMonth="2026-02" as |c|>
    <div data-slot="row">
      <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
      <c.Heading />
      <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
    </div>
    <c.Grid />
  </Calendar>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Move from February to March. Both grids keep six week rows, and dates outside each month are hidden.

## Month and Year Selects

`CalendarMonthSelect` and `CalendarYearSelect` are native selects for jumping directly to a date, such as a birthday. The year options run from `@min` to `@max`, or ten years either side of the current year shown when bounds are missing. Months outside the bounds are disabled.

They update the first displayed month with the `select-change` reason. Their state exposes the options if you want to render a different select.

```glimmer-ts title="month-year-select.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

<template>
  <Calendar @defaultMonth="1990-06" @min="1920-01-01" @max="2026-10-16" as |c|>
    <div data-slot="row">
      <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
      <c.Heading />
      <div data-slot="row">
        <c.MonthSelect />
        <c.YearSelect />
      </div>
      <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
    </div>
    <c.Grid />
  </Calendar>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose a year and month to jump directly to a birthday, then choose the day.

## Custom Month and Year Selects

The month and year selects are native `select` elements. To use your own select, control the calendar's `@month` and drive it from your select's value, as with the [Select](./select.md) component. Keep a `c.Heading` in the calendar, visually hidden if you like, so the grid stays named.

```glimmer-ts title="custom-select.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown, ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { Select } from "ember-ui-sdk/select"
import { icon } from "./icon"

const months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
].map((label, index) => ({
  value: String(index + 1).padStart(2, "0"),
  label,
}))

const years = ["2024", "2025", "2026", "2027", "2028"].map((year) => ({
  value: year,
  label: year,
}))

export default class CustomSelect extends Component {
  months = months
  years = years
  @tracked month = "2026-10"

  get year() {
    return this.month.split("-")[0]
  }

  get monthOfYear() {
    return this.month.split("-")[1]
  }

  onMonthChange = (next: string | null) => {
    if (next) this.month = `${this.year}-${next}`
  }

  onYearChange = (next: string | null) => {
    if (next) this.month = `${next}-${this.monthOfYear}`
  }

  setMonth = (next: string) => {
    this.month = next
  }

  <template>
    <Calendar
      @month={{this.month}}
      @onMonthChange={{this.setMonth}}
      @defaultValue="2026-10-16"
      @min="2024-01-01"
      @max="2028-12-31"
      as |c|
    >
      <div data-slot="row">
        <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
        <c.Heading />
        <Select
          @items={{this.months}}
          @value={{this.monthOfYear}}
          @onValueChange={{this.onMonthChange}}
          as |s|
        >
          <s.Trigger aria-label="Month">
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.months key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <Select @items={{this.years}} @value={{this.year}} @onValueChange={{this.onYearChange}} as |s|>
          <s.Trigger aria-label="Year">
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.years key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
      </div>
      <c.Grid />
    </Calendar>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose a month or a year from the selects. The calendar follows, and the arrow keys still move between days.

## Language

`@locale` controls month names, weekday headers, and full date labels. If you omit it, Calendar reads the surrounding page’s `lang` after it mounts, with the browser’s language as a fallback. The initial server and client render use English, so they always match. The first weekday follows the locale, and so changes after mount too, unless `@weekStartsOn` sets it. `@weekdayFormat` accepts `"narrow"`, `"short"`, or `"long"`.

Previous and Next are named "Previous month" and "Next month". Pass `aria-label` to name them in another language. Dates remain Gregorian. Localized year systems, such as Buddhist or Japanese era years, can still appear in the labels.

```glimmer-ts title="locale.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

<template>
  <Calendar @locale="de-DE" @weekStartsOn={{1}} @weekdayFormat="narrow" @defaultValue="2026-10-16" as |c|>
    <div data-slot="row">
      <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
      <c.Heading />
      <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
    </div>
    <c.Grid />
  </Calendar>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Move through the calendar. Month names, weekday headers, and full date labels are in German, with Monday first.

## Name Formats

Set `@weekdayFormat` for the weekday headers and `@monthFormat` for the heading and the month select. Both take `"narrow"`, `"short"` or `"long"`, and follow the calendar's locale. Screen readers still hear full names: the grid and each day keep their long labels.

```glimmer-ts title="formats.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

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
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

The weekday headers are narrow and the heading uses short month names: Oct – Nov 2026.

## Custom Days

A day's block receives its state, including the date, label, selection, and whether it is outside the month. This example adds a price below each day. Weekday headers can have custom content too.

```glimmer-ts title="custom-day.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

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
          <abbr title={{wd.state.name}} data-weekend={{isWeekend wd.state.weekday}}>
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
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose a date to see its price selected with it. Dates outside the current month have no price.

## Range Limits

`@minDays` and `@maxDays` count both ends. A three-day range includes its start, the day between, and its end. A press that would break a limit keeps the start, so another end can be chosen. Until then, the dates that can't end the range are disabled.

A range cannot include an unavailable date unless `@allowUnavailable={{true}}` is set. That allows unavailable dates between the ends; they still cannot be chosen as an endpoint.

```glimmer-ts title="range-limits.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

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
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

In October 2026, choose October 15 then October 20. This example accepts 3–8 days and allows the range to span the unavailable weekend.

## Range in Progress

The calendar's state has `anchor`, the start while an end is being picked, and `focused`, the date with the Tab stop. `@onAnchorChange` and `@onFocusedChange` report them before they change, to show the range being picked outside the calendar, and canceling either keeps things as they were. A day that takes focus because the months turned reports nothing.

```glimmer-ts title="range-progress.gts"
import Component from "@glimmer/component"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"
import { useLog } from "./log"

export default class RangeProgress extends Component {
  log = useLog(this)

  onAnchorChange = (anchor: string | null) => {
    this.log(anchor ? `Started on ${anchor}` : "Range finished")
  }

  onFocusedChange = (focused: string) => {
    this.log(`Focus on ${focused}`)
  }

  <template>
    <div>
      <Calendar
        @mode="range"
        @onAnchorChange={{this.onAnchorChange}}
        @onFocusedChange={{this.onFocusedChange}}
        as |c|
      >
        <div data-slot="row">
          <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
          <c.Heading />
          <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
        </div>
        <c.Grid />
      </Calendar>
    </div>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose a start date, then move with the arrow keys. The console logs the start and each focused date until Enter picks the end.

## Controlled

The selection and displayed month are separate. `@value` uses the shape for the chosen mode; `@month` names the first displayed month, such as `"2026-10"`.

Use `@value` with `@onValueChange` and `@month` with `@onMonthChange` to control them. Use `@defaultValue` and `@defaultMonth` for initial state. Change details include a reason; `details.cancel()` rejects the change. The [reason tables](#reasons) list Calendar’s reasons.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Controlled extends Component {
  log = useLog(this)
  @tracked value: string | null = "2026-10-16"
  @tracked month = "2026-10"

  onValueChange = (next: unknown, details: { reason: string }) => {
    this.value = next as string
    this.log(`Selected ${String(next)} (${details.reason})`)
  }

  onMonthChange = (next: string, details: { reason: string }) => {
    this.month = next
    this.log(`Showing ${next} (${details.reason})`)
  }

  <template>
    <div>
      <Calendar
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @month={{this.month}}
        @onMonthChange={{this.onMonthChange}}
        as |c|
      >
        <div data-slot="row">
          <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
          <c.Heading />
          <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
        </div>
        <c.Grid />
      </Calendar>
    </div>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose a date or change the month. The console logs each change and its reason.

## Today

Today gets `aria-current="date"` and `data-today`. When there is no selection or starting month, the calendar opens on today’s month. It reads today on the client; set `@today` to pin a date explicitly.

`@timeZone` determines which date is today. It does not convert the selected date into another time zone.

```glimmer-ts title="time-zone.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

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
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Find the marked date for today in Pacific/Kiritimati, which may differ from today in your time zone.

## Driving It from Anywhere

A `createCalendarController()` instance can set the value, change months, and focus a date. Focusing a date in another month shows that month first.

```glimmer-ts title="controller.gts"
import Component from "@glimmer/component"
import { todayDate } from "@ui-sdk/core/date"
import { ChevronLeft, ChevronRight } from "lucide"
import { on } from "@ember/modifier"
import { Calendar, createCalendarController } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

export default class Controller extends Component {
  calendar = createCalendarController()

  select = (date: string) => {
    this.calendar.setValue(date)
    this.calendar.focus(date)
  }

  goToChristmas = () => this.select("2026-12-25")
  goToToday = () => this.select(todayDate())

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.goToChristmas}}>Go to Christmas</button>
        <button type="button" {{on "click" this.goToToday}}>Today</button>
      </div>
      <Calendar @controller={{this.calendar}} @defaultValue="2026-10-16" @defaultMonth="2026-10" as |c|>
        <div data-slot="row">
          <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
          <c.Heading />
          <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
        </div>
        <c.Grid />
      </Calendar>
    </div>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Press Go to Christmas to select December 25 and move focus there, or Today to jump back to today and select it.

## Presets

Drive a range calendar from buttons for the ranges people pick most. Each preset sets the value through the [controller](#driving-it-from-anywhere) and moves focus to its first day, using the date helpers in `@ui-sdk/core/date` for the arithmetic.

```glimmer-ts title="presets.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { fn } from "@ember/helper"
import { addDays, endOfMonth, startOfMonth } from "@ui-sdk/core/date"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar, createCalendarController } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

const today = "2026-10-16"

const presets = [
  { label: "Last 7 Days", range: [addDays(today, -6), today] },
  { label: "This Month", range: [startOfMonth(today), endOfMonth(today)] },
  { label: "Next 30 Days", range: [today, addDays(today, 29)] },
]

export default class Presets extends Component {
  presets = presets
  today = today
  calendar = createCalendarController()

  choose = (preset: { range: string[] }) => {
    this.calendar.setValue([...preset.range])
    this.calendar.focus(preset.range[0])
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        {{#each this.presets key="label" as |preset|}}
          <button type="button" data-size="sm" {{on "click" (fn this.choose preset)}}>
            {{preset.label}}
          </button>
        {{/each}}
      </div>
      <Calendar
        @mode="range"
        @controller={{this.calendar}}
        @today={{this.today}}
        @defaultMonth="2026-10"
        as |c|
      >
        <div data-slot="row">
          <c.Previous data-variant="ghost">{{icon ChevronLeft}}</c.Previous>
          <c.Heading />
          <c.Next data-variant="ghost">{{icon ChevronRight}}</c.Next>
        </div>
        <c.Grid />
      </Calendar>
    </div>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose Last 7 Days, This Month or Next 30 Days. The range is selected and the calendar shows its start.

## Custom Rendering

Write the grid yourself when you need its markup. Import `CalendarWeekday` and `CalendarDay` from `ember-ui-sdk/calendar`; each yields its state. Preserve empty cells marked `hidden` so dates shown by another month do not appear twice.

```glimmer-ts title="custom-grid.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Calendar, CalendarDay, CalendarWeekday } from "ember-ui-sdk/calendar"
import { icon } from "./icon"

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
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

The table is your own markup, built from the grid's state. Navigate and select as usual.

## Styling

Use `data-selected`, `data-today`, `data-outside`, `data-unavailable`, and `data-disabled` to style dates. A range also exposes its start, middle, end, and unfinished preview. Navigation buttons also get `data-disabled` when they reach the bounds.

Each part has a `data-slot`, such as `calendar-day`, and its state attributes are listed under [Data Attributes](#data-attributes).

## Data Attributes

### Calendar
`[data-slot="calendar"]`

- `data-mode` (`single`, `multiple`, `range`): How the calendar selects.
- `data-readonly`: Present when dates can be focused but not picked.
- `data-disabled`: Present on the root, grids and selects when the calendar is disabled, on a day that can't be picked, and on Previous or Next at `min` or `max`.

### CalendarPrevious
`[data-slot="calendar-previous"]`

- `data-disabled`: Present on the root, grids and selects when the calendar is disabled, on a day that can't be picked, and on Previous or Next at `min` or `max`.

### CalendarNext
`[data-slot="calendar-next"]`

- `data-disabled`: Present on the root, grids and selects when the calendar is disabled, on a day that can't be picked, and on Previous or Next at `min` or `max`.

### CalendarMonthSelect
`[data-slot="calendar-month-select"]`

- `data-disabled`: Present on the root, grids and selects when the calendar is disabled, on a day that can't be picked, and on Previous or Next at `min` or `max`.

### CalendarYearSelect
`[data-slot="calendar-year-select"]`

- `data-disabled`: Present on the root, grids and selects when the calendar is disabled, on a day that can't be picked, and on Previous or Next at `min` or `max`.

### CalendarGrid
`[data-slot="calendar-grid"]`

- `data-disabled`: Present on the root, grids and selects when the calendar is disabled, on a day that can't be picked, and on Previous or Next at `min` or `max`.

### CalendarDay
`[data-slot="calendar-day"]`

- `data-value` (`2026-10-01`, `2026-10-14`, `2026-10-16`, `2026-10-18`, `2026-10-24`, `2026-09-30`): A day's ISO date.
- `data-selected`: Present on selected days. In a range, every day from start to end.
- `data-today`: Present on today, beside `aria-current="date"`.
- `data-disabled`: Present on the root, grids and selects when the calendar is disabled, on a day that can't be picked, and on Previous or Next at `min` or `max`.
- `data-unavailable`: Present on a day `unavailable` names. It stays focusable.
- `data-outside`: Present on a day of the month before or after its grid's.
- `data-range-start`: Present on the day a range starts, including one being picked.
- `data-range-middle`: Present on the days inside a range, between its ends.
- `data-range-end`: Present on the day a range ends, including one being picked.
- `data-preview`: Present on the days of a range being picked, from its start to the day under the pointer or focus.

## API Reference

Pass the root's options as `@` arguments.

### Calendar

- `mode?` (`CalendarMode`): How many dates it selects: one, any number, or a range from a start to an end.
- `value?` (`CalendarValue`): The selected value: an ISO date for `"single"`, a list for `"multiple"`, `[start, end]` for `"range"`, or `null`. Pass it to control the calendar.
- `defaultValue?` (`CalendarValue`): The value it starts with, when uncontrolled.
- `onValueChange?` (`((value: CalendarValue, details: ChangeDetails<CalendarValueChangeReason>) => void)`): Runs when a date is pressed (`"item-press"`), with Enter or Space too, or a controller sets the value (`"imperative"`). A range changes once both ends are picked. `details.cancel()` keeps the value.
- `month?` (`string`): The first month shown, like `"2026-10"`. Pass it to control the calendar.
- `defaultMonth?` (`string`): The first month it shows, when uncontrolled. Defaults to the selected date's month, else today's.
- `onMonthChange?` (`((month: ISOMonth, details: ChangeDetails<CalendarMonthChangeReason>) => void)`): Runs when the months shown want to change: Previous or Next, a key moving focus to another month, a press on a day of another month, or a controller.
- `min?` (`string`): The earliest date that can be picked. Keys stop there, and Previous stops at its month.
- `max?` (`string`): The latest date that can be picked.
- `unavailable?` (`DateMatchers`): Dates that can't be picked, like booked days, as data: ISO dates, `{ from, to }`, `{ weekday: [0, 6] }` for weekends, `{ before }`, `{ after }`, or a function. They stay focusable, so keyboard users hear them.
- `disabled?` (`boolean`): Whether nothing can be picked or focused.
- `readOnly?` (`boolean`): Whether dates can be focused but not picked.
- `deselectable?` (`boolean`): Whether pressing the selected date again clears it, in `"single"` mode.
- `onFocusedChange?` (`((date: ISODate, details: ChangeDetails<CalendarFocusedChangeReason>) => void)`): Runs before keys, a press or `focus()` move focus to another day. Canceling keeps focus where it was.
- `onAnchorChange?` (`((anchor: ISODate | null, details: ChangeDetails<CalendarAnchorChangeReason>) => void)`): Runs before a press starts a range, or ends it or Escape drops it, with `null`. Canceling keeps the start as it was.
- `months?` (`number`): How many months show side by side, each in its own grid.
- `pageBy?` (`"month" | "page"`): Whether Previous, Next and keys turn one month, or all the months shown.
- `locale?` (`string`): The language of the names and labels. Defaults to the page's `lang`, then the browser's.
- `weekStartsOn?` (`number`): The first day of the week, 0 for Sunday. Defaults to the locale's.
- `weekdayFormat?` (`"long" | "narrow" | "short"`): How weekday headers are written.
- `monthFormat?` (`"long" | "narrow" | "short"`): How month names are written, in the heading and the month select.
- `fixedWeeks?` (`boolean`): Whether every month shows six weeks, so the calendar doesn't change height.
- `showOutsideDays?` (`boolean`): Whether the days of the months before and after show at the edges.
- `today?` (`string`): Today's date, for `aria-current` and the starting month. Defaults to today in `timeZone`, read on the client.
- `timeZone?` (`string`): The time zone that says what day today is, like `"America/New_York"`. Defaults to the browser's.
- `minDays?` (`number`): The fewest days a range can span, counting both ends.
- `maxDays?` (`number`): The most days a range can span, counting both ends.
- `allowUnavailable?` (`boolean`): Whether a range may hold unavailable dates, like a stay over a booked night.
- `controller?` (`object`): Drives it from anywhere. Create one with `createCalendarController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### CalendarPrevious

Shows the previous month. Renders a `button` that is disabled at `@min`.

### CalendarHeading

Names the months shown, like "October 2026". Renders an `h2` the grid is labelled by, and screen readers hear it change.

### CalendarNext

Shows the next month. Renders a `button` that is disabled at `@max`.

### CalendarMonthSelect

A native `select` of the months, in the locale, that changes the first month shown.

### CalendarYearSelect

A native `select` of the years from `@min` to `@max`, or 10 either side of the year shown.

### CalendarGrid

- `offset?` (`number`): Which of the months shown it is, from 0.

### CalendarWeekdays

Renders the header row. Its block receives each weekday's index.

### CalendarWeekday

- `index` (`number`): The column, from 0.

### CalendarWeeks

Renders the week rows. Its block receives each cell, with its `date`.

### CalendarDay

- `value` (`string`): Its ISO date.
- `offset?` (`number`): The offset of the grid it's in.

### State

What `@render` parts and their blocks receive, per part.

`Calendar`:

- `value` (`CalendarValue`): The selected value.
- `month` (`string`): The first month shown.
- `mode` (`CalendarMode`): How it selects.
- `disabled` (`boolean`): Whether nothing can be picked or focused.
- `readOnly` (`boolean`): Whether dates can be focused but not picked.
- `focused` (`string | null`): The date with the tab stop, `null` until days render in the browser.
- `anchor` (`string | null`): A range's start while its end is being picked, else `null`.

`CalendarHeading`:

- `month` (`string`): The first month shown, to format the heading yourself.
- `label` (`string`): The months shown in `monthFormat`, like "October 2026", or "October – November 2026".

`CalendarMonthSelect` and `CalendarYearSelect`:

- `value` (`number`): The first month shown's month, 1 to 12, or its year.
- `options` (`CalendarSelectOption[]`): Every month, or the years from `min` to `max` (10 either side of the year shown without them).
- `disabled` (`boolean`): Whether the calendar's `disabled` option is on. Inside a Date Picker, a disabled `<fieldset>` around the picker counts too.

`CalendarPrevious` and `CalendarNext`:

- `month` (`string`): The first month it shows.
- `disabled` (`boolean`): Whether it can't go further, past `min` or `max`.

`CalendarGrid`:

- `month` (`string`): The month it shows: the first month shown, plus its `offset`.
- `label` (`string`): The month's name and year in `monthFormat`, like "October 2026".
- `weekdays` (`number[]`): The weekday of each column, 0 for Sunday, in the order they show.
- `weeks` (`CalendarGridCell[][]`): The weeks, each seven cells. Render a day for each cell that isn't hidden.

`CalendarWeekday`:

- `weekday` (`number`): The weekday, 0 for Sunday.
- `label` (`string`): Its name, in `weekdayFormat`.
- `name` (`string`): Its full name, which screen readers hear.

`CalendarDay`:

- `date` (`string`): Its ISO date.
- `label` (`string`): The day of the month in the locale's digits, like "16".
- `selected` (`boolean`): Whether it's selected. In a range, every date from start to end is.
- `today` (`boolean`): Whether it's the `today` option's date, or else today in `timeZone`, read once the calendar runs in the browser.
- `outside` (`boolean`): Whether it belongs to the month before or after its grid's.
- `disabled` (`boolean`): Whether it can't be picked: outside `min` and `max`, unavailable, unable to end the range being picked, or the calendar is disabled.
- `unavailable` (`boolean`): Whether `unavailable` names it.
- `rangeStart` (`boolean`): Whether a range starts here, including one being picked.
- `rangeEnd` (`boolean`): Whether a range ends here, including one being picked.
- `inRange` (`boolean`): Whether it's inside a range, ends included, including one being picked.

### Reasons

`details.reason` says why the value changed:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

And why the month changed:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.
- `previous-press` (`MouseEvent | KeyboardEvent`): A pagination's or a carousel's Previous part was pressed.
- `next-press` (`MouseEvent | KeyboardEvent`): A pagination's or a carousel's Next part was pressed.
- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `select-change`

Why focus moves to another day:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.
- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `focus-in` (`FocusEvent`): Keyboard focus moved into the component, which stops a rotating carousel, as the carousel pattern asks, or onto a canvas item, which brought it into view, or onto a calendar's day another way, like a screen reader's.

And why a range's start changed:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).

### Controller

Create one with `createCalendarController()` and pass it as `@controller`. Every write method takes an optional `{ reason, event }` and returns `false` when the change is canceled, there's nowhere to go, or the calendar is disabled or read-only.

- `getValue()` (`() => CalendarValue`): The selected value: an ISO date, a list of them, or a `[start, end]` range.
- `setValue(value, options?)` (`(value: CalendarValue, options?: CalendarChangeOptions<CalendarValueChangeReason> | undefined) => boolean`): Selects a value. Returns false when canceled, unchanged, disabled, read-only, or holding a date people can't pick, like one past `max`.
- `getMonth()` (`() => string`): The first month shown, like `"2026-10"`.
- `setMonth(month, options?)` (`(month: string, options?: CalendarChangeOptions<CalendarMonthChangeReason> | undefined) => boolean`): Shows a month first. Returns false when canceled or unchanged.
- `previous(options?)` (`(options?: CalendarChangeOptions<CalendarMonthChangeReason> | undefined) => boolean`): Shows the months before, as the Previous part does.
- `next(options?)` (`(options?: CalendarChangeOptions<CalendarMonthChangeReason> | undefined) => boolean`): Shows the months after, as the Next part does.
- `focus(date?)` (`(date?: string | undefined) => void`): Focuses a date, turning the months to show it, or the date with the tab stop.

### Events

Callbacks get the new value first, then the details. A controlled value only updates when the callback didn't cancel.

| Argument           | On         | Receives                                                                               |
| ------------------ | ---------- | -------------------------------------------------------------------------------------- |
| `@onValueChange`   | `Calendar` | `(value, details)`: the new value, and the [reason](#reasons)                          |
| `@onMonthChange`   | `Calendar` | `(month, details)`: the new first month, and the [reason](#reasons)                    |
| `@onFocusedChange` | `Calendar` | `(date, details)`: the day focus moves to, and the [reason](#reasons)                  |
| `@onAnchorChange`  | `Calendar` | `(date, details)`: a range's start, or `null` once it ends, and the [reason](#reasons) |

## Accessibility

It follows the grid of the [WAI-ARIA date picker dialog](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/datepicker-dialog/): each month is a `grid` named by its month, weekday headers are `columnheader`s named by their full names, and each day is a focusable `gridcell` named by its full date, like "Friday, October 16, 2026", with `aria-selected`, `aria-disabled` and `aria-current="date"`. A grid that selects several dates or a range is `aria-multiselectable`. Every line below is an automated test.

### Keyboard

The grid has one Tab stop: the selected date when visible, otherwise today, otherwise the first available date. Moving into another month shows it and then focuses the date.

| Key                             | Action                                          |
| ------------------------------- | ----------------------------------------------- |
| Left / Right Arrow              | Move one day, following the page’s direction.   |
| Up / Down Arrow                 | Move one week.                                  |
| Home / End                      | Move to the first or last day of the week.      |
| Page Up / Page Down             | Move one month, keeping the day where possible. |
| Shift+Page Up / Shift+Page Down | Move one year.                                  |
| Enter / Space                   | Select the focused date.                        |
| Escape                          | Cancel an unfinished range.                     |

### Tested Behavior

- The calendar shows a month as a grid of days under weekday headers.
- The selected date holds the tab stop, else today.
- Tab leaves the grid after one stop.
- Arrow keys move focus by day and week.
- Moving past the month's edge shows the next month and focuses the day there.
- Page Up and Page Down move by month, and with Shift by year.
- The day of the month stays the same, or the month's last, when moving by month.
- Home and End go to the first and last day of the week.
- The week starts on the locale's first day.
- Pressing a day selects it.
- Enter on a focused day selects it.
- Space on a focused day selects it.
- Previous and Next show the month before and after, and the heading announces it.
- Min and max stop keys there, and Previous and Next at their months.
- Unavailable dates can be focused but not selected.
- In multiple mode, presses toggle dates.
- In range mode, two presses pick a range, previewed in between.
- In range mode, keys preview the end and Escape drops the start.
- A range keeps to its fewest and most days, and keeps its start.
- Two months show side by side, and focus moves between them without turning.
- Pressing a day of the next month selects it and shows its month.
- Pressing another month's day before min keeps the month shown.
- Pressing another month's day before min leaves focus on the day that had it.
- A controlled calendar shows what the app passes.
- A controller turns to a date and focuses it.
- A disabled calendar has no tab stop and selects nothing.
- A read-only calendar moves focus but selects nothing.

**Month and year selects**

- They show the first month shown and turn the calendar, with the select-change reason.
- Years run from min to max, and months past them are disabled.
- They follow the page's language.

Runs in React, Vue and web components.

Beyond the baseline:

- Keys pressed without waiting still land on the right day.
- A day of next month takes focus even when its month renders after the key.

Runs in React, Vue and web components.
