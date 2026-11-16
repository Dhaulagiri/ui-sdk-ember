---
title: Toolbar
description: Give buttons, toggles, menus and fields one tab stop with arrow-key navigation.
---

Use a Toolbar to group the controls of an editor, a canvas or a table. Tab enters it once, and the arrow keys move between its buttons, toggles, menus and fields.

[toolbar/demo](../../examples/components/toolbar/ember/demo.gts)

Tab into the toolbar, then use Left and Right to move between Bold, Italic, Underline and Insert link. Press Space to toggle the focused style. The console logs each change.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Toolbar`:

```text
Toolbar as |t|
├── t.Button
├── t.Separator
├── t.Group
│   ├── t.Button
│   └── t.Button
├── t.Link
└── t.Input
```

Put buttons, links and fields straight inside the toolbar. `t.Group` names a set of related items, and `t.Separator` draws a line between sets. Toggles and toggle groups join the toolbar on their own, and menu and select triggers join through `t.Button`.

## Usage

Import the root and use the parts it yields:

```gts
import { Toolbar } from "ember-ui-sdk/toolbar"

<template>
  <Toolbar aria-label="Formatting" as |t|>
    <t.Button>Undo</t.Button>
    <t.Button>Redo</t.Button>
    <t.Separator />
    <t.Button>Insert Link</t.Button>
  </Toolbar>
</template>
```

Name the toolbar with `aria-label`, and give every icon-only control its own.

## Toggle Groups

A [Toggle](./toggle.md) group inside a toolbar joins its navigation instead of adding another tab stop. Arrow keys move focus without pressing anything; Enter or Space presses the focused toggle.

[toolbar/toggle-group](../../examples/components/toolbar/ember/toggle-group.gts)

Arrow from the alignment group to the list group, then press Space on Align center or Numbered list. The console logs each choice.

## Groups

Use `t.Group` to name related controls. Set `@disabled={{true}}` on the group to disable them together; they stay focusable with `aria-disabled`.

[toolbar/group](../../examples/components/toolbar/ember/group.gts)

Move through Cut, Copy and Paste into History with the arrow keys. Undo and Redo stay focusable but do nothing.

## Menus

Render a [Menu](./menu.md) trigger through `t.Button`. In a horizontal toolbar, Down opens the menu while Left and Right keep moving between toolbar items.

[toolbar/menu](../../examples/components/toolbar/ember/menu.gts)

Focus Share and press Down, then choose Email or Copy Link. Escape closes the menu and returns focus to Share.

## Selects

A [Select](./select.md) trigger joins the same way. It keeps its select behavior while it takes part in the toolbar's focus order.

[toolbar/select](../../examples/components/toolbar/ember/select.gts)

Open Zoom and choose a value, or step it with Zoom out and Zoom in. Each button turns off at the end of the range.

## Fields

Use `t.Input` for a text field, or render another field through it, like a [Number Input](./number-input.md) control. A field keeps Home, End and the arrow keys while they move its caret. At the matching end, with no text selected, an arrow moves to the next item.

Entering a field with an arrow puts its caret at the far end in that direction: press the same arrow again to leave, or the other arrow to edit. A number input keeps Up and Down for stepping its value.

[toolbar/input](../../examples/components/toolbar/ember/input.gts)

Move into Font size and press Up or Down to change it. In Find, type a word, then move the caret to an edge before that arrow leaves the field.

## Links

`t.Link` joins the same focus order and keeps its link behavior. The demo handles a plain click itself and leaves modified clicks, like opening in a new tab, to the browser.

[toolbar/link](../../examples/components/toolbar/ember/link.gts)

Arrow to Files Changed and press Enter. The console logs the page it opened.

## Vertical

Set `@orientation="vertical"` to move with Up and Down, like a canvas tool palette. Separators turn to run across the toolbar.

[toolbar/vertical](../../examples/components/toolbar/ember/vertical.gts)

Use Up and Down to move between the tools and Delete. Space picks the focused tool.

## Disabled

A disabled item stays reachable with `aria-disabled`, so people can find it, but it ignores presses, including keys meant for a component rendered through it. Set `@focusableWhenDisabled={{false}}` to skip it instead.

[toolbar/disabled](../../examples/components/toolbar/ember/disabled.gts)

Arrow from Reply to Archive, which is disabled but focusable. Delete is skipped. Only Reply logs a press.

Set `@disabled={{true}}` on the toolbar to disable every item. The toolbar keeps its tab stop, and its fields can't be edited.

```gts
<Toolbar @disabled={{true}} aria-label="Formatting" as |t|>
  <t.Button>Bold</t.Button>
  <t.Input aria-label="Find" />
</Toolbar>
```

## Loop

Arrow keys wrap from the last item to the first by default. Set `@loop={{false}}` to stop at the ends.

[toolbar/loop](../../examples/components/toolbar/ember/loop.gts)

Focus Last and press Right. Focus stays there; Home still moves to First.

## Controller

Create a controller with `createToolbarController()` and pass it as `@controller`. Its `focus()` moves focus to the item focused last, like the Alt+F10 shortcut editors give their toolbars. Create one controller per toolbar.

[toolbar/controller](../../examples/components/toolbar/ember/controller.gts)

Type in Notes, then press Alt+F10 or choose Focus Toolbar. Press a toolbar button and the console logs it.

## Custom Rendering

Pass `@render={{true}}` to a `t.Button` or `t.Input` to combine its behavior with another component, as the menu, select and number input examples do. Bind the yielded `part` to the inner element so the toolbar's focus and keys stay connected. The menu example shows the pattern.

## Styling

Use `data-orientation` on the root for a row or a column, and on a separator for the way its line runs, across the toolbar. Use `data-disabled` to style unavailable items and groups. Toggles inside keep their own `data-pressed`.

Each part has a `data-slot`, such as `toolbar-button`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/toolbar#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [toolbar reference](https://ui-sdk.dev/docs/react/components/toolbar) in the upstream docs.

Options and callbacks are passed as arguments, such as `@orientation` and `@loop`. Every part also takes `@render`.

### ToolbarGroup

`t.Link` and `t.Separator` take no options of their own.

## Accessibility

The toolbar follows the [WAI-ARIA toolbar pattern](https://www.w3.org/WAI/ARIA/apg/patterns/toolbar/). The root has the `toolbar` role and `aria-orientation`, and separators have the `separator` role.

### Keyboard

The toolbar has one tab stop, a roving focus. Tab enters on the first enabled item, then returns to the item focused last. The next Tab leaves the toolbar.

| Key                        | Action                                          |
| -------------------------- | ----------------------------------------------- |
| `ArrowRight` / `ArrowLeft` | Move focus in a horizontal toolbar              |
| `ArrowDown` / `ArrowUp`    | Move focus in a vertical toolbar                |
| `Home` / `End`             | Focus the first or last item, except in a field |
| `Enter` / `Space`          | Activate a button or toggle, or open its popup  |

Controls keep the keys they use: Down opens a menu, and Up and Down step a number input. Moving focus never presses a toggle. In right-to-left text, Left and Right swap.
