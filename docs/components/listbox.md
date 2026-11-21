---
title: Listbox
description: Choose one or several options from an always-visible list.
---

Use a Listbox when the choices should stay in view. It works like a native select with several visible rows, with keyboard navigation, typeahead, and optional range selection.

[listbox/basic](../../examples/components/listbox/ember/basic.gts)

Choose Comments, then hold Shift and choose New sign-ins to select the range. A click replaces the selection; Ctrl or ⌘ adds one option.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Listbox`:

```text
Listbox as |l|
├── l.Item as |i|
│   └── i.Indicator
└── l.Item as |i|
    └── i.Indicator
```

Give the list an accessible name and each option a unique `@value`. `i.Indicator` shows its content when that option is selected.

You can also name the list with a [Field label](./field.md) or `aria-labelledby`. Keep buttons, search fields, and empty messages outside the list: its contents should be options, groups, and separators.

## Usage

Import the root and use the parts it yields:

```gts
import { Listbox } from "ember-ui-sdk/listbox"

<template>
  <Listbox aria-label="Toppings" @defaultValue="basil" as |l|>
    <l.Item @value="basil" as |i|>
      Basil
      <i.Indicator>✓</i.Indicator>
    </l.Item>
    <l.Item @value="olive" as |i|>
      Olive
      <i.Indicator>✓</i.Indicator>
    </l.Item>
  </Listbox>
</template>
```

`ember-ui-sdk/listbox` also exports each part by name, such as `ListboxItem` and `ListboxItemIndicator`. They take the root's `@handle`, so use the parts the root yields instead.

## Multiple

Add `@multiple={{true}}` to select several options. The value becomes an array; a single list uses one value or `null`. By default, arrow keys move focus without changing a multiple selection.

| Action                             | Result                                                 |
| ---------------------------------- | ------------------------------------------------------ |
| Press an option or Space           | Toggle that option.                                    |
| Shift + press, arrow key, or Space | Select a range from the last chosen option.            |
| Ctrl/Cmd + Shift + Home or End     | Extend the range to the first or last option.          |
| Ctrl/Cmd + A                       | Select every enabled option, then clear the selection. |

Changing a Shift range preserves the options selected before that range began.

[listbox/multiple](../../examples/components/listbox/ember/multiple.gts)

Choose Basil, then hold Shift and choose Pepper to select a range. Use Ctrl+A or ⌘A to select every option, then again to clear. The console logs each change.

## Selection That Follows Focus

A single list selects as arrow keys, Page Up and Page Down, Home, End, or typing move focus. Page Up and Page Down move ten options, and stop at the ends. A multiple list can do the same with `@activation="automatic"`, like a file list: a press or arrow replaces the selection, Ctrl or Cmd adds to it, and Ctrl or Cmd with an arrow moves focus without selecting.

Taps and screen-reader presses toggle an option instead, since they do not have modifier keys.

```gts
<Listbox @multiple={{true}} @activation="automatic" aria-label="Files" as |l|>…</Listbox>
```

[listbox/activation](../../examples/components/listbox/ember/activation.gts)

Choose index.ts to replace the selection. Hold Ctrl or Cmd while choosing another file to add it; Shift selects a range.

## Manual Activation

Set `@activation="manual"` on a single list to browse without selecting. Space, Enter, or a press chooses the focused option.

[listbox/manual](../../examples/components/listbox/ember/manual.gts)

Move through the options with the arrow keys. Nothing is selected until you press Space or Enter, and the console logs the choice.

## Focus on the List

Set `@virtualFocus={{true}}` to keep focus on the list itself while arrow keys, Home, End, and typing move a highlight through the options. The list points at the highlighted option with `aria-activedescendant`, so screen readers still announce it. Style the highlight with `[data-highlighted]`, since the options don't take focus.

[listbox/virtual-focus](../../examples/components/listbox/ember/virtual-focus.gts)

Tab into the list and move through it with the arrow keys. Focus stays on the list, and Space or Enter chooses the highlighted option.

## Deselectable

Add `@deselectable={{true}}` to let pressing the selected option clear a single selection. Without it, the selection stays as it is.

[listbox/deselectable](../../examples/components/listbox/ember/deselectable.gts)

Press Astro again to clear the selection, or choose another framework. The console logs each change.

## Groups

Use `l.Group` with `g.Label` to name a group. Arrow keys and ranges continue across groups. Separators stay out of the accessibility tree.

[listbox/groups](../../examples/components/listbox/ember/groups.gts)

Move from Apple through the list with Down Arrow. Navigation continues into the Vegetables group.

## Icons

Wrap an icon in `i.Icon` so screen readers and typeahead skip it. Add `@mirror={{true}}` to a directional icon to flip it in right-to-left text.

[listbox/icons](../../examples/components/listbox/ember/icons.gts)

Choose Drafts. The icon stays out of the option’s accessible name and the text used for typeahead.

## Horizontal

Set `@orientation="horizontal"` to move with Left and Right Arrow. Arrow keys normally wrap; set `@loop={{false}}` to stop at the ends, as this example does. Shift ranges never wrap.

The list reads `dir="rtl"` from the page or an ancestor, so Left Arrow moves to the next option in right-to-left text.

[listbox/horizontal](../../examples/components/listbox/ember/horizontal.gts)

Focus M, then use Left and Right Arrow to choose a size. The list stops at its ends; XL cannot be selected.

## Disabled

A disabled option cannot be selected. Arrow keys, typeahead and ranges skip it. Disabling the whole list removes its tab stop, prevents changes, and excludes its value from the form.

[listbox/disabled](../../examples/components/listbox/ember/disabled.gts)

Try choosing Olive. Then press Disable the List to make every option unavailable until you enable it again.

## Read-Only

Use `@readOnly={{true}}` when people should be able to browse the list without changing its value. The list remains focusable and its value still submits.

[listbox/read-only](../../examples/components/listbox/ember/read-only.gts)

Move focus through the frameworks. Nuxt stays selected because the list is read-only.

## Form

Add `@name` to submit the selection. Multiple selections submit one entry per value. Reset restores `@defaultValue`, and `@required={{true}}` prevents submission when nothing is selected.

The server HTML includes the hidden inputs for the current selection, so those values can submit before hydration.

The list can live outside its form: set `@form` to the form’s ID, as this example does. A disabled fieldset also disables the list.

[listbox/form](../../examples/components/listbox/ember/form.gts)

Choose Basil and press Order: the console logs both toppings. Reset restores Extra cheese; clearing every option makes the required list block the order.

## Object Values

Pass objects as item values when the selection should carry more than an ID. `@itemToValue` provides the string used for identity and form submission; `@isItemEqualToValue` matches objects that represent the same option but are different instances.

[listbox/data](../../examples/components/listbox/ember/data.gts)

Choose Team. The console logs the price from the selected object, not from its string ID.

To keep markup and classes explicit, map the data into parts, as the example does.

## Controller

A controller can select all options, clear the selection, or focus the list from another control. Create one with `createListboxController()` and pass it as `@controller`.

[listbox/controller](../../examples/components/listbox/ember/controller.gts)

Press Select All, Clear and Focus. Each button drives the same list through its controller, and the console logs the change.

## Scrollable

Give a long list a maximum height and `overflow-y: auto`. It starts scrolled to the selected option without taking focus. Keyboard navigation reveals the focused option without scrolling the page.

[listbox/scrollable](../../examples/components/listbox/ember/scrollable.gts)

Focus the list and use the arrow keys. Options scroll into view, and the console logs the focused time zone.

For a virtualized list, supply `@items` so typeahead knows about unmounted options. `@onHighlight` reports the focused value and index; each rendered item's `index` places it in the full collection for screen readers.

Set `@keepInView={{false}}` when something else scrolls the list, like a wheel that picks the option at its center. The list then leaves its scroll position alone as keys move focus.

## Custom Rendering

Render an option as a link when choosing it should navigate. Pass `@render={{true}}` to the item and bind its `part` to the link. A press or Enter follows the link and selects the option. This example uses manual activation so arrow keys only browse.

```gts
<l.Item @value="remix" @render={{true}} as |i|>
  <a {{i.part}} href="#remix">Remix</a>
