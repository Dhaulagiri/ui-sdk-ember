---
title: Checkbox
description: Choose one or more options, individually or as a group.
---

Use a checkbox for a choice someone can check or uncheck. Use a group when several choices belong to one value.

[checkbox/basic](../../examples/components/checkbox/ember/basic.gts)

Click the checkbox or its label, or focus it and press Space, to accept the terms.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Checkbox`:

```text
Checkbox as |c|
└── c.Indicator
```

Wrap the checkbox and its text in a label. The indicator shows while the checkbox is checked or mixed.

## Usage

Import the root and use the parts it yields:

```gts
import { Checkbox } from "ember-ui-sdk/checkbox"

<template>
  <label>
    <Checkbox as |c|>
      <c.Indicator aria-hidden="true">✓</c.Indicator>
    </Checkbox>
    Accept terms and conditions
  </label>
</template>
```

## Description

Use `Field` with its `f.Label` and `f.Description` when a choice needs more explanation. The field connects both to the checkbox.

[checkbox/description](../../examples/components/checkbox/ember/description.gts)

Click Accept terms and conditions. The field connects the label and description to the checkbox.

## Disabled

`@disabled={{true}}` prevents focus and changes, and leaves the checkbox out of form submissions. A disabled `fieldset` does the same.

[checkbox/disabled](../../examples/components/checkbox/ember/disabled.gts)

Security alerts are always on, so that checkbox is disabled. Clicking its label leaves it checked.

## Read-Only

`@readOnly={{true}}` keeps the checkbox focusable and included in form submissions, while preventing the user from changing it.

[checkbox/read-only](../../examples/components/checkbox/ember/read-only.gts)

Tab to the checked checkbox. Space and clicks leave the setting unchanged.

## Indeterminate

An indeterminate checkbox represents a partly checked set. It has `aria-checked="mixed"` and `data-indeterminate`. A press checks it; only your code puts it back into the mixed state.

Start with `@defaultChecked="indeterminate"`, or pass `"indeterminate"` as the controlled value. A [parent checkbox](#parent-checkbox) derives this state from a group for you.

```gts
<Checkbox @defaultChecked="indeterminate" as |c|>
  <c.Indicator>{{icon Minus}}</c.Indicator>
