---
title: Number Input
description: Enter numbers, step through values, and format them for a locale.
---

Use a Number Input for quantities, prices and measurements. It keeps a numeric value while showing formatted text, and steps it with the keyboard, the step buttons, or a drag on its label.

[number-input/basic](../../examples/components/number-input/ember/basic.gts)

Drag the Quantity label sideways to scrub the value, or click it to focus the input. Type a number, press ArrowUp or ArrowDown, or hold a step button. The console logs the value once each change is committed.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `NumberInput`:

```text
NumberInput as |n|
├── n.ScrubArea
│   └── n.ScrubAreaCursor
└── n.Group
    ├── n.Decrement
    ├── n.Control
    └── n.Increment
```

`NumberInput` holds the numeric value. `n.Group` wraps the text input and the optional step buttons. `n.Control` renders the input; `n.Decrement` and `n.Increment` change its value and repeat while held. `n.ScrubArea` is optional and changes the value as you drag it.

Typing updates the value when the text is valid and within bounds. Enter or blur commits it: the text is parsed, clamped, snapped to the step, and formatted. An empty input has the value `null`.

## Usage

Import the root and use the parts it yields:

```gts
import { NumberInput } from "ember-ui-sdk/number-input"

<template>
  <NumberInput @defaultValue={{1}} @min={{0}} as |n|>
    <n.Group>
      <n.Decrement aria-label="Decrease">−</n.Decrement>
      <n.Control aria-label="Quantity" />
      <n.Increment aria-label="Increase">+</n.Increment>
    </n.Group>
  </NumberInput>
</template>
```

## Field

Wrap the number input in [Field](./field.md) to give it a visible label and a description.

[number-input/field](../../examples/components/number-input/ember/field.gts)

Click Tickets to focus the input, then type or step its value. Screen readers read the description with the field.

## Min and Max

Use `@min` and `@max` to set bounds. A step button disables at its bound. Typed values outside the bounds are clamped when committed.

[number-input/min-max](../../examples/components/number-input/ember/min-max.gts)

Change Guests between 1 and 8. Type 20 and press Enter to clamp it to 8. At either bound, that direction's step button is disabled.

## Step and Large Step

`@step` sets the usual increment, and defaults to 1. Steps are measured from `@min`, or from zero when no minimum is set. When they don't land on `@max`, End and the increment button stop at the highest step below it, so stepping keeps the value on the step grid, as [Slider](./slider.md#step-and-bounds) does. Shift, Page Up and Page Down use `@largeStep`, ten steps by default, and Alt (Option) with an arrow key uses `@smallStep`, a tenth of a step. [Keyboard](#keyboard) lists every key.

[number-input/step](../../examples/components/number-input/ember/step.gts)

Step Hours by 0.25. Hold Shift to move by 1, or hold Alt (Option) with an arrow key to move by 0.05. Home and End go to 0 and 24.

## Format

Pass `Intl.NumberFormat` options through `@format`. The input displays and parses that format while keeping a numeric value. For percentages, `0.15` is displayed as `15%`, and `@step` defaults to the smallest percent the format shows: `0.01` for whole percents, `0.0001` with two fraction digits.

[number-input/format](../../examples/components/number-input/ember/format.gts)

Edit Price, Discount, or Weight and leave the field to format it. Try entering 5 in Price or 25% in Discount, then use the step buttons.

## Locale

Set `@locale` to choose separators, currency symbols, and grouping. Without it, the input follows the page's language or the browser's language after mounting. Server markup uses English when no locale is provided; set a locale explicitly when that first render matters.

[number-input/locale](../../examples/components/number-input/ember/locale.gts)

Edit Preis using a comma for decimals, or step Budget to see Indian digit grouping. The displayed and accepted formats follow each field's locale.

## Mouse Wheel

Set `@wheel={{true}}` to step with the mouse wheel while the input is focused. It is off by default.

[number-input/wheel](../../examples/components/number-input/ember/wheel.gts)

Focus Font size and scroll over it to change the value. Move focus away and scroll again; the value stays unchanged.

## Scrub Area

`n.ScrubArea` changes the value while you drag it. The handle can be any element inside the number input: the label, as in the first example, or a letter or icon inside the group, as in a design tool. Right and up increase the value. `@orientation` chooses an axis, and `@pixelsPerStep` controls how far the pointer moves per step. Shift and Alt (Option) use the large and small increments.

[number-input/scrub](../../examples/components/number-input/ember/scrub.gts)

Drag the X, Y, W or H letter sideways to change that value. Hold Shift for larger steps or Alt (Option) for smaller ones. The console logs each value when the drag ends.

Where pointer lock is available, the drag can continue past the edge of the screen. `n.ScrubAreaCursor` draws a replacement cursor while it is locked. The cursor is placed in the document body with an inline translation; center your icon with negative margins.

