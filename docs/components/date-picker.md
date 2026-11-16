---
title: Date Picker
description: Type a date or choose one from a calendar, with support for ranges and forms.
---

Date Picker combines a text field with [Calendar](./calendar.md). People can type a date in their language or choose it from the popup. Your application receives an ISO date string either way.

[date-picker/basic](../../examples/components/date-picker/ember/basic.gts)

Type a date and press Enter, or open the calendar and choose a day. The field formats the date when you commit it.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `DatePicker`:

```text
DatePicker as |dp|
├── dp.Input
├── dp.Trigger
├── dp.Hint
└── dp.Content
```

The input accepts a date, the trigger opens the calendar, and the hint describes the expected format. The content holds the calendar; its navigation and grid parts are the same as [Calendar's](./calendar.md#composition), so write them out inside `dp.Content` when you need to add styles, change the layout, or include custom day content.

In range mode, the picker renders an input for each end; pass `@end={{true}}` to the second one.

## Usage

Import the root and use the parts it yields:

```gts
import { DatePicker } from "ember-ui-sdk/date-picker"

<template>
  <DatePicker @defaultValue="2026-10-16" as |dp|>
    <dp.Input aria-label="Due date" />
    <dp.Trigger>Choose date</dp.Trigger>
    <dp.Hint />
    <dp.Content>
      <dp.Previous>Previous</dp.Previous>
      <dp.Heading />
      <dp.Next>Next</dp.Next>
      <dp.Grid />
    </dp.Content>
  </DatePicker>
</template>
```

## Values

Dates are strings such as `"2026-10-16"`, with no time or time zone attached. No date library is needed.

| Mode                 | Value                                                 |
| -------------------- | ----------------------------------------------------- |
| `"single"` (default) | A date string or `null`.                              |
| `"range"`            | `[start, end]` or `null`, with an input for each end. |

## Typing a Date

The input parses text when you press Enter or leave the field. It uses the locale’s date order, such as `10/16/2026` in American English or `16.10.2026` in German. It also accepts ISO dates, digits without separators, two-digit years, and month names in the locale or English. Dates without a year use the current year.

The field formats a valid date after it is committed, leaving your typing alone until then. Invalid text stays visible and sets `aria-invalid` and `data-invalid`; the previous value stays unchanged. Until the text is a date again, or empty, the input reports "Enter a valid date." as its validation message, so its form won't submit. The hint’s state includes an example date you can show alongside the field.

[date-picker/invalid](../../examples/components/date-picker/ember/invalid.gts)

Type not a date and press Enter to mark the field invalid. Replace it with 10/18/2026 to clear the invalid state.

## Range

`@mode="range"` uses one input for the start and another with `@end={{true}}` for the end. The calendar stays open after the start is picked and closes once both dates are chosen. A typed end before the start is invalid.

The range is `null` until both ends are valid. Clearing either input clears the complete value while leaving the other input’s date visible.

For two months side by side, set `@months={{2}}` and render a second `dp.Grid` with `@offset={{1}}`. `@pageBy="page"` moves both months together.

[date-picker/range](../../examples/components/date-picker/ember/range.gts)

Choose October 20, then October 23. The calendar stays open after the first date and closes after the second.

## Presets

`dp.Preset` chooses its `@value` and closes the popup. It exposes `aria-pressed` and `data-selected` when that value matches the selection. Your application calculates relative dates, such as the last seven days.

[date-picker/presets](../../examples/components/date-picker/ember/presets.gts)

Open the calendar and choose Last 7 Days. Reopen it to see the selected preset.

## Min, Max and Unavailable Dates

`@min`, `@max`, and `@unavailable` apply to typing, calendar selection, presets, and the controller. A date outside those rules is invalid when typed, a preset that holds one is disabled, and the controller refuses it. The controller also refuses a value while the picker is disabled or read-only. [Calendar](./calendar.md#unavailable-dates) explains the available matchers and how unavailable dates differ from the bounds.

For ranges, `@minDays` and `@maxDays` count both endpoints. `@allowUnavailable={{true}}` permits unavailable dates between them, but never as an endpoint. See [Range Limits](./calendar.md#range-limits).

[date-picker/min-max](../../examples/components/date-picker/ember/min-max.gts)

Try typing 11/21/2026, past the last allowed date, then 10/17/2026, a Saturday. Both are invalid and can't be picked; 10/19/2026 is accepted.

## Language

`@locale` sets the input’s format, hint, month names, and date labels. If you omit it, Date Picker reads the surrounding page’s `lang` after it mounts, with the browser’s language as a fallback. The initial server and client render use English, so they always match. Date strings remain Gregorian ISO dates.

The trigger, popup, and calendar navigation have English accessible labels by default. Pass `aria-label` to translate those controls too.

Calendar’s `@weekStartsOn`, `@weekdayFormat`, `@fixedWeeks`, `@showOutsideDays`, and `@timeZone` options apply here too. [Calendar](./calendar.md#language) shows these options without the popup.

[date-picker/locale](../../examples/components/date-picker/ember/locale.gts)

Enter 3.12.2026 and press Enter. The field, format hint, and calendar use German dates.

## Clear

`dp.Clear` clears the value and focuses the input. It gets `data-empty` when there is nothing to clear. Emptying a single-date input clears its value too.

[date-picker/clear](../../examples/components/date-picker/ember/clear.gts)

Press Clear to empty the value and focus the input. The Clear button disappears until there is a value again.

## Disabled and Read Only

`@disabled={{true}}` prevents typing, opening, and selection. `@readOnly={{true}}` lets people open the calendar and inspect its dates without changing the value.

```gts
<DatePicker @disabled={{true}} @defaultValue="2026-10-16" as |dp|>…</DatePicker>
<DatePicker @readOnly={{true}} @defaultValue="2026-10-16" as |dp|>…</DatePicker>
```

## Staying Open

Set `@closeOnSelect={{false}}` to keep the calendar open after choosing a date, completing a range, or pressing a preset.

```gts
<DatePicker @closeOnSelect={{false}} as |dp|>…</DatePicker>
```

## Keep It Open Until Both Dates Are Picked

Set `@dismissible={{false}}` while a choice is incomplete. Escape, an outside press, or the system back gesture then leave the popup open. `@onDismissAttempt` reports intentional attempts, so you can explain what is missing. Focus leaving is refused quietly. The trigger and imperative controls can still close it.

[date-picker/dismissible](../../examples/components/date-picker/ember/dismissible.gts)

Choose a check-in date, then press outside the calendar. The message asks for a check-out date before the popup can be dismissed.

## Popup and Presentation

`dp.Content` opens below the input by default. Position it with `@side`, `@align`, and offsets, or provide a custom `@anchor`. `@container` changes where it renders; `@keepMounted={{true}}` retains it while closed, and `@finalFocus` controls focus after it closes. [Popover](./popover.md) covers these shared options.

`@presentation="auto"` uses a sheet on small touch screens and a popover elsewhere. `@presentation="sheet"` always uses a sheet. Style the two layouts using `data-presentation`.

[date-picker/popup](../../examples/components/date-picker/ember/popup.gts)

Open the calendar. On a small touch screen it opens as a sheet, and the console logs each open, close and month change.

## Forms

`@name` submits an ISO date. In range mode, pass `@name` to submit both ends under the same name. `@required={{true}}` blocks an empty submission, text that isn't a date blocks one too, a form reset restores `@defaultValue`, and a disabled `fieldset` disables the picker. Server-rendered hidden inputs submit the initial value before hydration too.

In a [Field](./field.md), the field connects the label, description, and errors to the input, and shows an error for an empty required date or text that isn't a date. Its `name` is used when the picker has none, and a disabled field disables the picker.

[date-picker/form](../../examples/components/date-picker/ember/form.gts)

Press Submit with an empty field to see the inline error, then choose a date and submit. The console logs the ISO date.

## Controlled

The selected value, displayed month, and open state are separate. `@value` uses the shape for the chosen mode; `@month` is the first displayed month, such as `"2026-10"`; `@open` is a boolean.

Use `@value` with `@onValueChange`, `@month` with `@onMonthChange`, and `@open` with `@onOpenChange` to control them. `@defaultValue`, `@defaultMonth`, and `@defaultOpen` set initial state instead. Change details carry a reason; `details.cancel()` rejects the requested change. The [reason tables](https://ui-sdk.dev/docs/react/components/date-picker#reasons) list Date Picker’s reasons.

[date-picker/controlled](../../examples/components/date-picker/ember/controlled.gts)

Type or choose a date. The console logs each value and the reason for the change.

## Driving It from Anywhere

A `createDatePickerController()` instance can set the value, show a month, open or close the popup, and focus a date in the open calendar. The [controller reference](#controller) lists the methods.

[date-picker/controller](../../examples/components/date-picker/ember/controller.gts)

Press Choose Christmas to set the date from outside, or Open to open the calendar.

## Styling

The root, inputs, and trigger expose `data-disabled`. Invalid input sets `data-invalid` on that input and the root. The root and trigger expose `data-open`; presets expose `data-selected`, and Clear exposes `data-empty`. Calendar days carry [Calendar’s state attributes](./calendar.md#styling).

Each part has a `data-slot`, such as `date-picker-input`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/date-picker#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [date-picker reference](https://ui-sdk.dev/docs/react/components/date-picker) in the upstream docs.

Pass the root's options as `@` arguments. `@value`, `@month` and `@open` are controlled with their `@on…Change` callbacks.

### DatePickerTrigger

Opens and closes the calendar. Renders a `button` with `aria-haspopup="dialog"`, named by the chosen date.

### DatePickerHint

Describes the expected format, and its state includes an example date. Renders a `span` that describes the input.

### DatePickerClear

Clears the value and focuses the input. Renders a `button`.

### DatePickerPreset

`DatePickerTrigger`, `DatePickerHint` and `DatePickerClear` take no arguments of their own.

### Controller

Create one with `createDatePickerController()` and pass it as `@controller`.

### Events

Callbacks get the new value first, then the details. A controlled value only updates when the callback didn't cancel.

| Argument                | On           | Receives                                                                                                          |
| ----------------------- | ------------ | ----------------------------------------------------------------------------------------------------------------- |
| `@onValueChange`        | `DatePicker` | `(value, details)`: the new value, and the [reason](https://ui-sdk.dev/docs/react/components/date-picker#reasons) |
| `@onOpenChange`         | `DatePicker` | `(open, details)`: whether the popup opens, and the reason                                                        |
| `@onOpenChangeComplete` | `DatePicker` | `(open)`: once the popup has finished opening or closing                                                          |
| `@onMonthChange`        | `DatePicker` | `(month, details)`: the calendar's new first month, and the reason                                                |
| `@onDismissAttempt`     | `DatePicker` | `({ reason, event })`, when a dismissal was refused                                                               |

## Accessibility

It follows the [WAI-ARIA date picker dialog](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/datepicker-dialog/): a plain text input that every screen reader handles, a button with `aria-haspopup="dialog"` and `aria-expanded` named by the date chosen, and a dialog holding the calendar's grid. Focus moves into the grid when the dialog opens and back to the button when a date is picked or Escape closes it. Every line below is an automated test.

### Keyboard

| Key             | Where   | Action                                                                        |
| --------------- | ------- | ----------------------------------------------------------------------------- |
| Enter           | Input   | Commit the typed date.                                                        |
| Alt+Down Arrow  | Input   | Open the calendar.                                                            |
| Enter / Space   | Trigger | Open or close the calendar.                                                   |
| Escape          | Popup   | Cancel an unfinished range first; otherwise close the popup.                  |
| Tab / Shift+Tab | Popup   | Move through controls. Leaving the popup closes it when dismissal is allowed. |

Opening focuses the selected date, otherwise today, otherwise the first focusable date. The calendar’s [arrow keys and month navigation](./calendar.md#keyboard) work here too. An ancestor’s `dir="rtl"` reverses Left and Right Arrow to follow the visual order.
