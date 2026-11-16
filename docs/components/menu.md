---
title: Menu
description: Choose actions and settings from a button or a context menu.
---

Start with a trigger and a few actions. Add groups, checkboxes, radio choices, or submenus as the task grows. The menu handles focus, arrow keys, typeahead, and dismissal.

[menu/basic](../../examples/components/menu/ember/basic.gts)

Press Open Menu and choose an item, with the pointer or the arrow keys and Enter. The menu closes and the console logs your choice.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Menu`:

```text
Menu as |m|
├── m.Trigger
└── m.Content
    ├── m.Item
    └── m.Item
```

Give items a `@value` and handle `@onAction` on the menu to run the selected command. A Group and its Label can organize related actions; a Separator divides them without becoming a focus stop.

Return a promise from `@onAction` or an item’s `@onSelect` to keep the item pending. It gets `data-pending`, `aria-busy` and `aria-disabled`, the menu stays open, and choosing it again does nothing until the promise settles. The menu closes once it resolves. A rejection keeps it open and puts the reason in the item’s `error` state until the next try. After a second, screen readers hear `pendingAnnouncement`, “Loading” by default.

## Usage

Import the root and use the parts it yields:

```gts
import { Menu } from "ember-ui-sdk/menu"

<template>
  <Menu as |m|>
    <m.Trigger>Actions</m.Trigger>
    <m.Content>
      <m.Item @value="rename">Rename</m.Item>
      <m.Item @value="duplicate">Duplicate</m.Item>
    </m.Content>
  </Menu>
</template>
```

## Submenus

Nest a `m.Sub` with its own `s.Trigger` and `s.Content` to add another level. Hover or press the arrow key toward a submenu to open it. The menu lets a pointer travel diagonally into the submenu without accidentally choosing an item it passes over. Escape closes only the submenu and returns focus to its trigger, as the menu pattern asks.

[menu/submenu](../../examples/components/menu/ember/submenu.gts)

Open Edit, then Find or Transform. Use the arrows to enter and leave each level; choosing an action closes the menu tree.

## Shortcuts

An item’s `@shortcut` displays a platform-specific hint and sets `aria-keyshortcuts`. `mod+s` reads as Command+S on Apple platforms and Control+S elsewhere.

In markup, this is a hint: your app owns the key handler. [Data menus](#menus-as-data) also register their shortcuts while closed. Letters and digits match physical keys, including combinations such as Option+N.

[menu/shortcuts](../../examples/components/menu/ember/shortcuts.gts)

Open File to see shortcut hints for your platform. Choose an item to report its action; this markup example does not register global shortcuts.

## Icons

Put decorative icons in `m.ItemIcon` so screen readers and typeahead ignore them. `@mirror={{true}}` flips a directional icon in right-to-left text. An icon-only item still needs an `aria-label`.

`data-has-icon` on items and `data-has-icons` on the menu let text line up when only some items have icons.

[menu/icons](../../examples/components/menu/ember/icons.gts)

Open Share and type an item’s name. The icons aren’t part of the item’s accessible name or the text typeahead matches.

## Checkboxes

Checkbox items toggle independently and stay open by default. Pass `@checked` and update it in `@onCheckedChange`, or use `@defaultChecked` for an uncontrolled item. An item indicator renders the check; `@keepMounted={{true}}` preserves its space while unchecked. Style `data-checked` and `data-unchecked` for each state.

[menu/checkboxes](../../examples/components/menu/ember/checkboxes.gts)

Open View and toggle Status bar or Minimap. The menu stays open so you can change several settings, and the console logs each one.

## Radio Group

Radio items choose one value in their group and stay open by default. Pass `@value` and update it in `@onValueChange`, or use `@defaultValue` for an uncontrolled group. Give the group a `@name` when it should identify itself in the menu’s value-change callback.

[menu/radio-group](../../examples/components/menu/ember/radio-group.gts)

Open Panel and choose a position. Only one item in each group is checked, the menu stays open, and the console logs the change.

## Context Menu

A `m.ContextTrigger` opens at a right-click or long press. Give the area a tab stop so Shift+F10 and the context-menu key can open it from the keyboard. Right-clicking elsewhere in the same area repositions an open menu.

Set `@disabled={{true}}` to leave that area’s native browser menu available. Context triggers can pass a payload too.

[menu/context-menu](../../examples/components/menu/ember/context-menu.gts)

Right-click or long-press the area, or focus it and press Shift+F10. Choose an action and the console logs it.

## Placement

`@side` and `@align` choose the starting position. The menu flips or shifts when it does not fit; `data-side` reports where it ended up. Logical alignment and submenu keys follow the surrounding text direction.

```gts
<m.Content @side="right" @align="start">…</m.Content>
```

## Offsets and Collision Padding

`@sideOffset` sets the gap, `@alignOffset` shifts along the anchor, and `@collisionPadding` leaves room around the viewport. Use `--anchor-width` to match the trigger's width and `--available-height` to scroll a long list.

```gts
<m.Content @sideOffset={{8}} @alignOffset={{-4}} @collisionPadding={{24}}>…</m.Content>
```

## Modal

The default `@modal="pointer"` consumes an outside press while closing the menu. `@modal={{true}}` also locks scrolling and makes the page inert. `@modal={{false}}` lets the outside press reach its target after closing.

```gts
<Menu @modal={{false}} as |m|>
  <m.Trigger>Actions</m.Trigger>
  <m.Content />
