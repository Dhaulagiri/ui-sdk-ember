---
title: Trigger Menu
description: "Opens suggestions at the caret when you type a trigger such as @, /, or #."
---

A trigger menu suggests what to insert when someone types a trigger character, like `@` for people or `/` for commands. It opens at the caret, narrows as they type, and inserts the choice into the text.

[trigger-menu/demo](../../examples/components/trigger-menu/ember/demo.gts)

Type @, narrow the list with a name, and press Enter to insert the highlighted person.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `TriggerMenu`:

```text
TriggerMenu as |m|
├── m.Input
├── m.Status
└── m.Content
    ├── m.Empty
    └── m.List
        ├── m.Item
        └── m.Item
```

`TriggerMenu` holds the triggers and what each one lists. `m.Input` is the field people type in, and `m.Content` is the popup with the suggestions. Without a `m.Content` among its direct children, the menu renders the current trigger's items for you. Inside a [Token Input](./token-input.md), leave out `m.Input`: the menu suggests into the token input.

## Usage

Import the root and use the parts it yields:

```gts
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"

const triggers = [{ char: "@" }]

<template>
  <TriggerMenu @triggers={{triggers}} as |m|>
    <m.Input aria-label="Message" placeholder="Type @ to mention someone…" />
    <m.Content>
      <m.List>
        <m.Item @value="hollis" @label="Hollis Grant">Hollis Grant</m.Item>
        <m.Item @value="ines" @label="Inès Moreau">Inès Moreau</m.Item>
      </m.List>
    </m.Content>
  </TriggerMenu>
</template>
```

`@label` is the text an item is matched by and inserts. Choosing Hollis Grant replaces `@` and what was typed after it with `@Hollis Grant `.

## Trigger Menu or Token Input

Trigger Menu suggests what to insert: it matches the trigger, filters, moves the highlight, loads items and asks for a command's arguments. [Token Input](./token-input.md) holds a value that mixes text and tokens.

Use Trigger Menu with a textarea or an input to insert text. Put it inside a Token Input to insert tokens instead.

## Triggers as Data

Give each trigger a `char` and its `items`. Items can be strings, objects, groups or a loader, and they render themselves when you leave out `m.Content`. The same field can offer people after `@`, commands after `/` and channels after `#`.

[trigger-menu/data](../../examples/components/trigger-menu/ember/data.gts)

Type @ for people, / at the start for commands, or # to load channels.

## Commands with Arguments

A trigger with `boundary: "start"` matches only at the start of the text, so a leading space escapes it. An item with `arguments` asks for each one in order: `m.Hint` shows what's left at the caret, Tab accepts the highlighted suggestion and moves to the next argument, Enter finishes once only optional arguments remain, and Backspace past an argument's start goes back. An argument without `items` is free text. `after: "submit"` sends the form once the item is inserted.

[trigger-menu/commands](../../examples/components/trigger-menu/ember/commands.gts)

Type /status, then press Tab to choose a status and an optional time, and Enter to finish. Choose /away to send it at once. The console logs each command.

## Icons

Put an item's icon in a `item.Icon`, before its text. Screen readers skip it, and filtering and the text a choice inserts ignore it, so an SVG's `<title>`, an icon font's glyph or an emoji never joins the item's name or the field. Items as data have no icon, so compose the items that show one.

- **Icons that point a way**, like arrows and reply, flip in right-to-left text with `@mirror={{true}}`.
- **Items with only an icon** need an `aria-label`, which filtering matches too. In development, one with no name warns.
- **Lining up items.** Items with an icon get `data-has-icon`, and the list gets `data-has-icons` while any item has one, so items without an icon can keep its space with padding.

[trigger-menu/icons](../../examples/components/trigger-menu/ember/icons.gts)

Type / to open the commands, then type re to narrow them. Each icon sits before its name, and filtering ignores it.

## Loading Items

A trigger's `items` can be a loader, called with the query and an `AbortSignal` once typing pauses. A newer query aborts the older load, so only its results land, and the last results stay while the next ones load. `m.Status` and `m.Empty` get `loading`, and while a load runs, `aria-busy` marks the list, so you can fade the results that are about to change.

[trigger-menu/async](../../examples/components/trigger-menu/ember/async.gts)

Type # and a channel name. The list says it's loading, and older results fade while newer ones load.

## Custom Items

Compose `m.Item`s with any content, in groups. `@label` is what's matched and inserted, `keywords` adds words to match, and `disabled` keeps an item in the list without letting it be chosen. A trigger's `spaces`, `pattern` and `maxLength` decide what its query may hold, `filter` how it narrows the items, and `insert` what replaces the trigger and query. An item's own `@onSelect` runs first and can insert something else with `details.insert()`.

[trigger-menu/custom-items](../../examples/components/trigger-menu/ember/custom-items.gts)

Type @ and the start of a first name to insert it, or choose Notify everyone here to insert @here. Deactivated people can't be chosen.

## Input

Render the input part as an `<input>` for a single line, using `@render={{true}}` on `m.Input`. It's a combobox with `aria-expanded`. In a single line, Enter often submits a form, so this example sets `@autoHighlight={{false}}`: Enter chooses only once an arrow key has highlighted a person, and `@loop={{false}}` stops the arrows at either end of the list.

[trigger-menu/input](../../examples/components/trigger-menu/ember/input.gts)

Type @ in the empty task. Nothing is highlighted until you press ArrowDown, then Enter assigns the person.

## Positioning

By default, the list opens below the trigger at the caret and flips to stay on screen. `@side`, `@align` and the offsets place it, and `@anchor` positions it against another element. This example opens the list above the whole field, lines its items up with the label, and renders it inside the field with `@container`.

[trigger-menu/positioning](../../examples/components/trigger-menu/ember/positioning.gts)

