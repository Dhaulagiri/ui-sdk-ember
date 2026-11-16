---
title: Slider
description: Adjust a number or a range with draggable thumbs and keyboard controls.
---

Use a slider to pick a number or a range along a scale, like a volume or a price range, by dragging a thumb or with the arrow keys.

[slider/basic](../../examples/components/slider/ember/basic.gts)

Drag the thumb, or focus it and use the arrow keys, to adjust Volume.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Slider`:

```text
Slider as |s|
├── s.Value
└── s.Control
    └── s.Track
        ├── s.Indicator
        └── s.Thumb
```

A control handles presses around the track. Put a thumb on that track for each value.

- **Slider** holds the value and is a group around the thumbs.
- **s.Control** is where presses land. Pressing it moves the nearest thumb and starts a drag. Give it some height around a thin track.
- **s.Track** is the rail the thumbs move along. Thumbs and the indicator are placed in percentages of it with inline styles, so give it a size. It's the positioned box.
- **s.Indicator** fills the track up to a single thumb, or between the first and last thumb of a range.
- **s.Thumb** is what you drag. Give each one a size.
- **s.Value** shows the formatted value, and a range joined with an en dash. It's optional.

Each thumb renders a visually hidden `<input type="range">` inside itself. That input is what takes focus, so screen readers on phones adjust it with their own gestures. Style focus on the thumb with `:has(:focus-visible)`. The slider also renders a hidden input that the form submits.

A single thumb is named by a `f.Label` in a `Field`, or by `aria-label` on the thumb. In a range, give each thumb its own `aria-label`, like "Minimum price", and name the group with a `f.Label` or `aria-label` on the slider.

## Usage

Import the root and use the parts it yields:

```gts
import { Slider } from "ember-ui-sdk/slider"

<template>
  <Slider @defaultValue={{50}} as |s|>
    <s.Value />
    <s.Control>
      <s.Track>
        <s.Indicator />
        <s.Thumb aria-label="Volume" />
      </s.Track>
    </s.Control>
  </Slider>
</template>
```

## Range

Pass an array for a range, then render one thumb per number. Give each thumb its `@index`, from 0, and its own name, like "Minimum price". The indicator fills the space between the first and the last thumb, and the `f.Label` names the group.

[slider/range](../../examples/components/slider/ember/range.gts)

Move either end of Price. The thumbs stay in order.

## Multiple Thumbs

Any number of thumbs works the same way. They never pass each other, and a press on the track moves the nearest one.

[slider/multiple](../../examples/components/slider/ember/multiple.gts)

Adjust Low, Medium and High independently, without moving one past another.

## Vertical

Set `@orientation="vertical"` and give the slider a height. The bottom is the minimum, ArrowUp increases the value, and every part gets `data-orientation`, so `[data-orientation="vertical"]` styles the vertical axis.

[slider/vertical](../../examples/components/slider/ember/vertical.gts)

Drag up or down, or use the arrow keys, to adjust Bass and Treble.

## Field

Put the slider in a `Field`. The label names the thumb, the description describes it, and `s.Value` shows the value beside the label. Screen readers don't announce `s.Value` as it changes, since the thumb already says its value.

[slider/field](../../examples/components/slider/ember/field.gts)

Click the Volume label to focus the thumb, then use the arrow keys to change the value.

## Disabled

Set `@disabled={{true}}`. A disabled slider can't be focused or moved, and isn't submitted. A disabled fieldset around it disables it too.

[slider/disabled](../../examples/components/slider/ember/disabled.gts)

Brightness keeps its value, but can't be focused or dragged.

## Controlled

Pass `@value` and update it in `@onValueChange` to control the slider. The value keeps its shape: a number stays a number and an array stays an array. Every change carries a [reason](https://ui-sdk.dev/docs/react/components/slider#reasons), like `drag`, `track-press` or `step-key`, and `details.thumb` says which thumb moved. Call `details.cancel()` to keep the current value.

[slider/controlled](../../examples/components/slider/ember/controlled.gts)

Drag either Temperature thumb to log the range and its reason. Reset sets the value from outside.

## Step and Bounds

`@min` and `@max` set the bounds, 0 and 100 by default, and `@step` sets how far one step moves, counted from `@min`. Decimal steps avoid floating-point drift, so a 0.1 step can reach 0.3 cleanly. When the steps from `@min` don't land on `@max`, the highest step below it is the end.

[slider/step](../../examples/components/slider/ember/step.gts)

Move Year in steps of five, and Opacity in steps of 0.05.

## Large Step

Arrow keys move one step. Page Up, Page Down and Shift with an arrow key move by `@largeStep`, which is ten steps unless you set it. Home and End go to the bounds.

[slider/large-step](../../examples/components/slider/ember/large-step.gts)

Focus Zoom and press an arrow key to move 1%, then Page Up, Page Down or Shift with an arrow key to move 25%.

## Distance Between Thumbs

Set `@minStepsBetweenThumbs` to keep neighbouring thumbs that many steps apart. A thumb stops at its neighbour, and Home and End move it only as far as its neighbour allows.

[slider/min-steps](../../examples/components/slider/ember/min-steps.gts)

Move either end of Opening hours. The thumbs stay at least four hours apart.

## Format and Locale

`@format` takes `Intl.NumberFormat` options, like `{ style: "currency", currency: "USD" }` or `{ style: "percent" }`, or a function of the value. It sets what `s.Value` shows and what screen readers announce for each thumb, while the value stays a plain number. `@locale` sets separators, digits and symbol placement. Without it, the slider uses the page's `lang`, or the browser's language, once the page is interactive. Server markup uses English until then, so it never disagrees with the client.

[slider/format](../../examples/components/slider/ember/format.gts)

Adjust Budget, Opacity, Weight, Duration and Preis to compare currency, a percentage, a unit, a custom function and German formatting.

## Saving on Commit

`@onValueChange` runs on every step of a drag. `@onValueCommit` runs once, when the interaction that changed the value ends: the pointer lifts, the key comes up, or a screen reader adjusts it. Use the commit callback to save once per interaction. A press that doesn't change the value commits nothing.

[slider/commit](../../examples/components/slider/ember/commit.gts)

Drag Brightness and release it, or press an arrow key. The console logs the value once, when you let go.

## Controller

A controller, from `createSliderController()` and passed as `@controller`, moves the slider from anywhere with `setValue()`, reads it with `getValue()` and focuses a thumb with `focus()`. Values set through it are clamped, snapped to the step and sorted, and reported with the `imperative` reason.

[slider/controller](../../examples/components/slider/ember/controller.gts)

Use Mute, Louder and Focus to operate Volume from outside the slider. The console logs each change with the imperative reason, and Read logs the value.

## Form

A hidden input beside the slider is what the form sees. It takes the slider's `@name`, `@form` and `@disabled`, so `FormData`, `form.reset()`, a disabled fieldset and the browser's restore all work.

- **Submit:** a single thumb submits its number under `@name`, like `40`. A range submits `"start/end"`, like `200/800`. Without a name, it submits nothing.
- **Reset:** a form reset returns it to `@defaultValue`, with the `reset` reason.
- **Join a form from elsewhere:** set `@form` to the id of a form.

`@required={{true}}` adds `data-required`. A slider always has a value, so it never blocks a form.

[slider/form](../../examples/components/slider/ember/form.gts)

Adjust the filters and press Save to log the submitted values. Distance sits outside the form and joins it by id. Reset restores the defaults.

## Read-Only

Set `@readOnly={{true}}` to keep the slider focusable and submitted, while drags, keys and screen reader adjustments leave its value alone.

```gts
<Field as |f|>
  <f.Label>Storage</f.Label>
  <Slider @name="storage" @defaultValue={{50}} @readOnly={{true}} @field={{f.field}} as |s|>
    <s.Control>
      <s.Track>
        <s.Indicator />
        <s.Thumb />
      </s.Track>
    </s.Control>
  </Slider>
  <f.Description>Set by your plan.</f.Description>
