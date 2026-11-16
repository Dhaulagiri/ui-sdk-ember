---
title: Progress
description: Show a task’s progress, or an indeterminate state while its progress is unknown.
---

[progress/basic](../../examples/components/progress/ember/basic.gts)

Read the export bar. Its label and 60% value are available both visually and to a screen reader.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

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

`ember-ui-sdk/progress` also exports each part by name, such as `ProgressLabel` and `ProgressTrack`. They take the root's `@handle`, so use the parts the root yields instead.

## Indeterminate

Leave out `@value` when you do not know how much work is complete. Every part gets `data-indeterminate`, and the root has no `aria-valuenow`.

The indicator has no inline width in this state. This example sweeps a short highlight across the track, and shows a still, full-width fill when reduced motion is on.

[progress/indeterminate](../../examples/components/progress/ember/indeterminate.gts)

Read the Connecting to server bar. It shows an ongoing task without announcing a percentage.

## Changing the Value

Pass the latest `@value` as your task progresses. The parts get `data-progressing` while the value is below `@max`, and `data-complete` when it reaches the end.

[progress/controlled](../../examples/components/progress/ember/controlled.gts)

Click Upload Next to add one photo, or 20%, and watch the console count them. At 100%, the button stops advancing the bar. Click Reset to start at 0%.

Progress displays your state; it has no change callback.

## Bounds

`@min` and `@max` default to 0 and 100. A value outside that range is clamped for the fill, the percentage and `aria-valuenow`, but the state's `value` and a format other than percent keep it as you passed it. A value of 3 between 1 and 5 fills half the track.

[progress/min-max](../../examples/components/progress/ember/min-max.gts)

Compare step 3 of 5 with the fill. Because the range starts at 1, the value is halfway through the range.

## Format and Locale

Pass `Intl.NumberFormat` options to `@format` for units or decimal places. A function can return custom text, such as the time remaining.

[progress/format](../../examples/components/progress/ember/format.gts)

Compare the progress readings. They show downloaded data, a precise percentage, time remaining, and a localized percentage.

A percent format reports the value's position between `@min` and `@max`. Other formats use the value itself.

`@locale` controls digits and separators. If you omit it, the component reads the page's language after it mounts, with the browser's language as a fallback. The initial server and client render use English.

Set `dir="rtl"` on the surrounding content to fill the track from the right.

## Value Label

Use `@getValueLabel` to give screen readers more context than the visible number. Its details include `formatted`, `percent`, `min`, and `max`. Handle a `null` value when the task can be indeterminate; `percent` is also `null` and `formatted` is empty then.

[progress/value-label](../../examples/components/progress/ember/value-label.gts)

Read Copying files with a screen reader. It announces 3 of 12 files and 25%, while the visible value stays compact.

Use [Meter](./meter.md) for a reading such as storage used, rather than a task that will finish.

## Custom Rendering

Pass `@render={{true}}` to a part to render your own element. The part yields `{ part, state }`: bind `part` to your element as a modifier, and read `state` to change its content. Use `@format` for text that should be shared by the visible value and screen readers.

## Styling

Give the track a height, background, and width. The indicator sets its width as an inline percentage of the track. Style `data-indeterminate` for a task whose progress is unknown, since the indicator has no width then, and `data-complete` once the task finishes. Both styling options are shown in each example's Code tab.

Each part has a `data-slot`, such as `progress-indicator`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/progress#data-attributes).

### Progress

The root exposes a CSS variable for positioning other content alongside the reading.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [progress reference](https://ui-sdk.dev/docs/react/components/progress) in the upstream docs.

Options are passed as arguments, such as `@value` and `@format`. Every part also takes `@render`.

## Accessibility

Name the component with `p.Label` or `aria-label`. It exposes the range and formatted value through the `progressbar` role. Use `@getValueLabel` when that value needs more explanation.
