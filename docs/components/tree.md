---
title: Tree
description: Browse a hierarchy of files, pages, or choices with expandable branches.
---

Use a Tree when items have children, like files in folders or pages in a docs sidebar. Start with nested parts, then add selection, checkboxes, or children loaded from a server as you need them.

[tree/demo](../../examples/components/tree/ember/demo.gts)

Expand components to see its files. Use the arrow keys to move between rows and open or close branches.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Tree`:

```text
Tree as |t|
├── t.Item
│   ├── t.Label
│   │   └── t.Indicator
│   └── t.Group
│       └── t.Item
│           └── t.Label
└── t.Item
    └── t.Label
```

Give the tree an accessible name and every item a unique `@value`. An item with a `t.Group` inside it is a branch. The group holds its children; the label names the item. The indicator and checkbox are optional, and they belong to the item around them, so put them inside its label to make them part of the row.

## Usage

Import the root and use the parts it yields:

```gts
import { Tree } from "ember-ui-sdk/tree"

<template>
  <Tree aria-label="Project files" as |t|>
    <t.Item @value="src">
      <t.Label>
        <t.Indicator>›</t.Indicator>
        src
      </t.Label>
      <t.Group>
        <t.Item @value="src/index.ts">
          <t.Label>index.ts</t.Label>
        </t.Item>
      </t.Group>
    </t.Item>
    <t.Item @value="package.json">
      <t.Label>package.json</t.Label>
    </t.Item>
  </Tree>
</template>
```

## Items as Data

Pass `@items` to give the tree its full hierarchy, including collapsed branches. Each `TreeItemData` has a `value`, a `label`, and optional `children`. With no children of its own, the tree renders bare parts from the data:

```gts
import { Tree } from "ember-ui-sdk/tree"

const items = [
  {
    value: "fruit",
    label: "Fruit",
    children: [
      { value: "apple", label: "Apple" },
      { value: "banana", label: "Banana" },
    ],
  },
  { value: "bread", label: "Bread" },
]

