---
title: Label
description: Name any control with a label, and let a press on the label reach it.
---

A plain `<label>` only reaches inputs, buttons and selects. Label names any control by its `for`, including a radio group or a slider, and a press on the label moves focus into it.

[label/basic](../../examples/components/label/ember/basic.gts)

Press Shipping speed. Focus moves to the checked option, and a screen reader names the group Shipping speed.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Usage

Import the label and point its `for` at the control's `id`:

```gts
import { Label } from "ember-ui-sdk/label"
import { RadioGroup } from "ember-ui-sdk/radio"

<template>
  <Label for="plan">Plan</Label>
  <RadioGroup id="plan" @defaultValue="pro" as |g|>
    <g.Radio @value="free" as |r|>…</g.Radio>
    <g.Radio @value="pro" as |r|>…</g.Radio>
  </RadioGroup>
</template>
```

Label renders a native `<label>`. When the browser can reach the control on its own, like an input, it does. For anything else, the control takes the label as its name, and a press on the label focuses it, checks it or clicks it, as a native label would.

Inside a [Field](./field.md), use the field's own label part, which also ties the field's description and errors to the control.

## Slider

A label for a slider names its thumb, so the thumb reads as **Volume**, and a press on the label focuses it.

[label/slider](../../examples/components/label/ember/slider.gts)

Press Volume, then use the arrow keys. The thumb moves, and a screen reader reads it as Volume.

## Switch

Point the label at a switch beside it. A press on the label turns the switch on and off.

[label/switch](../../examples/components/label/ember/switch.gts)

Press Email me product updates. The switch turns on.

## Wrapping a Control

Put the control inside the label instead of pointing at it, and you need no `id`.

[label/wrap](../../examples/components/label/ember/wrap.gts)

Press Accept terms and conditions. The checkbox checks, and a double click doesn't select the text.

## Custom Rendering

Pass `@render={{true}}` to use a different element, such as a `<span>`, and spread the part onto it with `{{l.part}}`. A label that isn't a `<label>` still names its control and reaches it on a press.

## Styling

The label is unstyled. It has a `data-slot` of `label`.

A double click on the label doesn't select its text, so you don't need `user-select: none` for that.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [label reference](https://ui-sdk.dev/docs/react/components/label) in the upstream docs.

Options are passed as arguments, along with a native label's `for`.

## Accessibility

A native `<label>` names the element its `for` points at only when that element is labelable, like an input or a button. Label names any other control through `aria-labelledby`, unless the control has an `aria-label` or an `aria-labelledby` of its own, which win. Its press does what a native label's does: it checks a checkbox, a switch or a radio, focuses a group's checked radio, and focuses anything else. A press on a disabled control does nothing.
