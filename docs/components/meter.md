---
title: Meter
description: Show a measurement within a known range, such as storage used or an account quota.
---

Use a Meter for a value within a known range, such as storage used, a battery level or an account quota. It fills a track to show the value, and screen readers announce the same value.

[meter/basic](../../examples/components/meter/ember/basic.gts)

Read the storage meter. The label names it, and both the visible value and screen reader value report 68%.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Meter`:

```text
Meter as |m|
├── m.Label
├── m.Value
└── m.Track
    └── m.Indicator
```

- `Meter` holds the value and range.
- `m.Label` gives it a visible name. You can use `aria-label` on the root instead.
- `m.Value` displays the formatted value.
- `m.Track` gives the bar its size, and `m.Indicator` fills it.

The value is already part of the root's accessible description. The visible value is hidden from screen readers to avoid reading it twice.

## Usage

Import the root and use the parts it yields:

```gts
import { Meter } from "ember-ui-sdk/meter"

<template>
  <Meter @value={{40}} as |m|>
    <m.Label>Storage used</m.Label>
    <m.Value />
    <m.Track>
      <m.Indicator />
    </m.Track>
  </Meter>
</template>
```

`ember-ui-sdk/meter` also exports each part by name, such as `MeterLabel` and `MeterTrack`. They take the root's `@handle`, so use the parts the root yields instead.

## Bounds

`@min` and `@max` set the range. They default to 0 and 100. A value outside the range is clamped for the fill, the percentage and `aria-valuenow`, but the state's `value` and a format other than percent keep it as you passed it. Here, 720 sits about 76% of the way from 300 to 850. Decimal formatting keeps the visible value as 720.

[meter/min-max](../../examples/components/meter/ember/min-max.gts)

Compare the score with the filled track. The number shows 720; the fill shows its position between 300 and 850.

## Format and Locale

Pass `Intl.NumberFormat` options to `@format` for units, currency, or decimal places. A function can return custom text, such as the number of occupied seats.

[meter/format](../../examples/components/meter/ember/format.gts)

Compare the readings. Each meter formats its own value as a unit, currency, custom text, or localized percentage.

A percent format reports the value's position between `@min` and `@max`. Other formats use the value itself.

`@locale` controls digits and separators. If you omit it, the component reads the page's language after it mounts, with the browser's language as a fallback. The initial server and client render use English.

Set `dir="rtl"` on the surrounding content to fill the track from the right.

## Value Label

Use `@getValueLabel` when a screen reader needs more context than the visible number. It receives the value and details containing `formatted`, `percent`, `min`, and `max`.

[meter/value-label](../../examples/components/meter/ember/value-label.gts)

Read API requests with a screen reader. It announces 750 of 1000 requests and 75%, while the visible value stays compact.

## Changing the Value

Pass a new `@value` when your reading changes. Meter follows your state and has no change callback.

Use [Progress](./progress.md) for a task that is working toward completion, such as an upload.

## Custom Rendering

Pass `@render={{true}}` to a part to render your own element. The part yields `{ part, state }`: bind `part` to your element as a modifier, and read `state` to change its content. Use `@format` for text that should be shared by the visible value and screen readers.

## Styling

Give the track a height, background, and width. The indicator sets its width as an inline percentage of the track. Both styling options are shown in each example's Code tab.

Each part has a `data-slot`, such as `meter-indicator`, and no state attributes: the reading is in `--meter-value` and the indicator's width.

### Meter

The root exposes a CSS variable for positioning other content alongside the reading.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [meter reference](https://ui-sdk.dev/docs/react/components/meter) in the upstream docs.

Options are passed as arguments, such as `@value` and `@format`. Every part also takes `@render`.

## Accessibility

Name the component with `m.Label` or `aria-label`. It exposes the range and formatted value through the `meter` role. Use `@getValueLabel` when that value needs more explanation.
