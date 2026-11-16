---
title: Toggle
description: Keep a button pressed, or group toggles with a shared value and arrow-key navigation.
---

Use a toggle for a button that stays on until you press it again, like starring a document or turning on Bold. Put several in a toggle group to share one value, as a text editor's formatting buttons or a view switcher do.

[toggle/basic](../../examples/components/toggle/ember/basic.gts)

Press the star beside Q3 Roadmap, or focus it and press Enter or Space. It fills in while pressed, and its accessible name stays Star.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Toggle`:

```text
Toggle as |t|
└── t.Icon
```

And a `ToggleGroup`:

```text
ToggleGroup as |g|
├── g.Toggle as |t|
│   └── t.Icon
└── g.Toggle as |t|
    └── t.Icon
```

`Toggle` renders a native button that reports its state with `aria-pressed`. `t.Icon` is optional: it holds an icon and hides it from screen readers. In a group, give each toggle a `@value`; the group's value lists the pressed ones.

## Usage

Import the root and use the parts it yields:

```gts
import { Toggle } from "ember-ui-sdk/toggle"

<template>
  <Toggle aria-label="Star" as |t|>
    <t.Icon>★</t.Icon>
  </Toggle>
</template>
```

Keep the label the same in both states: screen readers announce whether the button is pressed. An icon-only toggle needs an `aria-label`, as above. Set `@defaultPressed={{true}}` to start pressed. The toggle always uses `type="button"`, so pressing it never submits a form.

## Group

Put toggles in a `ToggleGroup`, from the same `ember-ui-sdk/toggle` entry, to share a value and arrow-key navigation. Give the group an accessible name and each toggle a `@value`. Set `@multiple={{true}}` to let several toggles stay pressed.

[toggle/group](../../examples/components/toggle/ember/group.gts)

Press Bold and Italic to keep both pressed. Left and Right move focus without changing either.

The group owns which toggles are pressed, so a toggle's own `@pressed` and `@defaultPressed` don't apply inside it. Its value is always an array, in the toggles' document order.

## Single Selection

Without `@multiple`, pressing a toggle unpresses the others. Pressing the pressed toggle again clears the selection, unless you set `@deselectable={{false}}`, as this alignment group does. `@deselectable` doesn't choose an initial value for you, so pair it with `@defaultValue`.

[toggle/group-single](../../examples/components/toggle/ember/group-single.gts)

Press Align center to replace Align start, then press Align center again. One alignment always stays pressed.

Set `@mirror={{true}}` on directional icons, such as Align start and Align end, to flip them in right-to-left text. Use [Radio](./radio.md) instead when the arrow keys should select an option as they move; a toggle group moves focus first and waits for a press.

## Icon and Label

Put an icon beside the label with `t.Icon`. The icon is hidden from screen readers, so the text alone names the button.

```gts
<Toggle as |t|>
  <t.Icon>📌</t.Icon>
  Pin
</Toggle>
```

## Disabled

Set `@disabled={{true}}` on a toggle or a group to prevent presses. A disabled toggle can still start pressed, and a disabled fieldset around it disables it too.

```gts
<Toggle @disabled={{true}} @defaultPressed={{true}}>Pin</Toggle>
```

A disabled toggle on its own leaves the tab order. In a group, disabled toggles stay reachable with the arrow keys and report `aria-disabled`, but ignore presses.

```gts
<ToggleGroup @multiple={{true}} aria-label="Text formatting" as |g|>
  <g.Toggle @value="bold">Bold</g.Toggle>
  <g.Toggle @value="italic">Italic</g.Toggle>
  <g.Toggle @value="underline" @disabled={{true}}>Underline</g.Toggle>
</ToggleGroup>
```

## Focusable When Disabled

Set `@focusableWhenDisabled={{true}}` to keep a disabled toggle focusable. It uses `aria-disabled` and still ignores presses. Use `aria-describedby` to explain why it's unavailable:

```gts
<Toggle @disabled={{true}} @focusableWhenDisabled={{true}} aria-describedby="pin-hint">Pin</Toggle>
<p id="pin-hint">Only owners can pin messages.</p>
```

## Controlled

Pass `@pressed` and update it in `@onPressedChange` to own the state. Call `details.cancel()` in `@onPressedChange` to keep the current state. A [controller](#toggle-controller) from `createToggleController()` presses the toggle from anywhere, such as a keyboard shortcut. Create one controller per mounted toggle.

```gts
import { Toggle, createToggleController } from "ember-ui-sdk/toggle"

