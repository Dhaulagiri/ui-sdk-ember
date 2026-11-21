---
title: Combobox
description: Search a list of options and choose one or several values.
---

Use a Combobox when people need to find a choice by typing. Start with an input and a list, then add chips, server results, or the option to create something new as you need them.

[combobox/demo](../../examples/components/combobox/ember/demo.gts)

Type “sv” to find SvelteKit. Press Down Arrow to highlight it, then Enter to choose it.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Combobox`:

```text
Combobox as |c|
├── c.Label
├── c.Input
└── c.Content
    └── c.List
        ├── c.Item
        └── c.Item
```

Name the input, give each option a unique value, and put the options in a list inside the popup. The label names the input; choosing an option puts its label in the input.

## Usage

Import the root and use the parts it yields:

```gts
import { Combobox } from "ember-ui-sdk/combobox"

<template>
  <Combobox as |c|>
    <c.Label>Fruit</c.Label>
    <c.Input placeholder="Search fruits…" />
    <c.Content>
      <c.List>
        <c.Item @value="apple" @label="Apple">Apple</c.Item>
        <c.Item @value="banana" @label="Banana">Banana</c.Item>
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

## Autocomplete vs Combobox

Both filter a list as you type. They differ in what the value is.

- **Combobox**: the value is an option from the list, or several with `@multiple`. The text is only a query; closing without choosing restores the selected label, and a form submits the value, not the text. Use it for a country, an assignee or a set of labels.
- **[Autocomplete](./autocomplete.md)**: the value is the text. Suggestions help fill it in, and anything typed is valid. Use it for a search box, an address or a free-form field.

`@allowCustomValue` lets a combobox accept text that matches no option, like a datalist. Reach for it when choosing from the list is the main path; use an autocomplete when free text is.

## Disabled

A disabled combobox cannot be focused or changed and submits nothing. A read-only one remains focusable and submits its value, but does not open or accept changes. Keyboard navigation skips a disabled option, and it cannot be chosen.

[combobox/disabled](../../examples/components/combobox/ember/disabled.gts)

Billing country is disabled and Shipping from is read-only. Open Shipping to: arrow keys skip Denmark, which can't be chosen.

## Clear and Trigger

`c.Clear` clears both the selection and the query, then keeps focus in the input. It appears while either has a value. When someone deletes all the text, a single selection clears right away instead of when the list closes. Escape brings the selection back while the list is still open; closing it any other way leaves it cleared.

[combobox/clear](../../examples/components/combobox/ember/clear.gts)

Choose a framework, then press the clear button. The selection and text clear, focus stays in the input, and the console logs each change.

## Auto Highlight

Add `@autoHighlight={{true}}` to highlight the first match while typing, so Enter can choose it immediately. With `@autoHighlight="always"`, opening the list also highlights the selected item, or the first, so the arrow keys move from there. `@autoHighlight="selected"` highlights only the selected item when the list opens, and nothing when none is. A highlight it placed follows the list as items arrive, and one the user moved stays while its item is there.

[combobox/auto-highlight](../../examples/components/combobox/ember/auto-highlight.gts)

Type “sw” and press Enter. The first matching country is already highlighted.

## Highlight Matches

`c.ItemText` marks the matching text. Matching ignores case and accents using the current locale, while the label keeps its original spelling. Its state also exposes segments if you want to render the marks yourself.

[combobox/highlight](../../examples/components/combobox/ember/highlight.gts)

Type “an”. Matching letters are marked while each country keeps its original spelling.

## Filter and Keywords

`@filter` accepts `"contains"` (the default), `"startsWith"`, a function of the item and query, or `false` for results already filtered by a server. A function can return a score instead of `true` or `false`, and items you pass as `@items` then sort by it, best first. `fuzzyScore` from `@ui-sdk/core/text-match` scores an exact match above a prefix, and a prefix above a match inside the label.

Use `keywords` for text that should match without appearing in the label, such as a username or a country’s local name.

[combobox/filter](../../examples/components/combobox/ember/filter.gts)

Type “an” and switch Filter between Contains and Starts with. Choose Fuzzy and type “swd” for Sweden, or type “deutschland” to find Germany through a keyword.

## Groups