To place a scrub area outside its number input, such as on an icon in a toolbar, pass the same [controller](#controller) to both. More than one scrub area can control the same field.

## Disabled

Set `@disabled={{true}}` on the component or its enclosing fieldset to prevent focus, changes, and form submission. Set `@disabled={{true}}` on one step button to turn off only that direction. The other button still steps.

## Read-Only

Set `@readOnly={{true}}` to keep the value focusable and included in form data while preventing edits and steps.

## Validation

Use `@required={{true}}` to block an empty value. Field associates its error with the input and marks it invalid after an unsuccessful submit. Here, choosing **Continue** while Age is empty shows "Enter your age."

```gts
<form>
  <Field as |f|>
    <f.Label>Age</f.Label>
    <NumberInput @name="age" @required={{true}} @min={{18}} @max={{120}} @field={{f.field}} as |n|>
      <n.Group>
        <n.Decrement aria-label="Decrease">−</n.Decrement>
        <n.Control />
        <n.Increment aria-label="Increase">+</n.Increment>
      </n.Group>
    </NumberInput>
    <f.Error @match="valueMissing">Enter your age.</f.Error>
  </Field>
  <button type="submit">Continue</button>
</form>
```

## Controlled

Pass `@value` and update it in `@onValueChange` for the reason. `@onValueChange` reports valid changes while an interaction is in progress. `@onValueCommit` runs when typing is committed, a step key or button is released, or a scrub ends. Use the commit event for work that should happen after the interaction.

[number-input/controlled](../../examples/components/number-input/ember/controlled.gts)

Hold a Servings step button. The console logs each value as it changes, then one Committed line when you let go. Clear sets the value to null, and Reset to 4 restores it.

## Controller

Create one with `createNumberInputController()` and pass it as `@controller` to change or focus the input from other controls. `increment()` and `decrement()` step the value; pass `{ large: true }` for a large step. `setValue()`, `getValue()`, and `focus()` cover direct updates and inspection.

[number-input/controller](../../examples/components/number-input/ember/controller.gts)

Press Zoom In and Zoom Out to move by 100%, then Actual Size to restore 100%. Read logs the current value, and Focus moves into the field.

## Form

A hidden input submits the plain numeric value under `@name`. Formatting does not change form data: a displayed amount of $4.50 still submits `4.5`. Empty values submit an empty string.

[number-input/form](../../examples/components/number-input/ember/form.gts)

Change Quantity or Tip and press Save: the console logs the plain numeric values. Gift cards belongs to the same form through its form ID. Reset restores the defaults.

Set `@form` to associate the input with a form elsewhere in the page. A form reset restores the default value and reports the `reset` reason.

## Custom Rendering

Pass `@render={{true}}` to a part to render your own element. The part yields `{ part, state }`: bind `part` to the element, and read `state` to change its content. Here the decrement button adds a tooltip, and the increment button shows Max once the value reaches its bound.

[number-input/render](../../examples/components/number-input/ember/render.gts)

Press End in Temperature to jump to 40°C. The increment button reads Max; hover the decrement button to see its tooltip.

Each part's state is listed under [State](https://ui-sdk.dev/docs/react/components/number-input#state).

## Styling

Style the group as the field's box, and the input and step buttons inside it. `data-disabled` on a step button also means it has reached its bound, and `data-scrubbing` marks every part while a drag changes the value. Inside Field, the native input receives validation attributes such as `data-invalid`. Use logical spacing so the layout follows the surrounding direction.

Each part has a `data-slot`, such as `number-input-group`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/number-input#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [number-input reference](https://ui-sdk.dev/docs/react/components/number-input) in the upstream docs.

Options and callbacks are passed as arguments, such as `@value` and `@onValueChange`. Every part also takes `@render`.

### Controller

Create one with `createNumberInputController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

### Events

Callbacks get the new value first, then the details.

| Argument         | On            | Receives                                                                                                                               |
| ---------------- | ------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `@onValueChange` | `NumberInput` | `(value, details)`: the new value, or null when empty, and the [reason](https://ui-sdk.dev/docs/react/components/number-input#reasons) |
| `@onValueCommit` | `NumberInput` | `(value, details)`: the value once the interaction ends, and its reason                                                                |

## Accessibility

Follows the keyboard model of the [WAI-ARIA spinbutton pattern](https://www.w3.org/WAI/ARIA/apg/patterns/spinbutton/) on a native text input, so ordinary text editing works too. Give the input a field label or `aria-label`, and name both step buttons. Each button points to the input with `aria-controls`.

### Keyboard

| Input                                               | Increment                                          |
| --------------------------------------------------- | -------------------------------------------------- |
| ArrowUp, ArrowDown, or a step button                | `@step`, which defaults to 1.                      |
| Shift with an arrow or button; Page Up or Page Down | `@largeStep`, which defaults to ten steps.         |
| Alt (Option) with an arrow key                      | `@smallStep`, which defaults to a tenth of a step. |
| Home or End                                         | The minimum or maximum, when set.                  |

Enter commits typed text. The step buttons stay out of the Tab order, because the focused input gives the same steps through its arrow keys.
