# Progress

Show a task’s progress, or an indeterminate state while its progress is unknown.

```glimmer-ts title="basic.gts"
import { Progress } from "ember-ui-sdk/progress"

<template>
  <Progress @value={{60}} as |p|>
    <p.Label>Exporting video</p.Label>
    <p.Value />
    <p.Track>
      <p.Indicator />
    </p.Track>
  </Progress>
</template>
```

Read the export bar. Its label and 60% value are available both visually and to a screen reader.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Progress`:

```text
Progress as |p|
├── p.Label
├── p.Value
└── p.Track
    └── p.Indicator
```

- `Progress` holds the value and range.
- `p.Label` gives it a visible name. You can use `aria-label` on the root instead.
- `p.Value` displays the formatted value.
- `p.Track` gives the bar its size, and `p.Indicator` fills it.

The value is already part of the root's accessible description. The visible value is hidden from screen readers to avoid reading it twice.

## Usage

Import the root and use the parts it yields:

```gts
import { Progress } from "ember-ui-sdk/progress"

<template>
  <Progress @value={{40}} as |p|>
    <p.Label>Uploading photos</p.Label>
    <p.Value />
    <p.Track>
      <p.Indicator />
    </p.Track>
  </Progress>
</template>
```

`ember-ui-sdk/progress` also exports each part by name, such as `ProgressLabel` and `ProgressTrack`.

## Indeterminate

Leave out `@value` when you do not know how much work is complete. Every part gets `data-indeterminate`, and the root has no `aria-valuenow`.

The indicator has no inline width in this state. This example sweeps a short highlight across the track, and shows a still, full-width fill when reduced motion is on.

```glimmer-ts title="indeterminate.gts"
import { Progress } from "ember-ui-sdk/progress"

<template>
  <Progress @value={{null}} as |p|>
    <p.Label>Connecting to server</p.Label>
    <p.Track>
      <p.Indicator />
    </p.Track>
  </Progress>
</template>
```

Read the Connecting to server bar. It shows an ongoing task without announcing a percentage.

## Changing the Value

Pass the latest `@value` as your task progresses. The parts get `data-progressing` while the value is below `@max`, and `data-complete` when it reaches the end.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Progress } from "ember-ui-sdk/progress"
import { useLog } from "./log"

const total = 5

export default class Controlled extends Component {
  log = useLog(this)
  @tracked uploaded = 1

  get done() {
    return this.uploaded >= total
  }

  get doneText() {
    return String(this.done)
  }

  get percent() {
    return (this.uploaded / total) * 100
  }

  uploadNext = () => {
    if (this.uploaded >= total) {
      return
    }
    this.uploaded++
    this.log(`Uploaded ${this.uploaded} of ${total} photos`)
  }

  reset = () => {
    this.uploaded = 0
    this.log("Reset to 0 photos")
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button
          type="button"
          aria-disabled={{this.doneText}}
          {{on "click" this.uploadNext}}
        >Upload Next</button>
        <button type="button" {{on "click" this.reset}}>Reset</button>
      </div>
      <Progress @value={{this.percent}} as |p|>
        <p.Label>Uploading photos</p.Label>
        <p.Value />
        <p.Track>
          <p.Indicator />
        </p.Track>
      </Progress>
    </div>
  </template>
}
```

Click Upload Next to add one photo, or 20%, and watch the console count them. At 100%, the button stops advancing the bar. Click Reset to start at 0%.

Progress displays your state; it has no change callback.

## Bounds

`@min` and `@max` default to 0 and 100. A value outside that range is clamped for the fill, the percentage and `aria-valuenow`, but the state's `value` and a format other than percent keep it as you passed it. A value of 3 between 1 and 5 fills half the track.

```glimmer-ts title="min-max.gts"
import { Progress } from "ember-ui-sdk/progress"

<template>
  <Progress @value={{3}} @min={{1}} @max={{5}} as |p|>
    <p.Label>Account setup, step 3 of 5</p.Label>
    <p.Value />
    <p.Track>
      <p.Indicator />
    </p.Track>
  </Progress>
</template>
```

Compare step 3 of 5 with the fill. Because the range starts at 1, the value is halfway through the range.

## Format and Locale

Pass `Intl.NumberFormat` options to `@format` for units or decimal places. A function can return custom text, such as the time remaining.

```glimmer-ts title="format.gts"
import { Progress } from "ember-ui-sdk/progress"

const bars = [
  {
    label: "Download",
    value: 120,
    max: 250,
    format: { style: "unit" as const, unit: "gigabyte" },
  },
  {
    label: "Video render",
    value: 87.25,
    format: { style: "percent" as const, maximumFractionDigits: 1 },
  },
  {
    label: "Backup",
    value: 45,
    max: 60,
    format: (minutes: number) => `${60 - minutes} min left`,
  },
  { label: "Synchronisierung", value: 40, locale: "de-DE" },
]

<template>
  <div data-slot="stack">
    {{#each bars key="label" as |item|}}
      <Progress
        @value={{item.value}}
        @max={{item.max}}
        @format={{item.format}}
        @locale={{item.locale}}
        as |p|
      >
        <p.Label>{{item.label}}</p.Label>
        <p.Value />
        <p.Track>
          <p.Indicator />
        </p.Track>
      </Progress>
    {{/each}}
  </div>
</template>
```

Compare the progress readings. They show downloaded data, a precise percentage, time remaining, and a localized percentage.

A percent format reports the value's position between `@min` and `@max`. Other formats use the value itself.

`@locale` controls digits and separators. If you omit it, the component reads the page's language after it mounts, with the browser's language as a fallback. The initial server and client render use English.