const star = createToggleController()

<template>
  <Toggle aria-label="Star" @controller={{star}} as |t|>
    <t.Icon>★</t.Icon>
  </Toggle>
</template>
```

Call `star.toggle()` from any handler, such as a keyboard shortcut, to press or unpress the toggle.

`@onPressedChange` receives the new state and `details`, whose `reason` is `"press"` or `"imperative"`.

## Controlled Group

Pass `@value` and update it in `@onValueChange` to own the group's value, or to show it somewhere else. A toggle's own `@onPressedChange` runs before the group's, and calling `details.cancel()` in either cancels the change. A [controller](#togglegroup-controller) from `createToggleGroupController()`, passed as `@controller`, changes the value from anywhere: `setValue([])` clears it.

## Vertical

Set `@orientation="vertical"` to move with Up and Down instead of Left and Right. The group and its toggles get `data-orientation`.

```gts
<ToggleGroup @orientation="vertical" aria-label="Tool" as |g|>…</ToggleGroup>
```

## Loop

Arrow keys wrap from the last toggle to the first. Set `@loop={{false}}` to stop at the ends.

```gts
<ToggleGroup @multiple={{true}} @loop={{false}} aria-label="Text formatting" as |g|>…</ToggleGroup>
```

## Forms

Toggles don't submit values. Use [Checkbox](./checkbox.md) for several form choices or [Radio](./radio.md) for one. If you keep a toggle group in a form, copy its value into hidden inputs yourself.

## Custom Rendering

Pass `@render={{true}}` to a toggle, its icon or its group to render your own element. The part yields `{ part, state }`: bind `part` to the button so its `aria-pressed` and keyboard behavior stay connected. A toggle's state has `pressed`, and a group's has `value`, its pressed values.

[toggle/render](../../examples/components/toggle/ember/render.gts)

Press Favorite. The heart renders filled or empty from the toggle's pressed state.

## Styling

Style the pressed state with `data-pressed`, and use `data-disabled` for unavailable toggles. A toggle with an icon gets `data-has-icon`, and its group gets `data-has-icons` while any toggle has one, which helps align icon and text content. `data-orientation` tells a group's toggles which way it runs.

Each part has a `data-slot`, such as `toggle`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/toggle#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [toggle reference](https://ui-sdk.dev/docs/react/components/toggle) in the upstream docs.

Options and callbacks are passed as arguments: `@pressed`, `@onPressedChange`. Every part also takes `@render`.

### Toggle Controller

Create one with `createToggleController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

### ToggleGroup Controller

Create one with `createToggleGroupController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs `@onValueChange` like a press, and returns `false` when the change is canceled.

### Events

Callbacks get the new state or value first, then the details. `@onValueChange` never runs on mount.

| Argument           | On            | Receives                                                                                                                                                                    |
| ------------------ | ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `@onPressedChange` | `Toggle`      | `(pressed, details)`: the new state, and the [reason](https://ui-sdk.dev/docs/react/components/toggle#reasons). In a group, it runs first and can cancel the group's change |
| `@onValueChange`   | `ToggleGroup` | `(value, details)`: the pressed toggles' values, and the [reason](https://ui-sdk.dev/docs/react/components/toggle#reasons)                                                  |

## Accessibility

A toggle follows the toggle button in the [WAI-ARIA button pattern](https://www.w3.org/WAI/ARIA/apg/patterns/button/): a native button with `aria-pressed`. A group follows the keyboard of the [WAI-ARIA toolbar pattern](https://www.w3.org/WAI/ARIA/apg/patterns/toolbar/), with one tab stop and arrow keys between toggles. It has the `group` role, not `toolbar`, so it can sit inside a [Toolbar](./toolbar.md), and not `radiogroup`, since its toggles are buttons.

### Keyboard

A group is one tab stop. Tab first enters on its first enabled pressed toggle, or its first enabled toggle, and later returns to the last focused one.

| Key          | Does                                                    |
| ------------ | ------------------------------------------------------- |
| Enter, Space | Presses or unpresses the focused toggle                 |
| Tab          | Moves into or out of a group                            |
| Left, Right  | Move focus in a horizontal group, swapped right to left |
| Up, Down     | Move focus in a vertical group                          |
| Home, End    | Move focus to the first or last toggle                  |