Use `c.Group` and `c.GroupLabel` to name groups. Filtering hides empty groups and separators as their items disappear.

[combobox/groups](../../examples/components/combobox/ember/groups.gts)

Type “chic”. Chicago remains in Americas; groups with no matches disappear.

## Icons

`c.ItemIcon` keeps decorative icons out of accessible names, filtering, and match marks. `c.ValueIcon` projects the selected item’s icon next to the input; it takes no children and is only for a single selection.

Wrap the input and icon together, then use that wrapper as the popup’s `@anchor`. Add `@mirror={{true}}` for directional icons. An icon-only option still needs an `aria-label`.

[combobox/icons](../../examples/components/combobox/ember/icons.gts)

Choose Done. Its icon appears next to the input as well as in the list.

## Custom Items

Show useful context beside a label, such as a username or role. Set `@label` explicitly so filtering and the input use the intended text, and put extra search terms in `keywords`.

[combobox/custom-items](../../examples/components/combobox/ember/custom-items.gts)

Search for a person’s name or username. Choose a result to put that person’s name in the input.

## Items as Data

Pass `@items` when the combobox needs the whole collection, such as recent items or server results. It can render bare parts for you, or you can render the parts yourself from the list's `state.items`. Each item's `label` supplies the text for filtering and the input; `keywords` and `disabled` work the same as with items you render yourself. Lists and Menus covers the `ListData` format.

```gts
import { Combobox } from "ember-ui-sdk/combobox"

const fruits = [
  { value: "apple", label: "Apple" },
  { value: "cherry", label: "Cherry", keywords: ["red"] },
  {
    type: "group",
    label: "Citrus",
    items: [{ value: "lemon", label: "Lemon" }],
  },
]

<template>
  <Combobox @items={{fruits}} as |c|>
    <c.Input aria-label="Fruit" />
  </Combobox>
</template>
```

Items can change while the list is open. Selection and highlight stay on their items; removing the highlighted item clears the highlight.

## Recent Items

`@emptyItems` supplies suggestions while the query is empty. Pair it with `@items` for the full searchable collection. Render the list from `state.items` so it follows the active collection.

[combobox/recent](../../examples/components/combobox/ember/recent.gts)

Open the empty input to see Recent. Start typing to search all countries; clear the text to return to Recent.

## Object Values

Use `@itemToValue` for an object’s string identity and form value, `@itemToLabel` for its displayed text, and `@isItemEqualToValue` when two different objects can represent the same option.

```gts
<Combobox
  @name="reviewer"
  @itemToValue={{this.personId}}
  @itemToLabel={{this.personName}}
  @isItemEqualToValue={{this.samePerson}}
  as |c|
>…</Combobox>
```

## Multiple

Add `@multiple={{true}}` to make the value an array. Choosing an option toggles it, keeps the list open, and clears the query. Put `c.Value` and the input inside `c.Chips`, then render each value as a chip with a removal button.

