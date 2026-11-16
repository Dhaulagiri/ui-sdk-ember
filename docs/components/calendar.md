---
title: Calendar
description: Choose one date, several dates, or a range from a month grid.
---

Calendar shows dates directly on the page. Use it for a booking flow, a schedule, or any place where the dates should stay visible. For a text field that opens a calendar, use [Date Picker](./date-picker.md).

[calendar/basic](../../examples/components/calendar/ember/basic.gts)

Choose a date, then use Previous or Next to change the month. Arrow keys move through the days.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

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

[calendar/range](../../examples/components/calendar/ember/range.gts)

Choose a start date, then move to an end date to preview the range. Choose the end to finish, or press Escape to cancel the unfinished range.

## Multiple

`@mode="multiple"` toggles each date independently. Its value is a sorted array, even when dates were chosen in another order.

[calendar/multiple](../../examples/components/calendar/ember/multiple.gts)

Choose another date to add it, or choose a selected date to remove it.

## Unavailable Dates

`@unavailable` accepts a date, `{ from, to }`, `{ weekday: [0, 6] }` for weekends, `{ before }`, `{ after }`, a predicate, or an array of these matchers. Weekday zero is Sunday.

Unavailable dates cannot be selected, but stay focusable so keyboard and screen reader users can discover them. They expose `aria-disabled` and `data-unavailable`.

[calendar/unavailable](../../examples/components/calendar/ember/unavailable.gts)

Try an unavailable date, then choose an available one. Unavailable days remain focusable so their state can be heard.

## Deselect

`@deselectable={{true}}` lets a second press on the selected date clear it, in single mode. Without it, a second press keeps the date selected.

## Min and Max

`@min` and `@max` set the earliest and latest selectable dates. Dates outside those bounds cannot receive focus. Arrow keys stop at the bounds, and Previous and Next stop at their months.

[calendar/min-max](../../examples/components/calendar/ember/min-max.gts)

Move toward either end of the allowed dates. Keyboard navigation and month buttons stop at the limits.

## Disabled and Read Only

`@disabled={{true}}` prevents focus, selection, and month navigation. `@readOnly={{true}}` allows navigation so dates can be inspected, but keeps the selected value unchanged.

[calendar/disabled](../../examples/components/calendar/ember/disabled.gts)

Try choosing a date or changing months. A disabled calendar has no available controls.

[calendar/read-only](../../examples/components/calendar/ember/read-only.gts)

Move through dates and months. The selected value stays unchanged.

## Two Months

Set `@months={{2}}` and render grids with offsets `0` and `1`. Arrow keys move between the grids without turning the page. Dates that another visible month already shows leave an empty cell, so each date appears once.

`@pageBy="page"` makes Previous, Next, and navigation beyond the visible grids move by the full number of months.

[calendar/two-months](../../examples/components/calendar/ember/two-months.gts)

Move between October and November with arrow keys. Next advances both visible months to December and January.

## Fixed Weeks

`@fixedWeeks={{true}}` renders six week rows in every month. Set `@showOutsideDays={{false}}` to leave dates from neighboring months blank.

[calendar/fixed-weeks](../../examples/components/calendar/ember/fixed-weeks.gts)

Move from February to March. Both grids keep six week rows, and dates outside each month are hidden.

## Month and Year Selects

`CalendarMonthSelect` and `CalendarYearSelect` are native selects for jumping directly to a date, such as a birthday. The year options run from `@min` to `@max`, or ten years either side of the current year shown when bounds are missing. Months outside the bounds are disabled.

They update the first displayed month with the `select-change` reason. Their state exposes the options if you want to render a different select.

[calendar/month-year-select](../../examples/components/calendar/ember/month-year-select.gts)

Choose a year and month to jump directly to a birthday, then choose the day.

## Custom Month and Year Selects

The month and year selects are native `select` elements. To use your own select, control the calendar's `@month` and drive it from your select's value, as with the [Select](./select.md) component. Keep a `c.Heading` in the calendar, visually hidden if you like, so the grid stays named.

[calendar/custom-select](../../examples/components/calendar/ember/custom-select.gts)

Choose a month or a year from the selects. The calendar follows, and the arrow keys still move between days.

## Language

`@locale` controls month names, weekday headers, and full date labels. If you omit it, Calendar reads the surrounding page’s `lang` after it mounts, with the browser’s language as a fallback. The initial server and client render use English, so they always match. The first weekday follows the locale, and so changes after mount too, unless `@weekStartsOn` sets it. `@weekdayFormat` accepts `"narrow"`, `"short"`, or `"long"`.

Previous and Next are named "Previous month" and "Next month". Pass `aria-label` to name them in another language. Dates remain Gregorian. Localized year systems, such as Buddhist or Japanese era years, can still appear in the labels.

[calendar/locale](../../examples/components/calendar/ember/locale.gts)

Move through the calendar. Month names, weekday headers, and full date labels are in German, with Monday first.

## Name Formats

Set `@weekdayFormat` for the weekday headers and `@monthFormat` for the heading and the month select. Both take `"narrow"`, `"short"` or `"long"`, and follow the calendar's locale. Screen readers still hear full names: the grid and each day keep their long labels.

[calendar/formats](../../examples/components/calendar/ember/formats.gts)

