---
title: Date Input
description: Type a date one part at a time, in the order your user's language writes it.
---

Use a Date Input for dates people know by heart, like a birthday or a booking date. Each part of the date is its own small input, ordered the way the locale writes it.

[date-input/basic](../../examples/components/date-input/ember/basic.gts)

Click the month and type 11042026. Each part moves to the next as it fills. Press ArrowUp or ArrowDown on a part to step it.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `DateInput`:

```text
DateInput as |d|
├── d.Segment
└── d.Segment
```

`DateInput` renders a group with one `d.Segment` for each part of the date: month, day and year in English, day, month and year in German. Each segment you type in is a small input. The slashes or dots between them are segments too, as plain text. `DateInput` renders its segments for you; render them yourself only to change how they look, as in [Custom Rendering](#custom-rendering).

## Usage

Put the input in a [Field](./field.md) and give it a label:

```gts
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Start date</f.Label>
    <DateInput @defaultValue="2026-11-02" @field={{f.field}} />
  </Field>
</template>
```

The value is an ISO date string like `"2026-11-02"`, the same as a native date input's. It stays `null` until every segment holds something, so your app only sees whole dates.

Type digits and each segment fills, then moves on. A month that can't take another digit, like 4, moves on at once. Typing a separator, like `/` or `.`, moves on too. The day is kept within its month: moving from January 31 to February shows the 28th. Paste a whole date into any segment, as `2026-11-02` or written the way the locale writes it.

## Field

The Field's label names the group, and clicking it focuses the first segment. Its description is read with the input.

[date-input/field](../../examples/components/date-input/ember/field.gts)

Click Birthday to focus the month, then type a date. Screen readers read the description with the input.

## Date and Time

Set `@granularity` to `"hour"`, `"minute"` or `"second"` to add the time. The value becomes a local date and time like `"2026-11-02T14:30"`. For a time alone, use the Time Input from `ember-ui-sdk/time-input`.

[date-input/date-time](../../examples/components/date-input/ember/date-time.gts)

Tab through the date and time. Type a P or an A in the last segment to switch between AM and PM.

## Min and Max

`@min` and `@max` take ISO dates. A date outside them is invalid: the input sets `data-invalid`, and its form won't submit.

[date-input/min-max](../../examples/components/date-input/ember/min-max.gts)

Change the year of Check-in to 2027 to see it turn invalid, then back to 2026.

## Unavailable Dates

`@unavailable` takes the same matchers as [Calendar](./calendar.md#unavailable-dates): ISO dates, `{ from, to }` ranges, weekdays like `{ weekday: [0, 6] }`, or a function. An unavailable date is invalid with the message "This date isn't available."

[date-input/unavailable](../../examples/components/date-input/ember/unavailable.gts)

Step the day of Delivery date back from Monday the 2nd to Sunday the 1st. The input turns invalid until you pick a weekday again.

## Locale

The input reads its order, separators and clock from `@locale`, or from the page's language when you leave it out. The digits are always 0 to 9, and the calendar is always the Gregorian one, so the value means the same date everywhere. On the server, the input renders in English until it reads the page's language; set `@locale` when that first render matters.

[date-input/locale](../../examples/components/date-input/ember/locale.gts)

The same date in British English, German and Japanese. Each orders its parts its own way.

## Disabled

Set `@disabled={{true}}` on the input, or on its Field or fieldset, to keep it from focus and from its form.

[date-input/disabled](../../examples/components/date-input/ember/disabled.gts)

Click Start date or press Tab to reach it. Focus skips it, and the date stays November 2, 2026.

## Read-Only

Set `@readOnly={{true}}` for a date people can focus, read and submit as it is.

[date-input/read-only](../../examples/components/date-input/ember/read-only.gts)

Focus Signed on and press ArrowUp or type a digit. The date stays the same.

## Form

A hidden input submits the ISO date under `@name`. An empty or partly typed date submits an empty string. Set `@required={{true}}` to need a date before the form submits. Enter in a segment submits the form with what was typed.

[date-input/form](../../examples/components/date-input/ember/form.gts)

Clear the day of Date with Backspace and choose Book to see the form stop. Fill it in and choose Book: the console logs the values. Reset brings back the defaults.

A partly typed date stops the form too, with "Enter a valid date." Set `@form` to the id of a form elsewhere in the page to submit and validate with it. A form reset restores `@defaultValue` and reports the `reset` reason.

## Controlled

Pass `@value` and update it in `@onValueChange`, which also receives the change details. Both get each whole date, and `null` once any part of it is erased. A half-typed date already reads `null`, so setting the value to `null` leaves it as typed. Call `clear()` on a controller to empty every segment.

[date-input/controlled](../../examples/components/date-input/ember/controlled.gts)

Change Due date: the console logs each whole date. Clear sets the value to null.

[Reasons](https://ui-sdk.dev/docs/react/components/date-input#reasons) lists why each change happened.

## Controller

Create a controller with `createDateInputController()` and pass it as `@controller` to set, clear or focus the input from elsewhere. `focus("year")` focuses a segment by its unit.

[date-input/controller](../../examples/components/date-input/ember/controller.gts)

Choose Christmas to set the date, Edit Year to focus the year, or Clear to empty it.

## Custom Rendering

Render the segments yourself with a block. Its `d.state.segments` lists each segment in order, with the text between them. Render a `d.Segment` for each one that is editable, and give the text between segments content of your own.

[date-input/segments](../../examples/components/date-input/ember/segments.gts)

The segments here are separated by dashes in place of the locale's slashes. The order stays the locale's.

Each part's state is listed under [State](https://ui-sdk.dev/docs/react/components/date-input#state).

## Styling

Style the root as the field's box, and its segments inside it. Every segment sets `data-type` to its unit, so you can make the year wider or mute the text between segments, which has `data-type="literal"`. An empty segment sets `data-empty` and shows its placeholder. The root sets `data-invalid` while the date is out of range or unavailable.

Each part has a `data-slot`, such as `date-input-segment`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/date-input#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [date-input reference](https://ui-sdk.dev/docs/react/components/date-input) in the upstream docs.

Pass the root's options as `@` arguments. `@value` is controlled with `@onValueChange`.

### Controller

Create one with `createDateInputController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like typing, and returns `false` when the change is canceled.

### Events

Callbacks get the new value first, then the details. A controlled `@value` only updates when `@onValueChange` didn't cancel the change.

| Argument         | On          | Receives                                                                                                                                  |
| ---------------- | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `@onValueChange` | `DateInput` | `(value, details)`: the ISO date, or null once it's erased, and the [reason](https://ui-sdk.dev/docs/react/components/date-input#reasons) |

## Accessibility

The root is a group, named by its Field's label or by your `aria-label`. Each segment is a [spinbutton](https://www.w3.org/WAI/ARIA/apg/patterns/spinbutton/) named by its unit, like "month", with its value, range and text. An empty segment reads as "Empty". The text between segments is hidden from screen readers, which read each segment's name instead.

Segments are real inputs, so phones show a number pad and typing works before the page's script runs.

### Keyboard

| Key                    | Action                                                                      |
| ---------------------- | --------------------------------------------------------------------------- |
| 0 to 9                 | Fill the segment, then move to the next one.                                |
| ArrowUp / ArrowDown    | Step the segment by one, wrapping around. An empty segment starts at today. |
| PageUp / PageDown      | Step by more: a year by 5, a month by 3, a day by 7, minutes by 15.         |
| Home / End             | Go to the segment's first or last value.                                    |
| ArrowLeft / ArrowRight | Move to the segment before or after.                                        |
| Backspace              | Remove the last digit, then empty the segment, then move back.              |
| Delete                 | Empty the segment.                                                          |
| A / P                  | Choose AM or PM, in a time with a 12-hour clock.                            |
| Enter                  | Submit the form with what was typed.                                        |
| Tab / Shift+Tab        | Move through the segments, then out of the input.                           |

In a right-to-left page, the segments keep the locale's order, and ArrowLeft and ArrowRight follow the order on screen.
