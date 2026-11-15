# Segmented Control

Pick one of a few options from a row of buttons, with an indicator that slides to the choice.

Use a segmented control to switch between a few views or settings, like List and Grid. It works like a radio group, with one value and a single tab stop, and its indicator slides to the checked item.

```glimmer-ts title="basic.gts"
import { Field } from "ember-ui-sdk/field"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"

<template>
  <Field as |f|>
    <f.Label>View</f.Label>
    <SegmentedControl @defaultValue="list" @field={{f.field}} as |s|>
      <s.Indicator />
      <s.Item @value="list">List</s.Item>
      <s.Item @value="grid">Grid</s.Item>
      <s.Item @value="board">Board</s.Item>
    </SegmentedControl>
  </Field>
</template>
```

Choose Grid, then use the arrow keys to move between views. The label above names the control, as in any field.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

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

`s.Indicator` measures the checked item. Position it inside the control and use its [CSS variables](#styling-indicator) to draw the background that slides to the choice. It measures again when an item or the control changes size, and has no box while nothing is checked.

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
}
```

## Vertical

Set `@orientation="vertical"` to stack the items. Arrow keys on both axes still move between them, as in any radio group, and `data-orientation` on every part lets one stylesheet lay out both directions.

```glimmer-ts title="vertical.gts"
import { Field } from "ember-ui-sdk/field"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"

<template>
  <Field as |f|>
    <f.Label>Vertical alignment</f.Label>
    <SegmentedControl @orientation="vertical" @defaultValue="middle" @field={{f.field}} as |s|>
      <s.Indicator />
      <s.Item @value="top">Top</s.Item>
      <s.Item @value="middle">Middle</s.Item>
      <s.Item @value="bottom">Bottom</s.Item>
    </SegmentedControl>
  </Field>
</template>
```

Choose Bottom, then press the Up arrow. The indicator follows down the column.

## Disabled

Set `@disabled={{true}}` on the control or on one item. Disabled items can't be focused or checked, and arrow keys skip them. A disabled control submits nothing.

```glimmer-ts title="disabled.gts"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"

<template>
  <div data-slot="stack">
    <SegmentedControl aria-label="Theme" @defaultValue="system" @disabled={{true}} as |s|>
      <s.Indicator />
      <s.Item @value="light">Light</s.Item>
      <s.Item @value="dark">Dark</s.Item>
      <s.Item @value="system">System</s.Item>
    </SegmentedControl>
    <SegmentedControl aria-label="Billing period" @defaultValue="monthly" as |s|>
      <s.Indicator />
      <s.Item @value="monthly">Monthly</s.Item>
      <s.Item @value="yearly">Yearly</s.Item>
      <s.Item @value="lifetime" @disabled={{true}}>Lifetime</s.Item>
    </SegmentedControl>
  </div>
</template>
```

The Theme control is disabled. In Billing period, Lifetime is disabled, so the arrow keys move between Monthly and Yearly.

## Controlled

Pass `@value` and update it in `@onValueChange` for the reason. Call `details.cancel()` in the callback to keep the current value. A [controller](#controller) from `createSegmentedControlController()`, passed as `@controller`, checks an item from anywhere, like the Show Month button below. Create one controller per mounted control.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import {
  SegmentedControl,
  createSegmentedControlController,
} from "ember-ui-sdk/segmented-control"
import { useLog } from "./log"

export default class Controlled extends Component {
  log = useLog(this)
  range = createSegmentedControlController()
  @tracked value: string | null = "week"

  showMonth = () => this.range.setValue("month")

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    this.log(`value: ${next} (${details.reason})`)
  }

  <template>
    <div>
      <div data-slot="controls">
        <button type="button" {{on "click" this.showMonth}}>Show Month</button>
      </div>
      <SegmentedControl
        aria-label="Range"
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @controller={{this.range}}
        as |s|
      >
        <s.Indicator />
        <s.Item @value="day">Day</s.Item>
        <s.Item @value="week">Week</s.Item>
        <s.Item @value="month">Month</s.Item>
      </SegmentedControl>
    </div>
  </template>
}
```

