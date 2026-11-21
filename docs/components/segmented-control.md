---
title: Segmented Control
description: Pick one of a few options from a row of buttons, with an indicator that slides to the choice.
---

Use a segmented control to switch between a few views or settings, like List and Grid. It works like a radio group, with one value and a single tab stop, and its indicator slides to the checked item.

[segmented-control/basic](../../examples/components/segmented-control/ember/basic.gts)

Choose Grid, then use the arrow keys to move between views. The label above names the control, as in any field.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `SegmentedControl`:

```text
SegmentedControl as |s|
├── s.Indicator
├── s.Item
└── s.Item
```

Give each item a `@value`. The control's value is the checked item's value, and the indicator sits behind that item.

## Usage

Import the root and use the parts it yields:

```gts
import { SegmentedControl } from "ember-ui-sdk/segmented-control"

<template>
  <SegmentedControl aria-label="View" @defaultValue="list" as |s|>
    <s.Indicator />
    <s.Item @value="list">List</s.Item>
    <s.Item @value="grid">Grid</s.Item>
  </SegmentedControl>
</template>
```

Name the control with `aria-label`, or put it in a [Field](./field.md) whose label names it. Without `@defaultValue`, nothing starts checked and Tab enters on the first enabled item.

## Indicator

`s.Indicator` measures the checked item. Position it inside the control and use its [CSS variables](https://ui-sdk.dev/docs/react/components/segmented-control#segmentedcontrolindicator) to draw the background that slides to the choice. It measures again when an item or the control changes size, and has no box while nothing is checked.

```css
[data-slot="segmented-control"] {
  position: relative;
  display: inline-flex;
  isolation: isolate;
}

[data-slot="segmented-control-indicator"] {
  position: absolute;
  z-index: -1;
  top: var(--segmented-control-indicator-top);
  left: var(--segmented-control-indicator-left);
  width: var(--segmented-control-indicator-width);
  height: var(--segmented-control-indicator-height);
  transition-property: top, left, width, height;
  transition-duration: 200ms;

  &[data-activation-direction="none"] {
    transition: none;
  }
}
```

Skip the transitions while `data-activation-direction` is `"none"`, so the indicator doesn't slide in on its first placement. After that it says which way the checked item moved: `left`, `right`, `up` or `down`.

## Vertical

Set `@orientation="vertical"` to stack the items. Arrow keys on both axes still move between them, as in any radio group, and `data-orientation` on every part lets one stylesheet lay out both directions.

[segmented-control/vertical](../../examples/components/segmented-control/ember/vertical.gts)

Choose Bottom, then press the Up arrow. The indicator follows down the column.

## Disabled

Set `@disabled={{true}}` on the control or on one item. Disabled items can't be focused or checked, and arrow keys skip them. A disabled control submits nothing.

[segmented-control/disabled](../../examples/components/segmented-control/ember/disabled.gts)

The Theme control is disabled. In Billing period, Lifetime is disabled, so the arrow keys move between Monthly and Yearly.

## Controlled

Pass `@value` and update it in `@onValueChange` for the reason. Call `details.cancel()` in the callback to keep the current value. A [controller](#controller) from `createSegmentedControlController()`, passed as `@controller`, checks an item from anywhere, like the Show Month button below. Create one controller per mounted control.

[segmented-control/controlled](../../examples/components/segmented-control/ember/controlled.gts)

Choose Day, then press Show Month. The console logs each change and its reason.

## Form

Each item renders a hidden native radio, so the control takes part in forms. Set `@name` to submit the checked value; nothing submits without a name or a checked item. `@required={{true}}` blocks submission until there's a choice, `@form` joins a form by its id from elsewhere on the page, and a reset returns to `@defaultValue`.

[segmented-control/form](../../examples/components/segmented-control/ember/form.gts)

Choose Dark and Compact, then press Save. The console logs both values, and Reset returns each control to its default.

## Read-Only

Set `@readOnly={{true}}` to keep the value while still letting people focus the items. Arrow keys move focus without checking anything, and the value still submits with a form.

## Loop

Arrow keys wrap from the last item to the first. Set `@loop={{false}}` to stop at the ends.

```gts
<SegmentedControl aria-label="View" @defaultValue="list" @loop={{false}} as |s|>…</SegmentedControl>
```

## Styling

Parts are unstyled. Use `data-checked` and `data-unchecked` for the checked item, and `data-disabled`, `data-readonly` and `data-required` for the rest. `data-orientation` is on the control and the indicator.

Each part has a `data-slot`, such as `segmented-control-item`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/segmented-control#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [segmented-control reference](https://ui-sdk.dev/docs/react/components/segmented-control) in the upstream docs.

Options and callbacks are passed as arguments, such as `@value` and `@onValueChange`. Every part also takes `@render`.

### Controller

Create one with `createSegmentedControlController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

### Events

Callbacks get the new value first, then the details.

| Argument         | On                 | Receives                                                                                                                    |
| ---------------- | ------------------ | --------------------------------------------------------------------------------------------------------------------------- |
| `@onValueChange` | `SegmentedControl` | `(value, details)`: the checked value, and the [reason](https://ui-sdk.dev/docs/react/components/segmented-control#reasons) |

## Accessibility

A segmented control is a radio group, so it follows the [WAI-ARIA radio group pattern](https://www.w3.org/WAI/ARIA/apg/patterns/radio/) and behaves like native radios that share a name. Each `s.Item` renders a button with the `radio` role, and a hidden native radio that takes part in forms. The indicator is presentational, so screen readers skip it.

### Keyboard

| Key        | Does                                                                   |
| ---------- | ---------------------------------------------------------------------- |
| Tab        | Moves into the control, onto the checked item or the first enabled one |
| Arrow keys | Move to the next or previous item and check it, skipping disabled ones |
| Space      | Checks the focused item                                                |
| Enter      | Submits its form                                                       |
