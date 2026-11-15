# Date Input

Type a date one part at a time, in the order your user's language writes it.

Use a Date Input for dates people know by heart, like a birthday or a booking date. Each part of the date is its own small input, ordered the way the locale writes it.

```glimmer-ts title="basic.gts"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Start date</f.Label>
    <DateInput @field={{f.field}} />
  </Field>
</template>
```

Click the month and type 11042026. Each part moves to the next as it fills. Press ArrowUp or ArrowDown on a part to step it.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

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

```glimmer-ts title="field.gts"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Birthday</f.Label>
    <DateInput @name="birthday" @field={{f.field}} />
    <f.Description>We send a card on the day.</f.Description>
  </Field>
</template>
```

Click Birthday to focus the month, then type a date. Screen readers read the description with the input.

## Date and Time

Set `@granularity` to `"hour"`, `"minute"` or `"second"` to add the time. The value becomes a local date and time like `"2026-11-02T14:30"`. For a time alone, use [Time Input](./time-input.md).

```glimmer-ts title="date-time.gts"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Departure</f.Label>
    <DateInput @granularity="minute" @defaultValue="2026-11-02T14:30" @field={{f.field}} />
  </Field>
</template>
```

Tab through the date and time. Type a P or an A in the last segment to switch between AM and PM.

## Min and Max

`@min` and `@max` take ISO dates. A date outside them is invalid: the input sets `data-invalid`, and its form won't submit.

```glimmer-ts title="min-max.gts"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Check-in</f.Label>
    <DateInput @min="2026-01-01" @max="2026-12-31" @defaultValue="2026-06-15" @field={{f.field}} />
    <f.Description>Any day in 2026.</f.Description>
    <f.Error />
  </Field>
</template>
```

Change the year of Check-in to 2027 to see it turn invalid, then back to 2026.

## Unavailable Dates

