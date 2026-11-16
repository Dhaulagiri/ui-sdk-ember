---
title: Switch
description: Turn a setting on or off.
---

Use a switch for a setting that takes effect as soon as it changes, like Airplane mode or a notification preference. Keep its label the same in both states: the label says what the setting is, and the switch shows whether it's on.

[switch/basic](../../examples/components/switch/ember/basic.gts)

Click Airplane mode, or focus the switch and press Space, to turn it on and off.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Switch`:

```text
Switch as |s|
└── s.Thumb
```

Wrap the switch and its text in a label. The thumb stays mounted and gets the switch's state, so CSS can slide it from one end to the other.

## Usage

Import the root and use the parts it yields:

```gts
import { Switch } from "ember-ui-sdk/switch"

<template>
  <label>
    Airplane mode
    <Switch as |s|>
      <s.Thumb />
    </Switch>
  </label>
</template>
```

## Description

Use `Field` with its `f.Label` and `f.Description` when a setting needs more explanation. The field connects both to the switch.

[switch/description](../../examples/components/switch/ember/description.gts)

Click Weekly digest. The field connects the label and description to the switch.

## Choice Card

A setting can fill a whole card. Here the label's `::after` covers the card, so a click anywhere on it toggles the switch, and `:has([data-checked])` marks the cards that are on.

[switch/choice-card](../../examples/components/switch/ember/choice-card.gts)

Click anywhere on the Public profile card to turn it on. Each card's switch keeps its own value.

## Disabled

`@disabled={{true}}` prevents focus and changes, and leaves the switch out of form submissions. A disabled `fieldset` does the same.

[switch/disabled](../../examples/components/switch/ember/disabled.gts)

Security alerts are always on, so that switch is disabled. Clicking it leaves it on, and Tab skips it.

## Read-Only

`@readOnly={{true}}` keeps the switch focusable and included in form submissions, while preventing the user from changing it. Use it for a setting managed somewhere else.

[switch/read-only](../../examples/components/switch/ember/read-only.gts)

Tab to Encrypt backups. Space and clicks leave it on.

## Controlled

Pass `@checked` and update it in `@onCheckedChange` to own the value. A [controller](#controller), from `createSwitchController()` and passed as `@controller`, changes it from anywhere, like the Toggle button below.

[switch/controlled](../../examples/components/switch/ember/controlled.gts)

Turn Wi-Fi off, or press Toggle. The console logs each change and its reason.

## Form

Set `@name` to include the switch in a native form. A switch that's on submits its `@value`, which defaults to `"on"`; a switch that's off submits nothing. Reset returns it to `@defaultChecked`. Set `@form` to a form's id to join it from elsewhere on the page.

[switch/form](../../examples/components/switch/ember/form.gts)

Turn on Product updates and press Save. The console logs the submitted values, and Reset restores the defaults.

## Validation

`@required={{true}}` blocks submission until the switch is on. In a `Field`, `f.Error` shows the message under the switch and connects it to the switch.

[switch/invalid](../../examples/components/switch/ember/invalid.gts)

Press Continue with the switch off to see the error. Turn on Two-factor authentication and continue; the console logs the submitted value.

## Saving on Toggle

To save a change before it shows, call `details.cancel()` in `@onCheckedChange` to keep the current value while the save runs. When it finishes, call `controller.setChecked(next, { reason: "imperative" })`, and let that reason through in the callback so the saved value commits.

The example ignores presses while a save is running, and shows a spinner in the thumb. `aria-busy` tells assistive technology the switch is busy; the callback is what blocks another change.

[switch/async](../../examples/components/switch/ember/async.gts)

Turn on Automatic backups. The thumb shows a spinner while it saves, then the switch turns on.

## Custom Rendering

Pass `@render={{true}}` to the switch or its thumb to render your own element. The part yields `{ part, state }`: bind `part` to the element so its role, label and keyboard behavior stay connected, and read `state` to change its content. See [Parts and Composition](#custom-rendering) for the rendering contract.

[switch/render](../../examples/components/switch/ember/render.gts)

Turn on Dark mode. The thumb renders a sun or a moon from its state.

## Styling

Style the switch and its thumb with `data-checked` and `data-unchecked`, and use `data-disabled`, `data-readonly` and `data-required` for the rest. In an invalid field, the switch also gets `data-invalid` and `aria-invalid`; the thumb doesn't. Slide the thumb with `translate` on `data-checked`, and reverse it under `dir="rtl"`.

Each part has a `data-slot`, such as `switch`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/switch#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [switch reference](https://ui-sdk.dev/docs/react/components/switch) in the upstream docs.

Options and callbacks are passed as arguments: `@checked`, `@onCheckedChange`. Every part also takes `@render`.

### Controller

Create one with `createSwitchController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

### Events

Callbacks get the new state first, then the details.

| Argument           | On       | Receives                                                                                                       |
| ------------------ | -------- | -------------------------------------------------------------------------------------------------------------- |
| `@onCheckedChange` | `Switch` | `(checked, details)`: the new state, and the [reason](https://ui-sdk.dev/docs/react/components/switch#reasons) |

## Accessibility

The switch follows the [WAI-ARIA switch pattern](https://www.w3.org/WAI/ARIA/apg/patterns/switch/). `Switch` renders a button with the `switch` role, and a hidden native checkbox that takes part in forms.

### Keyboard

| Key   | Does                                   |
| ----- | -------------------------------------- |
| Tab   | Moves to the next switch               |
| Space | Turns it on or off                     |
| Enter | Submits its form, and never toggles it |