</l.Item>
```

[listbox/render](../../examples/components/listbox/ember/render.gts)

Focus Remix and press Enter, or choose it with the pointer. The option is selected and its link updates the URL hash.

Each part's state is listed [below](https://ui-sdk.dev/docs/react/components/listbox#state).

## Styling

Use `data-selected` for the selection and `data-highlighted` for focus. They can describe different options when selection does not follow focus. Disabled and read-only states have their own attributes.

Each part has a `data-slot`, such as `listbox-item`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/listbox#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [listbox reference](https://ui-sdk.dev/docs/react/components/listbox) in the upstream docs.

Options and callbacks are passed as arguments, such as `@value` and `@onValueChange`. Every part also takes `@render`.

### ListboxItemIcon

`ListboxGroup`, `ListboxGroupLabel` and `ListboxSeparator` take no options of their own.

### Controller

Create one with `createListboxController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, passed to `@onValueChange`.

### Events

Callbacks get the new value first, then the details.

| Argument         | On        | Receives                                                                                                      |
| ---------------- | --------- | ------------------------------------------------------------------------------------------------------------- |
| `@onValueChange` | `Listbox` | `(value, details)`: the new value, and the [reason](https://ui-sdk.dev/docs/react/components/listbox#reasons) |
| `@onHighlight`   | `Listbox` | `(value, details)`: the focused option's value, and its index                                                 |

## Accessibility

Follows the [WAI-ARIA listbox pattern](https://www.w3.org/WAI/ARIA/apg/patterns/listbox/), with both of its keyboard models for several options. Options take real focus with one roving tab stop. Every option says whether it's selected.

### Focus

The list is one tab stop. Tab returns to the last focused option, then falls back to the first selected or enabled option. Options receive real DOM focus, so `focus-visible` works directly. With `@virtualFocus`, the list is the tab stop and keeps focus instead.

The root forwards focus into the options, including when you press a field label or the list's padding. Escape stays available to an enclosing dialog.