</Menu>
```

## Submenu Delay

`@delay` is the hover wait in milliseconds, 100 by default. It applies to the submenus directly inside that menu. Set it on a `m.Sub` to change the delay for the next level.

```gts
<Menu @delay={{300}} as |m|>
  <m.Trigger>File</m.Trigger>
  <m.Content>
    <m.Sub @delay={{0}} as |s|>
      <s.Trigger>Open recent</s.Trigger>
      <s.Content />
    </m.Sub>
  </m.Content>
</Menu>
```

## Keyboard Navigation

Arrow keys wrap by default; `@loop={{false}}` stops at the ends. Typing finds an item by name. If an item has extra descriptive text, set `@label` to the text typeahead should match. `@label` does not replace its accessible name; use `aria-label` for that.

```gts
<Menu @loop={{false}} as |m|>
  <m.Trigger>Status</m.Trigger>
  <m.Content>
    <m.Item @value="busy" @label="Do not disturb">
      Do not disturb
      <span>Notifications are muted</span>
    </m.Item>
  </m.Content>
</Menu>
```

## Focus After Closing

When the menu closes with focus inside it, focus returns to the trigger. If an action removes the trigger or moves people on to something else, set `@finalFocus` on the content to a selector, an element or a function returning one, or to `"none"` to leave focus where the action put it.

```gts
<m.Content @finalFocus="#file-list">…</m.Content>
```

## Disabled Items

Disabled items remain focusable so people can discover them, but cannot run or open a submenu. A disabled trigger is a native disabled button and cannot receive focus. Add `@focusableWhenDisabled={{true}}` to keep it in the tab order, so it can host a tooltip that says why; presses still do nothing.

[menu/disabled](../../examples/components/menu/ember/disabled.gts)

Open Document and move through its items with the arrow keys. Disabled actions remain discoverable but cannot run; Locked cannot open a menu.

## Keeping the Menu Open

Plain items close when selected; checkbox and radio items stay open. `@closeOnSelect` changes either default. A selection handler can also prevent the default event to keep it open for one action.

```gts
<m.Item @value="zoom-in" @closeOnSelect={{false}}>Zoom in</m.Item>
<m.CheckboxItem @value="fit" @closeOnSelect={{true}}>Fit to window</m.CheckboxItem>
```

## Container

Menus render in place and use the top layer. `@container` moves the popup to another element; submenus remain inside their parent popup. Pass the actual element after it exists.

```gts
<m.Content @container={{this.panel}}>…</m.Content>
```

## Animation

The menu stays mounted through an exit animation. `data-starting-style`, `data-ending-style`, `data-side`, and `--transform-origin` describe the transition. `@keepMounted={{true}}` leaves the closed content hidden afterward; `@onOpenChangeComplete` reports when it finishes.

[menu/animation](../../examples/components/menu/ember/animation.gts)

Open Animated, then its More tools submenu, and close them. The console logs Opening or Closing, then when the animation finishes.

## Presentation

`@presentation="auto"` uses a sheet on small touch screens and a popover elsewhere; `"sheet"` always requests a sheet. The sheet keeps menu roles and keys. Submenus replace the current level, and Escape or the arrow toward the parent goes back. Context menus and menus in a menubar remain popovers.

Use `data-presentation` or the content’s `presentation` state for the two layouts. Leave a sheet’s translation to the SDK. `--sheet-backdrop` sets its dimming color, and the sheet is modal unless `@modal` is false.

[menu/presentation](../../examples/components/menu/ember/presentation.gts)

Open Options as a sheet, enter Move to, then go back or choose a destination. You can drag downward to dismiss the sheet.

## Controlled

Pass `@open` and update it in `@onOpenChange`. A change carries a reason, and `details.cancel()` can refuse it. A controller can open the menu from another control.

```gts
<Menu @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |m|>
  <m.Trigger>Actions</m.Trigger>
  <m.Content />