<template><Tree aria-label="Groceries" @items={{items}} /></template>
```

To render the rows yourself, keep `@items` on the tree and render them with a recursive component that receives the tree's parts, so keyboard navigation, item counts, and controllers still know the whole hierarchy. The tree example's `Nodes` component does this.

## File Paths

Pass `@paths` for a file explorer. Folders become branches and sort before files; a path ending in `/` represents an empty folder. `treeFromPaths()` returns the same data when you want to render the rows yourself.

Selection and activation are separate. This example uses `@activation="automatic"` so arrow keys select a file, then `@onAction` opens it. Return a promise from the action callback to show a pending state while it opens.

[tree/paths](../../examples/components/tree/ember/paths.gts)

Arrow down to package.json, then press Enter. It shows a spinner while it opens, then the console logs Opened package.json.

## Selection

The default `@mode="single"` uses one string value or `null`. Use `"multiple"` for an array, or `"none"` when items should only navigate or perform actions.

`@activation="automatic"` selects while arrow keys move in single selection mode. Pressing a branch also expands or collapses it; set `@expandOnPress={{false}}` to leave expansion to the indicator and arrow keys.

## Multiple Selection

`@mode="multiple"` makes the value an array. Cmd-click or Ctrl-click toggles one item, Shift extends a range, and Cmd+A or Ctrl+A selects the visible items. This example sets `@expandOnPress={{false}}`, so clicking Inbox or Projects selects the folder without closing it.

[tree/multiple](../../examples/components/tree/ember/multiple.gts)

Cmd-click or Ctrl-click Archive to add it to the selection. Shift-click or Shift+Arrow extends a range, and the console logs what's selected.

## Checkboxes

Add `@checkable={{true}}` and `t.Checkbox` for a checked state separate from selection. Space checks the focused item. Checking a branch checks its descendants, and a partly checked branch reports a mixed state.

`@checkStrategy` chooses what the `checked` array reports:

| Strategy        | Reported Values                          |
| --------------- | ---------------------------------------- |
| `"leaf"`        | Checked leaves. This is the default.     |
| `"trunk"`       | The outermost fully checked items.       |
| `"branch"`      | Every fully checked item.                |
| `"independent"` | Each item on its own, without cascading. |

[tree/checkboxes](../../examples/components/tree/ember/checkboxes.gts)

Press Space on Vue, then on Frontend. Frontend is mixed while only some of its items are checked, and the console logs the trunk strategy's values.

## Links

Set `@mode="none"` for a navigation tree, then render labels as links. `@current` identifies the current page with `aria-current="page"`, expands its ancestors, and gives it the initial Tab stop. Update it when your route changes.

[tree/links](../../examples/components/tree/ember/links.gts)

Choose Dialog. The current-page marker moves to it, and you stay on this docs page.

## Disabled

Disabled items can't be selected, checked, expanded, or run. They stay focusable so screen readers can find them. Set `@focusableWhenDisabled={{false}}` to skip them, or `@disabled={{true}}` on the root to disable the whole tree. A disabled `<fieldset>` around the tree disables it too.

[tree/disabled](../../examples/components/tree/ember/disabled.gts)

Arrow through Enterprise while Focusable when disabled is on. Turn it off and the same arrow keys skip disabled items.

## Loading Children

Mark an item as a `@branch` before its children exist. `@loadChildren` runs the first time that branch expands while empty. Load and render its children, then let the promise resolve; the tree expands the branch once they are ready.

Use the supplied `signal` to cancel a request. Trying to expand the branch again while it loads aborts it. A rejection sets `data-failed`, and the next attempt retries. `@announcement` lets you customize loading and failure messages.

[tree/lazy](../../examples/components/tree/ember/lazy.gts)

Expand users to load its files. Archive fails on its first attempt and shows a retry icon; expand it again to load it.

## Virtualized

Pass the full `@items` hierarchy and use `visibleTreeRows(items, expanded)` to flatten the open branches. Render the nearby rows with their position; the tree supplies the correct ARIA hierarchy even though the DOM is flat.

`@onHighlight` reports the focused item's index among visible rows. Use it to scroll before mounting a row that is outside the rendered range. Every item sets `--tree-level`, so the stylesheet indents the flat rows by their level.

[tree/virtualized](../../examples/components/tree/ember/virtualized.gts)

Expand folders or press End to focus Folder 100. The tree has 10,100 items, but only nearby rows render.

## Find in Page

`@hiddenUntilFound={{true}}` keeps collapsed groups in the DOM with `hidden="until-found"`. In browsers that support it, Find in Page can match a hidden item and open its ancestors. Use `@keepMounted={{true}}` when you only need collapsed content to stay mounted, without browser search.

[tree/find-in-page](../../examples/components/tree/ember/find-in-page.gts)

Use your browser's Find command to look for Phobos, a moon of Mars. The matching branches open to reveal it.

## Animation

A group exposes its measured height as `--tree-group-height`. Transition between that height and zero from `data-starting-style` and `data-ending-style`:

```css
[data-slot="tree-group"] {
  height: var(--tree-group-height);
  overflow: hidden;
  transition: height 150ms ease-out;

  &:is([data-starting-style], [data-ending-style]) {
    height: 0;
  }
}
```

The group stays mounted until its closing animation ends. Groups open on the first render, or revealed by Find in Page, don't animate.

## Controlled

Selection, expanded branches, and checkboxes are independent:

| Argument    | Shape                                          | Change callback     |
| ----------- | ---------------------------------------------- | ------------------- |
| `@value`    | A string or `null`; an array in multiple mode. | `@onValueChange`    |
| `@expanded` | An array of branch values.                     | `@onExpandedChange` |
| `@checked`  | An array shaped by the check strategy.         | `@onCheckedChange`  |

Pass each with its change callback to control it, or use `@defaultValue`, `@defaultExpanded`, and `@defaultChecked` for starting state. Call `details.cancel()` in a change callback to reject a change.

## Controller

A `createTreeController()` instance can expand or collapse branches, change selection and checkboxes, or focus an item. `reveal(value)` opens an item's ancestors, scrolls it into view, and focuses it. Supply the hierarchy through `@items`, as this example does, or keep collapsed groups mounted so their descendants are known.

[tree/controller](../../examples/components/tree/ember/controller.gts)

Press Find Two-Factor to open Account and Security, then select and focus Two-factor authentication. Collapse All closes every branch.

## Custom Rendering

Pass `@render={{true}}` to any part to render it as your own element. The Links example renders `t.Label` as an anchor; a link in a label leaves the tab order to its item. The block of `t.Label` and `t.Indicator` also receives the item's state, which the File Paths and Loading Children examples use for their spinners.

## Styling

Style each row through `t.Label`, which carries its item's `data-selected`, `data-expanded`, `data-branch`, `data-current`, `data-disabled`, `data-loading`, `data-failed` and `data-pending`. An item's own background would also cover its children. Focus stays on the item, so style a focused row as a label inside an item with `:focus-visible`. Turn the indicator with its `data-expanded`, and indent rows with `--tree-level` or padding on each group.

Each part has a `data-slot`, such as `tree-label`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/tree#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [tree reference](https://ui-sdk.dev/docs/react/components/tree) in the upstream docs.

Pass the root's options as `@` arguments.

### Controller

Create one with `createTreeController()` and pass it as `@controller`.

## Accessibility

The tree follows the [WAI-ARIA tree view pattern](https://www.w3.org/WAI/ARIA/apg/patterns/treeview/). Items have the `treeitem` role with `aria-level`, `aria-expanded` on branches, and `aria-checked` when the tree is checkable.

### Keyboard

The tree has one tab stop. Tab enters at the current page, the selected item, or the first item, then returns to the item focused last.

| Key                         | Action                                                 |
| --------------------------- | ------------------------------------------------------ |
| Down / Up Arrow             | Focus the next or previous visible item.               |
| Right Arrow                 | Expand a branch, or enter its first child.             |
| Left Arrow                  | Collapse a branch, or focus its parent.                |
| Home / End                  | Focus the first or last visible item.                  |
| Alt+Right / Alt+Left Arrow  | Expand or collapse a branch and its descendants.       |
| `*`                         | Expand sibling branches.                               |
| Enter                       | Select and run the item's action, or follow its link.  |
| Space                       | Check the item when checkable, otherwise select it.    |
| Shift+Down / Shift+Up Arrow | Extend a multiple selection.                           |
| Cmd+A / Ctrl+A              | Select visible items in multiple selection mode.       |
| Typing                      | Focus the next item whose label starts with that text. |

Option is Alt on a Mac. In right-to-left text, Left and Right swap.
