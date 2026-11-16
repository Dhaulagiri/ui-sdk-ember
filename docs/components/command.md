---
title: Command
description: Search commands, run actions, and open pages of more choices.
---

Command puts a search field over a list of actions. The list stays open while someone searches. You can use it on its own, or put it in a dialog to build a command palette.

[command/demo](../../examples/components/command/ember/demo.gts)

Type “bil” to find Billing. Arrow keys move the highlight; Escape clears the search.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Command`:

```text
Command as |c|
├── c.Input
├── c.Empty
└── c.List
    ├── c.Item
    └── c.Item
```

Give the input an accessible name and each command a unique value. Keep empty and status messages outside the list, which holds commands and groups. `@onAction` reports the value of the command that ran; use it to perform the action.

Use `c.Group` and `g.Label` to name related commands, with a `c.Separator` between groups. Groups and separators disappear when filtering leaves them empty.

## Usage

Import the root and use the parts it yields:

```gts
import { Command } from "ember-ui-sdk/command"

<template>
  <Command as |c|>
    <c.Input aria-label="Search commands" />
    <c.Empty>No commands found.</c.Empty>
    <c.List>
      <c.Item @value="new-file">New file</c.Item>
      <c.Item @value="new-folder">New folder</c.Item>
    </c.List>
  </Command>
</template>
```

## Dialog

Put Command inside a [Dialog](./dialog.md) for a command palette. Give the dialog a title, put `@shortcut="mod+k"` on its trigger, and close it when a command runs. The dialog handles dismissal and returns focus to the trigger.

[command/dialog](../../examples/components/command/ember/dialog.gts)

Press Search or use Cmd+K / Ctrl+K. Choose a command to run it and close the palette; the console logs what ran.

## Shortcuts

An item’s `@shortcut` can run it while the command list is mounted, even when the search or current page hides it. `item.Shortcut` displays the keys for the current platform, and the item gets `aria-keyshortcuts`. Shortcuts inside a dialog run while it is open.

[command/shortcuts](../../examples/components/command/ember/shortcuts.gts)

Press Cmd+P / Ctrl+P to run Profile, even when the search hides it. The console logs each command that runs.

## Highlight Matches

`item.Text` marks the matched text. The default fuzzy filter can match letters that are apart, so one command may have several marked segments.

[command/highlight](../../examples/components/command/ember/highlight.gts)

Type “prf” to find Profile. Matching letters are marked even when they are not next to each other.

## Filter and Keywords

`"fuzzy"` is the default: `nf` matches New file. `"contains"` and `"startsWith"` match the text itself. A custom function returns a boolean or a score; zero hides a command and higher scores rank first.

Data commands are sorted by score. Commands written directly in markup keep their order, even though the best match can be highlighted.

`@keywords` adds search terms without changing the command's label. Use it for synonyms or names someone might type instead.

[command/filter](../../examples/components/command/ember/filter.gts)

Type “nf” with Fuzzy to find New file. Choose Words and type “zo in” for Zoom in, or type “smiley” to find Search emoji through a keyword.

## Pages

Set an item’s `@page` to the value of a `c.Page` to open it. An unnamed page holds the first set of commands. The `@pages` array records the stack of pages that have been opened.

Backspace in an empty search goes back and restores the previous page’s query. Escape clears the query first, then goes back. A Go back command can call `pop()` on a controller.

[command/pages](../../examples/components/command/ember/pages.gts)

Choose Change theme or Switch team. Use Go back, or press Backspace in an empty search field, to return.

## Items as Data

Pass `@items` to provide commands, groups, separators, and pages as `CommandData`. A data command with its own `items` opens a page. Its shortcut still works when another page or filter hides it.

The data can render bare parts for you. For styled commands, render from the list’s `state.items`, which follows the current page and ranked results. The example handles groups and separators as well as commands. Lists and Menus covers the shared data format.

Pass `@emptyItems` alongside `@items` to show suggested or recent commands while the first page's search is empty. Once someone types, the full collection is searched.

```gts
const suggested = [{ type: "group", label: "Suggested", items: recent }]

<template>
  <Command @items={{commands}} @emptyItems={{suggested}} as |c|>…</Command>