</Menu>
```

## Triggers Outside the Menu

Connect external triggers and one menu to a `createMenuController<File>()`. Each trigger passes its row as `@payload`, which the content reads from its state. Only the active trigger is expanded and receives focus back. Code can also open with a `payload` and `anchor`; the Promise resolves when the menu closes.

[menu/payload](../../examples/components/menu/ember/payload.gts)

Open the actions for different files. One menu shows the active row; opening from code uses the same payload and reports the closing reason.

## Menus as Data

`@items` accepts `MenuData`: actions, groups, checkboxes, radio groups, and submenus. A string is shorthand for an item whose label and value match. Data menus register their shortcuts even while closed; set `@itemShortcuts={{false}}` to turn that off.

`@onCheckedChange` reports the checkbox’s value in `details.value`; `@onValueChange` reports the radio group’s name in `details.group`. Either change can be canceled. You can also render your own parts from the same data while `@items` keeps the shortcuts registered. Lists and Menus covers the data shape.

```gts
import { Menu } from "ember-ui-sdk/menu"
import type { MenuData } from "ember-ui-sdk/menu"

const fileMenu: MenuData = [
  { value: "open", label: "Open…", shortcut: "mod+o" },
  { type: "separator" },
  {
    type: "checkbox",
    value: "toolbar",
    label: "Toolbar",
    defaultChecked: true,
  },
  {
    type: "radio-group",
    name: "sort",
    label: "Sort by",
    defaultValue: "name",
    items: [
      { value: "name", label: "Name" },
      { value: "date", label: "Date modified" },
    ],
  },
  { type: "submenu", label: "Share", items: ["Copy link", "Email"] },
]

<template>
  <Menu @items={{fileMenu}} @onAction={{this.run}} as |m|>
    <m.Trigger>File</m.Trigger>
    <m.Content />
  </Menu>
</template>
```

## Links and Custom Rendering

Render an item as a native link by passing `@render={{true}}` and binding the yielded `part` to your element. Enter follows the link like a click, preserving its target and modifier-key behavior.

```gts
<m.Item @value="composition" @render={{true}} as |item|>
  <a {{item.part}} href="#composition">Composition</a>
</m.Item>
```

## Custom Rendering

See [Links and Custom Rendering](#links-and-custom-rendering) for a native link. Every part accepts `@render` the same way, and its state is listed under [State](#api-reference).

## Styling

Use `data-highlighted` for the active item, `data-disabled` for unavailable actions, and `data-checked` for selected settings. Popup sizing and motion hooks are shared across the popup components.

Each part has a `data-slot`, such as `menu-item`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/menu#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [menu reference](https://ui-sdk.dev/docs/react/components/menu) in the upstream docs.

Pass the root's options as `@` arguments. `@open`, `@checked` and `@value` are controlled with their `@on…Change` callbacks.

### MenuTrigger

A trigger outside the menu also takes `@controller`.

### MenuSubContent

It takes the same arguments as `MenuContent`.

### MenuGroup, MenuGroupLabel and MenuSeparator

These take no arguments of their own, only the arguments of the element they render.

### Controller

Create one with `createMenuController<Payload>()` and pass it as `@controller`, to the menu and to any triggers outside it. `Payload` is the type of the data triggers and `open()` pass.

Every write method takes an optional `{ reason, event }`, passed to `@onOpenChange`. `open()` also takes `focus`: `"first"`, `"last"`, `"popup"` or `"none"`.

### Events

Callbacks get the new state first, then the details. A controlled `@open`, `@checked` or `@value` only updates when its change callback wasn't canceled.

| Argument                | On                 | Receives                                                                                                                 |
| ----------------------- | ------------------ | ------------------------------------------------------------------------------------------------------------------------ |
| `@onOpenChange`         | `Menu`             | `(open, details)`: the new state, and the [reason](https://ui-sdk.dev/docs/react/components/menu#reasons)                |
| `@onOpenChangeComplete` | `Menu`             | `(open)`, after the animation                                                                                            |
| `@onPayloadChange`      | `Menu`             | `(payload, details)`: the content's new payload, and the [reason](https://ui-sdk.dev/docs/react/components/menu#reasons) |
| `@onAction`             | `Menu`             | `(value, { event })` for every plain item, including items in submenus                                                   |
| `@onCheckedChange`      | `Menu`             | `(checked, details)`, with the item's value in `details.value`. For data menus                                           |
| `@onValueChange`        | `Menu`             | `(value, details)`, with the group's name in `details.group`. For data menus                                             |
| `@onDismissAttempt`     | `Menu`             | `({ reason, event })`, when a dismissal was refused                                                                      |
| `@onOpenChange`         | `MenuSub`          | `(open, details)`: the new state, and the [reason](https://ui-sdk.dev/docs/react/components/menu#reasons)                |
| `@onSelect`             | `MenuItem`         | `(event)`, before the menu closes. `event.preventDefault()` keeps it open                                                |
| `@onCheckedChange`      | `MenuCheckboxItem` | `(checked, details)`: the new state, and the [reason](https://ui-sdk.dev/docs/react/components/menu#reasons)             |
| `@onValueChange`        | `MenuRadioGroup`   | `(value, details)`: the selected value, and the [reason](https://ui-sdk.dev/docs/react/components/menu#reasons)          |

## Accessibility

The menu follows the [WAI-ARIA menu button pattern](https://www.w3.org/WAI/ARIA/apg/patterns/menu-button/).