Choose Day, then press Show Month. The console logs each change and its reason.

## Form

Each item renders a hidden native radio, so the control takes part in forms. Set `@name` to submit the checked value; nothing submits without a name or a checked item. `@required={{true}}` blocks submission until there's a choice, `@form` joins a form by its id from elsewhere on the page, and a reset returns to `@defaultValue`.

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"
import { useLog } from "./log"

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = new FormData(event.currentTarget as HTMLFormElement)
    this.log(`Saved theme=${data.get("theme")}, density=${data.get("density")}`)
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <f.Label>Theme</f.Label>
        <SegmentedControl @name="theme" @required={{true}} @defaultValue="system" @field={{f.field}} as |s|>
          <s.Indicator />
          <s.Item @value="light">Light</s.Item>
          <s.Item @value="dark">Dark</s.Item>
          <s.Item @value="system">System</s.Item>
        </SegmentedControl>
        <f.Description>System follows your device's setting.</f.Description>
      </Field>
      <Field as |f|>
        <f.Label>Density</f.Label>
        <SegmentedControl @name="density" @defaultValue="comfortable" @field={{f.field}} as |s|>
          <s.Indicator />
          <s.Item @value="compact">Compact</s.Item>
          <s.Item @value="comfortable">Comfortable</s.Item>
        </SegmentedControl>
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Save</button>
        <button type="reset">Reset</button>
      </div>
    </form>
  </template>
}
```

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

Each part has a `data-slot`, such as `segmented-control-item`, and its state attributes are listed under [Data Attributes](#data-attributes).

### SegmentedControlIndicator
- `--segmented-control-indicator-left`: Distance from the control's left edge to the checked item.
- `--segmented-control-indicator-right`: Distance from the control's right edge to the checked item.
- `--segmented-control-indicator-top`: Distance from the control's top edge to the checked item.
- `--segmented-control-indicator-bottom`: Distance from the control's bottom edge to the checked item.
- `--segmented-control-indicator-width`: Width of the checked item.
- `--segmented-control-indicator-height`: Height of the checked item.

## Data Attributes

### SegmentedControl
`[data-slot="segmented-control"]`

- `data-orientation` (`horizontal`, `vertical`): Which way the items run.
- `data-readonly`: Present when the control is read-only.
- `data-required`: Present when the control is required.
- `data-disabled`: Present when disabled, by its own prop, the control or a `<fieldset>`.

### SegmentedControlItem
`[data-slot="segmented-control-item"]`

- `data-checked`: Present on the checked item.
- `data-readonly`: Present when the control is read-only.
- `data-required`: Present when the control is required.
- `data-unchecked`: Present on items that aren't checked.
- `data-disabled`: Present when disabled, by its own prop, the control or a `<fieldset>`.

### SegmentedControlIndicator
`[data-slot="segmented-control-indicator"]`

- `data-orientation` (`horizontal`, `vertical`): Which way the items run.

## API Reference

Options and callbacks are the same as below, as arguments, such as `@value` and `@onValueChange`. Every part also takes `@render`.

### SegmentedControl

- `value?` (`T | null`): The checked item's value. Pass it to control the segmented control. `null` checks nothing.
- `defaultValue?` (`T | null`): The item checked at first, when uncontrolled. A form reset returns to it.
- `onValueChange?` (`((value: T | null, details: ChangeDetails<SegmentedControlValueChangeReason>) => void)`): Runs when a user or a form reset wants to change the value. `details.reason` says why, and `details.cancel()` stops it.
- `disabled?` (`boolean`): Disables every item: they can't be focused or changed, and the value isn't submitted.
- `readOnly?` (`boolean`): Keeps the items focusable and the value submitted, but stops changes.
- `required?` (`boolean`): Blocks form submission until an item is checked, with the browser's own message.
- `name?` (`string`): The name the value submits under. Without one, the segmented control submits nothing.
- `form?` (`string`): The id of a form to belong to, when the segmented control isn't inside that form.
- `loop?` (`boolean`): Whether arrow keys wrap from the last item to the first.
- `orientation?` (`SegmentedControlOrientation`): Which way the items run, for styling and for screen readers. Arrow keys on both axes move between items either way, as in any radio group.
- `controller?` (`{ getValue: () => T | null; setValue: (value: T | null, details?: SegmentedControlChangeOptions) => boolean; focus: () => void; }`): Checks items from anywhere. Create one with `createSegmentedControlController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### SegmentedControlItem