Backspace in an empty input removes the last chip in one press. Unlike [Token Input](./token-input.md#deleting-tokens), there is no `tokenDeletion` option to select it first. Arrow keys move between chips. Supply `@itemToLabel` when starting with values whose labels are not yet known from rendered items.

Add `@keepQuery={{true}}` to choose several matches without retyping the query.

[combobox/multiple](../../examples/components/combobox/ember/multiple.gts)

Choose several frameworks. Remove one with its chip button, or press Backspace in the empty input to remove the last chip.

## Select All

`c.SelectAll` toggles every matching, enabled option. Inside a group, it affects only that group. It joins keyboard navigation and reports a mixed state while some of its options are selected.

[combobox/select-all](../../examples/components/combobox/ember/select-all.gts)

Open the list and choose a group’s select-all option. Type to narrow the matches, then use the main select-all option on those results.

## Chips That Collapse

Add `c.ChipsOverflow` to keep chips on one line. It measures which chips fit, hides the rest, and exposes their count and labels. Separately, `c.Value` can use `@max` to show a short text summary of the selection.

[combobox/chips-overflow](../../examples/components/combobox/ember/chips-overflow.gts)

Add or remove countries. Chips that no longer fit are replaced by an overflow count; the summary below lists the first two.

## Max Selected

`@maxSelected` limits a multiple selection. Once the limit is reached, other options become disabled; their `maxReached` state explains why.

[combobox/max-selected](../../examples/components/combobox/ember/max-selected.gts)

Choose a third label. Other unselected labels become unavailable until you remove one.

## Create Option

`c.Create` offers the query when no label matches it exactly and it meets `@minLength`. Use `@onCreate` to save it; return a promise for asynchronous work. Creation does not change the selection itself: add the new item and select it after saving.

While saving, the option reports `data-pending`, `aria-busy` and `aria-disabled`. A rejected promise is available through its error state.

[combobox/create](../../examples/components/combobox/ember/create.gts)

Type a new label and choose Create. It becomes a selected chip after saving; a label longer than 20 characters shows an error.

## Custom Value

Use `@allowCustomValue={{true}}` when suggestions are optional, like a datalist. Unmatched text becomes the value on Enter with nothing highlighted, or when the list closes. This does not create a new item in the collection.

[combobox/custom-value](../../examples/components/combobox/ember/custom-value.gts)

Type a job title that isn't suggested, then press Enter without a highlighted option or leave the field. The text becomes the value, and the console logs it.

## Input in the Popup

The input can live inside the popup, opened by a button showing the current value. The button then stays in the tab order. Anchor the content to it, clear the query when opening, and return focus to it after closing, as this example does.

[combobox/popup](../../examples/components/combobox/ember/popup.gts)

Press Country to open the search field inside the popup. Choose a country; closing the popup returns focus to the button.

## Async Search

Use `useAsyncOptions` from `ember-ui-sdk/async-options` to debounce a search and discard stale results. Pass its `items` and `status` to the combobox, set `@filter` to `false`, and send query changes to the loader.

`c.Status` and `c.Empty` provide loading, error, and empty messages. Without a custom status, the combobox announces the result count once typing pauses.

[combobox/async](../../examples/components/combobox/ember/async.gts)

Replace “the” with another movie title. The status shows the pending search, then the latest results.

## Load More

`@onLoadMore` runs when scrolling or highlighting reaches the last option, once per page and not while a page loads. Connect it to the async loader’s `loadMore()`; return `{ items, hasMore }` from each page.

[combobox/infinite](../../examples/components/combobox/ember/infinite.gts)

Open the movies and scroll or arrow to the last result. Another page loads while the existing results stay available.

## Virtualized

Supply `@items` so filtering and keyboard navigation know about every option, even when only a few rows render. The list’s `state.items` contains matches, `@onHighlight` reports the row to reveal, and each rendered item’s `@index` gives its position in the full list to screen readers.

This example windows 10,000 items. Keep the actual row height aligned with your virtualizer’s measurement, and use the scroller’s visible height when revealing a row.

[combobox/virtualized](../../examples/components/combobox/ember/virtualized.gts)

Search 10,000 items or move through them with the arrow keys. Only the nearby rows render.

## Controlled

The selection, text, and popup have separate values:

| Argument | Change callback  | Meaning                                         |
| -------- | ---------------- | ----------------------------------------------- |
| `@value` | `@onValueChange` | One value or `null`; an array with `@multiple`. |
| `@query` | `@onQueryChange` | The input’s text.                               |
| `@open`  | `@onOpenChange`  | Whether the popup is open.                      |

Control only the values you need. Change callbacks include a reason and `details.cancel()` to reject the request. Choosing an item writes its label into the input, and a canceled choice keeps the current one. Closing without choosing restores the value’s label unless custom values are allowed.

Focus leaving the input closes the popup with the reason `focus-out`, even when code moves it, like a notice that takes focus. To keep the popup open, cancel that close in `@onOpenChange`.

[combobox/controlled](../../examples/components/combobox/ember/controlled.gts)

Type, choose, or use the buttons. The console logs each value, query and open change with its reason.

## Controller

Pass a controller from `createComboboxController()`. It can read or set the value and query, open or close the list, and focus the input. `open()` resolves when the list closes with its reason and source, including `unmount`; pass an abort signal to close it on cancellation.

[combobox/controller](../../examples/components/combobox/ember/controller.gts)

Use the buttons to drive the combobox from outside. Open and Wait logs how the list closed and what was chosen.

## Positioning

`@side` and `@align` place the popup around the input or chips. `@anchor` can use a different element, and `c.Arrow` follows the side chosen after collision handling. `@sideOffset` and `@collisionPadding` set offsets and available space.

The page stays usable by default. `@modal="pointer"` makes an outside press only dismiss the list; `@modal={{true}}` also locks scrolling and makes the rest of the page inert. The popup uses the top layer and renders in place; use `@container` when its DOM belongs elsewhere, such as a shadow root.

[combobox/positioning](../../examples/components/combobox/ember/positioning.gts)

Pick a side and an alignment, then open the list. Check Anchor to the Box to place it against the box instead of the input.

## Animation

The content has `data-starting-style` while it opens and `data-ending-style` while it closes. Transition from those states, and the popup stays mounted until the exit finishes. `@onOpenChangeComplete` runs after opening or closing finishes, and `@keepMounted={{true}}` on an item indicator keeps it in the page for a selection animation.

```css
[data-slot="combobox-content"] {
  transition:
    opacity 0.15s,
    translate 0.2s cubic-bezier(0.22, 1, 0.36, 1);

  &:is([data-starting-style], [data-ending-style]) {
    opacity: 0;
    translate: 0 -6px;
  }
}
```

[combobox/animation](../../examples/components/combobox/ember/animation.gts)

Open and close the list. The console logs when each animation finishes.

## Presentation

Use `@presentation="sheet"` for a sheet, or `"auto"` to choose a sheet on small touch screens each time the list opens. The input moves into the sheet’s header; there is still one input and one query.

A touch opening leaves the keyboard closed. Tapping the header input opens the keyboard and grows the sheet; closing the keyboard keeps the query. Choosing an item closes the sheet unless `@multiple` is set. Swiping down closes it with the reason `swipe`.

Keep the options inside `c.List` so the header stays outside the listbox. Give sheet content a height, style it with `data-presentation`, and leave its `translate` for the sheet behavior. `--sheet-backdrop` controls the backdrop. The sheet is modal unless you set `@modal` to `false`; mouse and keyboard openings keep input focus as it moves.

[combobox/presentation](../../examples/components/combobox/ember/presentation.gts)

Open the field to see a sheet. On touch, tap the search field in its header to bring up the keyboard, or swipe down to close it.

## Forms

A combobox submits the selected value under `@name`, rather than the query text. Multiple values submit as separate entries. `@required={{true}}` prevents empty submissions, reset restores the default selection and its label, and `@form` joins a form from elsewhere on the page.

In a [Field](./field.md), the field supplies the input's accessible name, description and error. Submitting a required field without a selection sets `aria-invalid` and `data-invalid`.

[combobox/form](../../examples/components/combobox/ember/form.gts)

Submit without a country to see the inline error. Choose one and submit; the console logs the values, and Reset restores the defaults.

## Custom Rendering

Pass `@render={{true}}` to render a part as your own element: it yields `{ part, state }`, and you bind `part` to your element as a modifier. A part's block also receives its state. Each part's state is listed [below](https://ui-sdk.dev/docs/react/components/combobox#state).

[combobox/custom-rendering](../../examples/components/combobox/ember/custom-rendering.gts)

Open the list and move through it. The chevron flips while it's open, the highlighted person shows Enter, and the chosen one shows a check.

## Styling

Each part has a `data-slot`, such as `combobox-content`, and shows its state through the attributes listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/combobox#data-attributes).

Use `data-highlighted` for the active option and `data-selected` for chosen values. Because the keyboard highlight usually moves without focus leaving the input, use the content's `data-modality="keyboard"` to style it. Real focus can move into the list for touch screen readers or into the sheet.

`--anchor-width` follows the input or chips. `--available-height` doesn't inherit: when a nested scroller needs it, copy it to a custom property on the content, such as `--list-height: var(--available-height)`, then use that property on the scroller.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [combobox reference](https://ui-sdk.dev/docs/react/components/combobox) in the upstream docs.

Pass the root's options as `@` arguments on `Combobox`. `@value`, `@query` and `@open` are controlled with their `@on…Change` callbacks.

### Combobox

`announcement` receives `{ type: "results", count, query, loading }` or `{ type: "removed", label }` and returns the words, or `null` for silence. The default is English: "3 results", "No results", "Loading" or "France removed".

### ComboboxLabel

The input's visible label. Renders a `label`.

### ComboboxInput

The text field that filters the list and shows the chosen label. Renders an `input`.

### ComboboxTrigger

Opens and closes the list. Renders a `button`, kept out of the tab order while the input sits beside it.

### ComboboxChips

Holds the chips and the input for a multiple selection. Renders a `div`.

### ComboboxChipRemove

Removes its chip's value. Renders a `button`. Takes the same arguments as `ComboboxChip`.

### ComboboxChipsOverflow

Turns collapsing on for the chips around it, and shows how many are hidden. Renders a `span`.

### ComboboxValueIcon

Shows the selected item's icon beside the input. It takes no arguments of its own, and no children.

### ComboboxArrow

Points from the popup to its anchor, following the side chosen after collision handling. Renders a `div`.

### ComboboxStatus

Announces loading, errors and result counts. Renders a `div` with the status role.

### ComboboxEmpty

Shows while no option matches. Renders a `div`.

### ComboboxList

Holds the options. Renders a `div` with the listbox role.

### ComboboxSelectAll

Toggles every matching, enabled option in its group, or outside a group. Renders a `div` with the option role.

### ComboboxGroup

Groups options under a label. Renders a `div` with the group role.

### ComboboxGroupLabel

Names its group. Renders a `div`.

### ComboboxItemText

Shows its item's label, and marks what matched the query. Renders a `span`.

### ComboboxSeparator

Separates options or groups. Renders a `div` with the separator role.

### Items as Data

Each item in `@items`. Groups are `{ type: "group", label, items }` and separators `{ type: "separator" }`.

### Async Options

Async Options, in `ember-ui-sdk/async-options`, covers loading, paging, and retries.

### Controller

Create one with `createComboboxController<Value, Multiple>()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, passed to the change callback.

### Events

Callbacks get the new state first, then the details. A controlled value only updates when the change callback wasn't canceled.

| Argument                | On               | Receives                                                                                                       |
| ----------------------- | ---------------- | -------------------------------------------------------------------------------------------------------------- |
| `@onValueChange`        | `Combobox`       | `(value, details)`: the new value, and the [reason](https://ui-sdk.dev/docs/react/components/combobox#reasons) |
| `@onQueryChange`        | `Combobox`       | `(query, details)`: the new text, and the [reason](https://ui-sdk.dev/docs/react/components/combobox#reasons)  |
| `@onOpenChange`         | `Combobox`       | `(open, details)`: the new state, and the [reason](https://ui-sdk.dev/docs/react/components/combobox#reasons)  |
| `@onOpenChangeComplete` | `Combobox`       | `(open)`, after the animation                                                                                  |
| `@onHighlight`          | `Combobox`       | `(value, { index, event })`: the highlighted item and its row                                                  |
| `@onLoadMore`           | `Combobox`       | `()`, when the last item is reached                                                                            |
| `@onDismissAttempt`     | `Combobox`       | `({ reason, event })`, when a dismissal was refused                                                            |
| `@onCreate`             | `ComboboxCreate` | `(query)`: the text. Return a Promise to mark it pending                                                       |

## Accessibility

The combobox follows the [WAI-ARIA combobox pattern with list autocomplete](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-autocomplete-list/). Focus usually stays in the input while `aria-activedescendant` identifies the highlighted option. A touch screen-reader trigger can move real focus into the list, and a sheet has its own [focus behavior](#presentation). Every line below is an automated test.

### Keyboard

| Key                   | Does                                                                     |
| --------------------- | ------------------------------------------------------------------------ |
| Typing                | Filters the options and opens the list                                   |
| ArrowDown, ArrowUp    | Opens the list, then moves the highlight. Wraps unless `@loop={{false}}` |
| Enter                 | Chooses the highlighted option                                           |
| Escape                | Closes the list, then restores the selection's label                     |
| Backspace             | In an empty input with chips, removes the last chip                      |
| ArrowLeft, ArrowRight | Moves between chips, reversed in right-to-left text                      |