Type @ in the comment. The list opens above the field, lined up with its label.

## Controlled

Pass `@open` and update it in `@onOpenChange`, which receives the reason. `@onQueryChange` reports the text after the trigger and the argument being typed, and `@onOpenChangeComplete` runs once the menu has finished opening or closing. Escape dismisses a match, and `@shortcut` reopens it, Control+Space by default.

[trigger-menu/controlled](../../examples/components/trigger-menu/ember/controlled.gts)

Type @ and a name, press Escape, then Control+J to reopen the list. The console logs each callback with its reason.

## Controller

Create a controller with `createTriggerMenuController()` and pass it as `@controller` to open suggestions, insert text at the caret, or read the current match. `open()` types the trigger at the caret and returns a Promise that resolves when the menu closes.

[trigger-menu/controller](../../examples/components/trigger-menu/ember/controller.gts)

Press Mention and choose a person. The console logs why the list closed. Insert Date adds today's date at the caret.

## Any Editor

Pass `@editor` to connect the menu to a field you render yourself, or to another editor. `textFieldAdapter()` makes one for a textarea or an input.

[trigger-menu/editor](../../examples/components/trigger-menu/ember/editor.gts)

Type @ in the notes, a textarea connected through an editor adapter, and choose a person.

An adapter for another editor reads its text and selection, measures a rectangle at an offset, replaces a range as one undo step, and reports changes. Report changes that weren't the user's with `user: false`, like a collaborator's, and the menu never opens for them.

## Undo

Choosing an item keeps the native text field's undo history. Press Command+Z or Control+Z to bring back the query. Safari may combine the insertion with the typing before it in one undo step.

A custom editor must make each replacement one undo step. [Token Input](./token-input.md) handles its own token history.

## Styling

Style the field, the popup and its items. The content shows `data-trigger`, so each trigger's list can look different, like commands in a monospace font. Items show `data-highlighted` and `data-disabled`, and `data-has-icon` when they hold an icon; the list shows `data-has-icons` while any item has one. Fade a loading list with `aria-busy`, and style the hint as ghost text: it's positioned at the caret for you.

Each part has a `data-slot`, such as `trigger-menu-item`, and shows its state through the attributes listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/trigger-menu#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [trigger-menu reference](https://ui-sdk.dev/docs/react/components/trigger-menu) in the upstream docs.

Pass the root's options as `@` arguments. `@open` is controlled with `@onOpenChange`.

### TriggerMenuInput

The field the menu suggests into. Renders a `textarea`, or an `input` through `@render`.

### TriggerMenuStatus

A polite status that says the count and the keys once typing pauses. Renders a `div`.

### TriggerMenuEmpty

Shown while no item matches. Rendering it keeps the menu open with no matches; without it, the menu closes until something matches. Renders a `div`.

### TriggerMenuList

The listbox. Without a block, it renders the current trigger's items. Renders a `div`.

### TriggerMenuGroup and TriggerMenuGroupLabel

A group of items, named by its label. Each renders a `div`.

### TriggerMenuSeparator

A line between items or groups, hidden from screen readers. Renders a `div`.

### TriggerMenuHint

Ghost text at the caret for the arguments still to type, like `<status>`. Renders a `span`, hidden from screen readers.

### Controller

Create one with `createTriggerMenuController()` and pass it as `@controller`.

### Events

Callbacks get the new state first, then the details. A controlled `@open` only updates when `@onOpenChange` wasn't canceled.

| Argument                | On                               | Receives                                                                                                                        |
| ----------------------- | -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `@onOpenChange`         | `TriggerMenu`                    | `(open, details)`: the new state, the [reason](https://ui-sdk.dev/docs/react/components/trigger-menu#reasons) and the `trigger` |
| `@onOpenChangeComplete` | `TriggerMenu`                    | `(open)`, after the animation                                                                                                   |
| `@onQueryChange`        | `TriggerMenu`                    | `(query, details)`: the text after the trigger, and the `argument` being typed                                                  |
| `@onDismissAttempt`     | `TriggerMenu`                    | `({ reason, event })`, when a dismissal was refused                                                                             |
| `@onSelect`             | `TriggerMenu`, `TriggerMenuItem` | `(value, details)`: the item, its `arguments`, `insert()` and `preventDefault()`                                                |

When `@onSelect` returns a Promise and the editor takes tokens, the token is inserted at once with `data-pending`, updated with what the Promise resolves to, and removed if it rejects. The menu closes either way, so people keep typing.

## Accessibility

Focus stays in the field while the arrow keys move the highlight. A `<textarea>` stays a textbox, the only role ARIA allows it, and points at the list with `aria-controls` and, after an arrow key, `aria-activedescendant`. An `<input>` is a combobox with `aria-expanded`. Counts and loading are said through `m.Status`, a polite status, never through the field, so render one: visually hidden, as in the demo, or at the top of the list, as in [Loading Items](#loading-items). Give the field a visible label through a [Field](./field.md), or an `aria-label`.

### Keyboard

| Key                  | Does                                                                                              |
| -------------------- | ------------------------------------------------------------------------------------------------- |
| ArrowDown, ArrowUp   | Moves the highlight while the list is open; the caret stays in the field                          |
| Enter                | Chooses the highlighted item. In a command's arguments, finishes once only optional ones are left |
| Tab                  | Chooses the highlighted item, or accepts an argument and moves to the next                        |
| Escape               | Closes the list and dismisses the match, so typing on doesn't reopen it                           |
| Control+Space        | Reopens a dismissed match with the caret in it; `@shortcut` changes the key                       |
| Backspace            | Past an argument's start, goes back to the previous argument                                      |
| Command+Z, Control+Z | Undoes the insertion and brings back the query                                                    |
