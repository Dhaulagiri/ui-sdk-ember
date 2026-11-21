---
title: Select
description: Choose one value or several from a popup list.
---

Use a Select when someone needs to choose from a set of options. It handles opening the list, keyboard navigation, selection, and the value submitted with a form. You provide the parts and styles.

[select/demo](../../examples/components/select/ember/demo.gts)

Open Role and choose Editor. The list closes and the trigger shows your choice.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Select`:

```text
Select
├── SelectLabel
├── SelectTrigger
│   └── SelectValue
└── SelectContent
    ├── SelectItem
    └── SelectItem
```

Start with a label, a trigger, and a list of items. `s.Value` shows the selected item's label inside the trigger. `s.Label` names the trigger; inside a Field, use its `f.Label` instead and pass the trigger `@field`, as the examples do.

## Usage

Import the root and use the parts it yields:

```gts
import { Select } from "ember-ui-sdk/select"

<template>
  <Select @placeholder="Select a role" as |s|>
    <s.Label>Role</s.Label>
    <s.Trigger>
      <s.Value />
    </s.Trigger>
    <s.Content>
      <s.Item @value="viewer">Viewer</s.Item>
      <s.Item @value="editor">Editor</s.Item>
    </s.Content>
  </Select>
</template>
```

## Items as Data

Pass an array to `@items` when your options come from data. A string is both the value and the label. Use an object when they differ:

```gts
<Select @items={{array "Free" "Pro"}} as |s|>…</Select>
<Select @items={{this.plans}} as |s|>…</Select>
```

These are option examples; add the label and trigger shown above. `@items` can also include groups and separators, checked with `ListData`:

```ts
import type { ListData } from "ember-ui-sdk/select"

const plans: ListData = [
  { value: "free", label: "Free" },
  { type: "separator" },
  { type: "group", label: "Contact sales", items: ["Enterprise"] },
]
```

The select can render bare items from this data. To style them, keep `@items` on `Select` and render `s.Item` parts inside `s.Content`, as the example does. Keeping the data on the root also makes labels available before the list opens.

[select/data](../../examples/components/select/ember/data.gts)

Open Plan to see the options, separator, and Contact sales group. Education is disabled; choose Enterprise to update the value.

Items can change while the list is open. Navigation follows the new order, and selection and highlight stay with their values while those items remain. Removing the highlighted item clears the highlight. Lists and Menus covers shared data shapes.

## Groups

Put related items inside `SelectGroup` and name each group with `SelectGroupLabel`. `SelectSeparator` adds a visual break without becoming an option.

[select/groups](../../examples/components/select/ember/groups.gts)

Open Font and choose from Sans serif, Serif or Monospace. Each group has a label that screen readers announce.

## Icons

`SelectItemIcon` keeps an icon separate from the item's text, so it doesn't affect its accessible name, typeahead, or search. Add `SelectValueIcon` to the trigger to show the selected item's icon there too.

```gts
<s.Trigger>
  <s.ValueIcon />
  <s.Value />
</s.Trigger>
```

The full example marks directional icons with `@mirror`, so they flip in right-to-left layouts. Items containing only an icon still need an `aria-label`.

[select/icons](../../examples/components/select/ember/icons.gts)

Choose Center or End. Both the label and the icon in the trigger update to match the selected item.

## Typeahead

With the trigger focused and closed, typing selects the next matching option without opening the list. With the list open, typing moves the highlight; Enter chooses the highlighted item.

Set an item's `@label` when its content includes extra text that shouldn't be matched. Here, country names match typing; calling codes don't.

[select/typeahead](../../examples/components/select/ember/typeahead.gts)

Focus Country and type “sw” to select Sweden without opening the list. Open it and type “g” to highlight Germany, then press Enter.

## Disabled

A disabled select can't be focused or changed and doesn't submit a value. A read-only select stays focusable and submits its value, but can't change. Keyboard navigation skips disabled items, and they can't be chosen.

[select/disabled](../../examples/components/select/ember/disabled.gts)

Billing country is disabled and Shipping from is read-only. Open Shipping to and press the arrow keys: the highlight skips Denmark, which can't be chosen.

## Clear Button

`@placeholder` appears while nothing is selected. Add `SelectClear` to return to that state. Clearing sets a single value to `null`, or multiple values to an empty array, and returns focus to the trigger.

Keep the clear button beside the trigger: a button can't contain another button. `@keepMounted` lets it stay in the DOM when there is nothing to clear.

[select/clearable](../../examples/components/select/ember/clearable.gts)

Press the clear button. The trigger shows Unassigned, focus returns to it, and the console logs null. Choose someone to bring the button back.

## Multiple

Set `@multiple` to select more than one value. The value becomes an array, and choosing an item toggles it while keeping the list open.

```gts
<Select @multiple={{true}} @defaultValue={{array "en" "ja"}} as |s|>…</Select>
```

`s.Value` yields its state, with the selected `labels`. Use them to summarize a long selection, as this example does.

[select/multiple](../../examples/components/select/ember/multiple.gts)

Choose several languages, then choose one again to remove it. The list stays open, and the console logs the array.

## Select All

Add `SelectSelectAll` to select or clear every enabled item. It shows a mixed state when only some are selected. Inside a `SelectGroup`, it applies to that group.

`<s.Value @maxLabels={{2}} />` shows up to two labels and summarizes the remaining values. `@getMoreLabel` lets you write that summary.

[select/select-all](../../examples/components/select/ember/select-all.gts)

Open Regions and press Select all. Press it again to clear the selection, then choose one region to see the mixed state.

## Search with Groups

Add `SelectInput` inside `SelectContent` to filter the options. Put the items in `SelectList`, so the search field stays outside the scrollable list. `SelectEmpty` shows when nothing matches.

```gts
<s.Content>
  <s.Input aria-label="Search countries" />
  <s.Empty>No countries found.</s.Empty>
  <s.List>{{! Items go here. }}</s.List>