The weekday headers are narrow and the heading uses short month names: Oct – Nov 2026.

## Custom Days

A day's block receives its state, including the date, label, selection, and whether it is outside the month. This example adds a price below each day. Weekday headers can have custom content too.

[calendar/custom-day](../../examples/components/calendar/ember/custom-day.gts)

Choose a date to see its price selected with it. Dates outside the current month have no price.

## Range Limits

`@minDays` and `@maxDays` count both ends. A three-day range includes its start, the day between, and its end. A press that would break a limit keeps the start, so another end can be chosen. Until then, the dates that can't end the range are disabled.

A range cannot include an unavailable date unless `@allowUnavailable={{true}}` is set. That allows unavailable dates between the ends; they still cannot be chosen as an endpoint.

[calendar/range-limits](../../examples/components/calendar/ember/range-limits.gts)

In October 2026, choose October 15 then October 20. This example accepts 3–8 days and allows the range to span the unavailable weekend.

## Range in Progress

The calendar's state has `anchor`, the start while an end is being picked, and `focused`, the date with the Tab stop. `@onAnchorChange` and `@onFocusedChange` report them before they change, to show the range being picked outside the calendar, and canceling either keeps things as they were. A day that takes focus because the months turned reports nothing.

[calendar/range-progress](../../examples/components/calendar/ember/range-progress.gts)

Choose a start date, then move with the arrow keys. The console logs the start and each focused date until Enter picks the end.

## Controlled

The selection and displayed month are separate. `@value` uses the shape for the chosen mode; `@month` names the first displayed month, such as `"2026-10"`.

Use `@value` with `@onValueChange` and `@month` with `@onMonthChange` to control them. Use `@defaultValue` and `@defaultMonth` for initial state. Change details include a reason; `details.cancel()` rejects the change. The [reason tables](https://ui-sdk.dev/docs/react/components/calendar#reasons) list Calendar’s reasons.

[calendar/controlled](../../examples/components/calendar/ember/controlled.gts)

Choose a date or change the month. The console logs each change and its reason.

## Today

Today gets `aria-current="date"` and `data-today`. When there is no selection or starting month, the calendar opens on today’s month. It reads today on the client; set `@today` to pin a date explicitly.

`@timeZone` determines which date is today. It does not convert the selected date into another time zone.

[calendar/time-zone](../../examples/components/calendar/ember/time-zone.gts)

Find the marked date for today in Pacific/Kiritimati, which may differ from today in your time zone.

## Driving It from Anywhere

A `createCalendarController()` instance can set the value, change months, and focus a date. Focusing a date in another month shows that month first.

[calendar/controller](../../examples/components/calendar/ember/controller.gts)

Press Go to Christmas to select December 25 and move focus there, or Today to jump back to today and select it.

## Presets

Drive a range calendar from buttons for the ranges people pick most. Each preset sets the value through the [controller](#driving-it-from-anywhere) and moves focus to its first day, using the date helpers in `@ui-sdk/core/date` for the arithmetic.

[calendar/presets](../../examples/components/calendar/ember/presets.gts)

Choose Last 7 Days, This Month or Next 30 Days. The range is selected and the calendar shows its start.

## Custom Rendering

Write the grid yourself when you need its markup. Import `CalendarWeekday` and `CalendarDay` from `ember-ui-sdk/calendar`; each yields its state. Preserve empty cells marked `hidden` so dates shown by another month do not appear twice.

[calendar/custom-grid](../../examples/components/calendar/ember/custom-grid.gts)

The table is your own markup, built from the grid's state. Navigate and select as usual.

## Styling

Use `data-selected`, `data-today`, `data-outside`, `data-unavailable`, and `data-disabled` to style dates. A range also exposes its start, middle, end, and unfinished preview. Navigation buttons also get `data-disabled` when they reach the bounds.

Each part has a `data-slot`, such as `calendar-day`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/calendar#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [calendar reference](https://ui-sdk.dev/docs/react/components/calendar) in the upstream docs.

Pass the root's options as `@` arguments.

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

### CalendarWeekdays

Renders the header row. Its block receives each weekday's index.

### CalendarWeeks

Renders the week rows. Its block receives each cell, with its `date`.

### Controller

Create one with `createCalendarController()` and pass it as `@controller`. Every write method takes an optional `{ reason, event }` and returns `false` when the change is canceled, there's nowhere to go, or the calendar is disabled or read-only.

### Events

Callbacks get the new value first, then the details. A controlled value only updates when the callback didn't cancel.

| Argument           | On         | Receives                                                                                                                                |
| ------------------ | ---------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `@onValueChange`   | `Calendar` | `(value, details)`: the new value, and the [reason](https://ui-sdk.dev/docs/react/components/calendar#reasons)                          |
| `@onMonthChange`   | `Calendar` | `(month, details)`: the new first month, and the [reason](https://ui-sdk.dev/docs/react/components/calendar#reasons)                    |
| `@onFocusedChange` | `Calendar` | `(date, details)`: the day focus moves to, and the [reason](https://ui-sdk.dev/docs/react/components/calendar#reasons)                  |
| `@onAnchorChange`  | `Calendar` | `(date, details)`: a range's start, or `null` once it ends, and the [reason](https://ui-sdk.dev/docs/react/components/calendar#reasons) |

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
