---
title: Color Picker
description: Choose a color by dragging across an area and along sliders, typing any CSS color, or picking a preset.
---

Use a color picker to choose a color, like a brand or theme color. The value is a CSS color string, and every part edits it: an area for two channels at once, a slider per channel, a text input that reads any CSS color, and presets.

[color-picker/basic](../../examples/components/color-picker/ember/basic.gts)

Drag across the area or along the sliders, or choose a preset. Choose HSL to write the color another way, or type one like rebeccapurple and press Enter.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `ColorPicker`:

```text
ColorPicker as |c|
├── c.Area as |a|
│   ├── a.Canvas
│   └── a.Thumb
├── c.Slider
│   └── s.Thumb
├── c.Swatch
├── c.Input
├── c.ChannelInput
├── c.EyeDropper
└── c.Swatches
    ├── c.SwatchItem
    └── c.SwatchItem
```

Every part is optional, so use the ones your picker needs.

- **ColorPicker** holds the value and is a group around the parts.
- **c.Area** edits two channels, like saturation across and brightness up. A press moves the thumb there and starts a drag. Its background is `--color-area-background`, so give it a size and that background.
- **a.Canvas** paints the area pixel by pixel, for channels no gradient can draw, like OKLCH's chroma and lightness.
- **a.Thumb** shows where the color sits in the area. It's a slider that screen readers hear as both channels.
- **c.Slider** edits one `@channel`, like `hue` or `alpha`, drawn by `--color-slider-background`.
- **s.Thumb** shows where the channel sits along its slider.
- **c.Swatch** shows the color, named for screen readers, like "vivid blue".
- **c.Input** reads any CSS color when you press Enter or leave it. Text that isn't a color goes back to the value.
- **c.ChannelInput** edits one `@channel` as a number, in the units people read it in, like 0 to 255 for red.
- **c.EyeDropper** picks a color from anywhere on the screen, where the browser can.
- **c.Swatches** and **c.SwatchItem** are a list of preset colors.

Each part writes the color as `--color-picker-color`, so a thumb or a swatch fills itself with `background: var(--color-picker-color)`. The picker also renders a hidden input that the form submits.

## Usage

Import the root and use the parts it yields:

```gts
import { ColorPicker } from "ember-ui-sdk/color-picker"

<template>
  <ColorPicker @defaultValue="#0ea5e9" aria-label="Brand color" as |c|>
    <c.Area as |a|>
      <a.Thumb />
    </c.Area>
    <c.Slider @channel="hue" as |s|>
      <s.Thumb />
    </c.Slider>
    <c.Input aria-label="Hex" />
  </ColorPicker>
</template>
```

Name the picker with `aria-label`, or put it in a [Field](./field.md) whose label names it. Without `@defaultValue`, it starts at black.

## Spaces and Channels

`@space` decides which channels the parts edit, and what the value is written in:

| `@space` | Area, across and up    | Slider | Value written as              |
| -------- | ---------------------- | ------ | ----------------------------- |
| `hsv`    | saturation, brightness | hue    | hex, like `#0ea5e9`           |
| `hsl`    | saturation, lightness  | hue    | `hsl(198.63 88.66% 48.43%)`   |
| `srgb`   | red, green             | blue   | `rgb(14 165 233)`             |
| `oklch`  | chroma, lightness      | hue    | `oklch(0.6847 0.1479 237.32)` |

Set `@format` to write the value another way, like `@format="hex"` in any space. Every space has an `alpha` channel too. Set `@x` and `@y` on the area, or `@channel` on a slider, to edit other channels:

```gts
<ColorPicker @space="hsl" @defaultValue="hsl(220 60% 50%)" aria-label="Background" as |c|>
  <c.Area @x="hue" @y="lightness" as |a|>
    <a.Canvas />
    <a.Thumb />
  </c.Area>
  <c.Slider @channel="saturation" @orientation="vertical" as |s|>
    <s.Thumb />
  </c.Slider>
</ColorPicker>
```

The parts keep a hue while the color turns gray or black, so dragging back out of a corner returns to the same hue.

## OKLCH

OKLCH spaces its colors evenly for the eye, so two colors with the same lightness look equally bright. Its edge with the colors a screen can show is a curve, which no gradient can draw. Add `a.Canvas` to the area, and it paints the colors inside that edge and leaves the rest clear.

[color-picker/oklch](../../examples/components/color-picker/ember/oklch.gts)

Drag the thumb right, past the painted edge, and let go. The thumb moves back to the closest color inside.

While a drag holds a color past the edge, the value is already the closest color inside it, and every part has `data-out-of-gamut`. Once the drag ends, the thumb moves to that color. Colors stay inside sRGB by default. Set `@gamut="p3"` for wide-gamut screens, or `@gamut={{false}}` to allow any color:

```gts
<ColorPicker
  @space="oklch"
  @gamut="p3"
  @defaultValue="oklch(0.7 0.25 150)"
  aria-label="Accent"
  as |c|
>…</ColorPicker>
```

## Presets and Channel Inputs

Put `c.SwatchItem`s inside `c.Swatches` for preset colors. Each one is selected while the value is its color, however either is written, so `#0000ff` selects `rgb(0 0 255)`. The list is one tab stop, and the arrow keys move between the presets.

