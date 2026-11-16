---
title: Autocomplete
description: Suggest text while someone types, without limiting what they can enter.
---

Use Autocomplete for a text field with helpful suggestions. Choosing one fills in the field, but any text is a valid value. Use [Combobox](./combobox.md) when the value should be a selected option instead.

[autocomplete/demo](../../examples/components/autocomplete/ember/demo.gts)

Type “man”, press Down Arrow, then Enter to fill in Mango. You can also leave text that is not in the list.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build an `Autocomplete`:

```text
Autocomplete as |c|
├── c.Label
├── c.Input
└── c.Content
    ├── c.Empty
    └── c.List
        ├── c.Item
        └── c.Item
```

Name the input, then put suggestions in a list inside the popup. Each suggestion needs a unique value.

## Usage

Import the root and use the parts it yields:

```gts
import { Autocomplete } from "ember-ui-sdk/autocomplete"

<template>
  <Autocomplete as |c|>
    <c.Label>Fruit</c.Label>
    <c.Input placeholder="Type a fruit…" />
    <c.Content>
      <c.List>
        <c.Item @value="Apple">Apple</c.Item>
        <c.Item @value="Banana">Banana</c.Item>
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

## Autocomplete vs Combobox

Both filter a list as you type. They differ in what the value is.

- **Autocomplete**: the value is the text. Suggestions help fill it in, and anything typed is valid. Use it for a search box, an address or a free-form field.
- **[Combobox](./combobox.md)**: the value is an option from the list, or several with `@multiple`. The text is only a query; closing without choosing restores the selected label, and a form submits the value, not the text. Use it for a country, an assignee or a set of labels.

## Disabled

A disabled field cannot be focused or changed and submits nothing. A read-only field stays focusable and submits its value, but does not open or accept changes. Disabled suggestions are skipped by keyboard navigation and cannot fill in the field.

[autocomplete/disabled](../../examples/components/autocomplete/ember/disabled.gts)

Try the Disabled and Read-only fields. In Disabled suggestion, type “b”: arrow keys skip Banana and a press cannot choose it.

## Clear and Trigger

`c.Clear` empties the field and returns focus to it. `c.Trigger` lets someone open the suggestions without typing. Give the trigger a label that describes what it opens.

[autocomplete/clear](../../examples/components/autocomplete/ember/clear.gts)

Clear Mango, then press Show fruits to open the suggestions. The clear button disappears while the field is empty.

## Open on Focus

Add `@openOnFocus={{true}}` to offer suggestions as soon as the input receives focus. This works well when there are useful choices before someone types.

[autocomplete/open-on-focus](../../examples/components/autocomplete/ember/open-on-focus.gts)

Focus Search docs to see recent searches before typing. Escape closes them; pressing the field opens them again.

## Auto Highlight

`@autoHighlight={{true}}` highlights the first match while typing, so Enter can choose it immediately. Set `@loop={{false}}` to stop arrow keys at either end of the list.

[autocomplete/auto-highlight](../../examples/components/autocomplete/ember/auto-highlight.gts)

Type “pe” and press Enter to choose the first match. Arrow keys stop at the ends because this example disables looping.

## Inline Completion

`@inlineComplete={{true}}` fills in the rest of the first suggestion that starts with the typed text, with the added text selected. Arrow keys fill in the suggestion they highlight. End or Right Arrow accepts the completion; Backspace or Escape takes it back out.

[autocomplete/inline](../../examples/components/autocomplete/ember/inline.gts)

Type “bl” to complete blackberry inline. Backspace removes the completion; Down Arrow fills in Blueberry. Press End to accept the text.

## Highlight Matches

`c.ItemText` marks the matching text, ignoring case and accents using the current locale. Its state exposes the matching segments when you want to render them yourself, as this example does in bold.

[autocomplete/highlight](../../examples/components/autocomplete/ember/highlight.gts)

Type “berry”. The matching letters are bold while each suggestion keeps its original spelling.

## Filter and Keywords

The default filter matches text anywhere in a suggestion. Use `@filter="startsWith"` or `@filter="fuzzy"` for a different match, a function for your own filter, or `@filter={{false}}` for results already filtered by a server. `@keywords` adds searchable text without changing what goes in the field.

[autocomplete/filter](../../examples/components/autocomplete/ember/filter.gts)

Type “bug” to find fix through its keywords. Type “re” to find labels or keywords that start with those letters.

## Groups

Use `c.Group` and `c.GroupLabel` to name related suggestions. Filtering hides empty groups and separators.

[autocomplete/groups](../../examples/components/autocomplete/ember/groups.gts)

Type “an”. Banana and Mango remain in Tropical; groups with no matches disappear.

## Icons

`c.ItemIcon` keeps decorative icons out of accessible names, filtering, and the text put in the field. Add `@mirror={{true}}` for directional icons. An icon-only suggestion still needs an `aria-label`.

[autocomplete/icons](../../examples/components/autocomplete/ember/icons.gts)

Type “rep” and choose Replies. The icon stays out of the text put in the field.

## Items as Data

Map an array into parts when you want to write the markup yourself. This example maps fruit groups and adds a separator between them.

[autocomplete/data](../../examples/components/autocomplete/ember/data.gts)

Open the list to see three fruit groups. Type “an” to narrow them to Banana and Mango.

Pass `@items` when the autocomplete needs the whole collection, such as server results or recent searches. It can render bare parts for you. Lists and Menus covers the `ListData` format.

Suggestions can change while the list is open. The highlight stays with its suggestion, and the typed text stays unchanged. Removing the highlighted suggestion clears the highlight.

## Controlled

The value is always a string. Control it with `@value` and `@onValueChange`, or start uncontrolled with `@defaultValue`. Suggestions have a separate `@open` state and `@onOpenChange`. Callbacks receive the proposed value first, then change details. Call `details.cancel()` to reject a text or open change.

[autocomplete/controlled](../../examples/components/autocomplete/ember/controlled.gts)

Type more than 12 characters and the extra text is refused. The console shows each change and its reason.

## Controller

Create a `createAutocompleteController()` for one instance and pass it as `@controller`. It can `setValue()`, `clear()`, `focus()`, `setOpen()`, or read `getValue()` and `isOpen()`. `open()` returns a promise that resolves when the popup closes, including abort and unmount; `close()` closes it.

[autocomplete/controller](../../examples/components/autocomplete/ember/controller.gts)

Use the buttons to open the suggestions, type Pea, clear the field or focus it from outside.

## Positioning

Use `@side`, `@align`, offsets, or a custom `@anchor` to position the suggestions. `@container` chooses where they render, and `@keepMounted` keeps closed content in the DOM.

[autocomplete/positioning](../../examples/components/autocomplete/ember/positioning.gts)

Open the suggestions. They appear above the card, aligned to its end.

## Animation

The content has `data-starting-style` while it opens and `data-ending-style` while it closes. Transition from those states, and the popup stays mounted until the exit finishes:

```css
[data-slot="autocomplete-content"] {
  transition:
    opacity 0.15s,
    translate 0.2s cubic-bezier(0.22, 1, 0.36, 1);

  &:is([data-starting-style], [data-ending-style]) {
    opacity: 0;
    translate: 0 -6px;
  }
}
```

[autocomplete/animation](../../examples/components/autocomplete/ember/animation.gts)

Type to open the suggestions. They slide and fade in, and fade out before they unmount.

## Presentation

`@presentation="sheet"` opens suggestions in a sheet. `"auto"` chooses a sheet on small touch screens and a popover elsewhere, each time the list opens. The server starts with the popover.

The same input moves into the sheet’s header. Opening by touch leaves the keyboard closed; tapping the input opens it and expands the sheet. Choosing a suggestion or swiping down closes it. Keyboard and mouse opening preserve input focus.

A sheet is modal unless `@modal` is `false`. Give it a height, keep suggestions inside `c.List`, and leave the content’s `translate` alone so dragging can move it. Use `data-presentation` to style both presentations and `--sheet-backdrop` to set the dimmed background.

[autocomplete/presentation](../../examples/components/autocomplete/ember/presentation.gts)

Open the field to see a sheet. On touch, tap the field in its header to show the keyboard, or swipe down to close it.

## Forms

The native input is the form control: `@name` gives its submitted key, `@required={{true}}` rejects empty text, and reset restores `@defaultValue`. Text does not have to match a suggestion. Use `@form` to associate the field with a form elsewhere in the page.

[autocomplete/form](../../examples/components/autocomplete/ember/form.gts)

Submit Apple, then choose Mango. Choosing it fills the field without submitting. Reset restores Apple.

## Search

Enter with no suggestion highlighted runs the `@onSubmit` callback with the text, then allows the surrounding form to submit. Call `preventDefault()` on `details.event` if your handler already performs the search.

Choosing a suggestion normally only fills in the field. Add `@submitOnSelect={{true}}` to search as soon as someone chooses one.

[autocomplete/search](../../examples/components/autocomplete/ember/search.gts)

Type “kotlin” and press Enter to search. Choose a suggestion to search for that text instead.

## Recent Searches

Pair `@emptyItems` with `@items` to show one collection while the field is empty and search the full collection once someone types. Add `@openOnFocus={{true}}` to show the recent searches on focus.

[autocomplete/recent](../../examples/components/autocomplete/ember/recent.gts)

Focus the empty field to see Recent searches. Type “react” to search all topics, then clear the text to return to recent searches.

## Async Suggestions

Use `useAsyncOptions` from `ember-ui-sdk/async-options` to wait for typing to pause and discard stale results. Pass its `items` and `status`, set `@filter={{false}}`, and send text changes to its `setQuery()` method.

`c.Status` and `c.Empty` provide loading, error, and empty messages. Without a status part, `@announcement` controls what screen readers hear when typing pauses. `@onLoadMore` can request another page when scrolling or highlighting reaches the last suggestion.

[autocomplete/async](../../examples/components/autocomplete/ember/async.gts)

Type “b” and wait for the city suggestions. Keep typing to replace the search; the status describes the latest results.

## Custom Rendering

Pass `@render={{true}}` to a suggestion to give it a different element. Here each suggestion is a link, so the autocomplete works as a jump-to menu: Enter or a click follows the highlighted link, and the text after the title is a hint that doesn't affect filtering.

[autocomplete/custom-rendering](../../examples/components/autocomplete/ember/custom-rendering.gts)

Type “sty” and press Enter to jump to the Styling section of this page.

## Styling

Each part has a `data-slot`, such as `autocomplete-content`, and shows its state through the attributes listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/autocomplete#data-attributes).

The popup exposes sizing and animation variables. `--anchor-width` is the input’s width; use `--available-height` on the content to keep a long list in the viewport.

While focus stays in the input, use the content’s `data-modality="keyboard"` with an item’s `data-highlighted` to show a keyboard focus indicator on the highlighted suggestion.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [autocomplete reference](https://ui-sdk.dev/docs/react/components/autocomplete) in the upstream docs.

Pass the root's options as `@` arguments. `@value` and `@open` are controlled with their `@on…Change` callbacks.

### AutocompleteLabel

Names the input. Renders a `label` tied to the input, so you don't need a `Field`.

### AutocompleteInput

The text field. Renders an `input` with the combobox role, and accepts its attributes.

### AutocompleteTrigger

An optional button that opens and closes the suggestions. Renders a `button`.

### AutocompleteArrow

An optional arrow pointing at the input. Renders a `div` positioned on the content's edge.

### AutocompleteStatus

Announces loading and result counts to screen readers.

### AutocompleteEmpty

Shows when no suggestion matches.

### AutocompleteList

Holds the suggestions. Renders the listbox, and renders `@items` when you pass no block.

### AutocompleteGroup

Groups related suggestions. Renders a `div` with the group role.

### AutocompleteGroupLabel

Names its group. Renders a `div` the group is labelled by.

### AutocompleteItemText

The suggestion's text, with the matched part marked. Its state includes the matched `segments`.

### AutocompleteSeparator

A divider between suggestions or groups. Renders a `div` with the separator role.

### Items as Data

Each suggestion in `@items`, or a plain string. Groups are `{ type: "group", label, items }` and separators `{ type: "separator" }`.

### Controller

Create one with `createAutocompleteController()` and pass it as `@controller`.

### Events

Callbacks get the new state first, then the details. A controlled value only updates when the change callback wasn't canceled.

| Argument                | On             | Receives                                                                                                          |
| ----------------------- | -------------- | ----------------------------------------------------------------------------------------------------------------- |
| `@onValueChange`        | `Autocomplete` | `(value, details)`: the new text, and the [reason](https://ui-sdk.dev/docs/react/components/autocomplete#reasons) |
| `@onOpenChange`         | `Autocomplete` | `(open, details)`: the new state, and the [reason](https://ui-sdk.dev/docs/react/components/autocomplete#reasons) |
| `@onOpenChangeComplete` | `Autocomplete` | `(open)`, after the animation                                                                                     |
| `@onSubmit`             | `Autocomplete` | `(value, { event })`: the text, when Enter submits                                                                |
| `@onHighlight`          | `Autocomplete` | `(value, { index, event })`: the highlighted suggestion                                                           |
| `@onLoadMore`           | `Autocomplete` | `()`, when the last suggestion is reached                                                                         |
| `@onDismissAttempt`     | `Autocomplete` | `({ reason, event })`, when a dismissal was refused                                                               |

## Accessibility

The autocomplete follows the [WAI-ARIA combobox pattern with list autocomplete](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-autocomplete-list/), and [list and inline](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-autocomplete-both/) with `@inlineComplete`.

Typing filters the suggestions. Arrow keys move the highlight; Enter fills in the highlighted text and Escape closes the list. Focus usually stays in the input while `aria-activedescendant` identifies the highlighted suggestion. A touch screen-reader trigger can move focus into the list, and a sheet has its own [focus behavior](#presentation).

Every line below is an automated test.