</Field>
```

## Custom Rendering

Pass `@render={{true}}` to a part to render your own element. The part yields `{ part, state }`: bind `part` to the element, and read `state` to change its content. The state includes whether a thumb is being dragged, its `thumbValue` and its `percent` along the track. Here the thumb renders a `span`, and a bubble shows its value above it.

[slider/render](../../examples/components/slider/ember/render.gts)

Focus or drag the Brightness thumb to show its value above it.

See [State](https://ui-sdk.dev/docs/react/components/slider#state) for each part's fields.

## Styling

Parts are unstyled, apart from the positions they need: thumbs and the indicator get `position: absolute` and their place along the track in percent, as inline styles. Give the control some height around a thin track, the track a size and a background, and each thumb a size. The thumb's range input is what takes focus, so draw the focus ring on the thumb with `:has(:focus-visible)`, and style a drag with `data-dragging`.

Each part has a `data-slot`, such as `slider-thumb`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/slider#data-attributes).

The indicator and thumbs also write CSS variables, for anything else that should follow them, like a label above a thumb.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [slider reference](https://ui-sdk.dev/docs/react/components/slider) in the upstream docs.

Options and callbacks are passed as arguments: `@value`, `@onValueChange`. Every part also takes `@render`.

### Controller

Create one with `createSliderController()` and pass it as `@controller`.

`setValue()` takes an optional `{ reason, event }`, runs the change callback like a drag, and returns `false` when the change is canceled.

### Events

Callbacks get the new value first, then the details.

| Argument         | On       | Receives                                                                                                                     |
| ---------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `@onValueChange` | `Slider` | `(value, details)`: the new value, the [reason](https://ui-sdk.dev/docs/react/components/slider#reasons) and `details.thumb` |
| `@onValueCommit` | `Slider` | `(value, details)`: the value once the interaction ends, its reason and `details.thumb`                                      |

## Accessibility

The slider follows the [WAI-ARIA slider pattern](https://www.w3.org/WAI/ARIA/apg/patterns/slider/), and the [multi-thumb slider pattern](https://www.w3.org/WAI/ARIA/apg/patterns/slider-multithumb/) for ranges. Each thumb is a native range input, named by a `f.Label` or its own `aria-label`, and the slider is a group around them.

### Keyboard

Focus a thumb to use these keys. Tab moves through the thumbs in order.

| Key                                        | Moves the thumb                                                       |
| ------------------------------------------ | --------------------------------------------------------------------- |
| ArrowRight or ArrowUp                      | One `@step` up. In right to left, ArrowRight moves down.              |
| ArrowLeft or ArrowDown                     | One `@step` down. In right to left, ArrowLeft moves up.               |
| Page Up, Page Down, or Shift with an arrow | By `@largeStep`, ten steps by default.                                |
| Home or End                                | To the minimum or maximum, or as far as a neighbouring thumb lets it. |