`@unavailable` takes the same matchers as [Calendar](./calendar.md#unavailable-dates): ISO dates, `{ from, to }` ranges, weekdays like `{ weekday: [0, 6] }`, or a function. An unavailable date is invalid with the message "This date isn't available."

```glimmer-ts title="unavailable.gts"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

const unavailable = { weekday: [0, 6] }

<template>
  <Field as |f|>
    <f.Label>Delivery date</f.Label>
    <DateInput @defaultValue="2026-11-02" @unavailable={{unavailable}} @field={{f.field}} />
    <f.Description>We deliver Monday to Friday.</f.Description>
    <f.Error />
  </Field>
</template>
```

Step the day of Delivery date back from Monday the 2nd to Sunday the 1st. The input turns invalid until you pick a weekday again.

## Locale

The input reads its order, separators and clock from `@locale`, or from the page's language when you leave it out. The digits are always 0 to 9, and the calendar is always the Gregorian one, so the value means the same date everywhere. On the server, the input renders in English until it reads the page's language; set `@locale` when that first render matters.

```glimmer-ts title="locale.gts"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <div data-slot="stack">
    <Field as |f|>
      <f.Label>Date (en-GB)</f.Label>
      <DateInput @locale="en-GB" @defaultValue="2026-11-02" @field={{f.field}} />
    </Field>
    <Field as |f|>
      <f.Label>Datum (de-DE)</f.Label>
      <DateInput @locale="de-DE" @defaultValue="2026-11-02" @field={{f.field}} />
    </Field>
    <Field as |f|>
      <f.Label>日付 (ja-JP)</f.Label>
      <DateInput @locale="ja-JP" @defaultValue="2026-11-02" @field={{f.field}} />
    </Field>
  </div>
</template>
```

The same date in British English, German and Japanese. Each orders its parts its own way.

## Disabled

Set `@disabled={{true}}` on the input, or on its Field or fieldset, to keep it from focus and from its form.

```glimmer-ts title="disabled.gts"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Start date</f.Label>
    <DateInput @defaultValue="2026-11-02" @disabled={{true}} @field={{f.field}} />
  </Field>
</template>
```

Click Start date or press Tab to reach it. Focus skips it, and the date stays November 2, 2026.

## Read-Only

Set `@readOnly={{true}}` for a date people can focus, read and submit as it is.

```glimmer-ts title="read-only.gts"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Signed on</f.Label>
    <DateInput @defaultValue="2026-11-02" @readOnly={{true}} @field={{f.field}} />
  </Field>
</template>
```

Focus Signed on and press ArrowUp or type a digit. The date stays the same.

## Form

A hidden input submits the ISO date under `@name`. An empty or partly typed date submits an empty string. Set `@required={{true}}` to need a date before the form submits. Enter in a segment submits the form with what was typed.

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"
import { TimeInput } from "ember-ui-sdk/time-input"
import { useLog } from "./log"

export default class Form extends Component {
  log = useLog(this)

  onsubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = [...new FormData(event.currentTarget as HTMLFormElement)].map(
      ([name, value]) => `${name}=${value}`
    )
    this.log(`Submitted ${data.join(", ")}`)
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onsubmit}}>
      <Field as |f|>
        <f.Label>Date</f.Label>
        <DateInput @name="date" @defaultValue="2026-11-02" @required={{true}} @field={{f.field}} />
        <f.Error />
      </Field>
      <Field as |f|>
        <f.Label>Time</f.Label>
        <TimeInput @name="time" @defaultValue="09:30" @required={{true}} @field={{f.field}} />
        <f.Error />
      </Field>
      <div data-slot="row">
        <button type="reset">Reset</button>
        <button type="submit" data-variant="solid">Book</button>
      </div>
    </form>
  </template>
}
```

Clear the day of Date with Backspace and choose Book to see the form stop. Fill it in and choose Book: the console logs the values. Reset brings back the defaults.

A partly typed date stops the form too, with "Enter a valid date." Set `@form` to the id of a form elsewhere in the page to submit and validate with it. A form reset restores `@defaultValue` and reports the `reset` reason.

## Controlled

Pass `@value` and update it in `@onValueChange`, which also receives the change details. Both get each whole date, and `null` once any part of it is erased. A half-typed date already reads `null`, so setting the value to `null` leaves it as typed. Call `clear()` on a controller to empty every segment.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"
import { useLog } from "./log"

export default class Controlled extends Component {
  log = useLog(this)
  @tracked value: string | null = "2026-11-02"

  clear = () => {
    this.value = null
  }

  onValueChange = (next: string | null) => {
    this.value = next
    this.log(`Due date ${next ?? "empty"}`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.clear}}>Clear</button>
      </div>
      <Field as |f|>
        <f.Label>Due date</f.Label>
        <DateInput @value={{this.value}} @onValueChange={{this.onValueChange}} @field={{f.field}} />
      </Field>
    </div>
  </template>
}
```

Change Due date: the console logs each whole date. Clear sets the value to null.