</template>
```

[command/data](../../examples/components/command/ember/data.gts)

Choose Change theme to open its commands. Press Cmd+I / Ctrl+I to run Open inbox from any page; the console logs what ran.

## Async Results

Use `useAsyncOptions` from `ember-ui-sdk/async-options` to wait for typing to pause and discard stale results. Send query changes to its `setQuery()`, render the returned items, and pass `@status`. Set `@filter={{false}}` to keep the server’s order.

`c.Status` describes loading and failures, and the list gets `aria-busy` while loading. `@onLoadMore` can request another page when scrolling or highlighting reaches the last command. Without a status part, `@announcement` controls the result-count message after typing pauses.

[command/async](../../examples/components/command/ember/async.gts)

Type “login” and wait for matching issues. Replace the text to start a new search; only the latest results appear.

## Pending Actions

Return a promise from `@onAction` or an item’s `@onSelect`. The command gets `data-pending`, `aria-busy` and `aria-disabled` until it settles; further presses do not start another run. A rejection becomes the command’s `error` state, which clears when it runs again.

An item’s `@onSelect` runs before `@onAction`. Call `preventDefault()` on its event to stop the action.

[command/pending](../../examples/components/command/ember/pending.gts)

Run Deploy to production and try it again while it's pending. Sync with server fails and can be retried; the console logs each outcome.

## Virtualized

Pass the full `@items` collection so filtering and keyboard navigation include commands that are not mounted. Render only visible rows, giving each its index in the current results. `@onValueChange` includes that index so you can scroll a newly highlighted row into view.

[command/virtualized](../../examples/components/command/ember/virtualized.gts)

Search 10,000 commands or move through them with the arrow keys. Only the rows near the viewport render.

## Controlled

The highlighted command, search text, and page stack are separate:

| Argument | Shape                               | Change callback  |
| -------- | ----------------------------------- | ---------------- |
| `@value` | A command’s string value or `null`. | `@onValueChange` |
| `@query` | The search text.                    | `@onQueryChange` |
| `@pages` | An array of page values.            | `@onPagesChange` |

Pass them with their change callbacks, or use `@defaultValue`, `@defaultQuery`, and `@defaultPages` for starting state. Change callbacks receive details; call `details.cancel()` to reject a change. `@value` is the highlighted command, not a chosen one, and it changes as the highlight moves. `@onAction` reports activation, so moving the highlight alone does not run a command.

[command/controlled](../../examples/components/command/ember/controlled.gts)

Open Change theme, search and move the highlight. The console logs each highlight, query and page change with its reason.

## Controller

Create a `createCommandController()` for one instance and pass it as `@controller`. It can read and set the highlight, query, and page stack. Use `push()` and `pop()` to navigate pages, `run()` to run the highlighted command or a named one, and `focus()` to focus the search.

[command/controller](../../examples/components/command/ember/controller.gts)

Use the buttons to open pages, search, move the highlight and run it from outside. The console logs each command that runs.

## Custom Rendering

Pass `@render={{true}}` to an item to render it as an anchor when it should navigate. Enter follows the highlighted link; modified clicks keep their usual browser behavior.

[command/custom-rendering](../../examples/components/command/ember/custom-rendering.gts)

Search for Installation and press Enter. The command follows the link to that section on this page.

## Styling

Each part has a `data-slot`, such as `command-item`, and shows its state through the attributes listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/command#data-attributes).

Use `data-highlighted` for the active command and `data-pending` for an action in progress. Give the list a height limit and `overflow-y: auto` for long lists; keyboard navigation scrolls the highlighted command into view. When mixing commands with and without icons, `data-has-icons` on the list and `data-has-icon` on each item let you reserve matching space with logical padding.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [command reference](https://ui-sdk.dev/docs/react/components/command) in the upstream docs.

Pass the root's options as `@` arguments.

### CommandInput

The search field. Renders an `input` with the combobox role.

### CommandStatus

Describes loading and failures. Renders a `div` with the status role.

### CommandEmpty

Shows while no command matches. Renders a `div`.

### CommandList

Holds the commands. Renders a `div` with the listbox role, always shown.

### CommandGroup

Groups commands under a label. Renders a `div` with the group role.

### CommandGroupLabel

Names its group. Renders a `div`.

### CommandItemText

Shows its command's label, and marks what matched the search. Renders a `span`.

### CommandSeparator

Separates commands or groups. Renders a `div` with the separator role.

### Items as Data

Each command in `@items`. Groups are `{ type: "group", label, items }` and separators `{ type: "separator" }`.

### Controller

Create one with `createCommandController()` and pass it as `@controller`.

### Events

Callbacks get the new state first, then the details. A controlled `@value`, `@query` or `@pages` only updates when its callback wasn't canceled.

| Argument         | On            | Receives                                                                                                                            |
| ---------------- | ------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `@onValueChange` | `Command`     | `(value, details)`: the highlighted command, the [reason](https://ui-sdk.dev/docs/react/components/command#reasons) and its `index` |
| `@onQueryChange` | `Command`     | `(query, details)`: the new text, and the [reason](https://ui-sdk.dev/docs/react/components/command#reasons)                        |
| `@onPagesChange` | `Command`     | `(pages, details)`: the new stack, and the [reason](https://ui-sdk.dev/docs/react/components/command#reasons)                       |
| `@onAction`      | `Command`     | `(value, { event })`: the command that ran. Return a Promise to mark it pending                                                     |
| `@onLoadMore`    | `Command`     | `()`, when the last command is reached                                                                                              |
| `@onSelect`      | `CommandItem` | `(event)`: before `@onAction`. `preventDefault()` skips it. A Promise marks it pending                                              |

## Accessibility

The command list follows the [WAI-ARIA combobox pattern](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/) with a listbox that's always shown. Focus stays in the input, which points to the highlighted command with `aria-activedescendant`. Every line below is an automated test.

### Keyboard

| Key                | Does                                                                  |
| ------------------ | --------------------------------------------------------------------- |
| Typing             | Filters the commands and highlights the best match                    |
| ArrowDown, ArrowUp | Moves the highlight. Wraps unless `@loop={{false}}`                   |
| Enter              | Runs the highlighted command, or follows it when it renders as a link |
| Escape             | Clears the search, then goes back a page                              |
| Backspace          | In an empty search, goes back a page and restores its query           |
| An item's shortcut | Runs it while the list is mounted, even when hidden by the search     |

The first available command is highlighted by default. Set `@autoHighlight={{false}}` to wait for an arrow key or pointer movement.