</Checkbox>
```

## Controlled

Pass `@checked` and update it in `@onCheckedChange` to own the value. A controller from `createCheckboxController()`, passed as `@controller`, changes it from anywhere, like the Toggle button below.

[checkbox/controlled](../../examples/components/checkbox/ember/controlled.gts)

Change the checkbox, or press Toggle. The console logs each change and its reason.

## Forms

Set `@name` and `@value` to include a checked checkbox in a native form. Unchecked and mixed checkboxes submit nothing. The default value is `"on"`. Independent checkboxes can share a name to submit several values; use a [group](#group) when your app also needs one list of checked values.

`@required={{true}}` blocks submission until the checkbox is checked. Reset returns it to `@defaultChecked`. Set `@form` to a form's id to join it from elsewhere on the page.

[checkbox/form](../../examples/components/checkbox/ember/form.gts)

Create the account with the terms unchecked to see native validation, then accept them and try again. The console logs what was submitted, and Reset restores the defaults.

## Group

`CheckboxGroup` keeps one list of checked values. Each checkbox supplies its `@value`; the group returns selected values in the order the checkboxes appear. Name the group with `aria-label`, `aria-labelledby`, or a [Field](#group-in-a-form).

[checkbox/group](../../examples/components/checkbox/ember/group.gts)

Choose several toppings. The group keeps one list of checked values.

## Parent Checkbox

Add a checkbox with `@parent={{true}}` to check or uncheck the group. It is checked when every value is selected, unchecked when none are, and mixed in between. It points to its children with `aria-controls` and submits nothing itself.

Pass `@allValues` to the group so the parent has the right state on the first render, including on the server. Otherwise it discovers the values after the checkboxes mount.

[checkbox/group-parent](../../examples/components/checkbox/ember/group-parent.gts)

Select all checks every topping. Uncheck one topping to put Select all into its mixed state.

## Disabled Group

Disable the group to lock every checkbox, or disable one child to keep just that value fixed. A parent changes only enabled children.

[checkbox/group-disabled](../../examples/components/checkbox/ember/group-disabled.gts)

The Backups group is disabled. In Sync folders, Select all changes the enabled folders while Desktop stays checked.

## Controlled Group

Pass `@value` and update it in `@onValueChange` to own the selected values. A controller from `createCheckboxGroupController()`, passed as `@controller`, can replace that list, as Select Weekdays and Clear do below.

[checkbox/group-controlled](../../examples/components/checkbox/ember/group-controlled.gts)

Choose working days, or press Select Weekdays or Clear. The console logs the group's value and the reason it changed.

## Group in a Form

Set `@name` on the group to submit every checked value under that name. `@required={{true}}` requires at least one selection, and Reset restores `@defaultValue`. Pass `@field={{f.field}}` to connect the group to a `Field`, which supplies its label and description, and `f.Error` shows the validation message inline until a selection makes the group valid.

[checkbox/group-field](../../examples/components/checkbox/ember/group-field.gts)

Save with nothing checked to see the inline error. Choose a notification method and save; the console logs the submitted values.

## Table

The same parent checkbox can select rows from a table header. Each row supplies its value and accessible name.

[checkbox/table](../../examples/components/checkbox/ember/table.gts)

Select rows individually, or use Select all in the header. The console logs how many are selected.

## Animation

The indicator has `data-starting-style` as it appears and `data-ending-style` while it leaves, and stays mounted until its exit finishes. Transition from those states:

```css
[data-slot="checkbox-indicator"] {
  transition:
    opacity 0.15s,
    scale 0.15s;

  &:is([data-starting-style], [data-ending-style]) {
    opacity: 0;
    scale: 0.5;
  }
}
```

`@keepMounted={{true}}` keeps the indicator in the page while unchecked, with `data-unchecked`, for styles that show both states.

[checkbox/indicator](../../examples/components/checkbox/ember/indicator.gts)

Check and uncheck a task. The check scales and fades in, and out before it unmounts.

## Custom Rendering

Pass `@render={{true}}` to a checkbox, indicator, or group to render your own element. The part yields `{ part, state }`: bind `part` to the interactive element so its role, label, and keyboard behavior stay connected, and read `state` to change its content.

[checkbox/render](../../examples/components/checkbox/ember/render.gts)

Choose topics. Each checkbox renders a button that shows a check or a plus from its state.

## Styling

Use `data-checked`, `data-unchecked` and `data-indeterminate` for the checked state, and `data-disabled`, `data-readonly` and `data-required` for the rest. The indicator gets the same state attributes as its checkbox.

Each part has a `data-slot`, such as `checkbox`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/checkbox#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [checkbox reference](https://ui-sdk.dev/docs/react/components/checkbox) in the upstream docs.

Options and callbacks are passed as arguments: `@checked`, `@onCheckedChange`. Every part also takes `@render`.

### Checkbox Controller

Create one with `createCheckboxController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

### CheckboxGroup Controller

Create one with `createCheckboxGroupController()` and pass it as `@controller`.

Its write methods work like the checkbox controller's.

### Events

Callbacks get the new state or value first, then the details.

| Argument           | On              | Receives                                                                                                                                |
| ------------------ | --------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `@onCheckedChange` | `Checkbox`      | `(checked, details)`: `true`, `false` or `"indeterminate"`, and the [reason](https://ui-sdk.dev/docs/react/components/checkbox#reasons) |
| `@onValueChange`   | `CheckboxGroup` | `(value, details)`: the checked values, and the [reason](https://ui-sdk.dev/docs/react/components/checkbox#reasons)                     |

## Accessibility

The checkbox follows the [WAI-ARIA checkbox pattern](https://www.w3.org/WAI/ARIA/apg/patterns/checkbox/), and a group's parent checkbox follows its [mixed checkbox example](https://www.w3.org/WAI/ARIA/apg/patterns/checkbox/examples/checkbox-mixed/). `Checkbox` renders a button with the `checkbox` role, and a hidden native checkbox that takes part in forms. Every line below is an automated test.

### Keyboard

| Key   | Does                                         |
| ----- | -------------------------------------------- |
| Tab   | Moves to the next checkbox                   |
| Space | Checks or unchecks it, or checks a mixed one |
| Enter | Submits its form                             |