[Reasons](#reasons) lists why each change happened.

## Controller

Create a controller with `createDateInputController()` and pass it as `@controller` to set, clear or focus the input from elsewhere. `focus("year")` focuses a segment by its unit.

```glimmer-ts title="controller.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createDateInputController, DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

export default class Controller extends Component {
  publish = createDateInputController()

  christmas = () => {
    this.publish.setValue("2026-12-25")
  }

  editYear = () => {
    this.publish.focus("year")
  }

  clear = () => {
    this.publish.clear()
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.christmas}}>Christmas</button>
        <button type="button" {{on "click" this.editYear}}>Edit Year</button>
        <button type="button" {{on "click" this.clear}}>Clear</button>
      </div>
      <Field as |f|>
        <f.Label>Publish on</f.Label>
        <DateInput @controller={{this.publish}} @field={{f.field}} />
      </Field>
    </div>
  </template>
}
```

Choose Christmas to set the date, Edit Year to focus the year, or Clear to empty it.

## Custom Rendering

Render the segments yourself with a block. Its `d.state.segments` lists each segment in order, with the text between them. Render a `d.Segment` for each one that is editable, and give the text between segments content of your own.

```glimmer-ts title="segments.gts"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

<template>
  <Field as |f|>
    <f.Label>Start date</f.Label>
    <DateInput @defaultValue="2026-11-02" @field={{f.field}} as |d|>
      {{#each d.state.segments key="key" as |segment|}}
        {{#if segment.editable}}
          <d.Segment @segment={{segment}} />
        {{else}}
          <d.Segment @segment={{segment}}>–</d.Segment>
        {{/if}}
      {{/each}}
    </DateInput>
  </Field>
</template>
```

The segments here are separated by dashes in place of the locale's slashes. The order stays the locale's.

Each part's state is listed under [State](#state).

## Styling

Style the root as the field's box, and its segments inside it. Every segment sets `data-type` to its unit, so you can make the year wider or mute the text between segments, which has `data-type="literal"`. An empty segment sets `data-empty` and shows its placeholder. The root sets `data-invalid` while the date is out of range or unavailable.

Each part has a `data-slot`, such as `date-input-segment`, and its state attributes are listed under [Data Attributes](#data-attributes).

## Data Attributes

### DateInput
`[data-slot="date-input"]`

- `data-disabled`: Present when disabled, by its own prop or a `<fieldset>`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-invalid`: Present while the date is before `min`, after `max` or unavailable.
- `data-empty`: Present while every segment is empty.

### DateInputSegment
`[data-slot="date-input-segment"]`

- `data-type` (`year`, `month`, `day`, `hour`, `minute`, `second`, `dayPeriod`, `literal`): The segment's unit, or `literal` for the text between segments.
- `data-disabled`: Present when disabled, by its own prop or a `<fieldset>`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-invalid`: Present while the date is before `min`, after `max` or unavailable.
- `data-empty`: Present while the segment is empty. It shows its placeholder.

## API Reference

Pass the root's options as `@` arguments. `@value` is controlled with `@onValueChange`.

### DateInput

- `value?` (`string | null`): The value: an ISO date like `"2026-11-02"`, with a time granularity a date and time like `"2026-11-02T14:30"`, or `null`. Pass it to control the input.
- `defaultValue?` (`string | null`): The value it starts with, when uncontrolled, and goes back to when its form resets.
- `onValueChange?` (`((value: string | null, details: ChangeDetails<DateInputValueChangeReason>) => void)`): Runs when the value wants to change: once every segment holds something, and again with `null` when one is emptied. `details.cancel()` keeps the value.
- `granularity?` (`DateInputGranularity`): The smallest unit it shows. `"day"` shows a date, and `"hour"`, `"minute"` or `"second"` add the time down to it.
- `hourCycle?` (`HourCycle`): A 12 or 24 hour clock for the time. Defaults to the locale's.
- `min?` (`string`): The earliest value, as an ISO date or date and time. A value before it is invalid.
- `max?` (`string`): The latest value. A date alone takes any time that day. A value after it is invalid.
- `unavailable?` (`DateMatchers`): Dates that can't be chosen, as in Calendar: ISO dates, `{ from, to }` ranges, weekdays or a function. A value on one is invalid.
- `locale?` (`string`): The language whose order, separators and clock it shows. Defaults to the page's.
- `disabled?` (`boolean`): Whether it can't be used.
- `readOnly?` (`boolean`): Whether the value can be seen but not changed.
- `required?` (`boolean`): Whether a value must be entered before its form submits.
- `name?` (`string`): The name the value submits under.
- `form?` (`string`): The id of the form it belongs to, when it isn't inside it.
- `controller?` (`object`): Drives it from anywhere. Create one with `createDateInputController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### DateInputSegment

- `segment` (`DateInputSegmentData`): The segment it shows, from the root's `segments`.

### State

What `d.state` and the block receive.

- `value` (`string | null`): The value, or `null` while empty or partly filled.
- `segments` (`DateInputSegmentData[]`): The segments in the order the locale shows them, with the text between them. Render one part for each.
- `disabled` (`boolean`): Whether it can't be used, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether the value can be seen but not changed.
- `invalid` (`boolean`): Whether the value is before `min`, after `max` or an unavailable date.

Each segment's state, `DateInputSegmentState`, is the segment with the input's state beside it:

- `key` (`string`): Tells segments apart: the type, or `"literal-<n>"` for the text between them.
- `type` (`DateInputSegmentType`)
- `text` (`string`): What it shows: the number, padded, or AM and PM in the locale. Empty while it holds nothing.
- `value` (`number | null`): The number it holds, or `null` while empty. AM is 0 and PM is 1.
- `min` (`number`): The smallest number it takes.
- `max` (`number`): The largest number it takes, like the days in the month.
- `empty` (`boolean`): Whether it holds nothing yet.
- `editable` (`boolean`): Whether it's a segment you type in, rather than the text between segments.
- `label` (`string`): Its name in the locale, like "month", which names it to assistive technology.
- `disabled` (`boolean`): Whether it can't be used.
- `readOnly` (`boolean`): Whether its value can't be changed.
- `invalid` (`boolean`): Whether the value is before `min`, after `max` or an unavailable date.

### Reasons

`details.reason` says why the value changed.

- `input-change` (`Event`): Typing, pasting or dropping changed a text field's value; in a combobox it can also open or close it, or Enter keeps the typed text as the value.
- `step-key` (`KeyboardEvent`): Arrow, Page Up, Page Down, Home or End stepped a slider or a number input.
- `paste` (`ClipboardEvent`): Files were pasted, like a screenshot, or text and tokens into a token input.
- `reset` (`none`): A form reset.
- `restore` (`none`): The browser restored state, like after going back, or a saved value was read back from storage.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createDateInputController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like typing, and returns `false` when the change is canceled.

- `getValue()` (`() => string | null`): The value, or `null` while empty or partly filled.
- `setValue(value, options?)` (`(value: string | null, options?: DateInputChangeOptions | undefined) => boolean`): Sets the value. Returns false when it isn't a value the input can show, or when canceled.
- `clear(options?)` (`(options?: DateInputChangeOptions | undefined) => boolean`): Empties every segment.
- `focus(segment?)` (`(segment?: string | undefined) => void`): Focuses a segment, like `"month"`, or the first one.

### Events

Callbacks get the new value first, then the details. A controlled `@value` only updates when `@onValueChange` didn't cancel the change.

| Argument         | On          | Receives                                                                               |
| ---------------- | ----------- | -------------------------------------------------------------------------------------- |
| `@onValueChange` | `DateInput` | `(value, details)`: the ISO date, or null once it's erased, and the [reason](#reasons) |

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

### Tested Behavior

Every line below is an automated test.

- Each unit is a spinbutton in the locale's order.
- Another locale orders the segments its own way.
- Typing fills each segment, moves on and reports the date once.
- A press on the box or between segments focuses the nearest segment.
- A digit that can't start a longer number moves on at once.
- A separator moves to the next segment.
- Typing with separators over a filled date or time keeps every segment.
- ArrowUp and ArrowDown step a segment and wrap around.
- PageUp and PageDown take bigger steps.
- Home and End go to a segment's first and last values.
- ArrowLeft and ArrowRight move between segments.
- Tab moves through the segments, then out.
- Backspace empties a segment, then moves back.
- A day past the end of a new month is moved back to its last day.
- Pasting a date fills every segment.
- A time takes hours, minutes and AM or PM.
- A 24-hour clock has no AM or PM.
- A date with a time shows its hour and minute too.
- A controller sets and clears the date.
- A canceled change keeps the date.
- The form submits the ISO date and time under their names.
- Enter submits the form with what was typed.
- Resetting the form brings back the default date.
- A partly filled date can't be submitted.
- A required empty date can't be submitted.
- A date after max is invalid.
- An unavailable date is invalid.
- The field's label focuses the first segment.
- A read-only date takes focus but doesn't change.
- A disabled date can't be focused.

Runs in React, Vue and web components.