Set `dir="rtl"` on the surrounding content to fill the track from the right.

## Value Label

Use `@getValueLabel` to give screen readers more context than the visible number. Its details include `formatted`, `percent`, `min`, and `max`. Handle a `null` value when the task can be indeterminate; `percent` is also `null` and `formatted` is empty then.

```glimmer-ts title="value-label.gts"
import { Progress } from "ember-ui-sdk/progress"

const valueLabel = (
  value: number | null,
  details: { max: number; formatted: string }
) => `${value} of ${details.max} files, ${details.formatted}`

<template>
  <Progress @value={{3}} @max={{12}} @getValueLabel={{valueLabel}} as |p|>
    <p.Label>Copying files</p.Label>
    <p.Value>3 of 12</p.Value>
    <p.Track>
      <p.Indicator />
    </p.Track>
  </Progress>
</template>
```

Read Copying files with a screen reader. It announces 3 of 12 files and 25%, while the visible value stays compact.

Use [Meter](./meter.md) for a reading such as storage used, rather than a task that will finish.

## Custom Rendering

Pass `@render={{true}}` to a part to render your own element. The part yields `{ part, state }`: bind `part` to your element as a modifier, and read `state` to change its content. Use `@format` for text that should be shared by the visible value and screen readers.

## Styling

Give the track a height, background, and width. The indicator sets its width as an inline percentage of the track. Style `data-indeterminate` for a task whose progress is unknown, since the indicator has no width then, and `data-complete` once the task finishes. Both styling options are shown in each example's Code tab.

Each part has a `data-slot`, such as `progress-indicator`, and its state attributes are listed under [Data Attributes](#data-attributes).

### Progress
The root exposes a CSS variable for positioning other content alongside the reading.

- `--progress-value`: Where the value sits between `min` and `max`, as a percentage, like 40%. Unset while indeterminate.

## Data Attributes

### Progress
`[data-slot="progress"]`

- `data-indeterminate`: Present while the value is null: the task is under way, but how far is unknown.
- `data-progressing`: Present while the value is below `max`.
- `data-complete`: Present once the value reaches `max`.

### ProgressLabel
`[data-slot="progress-label"]`

- `data-indeterminate`: Present while the value is null: the task is under way, but how far is unknown.
- `data-progressing`: Present while the value is below `max`.
- `data-complete`: Present once the value reaches `max`.

### ProgressValue
`[data-slot="progress-value"]`

- `data-indeterminate`: Present while the value is null: the task is under way, but how far is unknown.
- `data-progressing`: Present while the value is below `max`.
- `data-complete`: Present once the value reaches `max`.

### ProgressTrack
`[data-slot="progress-track"]`

- `data-indeterminate`: Present while the value is null: the task is under way, but how far is unknown.
- `data-progressing`: Present while the value is below `max`.
- `data-complete`: Present once the value reaches `max`.

### ProgressIndicator
`[data-slot="progress-indicator"]`

- `data-indeterminate`: Present while the value is null: the task is under way, but how far is unknown.
- `data-progressing`: Present while the value is below `max`.
- `data-complete`: Present once the value reaches `max`.

## API Reference

Options are the same as below, as arguments, such as `@value` and `@format`. Every part also takes `@render`.

### Progress

- `min?` (`number`): The lowest value.
- `max?` (`number`): The highest value.
- `format?` (`NumberFormat`): How the value reads, for screen readers and the Value part: `Intl.NumberFormat` options, or a function of the value. A percent style shows where the value sits between `min` and `max`; any other style shows the value itself, like `{ style: "unit", unit: "gigabyte" }`.
- `locale?` (`string`): The locale the value is formatted in. Defaults to the page's `lang`, or the browser's language without one, once the page is interactive. Server markup uses English until then, so it never disagrees with the client.
- `getValueLabel?` (`((value: number | null, details: GaugeLabelDetails<number | null>) => string)`): The text screen readers announce for the value, when the formatted value says too little, like "3 of 12 files". It receives the value, null while a progress bar is indeterminate, and details: the `formatted` value, its `percent`, `min` and `max`.
- `value?` (`number | null`): How far the task has come, between `min` and `max`. Null means it's under way but how far is unknown, and the bar is indeterminate.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### State

What `@render={{true}}` yields as `state`. Every part gets the same state.

- `value` (`number | null`): The value, or null while indeterminate.
- `percent` (`number | null`): Where the value sits between `min` and `max`, from 0 to 100, or null while indeterminate.
- `status` (`ProgressStatus`): Whether the progress is unknown, under way, or done.

`ProgressValue` adds the formatted text:

- `value` (`number | null`): The value, or null while indeterminate.
- `percent` (`number | null`): Where the value sits between `min` and `max`, from 0 to 100, or null while indeterminate.
- `status` (`ProgressStatus`): Whether the progress is unknown, under way, or done.
- `text` (`string`): The formatted value, like "40%". Empty while indeterminate.

## Accessibility

Name the component with `p.Label` or `aria-label`. It exposes the range and formatted value through the `progressbar` role. Use `@getValueLabel` when that value needs more explanation.

### Tested Behavior

Every line below is an automated test.

- A progress bar is named by its label and reads its value.
- The value part shows the formatted value.
- The indicator is as wide as the value.
- A new value updates the bar.
- Every part says whether the task is under way, done, or unknown.
- An indeterminate bar has no value.
- A unit format reads the value itself.
- A value label replaces the formatted value for screen readers.
- A value above the maximum reads as the maximum.

Runs in React, Vue and web components.