`c.ChannelInput` edits one channel as a number and sets it on Enter, when you leave it, or with its arrows. `c.EyeDropper` picks from the screen in browsers that can. Elsewhere it's disabled, with `data-unsupported`, so you can hide it.

[color-picker/swatches](../../examples/components/color-picker/ember/swatches.gts)

Choose a preset, or use the arrow keys between them. Type 255 into the first number to set red.

## Popover

Put a `Popover` inside the picker to open it from a swatch. The parts inside the popup edit the same color, and the swatch in the trigger shows it.

[color-picker/popover](../../examples/components/color-picker/ember/popover.gts)

Press the Background swatch to open the picker, then drag to change the color.

## Disabled

Set `@disabled={{true}}`. A disabled picker can't be focused or changed, and isn't submitted. A disabled `<fieldset>` around it disables it too.

[color-picker/disabled](../../examples/components/color-picker/ember/disabled.gts)

The thumbs can't be focused or dragged.

Set `@readOnly={{true}}` to keep the parts focusable and the value submitted, while drags, keys and typing leave the color alone.

## Controlled

Pass `@value` and update it in `@onValueChange`, which also receives the details. Each change carries a [reason](https://ui-sdk.dev/docs/react/components/color-picker#reasons), like `drag`, `step-key` or `input-commit`, and `details.color`, the color the parts hold, which keeps a hue while the value turns gray. Call `details.cancel()` in the callback to keep the current value.

`@onValueChange` runs on every step of a drag. `@onValueCommit` runs once, when the drag, key press or typed color ends, so use it to save. A controller from `createColorPickerController()` sets the color from anywhere with `setValue()`, like the Use Purple button in the example.

[color-picker/controlled](../../examples/components/color-picker/ember/controlled.gts)

Drag across the area and let go, or press Use Purple. The console logs each committed color and its reason.

## Form

The hidden input submits the value under `@name`, like `#f97316`, and a disabled picker submits nothing. A form reset returns it to `@defaultValue`. Set `@form` to join a form by its id.

[color-picker/form](../../examples/components/color-picker/ember/form.gts)

Change the color and press Save to log the submitted value. Reset restores the orange.

A color picker always has a value, so `@required` only adds `data-required`.

## Custom Rendering

Pass `@render={{true}}` to a part to render it as your own element. It yields `{ part, state }`: bind `part` to your element as a modifier, and read the state in the block. A slider thumb's state has its `channelValue`, a preset's has whether it's `selected`, and every part has the `color` and whether it's `outOfGamut`.

See [State](https://ui-sdk.dev/docs/react/components/color-picker#state) for each part's fields.

## Styling

Parts are unstyled, apart from the positions they need: thumbs get `position: absolute` and their place in percent, as inline styles. Give the area and sliders a size and their background variable, and center each thumb on its point with `translate: -50% -50%`.

Each part has a `data-slot`, such as `color-picker-area`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/color-picker#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [color-picker reference](https://ui-sdk.dev/docs/react/components/color-picker) in the upstream docs.

Pass the root's options as `@` arguments. `@value` is controlled with `@onValueChange`.

### Controller

Create one with `createColorPickerController()` and pass it as `@controller`.

`setValue()` takes any CSS color and an optional `{ reason, event }`, runs the change callback like a drag, and returns `false` when the color can't be read or the change is canceled.

### Events

Callbacks get the new value first, then the details. A controlled `@value` only updates when `@onValueChange` wasn't canceled.

| Argument         | On            | Receives                                                                                                                           |
| ---------------- | ------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| `@onValueChange` | `ColorPicker` | `(value, details)`: the new value, the [reason](https://ui-sdk.dev/docs/react/components/color-picker#reasons) and `details.color` |
| `@onValueCommit` | `ColorPicker` | `(value, details)`: the value once the interaction ends, its reason and `details.color`                                            |

## Accessibility

No WAI-ARIA pattern covers a color picker, so it's built from ones that do. The picker is a group. The area's thumb and each slider's thumb follow the [WAI-ARIA slider pattern](https://www.w3.org/WAI/ARIA/apg/patterns/slider/), and the area's thumb names both of its channels, like "Saturation 76%, Brightness 96%". The presets follow the [listbox pattern](https://www.w3.org/WAI/ARIA/apg/patterns/listbox/), and each one is named by its color, like "vivid red", as is `c.Swatch`.

The thumbs, inputs and presets are named in English by default. Pass `aria-label` to name them in another language.

### Keyboard

| Key                  | Does                                                                                          |
| -------------------- | --------------------------------------------------------------------------------------------- |
| Arrow keys           | Move a thumb one step. On the area, Left and Right move across, Up and Down move up and down. |
| Shift with an arrow  | Moves ten steps                                                                               |
| Page Up or Page Down | Moves a tenth of the range, up the area or along a slider                                     |
| Home or End          | Moves to the start or end, across the area or along a slider                                  |
| Enter                | Reads the text in the input, or picks the focused preset                                      |
| Escape               | Puts the input's text back to the value                                                       |

Each key press commits, like the end of a drag.
