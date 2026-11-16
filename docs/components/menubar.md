---
title: Menubar
description: Move between an application’s menus with one tab stop.
---

Wrap a few [Menus](./menu.md) in a Menubar to connect their triggers. Tab enters the bar once; arrow keys move between menus, and pointing at another trigger switches an open menu.

[menubar/demo](../../examples/components/menubar/ember/demo.gts)

Tab into the bar and use Left and Right to choose a menu, or point at another trigger once one is open. File has submenus, Edit has shortcuts, and View has checkboxes and an appearance choice. The console logs each one.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Menubar`:

```text
Menubar as |mb|
├── mb.Menu as |m|
│   ├── m.Trigger
│   └── m.Content
│       ├── m.Item
│       └── m.Item
└── mb.Menu as |m|
    ├── m.Trigger
    └── m.Content
        ├── m.Item
        └── m.Item
```

Each Menu joins its surrounding Menubar automatically. There are no separate menubar trigger or item components. Name the bar with `aria-label` when people need to distinguish it from another one.

## Usage

Import the root and use the parts it yields:

```gts
import { Menubar } from "ember-ui-sdk/menubar"

<template>
  <Menubar aria-label="Application" as |mb|>
    <mb.Menu as |m|>
      <m.Trigger>File</m.Trigger>
      <m.Content>
        <m.Item @value="new">New file</m.Item>
        <m.Item @value="open">Open file</m.Item>
      </m.Content>
    </mb.Menu>
    <mb.Menu as |m|>
      <m.Trigger>Edit</m.Trigger>
      <m.Content>
        <m.Item @value="undo">Undo</m.Item>
        <m.Item @value="redo">Redo</m.Item>
      </m.Content>
    </mb.Menu>
  </Menubar>
</template>
```

## Submenu

A submenu still uses the Menu’s `m.Sub`, its trigger, and its content. The arrow toward it enters that level. On an ordinary item, the same arrow can move to the next top-level menu instead.

[menubar/submenu](../../examples/components/menubar/ember/submenu.gts)

Open File and enter Share with the arrow key. Go back to File, then move to Edit without leaving the menubar.

## Vertical

Pass `@orientation="vertical"` to move between triggers with Up and Down. The arrow toward the popup opens it; the arrow back closes it and returns to the trigger.

[menubar/vertical](../../examples/components/menubar/ember/vertical.gts)

Use Up and Down to choose Inbox, Drafts, or Archive. Right opens its menu in left-to-right text; Left returns to its trigger.

## Menus as Data

Each Menu can take `@items` and register its shortcuts while closed. The [Menu data example](./menu.md#menus-as-data) explains the item shapes and callbacks.

```gts
import { Menu } from "ember-ui-sdk/menu"
import { Menubar } from "ember-ui-sdk/menubar"
import type { MenuData } from "ember-ui-sdk/menu"

const file: MenuData = [
  { value: "new", label: "New File", shortcut: "mod+alt+n" },
  { value: "open", label: "Open…" },
  { type: "separator" },
  {
    type: "submenu",
    label: "Share",
    items: [{ value: "email", label: "Email link" }],
  },
]

<template>
  <Menubar as |mb|>
    <mb.Menu @items={{file}} @onAction={{this.run}} as |m|>
      <m.Trigger>File</m.Trigger>
      <m.Content />
    </mb.Menu>
  </Menubar>
</template>
```

## Disabled

A disabled trigger stays focusable with `aria-disabled`, so people can discover it, but cannot open its menu. Set `@disabled={{true}}` on the bar to disable all its triggers while preserving the tab stop.

```gts
<Menubar as |mb|>
  <mb.Menu as |m|>
    <m.Trigger @disabled={{true}}>Share</m.Trigger>
    <m.Content />
  </mb.Menu>
</Menubar>

<Menubar @disabled={{true}} />
```

## Modal

The bar supplies `@modal` to menus that do not set their own value. The default, `"pointer"`, consumes an outside press while closing. With `@modal={{true}}`, the page also becomes inert and stops scrolling, but the menubar stays usable so you can switch menus.

```gts
<Menubar @modal={{true}} as |mb|>…</Menubar>
```

## Loop

Arrow keys wrap between triggers and open menus by default. Set `@loop={{false}}` to stop at the ends.

```gts
<Menubar @loop={{false}} as |mb|>…</Menubar>
```

## Controller

Create one with `createMenubarController()` and pass it as `@controller`. `focus()` moves focus to the bar; `close()` closes its active menu. Each menu still owns its own open state and controller. Connect a shortcut like Alt+M to `focus()`, like an application command that moves focus into its menus.

```gts
import { on } from "@ember/modifier"
import { Menubar, createMenubarController } from "ember-ui-sdk/menubar"

const menubar = createMenubarController()

<template>
  <Menubar @controller={{menubar}} as |mb|>…</Menubar>
  <button type="button" {{on "click" menubar.focus}}>Focus Menubar</button>
</template>
```

## Shared Menu Features

[Checkboxes](./menu.md#checkboxes), [radio groups](./menu.md#radio-group), [icons](./menu.md#icons), [shortcuts](./menu.md#shortcuts), and [links](./menu.md#links-and-custom-rendering) work as they do in Menu. The first example combines settings and actions in one bar. Menus inside a menubar always use the popover presentation.

## Styling

The bar gets `data-open` while any menu is open; a trigger gets it only for its own menu. Use `data-orientation` for row or column layout. Style the popups and their items through the same [Menu attributes and CSS variables](./menu.md#styling).

Each part has a `data-slot`, such as `menubar`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/menubar#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [menubar reference](https://ui-sdk.dev/docs/react/components/menubar) in the upstream docs.

Pass the root's options as `@` arguments.

### Menubar

Menus, items and their icons take the arguments on the Menu page, like [`MenuItemIcon`](./menu.md#menuitemicon).

## Accessibility

The menubar follows the [WAI-ARIA menubar pattern](https://www.w3.org/WAI/ARIA/apg/patterns/menubar/).

### Keyboard

Tab first lands on the first trigger, then remembers the last one used. While a menu is open, moving the pointer onto another enabled trigger opens its menu, unless the pointer is only passing over it on the way into the open menu. Pressing that trigger keeps it open. Moving to a disabled trigger closes the current menu without opening another.

| Key             | On a Trigger              | In an Open Menu                                  |
| --------------- | ------------------------- | ------------------------------------------------ |
| Left / Right    | Previous or next trigger. | Previous or next menu, or enter/leave a submenu. |
| Down            | Open at the first item.   | Next item.                                       |
| Up              | Open at the last item.    | Previous item.                                   |
| Enter / Space   | Open at the first item.   | Choose the focused item.                         |
| Home / End      | First or last trigger.    | First or last item.                              |
| A letter        | Find a trigger by name.   | Find an item by name.                            |
| Escape          | —                         | Close and return to the trigger.                 |
| Tab / Shift+Tab | Leave the bar.            | Close and leave the bar.                         |

These directions describe a horizontal bar in left-to-right text. Right-to-left text reverses the horizontal keys and submenu side; vertical bars use Up and Down between triggers.
