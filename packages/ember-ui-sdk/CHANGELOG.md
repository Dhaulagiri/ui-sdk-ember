# ember-ui-sdk

## 0.3.2

### Patch Changes

- 04dd566: A controlled `DateInput` or `TimeInput` takes a new `@value` without Ember's backtracking assertion in development builds. A part now reads a change it hears during a render, like the new value `syncOptions` hands over, once the render ends.

## 0.3.1

### Patch Changes

- 2ba49cd: `ember-ui-sdk/primitive` exports `onInsert`, a modifier that calls back with its element once it is in the page. Tracked state the callback sets renders a microtask later, and a function it returns runs when the element leaves. The resizable docs now give panels `@id`, which a panel's saved layout and a controller look up, not an `id` attribute.
- 2ba49cd: `TimeInput` takes `@min` and `@max`, like the time input in the other frameworks: a time outside them is invalid.

## 0.3.0

### Minor Changes

- c223620: Dialog and Popover content take `@inline` to render where they are instead of in a portal, and their backdrop stays there too.
- 471ccb0: Type what the roots yield. Collapsible, Tabs and 32 more roots now yield their `part` modifier, `state`, `handle` and parts with precise types instead of `Record<string, any>`, so `c.Panel` and `c.part` check in strict templates with `noPropertyAccessFromIndexSignature`, and a misspelled part or a wrong argument is an error. `ember-ui-sdk/primitive` exports `RootYield` and `PartModifier` to type your own roots the same way.

### Patch Changes

- c223620: A controlled `Input` or `Textarea` shows its `@value` when the parent doesn't take a change. It used to keep what was typed.
- c223620: Depend on `@ui-sdk/core` 0.1.0-beta.13, which brings its fixes from beta.6 to beta.13. Select, Listbox and Combobox take `@virtualFocus`, Combobox's `@autoHighlight` takes `"selected"`, and Pagination takes `@disabled`. An Image Cropper's handles now go beside its selection, not inside it.
- c223620: Each `FieldDescription` has an id of its own, so a control with two descriptions is described by both. The first `FieldError` that shows takes the id its control names.
- c223620: The hidden field a Select, Combobox or Listbox renders for its form is now a `<textarea>`, so Enter in the form's one text field submits a form without a submit button, like it does next to a native `<select>`.
- c223620: The item text of a Select, Combobox, Command or Autocomplete follows its content when it changes, like a count in a label, and a reused item reads its text again. Before, it kept the text it first rendered.
- c223620: `ember-ui-sdk/autocomplete` exports `AutocompleteValueChangeDetails` and `ember-ui-sdk/segmented-control` exports `SegmentedControlDirection`, as the other frameworks do.
- ef1c418: Document handing a root's instance to a part component of your own: a root yields the part with `(component MyTab handle=this.handle)` and the part calls `usePart(this, () => this.args.handle, "tab")`, wherever it renders. A part `usePart` creates without an instance now throws a clear error, "A tab part needs @handle, or the root's yielded part.", instead of a `TypeError`.

## 0.2.1

### Patch Changes

- daaa415: Widen the `ember-source` peer range to `^5.12.0 || ^6.0.0 || ^7.0.0`. The addon uses no Ember 7-only API, so apps on Ember 5.12 LTS and 6.x no longer get a peer-dependency warning.

## 0.2.0

### Minor Changes

- 257ef2d: Publish a standard v2 Ember addon with compiled JavaScript, portable Ember templates, and declaration exports instead of raw TypeScript and `.gts` source. Preserve per-component imports and add the classic-addon shim so Ember CLI can discover the package.

  Declare the Glint template type peer and emit portable type references. Explicitly import template helpers and type the combobox's contextual components, including nested item, group and chip parts, for consumers with `noPropertyAccessFromIndexSignature`.

  Use standard addon module metadata so classic webpack builds correctly interoperate with Ember's AMD default exports. Avoid unavailable truth helpers in item-text rendering.

  Verify packed-package discovery, strict declarations, classic production compilation and focused tabs, dialog and combobox interactions on Ember 6.5, alongside the Ember 7/Vite path. Ember 7 remains the supported peer range; these focused checks do not establish general Ember 6.5 support.

## 0.1.0

### Minor Changes

- 6b5e983: First release of ember-ui-sdk: every ui-sdk component as Glimmer components.
