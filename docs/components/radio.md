---
title: Radio
description: Choose one option, move the selection with arrow keys, and submit it with a form.
---

Use radios for a short list of choices where only one can be picked, like a shipping speed or a plan. The group keeps one value and gives the whole list a single tab stop.

[radio/basic](../../examples/components/radio/ember/basic.gts)

Choose Express, then use the arrow keys to move the selection between speeds.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `RadioGroup`:

```text
RadioGroup as |g|
├── g.Radio as |r|
│   └── r.Indicator
└── g.Radio as |r|
    └── r.Indicator
```

Give each radio a `@value` and wrap it with its text in a label. The group's value is the checked radio's value, and the indicator shows while its radio is checked.

## Usage

Import the group and use the parts it yields:

```gts
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

<template>
  <Field as |f|>
    <f.Label>Shipping speed</f.Label>
    <RadioGroup @defaultValue="standard" @field={{f.field}} as |g|>
      <label>
        <g.Radio @value="standard" as |r|>
          <r.Indicator />
        </g.Radio>
        Standard
      </label>
      <label>
        <g.Radio @value="express" as |r|>
          <r.Indicator />
        </g.Radio>
        Express
      </label>
    </RadioGroup>
  </Field>
</template>
```

The field's label names the group. Without a field, name it with `aria-label` or `aria-labelledby`. Without `@defaultValue`, nothing starts checked and Tab enters on the first enabled radio.

## Description

Put each radio in its own `Field` with a `f.Label` and `f.Description` when an option needs more explanation. That field connects both to its radio, while the outer field still names the group.

[radio/description](../../examples/components/radio/ember/description.gts)

Choose Weekly digest by its label. Each radio is also described by the line under it.

## Choice Card

Wrap an option's content in its label to make the whole card clickable. `:has([data-checked])` lets the card reflect the radio inside it.

[radio/choice-card](../../examples/components/radio/ember/choice-card.gts)

Click anywhere on the Pro card to choose it. Arrow keys move the selection between cards too.

## Fieldset and Legend

Use a `fieldset` with a `legend` to describe a set of choices together. Connect the group to the legend with `aria-labelledby`, and to the description with `aria-describedby`.

[radio/legend](../../examples/components/radio/ember/legend.gts)

Choose Yearly. The legend and the line under it describe both billing periods.

## Disabled

Set `@disabled={{true}}` on the group or on one radio. Disabled radios can't be focused or checked, and arrow keys skip them. A disabled fieldset disables the group too, and a disabled group submits nothing.

[radio/disabled](../../examples/components/radio/ember/disabled.gts)

The Theme group is disabled. In Backups, Hourly is disabled, so the arrow keys move between Daily and Weekly.

## Read-Only

Set `@readOnly={{true}}` on the group to keep its value while still letting people focus and read the options. Arrow keys move focus without checking anything, and the value still submits with a form.

[radio/read-only](../../examples/components/radio/ember/read-only.gts)

Click Team, or focus Pro and press the Down arrow. Pro stays checked.

## Controlled

Pass `@value` and update it in `@onValueChange` to own the value. Call `details.cancel()` in the callback to keep the current value. A controller from `createRadioGroupController()`, passed as `@controller`, checks a radio from anywhere, like the Choose Team button below. Create one controller per mounted group.

[radio/controlled](../../examples/components/radio/ember/controlled.gts)

Choose Starter, then press Choose Team. The console logs each change and its reason.

## Form

Each radio renders a button with the `radio` role and a hidden native radio, so the group takes part in forms. Set `@name` to submit the checked value; the group submits nothing without a name or a checked radio. `@required={{true}}` blocks submission until there's a choice, and a reset returns to `@defaultValue`.

Set `@form` to a form's id to join it from elsewhere on the page, as this group does.

[radio/form](../../examples/components/radio/ember/form.gts)

Choose Express and press Continue. The console logs the submitted value, and Reset returns the choice to Standard.

## Validation

Put a required group in a [Field](./field.md) with an `f.Error`. Submitting without a choice shows the error under the group and moves focus to it.

[radio/invalid](../../examples/components/radio/ember/invalid.gts)

Press Save without a choice to see the error. Choose SMS only and save again; the console logs the saved value.

## Animation

The indicator has `data-starting-style` as it appears and `data-ending-style` while it leaves, and stays mounted until its exit finishes. Transition from those states:

```css
[data-slot="radio-indicator"] {
  transition:
    opacity 0.15s,
    scale 0.15s;

  &:is([data-starting-style], [data-ending-style]) {
    opacity: 0;
    scale: 0.5;
  }
}
```

`@keepMounted={{true}}` keeps the indicator in the page while unchecked, with `data-unchecked`. Here it lets a hovered option preview its dot.

[radio/indicator](../../examples/components/radio/ember/indicator.gts)

Hover Light to preview its dot, then choose it. The dot scales in on Light and out of System.

## Loop

Arrow keys wrap from the last radio to the first. Set `@loop={{false}}` to stop at the ends.

```gts
<RadioGroup @defaultValue="low" @loop={{false}} as |g|>…</RadioGroup>
```

## Custom Rendering

Pass `@render={{true}}` to a radio or its indicator to render your own element. The part yields `{ part, state }`: bind `part` to the interactive element so its role, label and keyboard behavior stay connected, and read `state` to change its content.

[radio/render](../../examples/components/radio/ember/render.gts)

Choose Nothing. Each radio renders a full-width button that shows a check from its state.

## Styling

Use `data-checked` and `data-unchecked` for the checked state, and `data-disabled`, `data-readonly` and `data-required` for the rest. The indicator gets the same state attributes as its radio, and the group gets `data-disabled`, `data-readonly` and `data-required`.

Each part has a `data-slot`, such as `radio`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/radio#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [radio reference](https://ui-sdk.dev/docs/react/components/radio) in the upstream docs.

Options and callbacks are passed as arguments: `@value`, `@onValueChange`. Every part also takes `@render`.

### Controller

Create one with `createRadioGroupController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

### Events

Callbacks get the new value first, then the details.

| Argument         | On           | Receives                                                                                                        |
| ---------------- | ------------ | --------------------------------------------------------------------------------------------------------------- |
| `@onValueChange` | `RadioGroup` | `(value, details)`: the checked value, and the [reason](https://ui-sdk.dev/docs/react/components/radio#reasons) |

## Accessibility

Radio groups follow the [WAI-ARIA radio group pattern](https://www.w3.org/WAI/ARIA/apg/patterns/radio/), and behave like native radios that share a name. `Radio` renders a button with the `radio` role, and a hidden native radio that takes part in forms.

### Keyboard

| Key        | Does                                                                    |
| ---------- | ----------------------------------------------------------------------- |
| Tab        | Moves into the group, onto the checked radio or the first enabled one   |
| Arrow keys | Move to the next or previous radio and check it, skipping disabled ones |
| Space      | Checks the focused radio                                                |
| Enter      | Submits its form                                                        |