</s.Content>
```

Groups with no matching items hide automatically. `SelectItemText` can highlight the matching text; this example reads `state.segments` with `@render={{true}}` to bold the matches. Closing the popup clears the search.

[select/search-groups](../../examples/components/select/ember/search-groups.gts)

Open Country and type “ja”. Only Asia Pacific and Japan remain. Try “zz” to see the empty message, then clear the search to show every country.

Arrow keys move the highlight while focus stays in the search field. On a touch screen reader, focus moves into the items instead. To show recent choices before a search, pass `@emptyItems` alongside `@items`. Lists and Menus covers filtering options.

## Async Search

Use `@filter={{false}}` when the server already filters your options. Connect `@query` and `@onQueryChange` to your loader, and pass its items and status to `Select`.

This example uses `useAsyncOptions` from `ember-ui-sdk/async-options` to replace stale requests and load another page through `@onLoadMore`. `SelectStatus` shows loading and result counts. Without a status part, Select announces result counts through the page's live region.

[select/async-search](../../examples/components/select/ember/async-search.gts)

Open Country and type “an”. Results arrive after a short delay. Clear the search and move or scroll to the last result to load another page.

## Object Values

A value can be an object. Tell Select how to identify it, display it, and compare it with another copy:

| Prop                  | What It Does                                                          |
| --------------------- | --------------------------------------------------------------------- |
| `@itemToValue`        | Returns the string used to identify and submit the value.             |
| `@itemToLabel`        | Returns the text shown in the trigger.                                |
| `@isItemEqualToValue` | Matches an item with a selected value that may be a different object. |

[select/object-values](../../examples/components/select/ember/object-values.gts)

Inès starts selected even though the initial value is a copy of her item. Choose another assignee; the console logs the ID the form submits.

## Virtualized

For a large list, pass every option through `@items` and render only the visible rows. `@onHighlight` tells your virtualizer which row to bring into view. Give each rendered item its full-list `index` so the accessibility attributes describe its position correctly.

The example includes its own small row-windowing helpers. You can use the same props with a virtualizer of your choice.

[select/virtualized](../../examples/components/select/ember/virtualized.gts)

Open Item and press End to reach Item 10000, then Home to return to the beginning. Scroll through the list; only nearby rows render.

## Align Item with Trigger

Set `@alignItemWithTrigger` on `SelectContent` to place the selected item over the trigger. It falls back to normal popup placement when opened by touch or when there isn't enough room.

[select/align-item](../../examples/components/select/ember/align-item.gts)

Open Priority: Medium sits over the trigger. Close it, uncheck Align item with trigger, and open it again to compare placement.

## Scrollable

Limit the content's height and allow vertical scrolling. `--available-height` tells you how much room the popup has; the highlighted item scrolls into view as you move with the keyboard.

[select/scrollable](../../examples/components/select/ember/scrollable.gts)

Open Time zone and move down with the arrow keys. The list scrolls to keep the highlighted option visible.

## Invalid

Inside a [Field](./field.md), the field's label names the trigger, its description and errors describe it, and its `@name` is used for submission. After invalid submission, the trigger gets `aria-invalid` and `data-invalid`.

[select/invalid](../../examples/components/select/ember/invalid.gts)

Press Continue without choosing a shipping method to show the error. Choose one and continue; the console logs the submitted value.

## Forms

Set `@name` to include a select in form submission. `@required` blocks submission until something is selected; resetting the form restores `@defaultValue`. Multiple values submit as separate entries under the same name.

The example also uses `@autoComplete="country"` for autofill and `@form="select-newsletter"` to associate the Frequency select with a form it sits outside.

[select/form](../../examples/components/select/ember/form.gts)

Choose a country and some topics, change Frequency, then press Save; the console logs all three fields. Reset restores the initial choices.

## Presentation

Use `@presentation="sheet"` to open the options in a bottom sheet, or `"auto"` to use a sheet on small touch screens. Choosing an item still selects it and closes the single-select list.

The content gets `data-presentation`, and its render state includes `@presentation`. Use either to give sheet items more space. Keep the sheet's `translate` property free for its drag behavior, and include safe-area padding at the bottom.

[select/presentation](../../examples/components/select/ember/presentation.gts)

Open Status to show the bottom sheet. Choose an option to close it, or drag down to dismiss it without changing the value.

A sheet makes the page behind it inert and locks scrolling unless `@modal={{false}}`.

## Controlled

Pass `@value` and update it in `@onValueChange` to own the selection, and `@open` with `@onOpenChange` to own the popup state. A single value is `T | null`; with `@multiple`, it is `T[]`. `@onValueChange` and `@onOpenChange` receive the requested value first and change details second. Call `details.cancel()` to refuse a change.

State and Events explains this pattern. The [reason tables](https://ui-sdk.dev/docs/react/components/select#reasons) list Select's reasons, including `item-press`, `list-navigation`, and `clear-press`.

## Controller

`createSelectController()` can open, read, or change the select from outside its component. It can also connect a separate trigger.

## Positioning

Use `@side`, `@align`, and offsets to place the popup. `SelectArrow` follows the side it lands on.

## Modal

By default, pressing outside closes the list without activating the element behind it. `@modal={{true}}` also locks scrolling and makes the page inert. `@modal={{false}}` allows outside presses through.

## Container

The popup uses the top layer without a portal. Use `@container` when it must render in another DOM container.

## Animation

Select keeps closing content mounted until its exit animation finishes. `@onOpenChangeComplete` runs afterward. Use `@keepMounted` when your animation library needs the closed content to remain in the DOM.

## Custom Rendering

Pass `@render={{true}}` to render a part as your own element: it yields `{ part, state }`, and you bind `part` to your element as a modifier. A part's block also receives its state. Select's part states are listed under [State](https://ui-sdk.dev/docs/react/components/select#state).

## Styling

Use `data-highlighted` for the active item, `data-selected` for chosen items, and `data-placeholder` on the trigger and value while nothing is selected. `data-modality="keyboard"` on the content tells a keyboard highlight from a pointer one.

`--anchor-width` matches the trigger's width, and `--available-height` says how much room the popup has. Use them to size the content.

Each part has a `data-slot`, such as `select-trigger`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/select#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [select reference](https://ui-sdk.dev/docs/react/components/select) in the upstream docs.

Options and callbacks are passed as arguments, like `@onValueChange`. Every part also takes `@render`.

### SelectTrigger

A trigger outside the select also takes `@controller`.

### SelectItemIcon

`SelectValueIcon` takes no arguments of its own, and no children.

### SelectInput, SelectEmpty, SelectStatus, SelectItemText and SelectSelectAll

They take no arguments of their own. A `SelectInput` turns searching on, `SelectItemText` marks what the search matched in its item's text, and `SelectSelectAll` covers its group's items, or every item outside a group. Without a `SelectStatus`, result counts go to screen readers through the page's shared live region once typing pauses. `announcement` receives `{ type: "results", count, query, loading }` and returns the words, or `null` for silence. The default is English: "3 results", "No results" or "Loading".

### Items as Data

Each item in `@items`. Groups are `{ type: "group", label, items }` and separators `{ type: "separator" }`.

### Controller

Create one with `createSelectController<Value, Multiple>()` and pass it as `@controller`, to the select and to
a trigger outside it.

Every write method takes an optional `{ reason, event }`, passed to the change callback.

### Events

Callbacks get the new state first, then the details.

| Argument                | On       | Receives                                                                                                       |
| ----------------------- | -------- | -------------------------------------------------------------------------------------------------------------- |
| `@onValueChange`        | `Select` | `(value, details)`: the new value, and the [reason](https://ui-sdk.dev/docs/react/components/select#reasons)   |
| `@onOpenChange`         | `Select` | `(open, details)`: the new state, and the [reason](https://ui-sdk.dev/docs/react/components/select#reasons)    |
| `@onOpenChangeComplete` | `Select` | `(open)`, after the animation                                                                                  |
| `@onHighlight`          | `Select` | `(value, { index, event })`: the highlighted item and its row                                                  |
| `@onQueryChange`        | `Select` | `(query, details)`: the search text, and the [reason](https://ui-sdk.dev/docs/react/components/select#reasons) |
| `@onLoadMore`           | `Select` | `()`, when the last item is reached                                                                            |
| `@onDismissAttempt`     | `Select` | `({ reason, event })`, when a dismissal was refused                                                            |

## Accessibility

The select follows the [WAI-ARIA select-only combobox pattern](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-select-only/). The trigger has the `combobox` role and the popup is a `listbox`. If you don't need a visible label, give `SelectTrigger` an `aria-label` instead.

### Keyboard

Arrow keys move through the open list; Home and End reach its first and last items. Set `@loop={{false}}` to stop arrow keys at either end. The popup follows the trigger's inherited text direction; use logical CSS properties for spacing in right-to-left layouts.

Set `@virtualFocus={{true}}` to keep focus on the trigger while the list is open, as on a native select: arrow keys, Home, End and typing move the highlight, the trigger points at it with `aria-activedescendant`, and Tab closes the list and moves on. A search field in the list still takes focus.