- `value` (`string`): What the value becomes when this item is checked.
- `disabled?` (`boolean`): Skips the item, like a disabled native radio: arrow keys pass it and it can't be focused or checked.

### State

What `@render={{true}}` yields as `state`.

- `value` (`string | null`): The checked item's value.
- `disabled` (`boolean`): Whether the segmented control is disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether it's read-only: arrow keys still move focus, but nothing changes the checked item.
- `required` (`boolean`): Whether a form won't submit until an item is checked.
- `orientation` (`SegmentedControlOrientation`): Which way the items run.

- `checked` (`boolean`): Whether this item is the control's value, which the indicator sits behind.
- `disabled` (`boolean`): Whether this item is disabled, by itself, the segmented control or a `<fieldset>`.
- `readOnly` (`boolean`): Whether the control is read-only, so pressing this item changes nothing.
- `required` (`boolean`): Whether a form won't submit until an item is checked.

- `value` (`string | null`): The checked item's value, which the indicator sits behind.
- `orientation` (`SegmentedControlOrientation`): Which way the items run.

### Reasons

`details.reason` says why the checked value changed.

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `reset` (`none`): A form reset.
- `restore` (`none`): The browser restored state, like after going back, or a saved value was read back from storage.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createSegmentedControlController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

- `getValue()` (`() => T | null`): The checked item's value.
- `setValue(value, details?)` (`(value: T | null, details?: SegmentedControlChangeOptions | undefined) => boolean`): Checks an item, as a user would. Disabled items and read-only controls ignore it.
- `focus()` (`() => void`): Moves focus to the checked item, or the first one.

### Events

Callbacks get the new value first, then the details.

| Argument         | On                 | Receives                                                          |
| ---------------- | ------------------ | ----------------------------------------------------------------- |
| `@onValueChange` | `SegmentedControl` | `(value, details)`: the checked value, and the [reason](#reasons) |

## Accessibility

A segmented control is a radio group, so it follows the [WAI-ARIA radio group pattern](https://www.w3.org/WAI/ARIA/apg/patterns/radio/) and behaves like native radios that share a name. Each `s.Item` renders a button with the `radio` role, and a hidden native radio that takes part in forms. The indicator is presentational, so screen readers skip it.

### Keyboard

| Key        | Does                                                                   |
| ---------- | ---------------------------------------------------------------------- |
| Tab        | Moves into the control, onto the checked item or the first enabled one |
| Arrow keys | Move to the next or previous item and check it, skipping disabled ones |
| Space      | Checks the focused item                                                |
| Enter      | Submits its form                                                       |

### Tested Behavior

Every line below is an automated test.

**Selection**

- The default item is checked, and only that one.
- Clicking an item checks it and says why.
- Clicking a disabled item does nothing.
- A change can be cancelled.
- A controller checks an item.

**Keyboard**

- Tab lands on the checked item, and the next Tab leaves.
- Arrow keys on both axes check the next item, skip disabled ones and wrap.

**Orientation**

- A segmented control is horizontal unless it says otherwise.
- A vertical segmented control reports it.

**Indicator**

- The indicator covers the checked item.
- The indicator follows the checked item.
- The indicator covers the checked item in a vertical control.
- The indicator matches items with fractional widths exactly.
- A scaled ancestor doesn't move the indicator off fractional items.
- With nothing checked, the indicator has no box.

**Forms**

- The checked value submits under the control's name.
- A form reset checks the default item again.
- A disabled control submits nothing, and its items can't be focused or checked.

Runs in React, Vue and web components.
