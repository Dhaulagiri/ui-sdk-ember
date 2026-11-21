---
title: Dialog
description: Open a focused task over the page.
---

A dialog gives a task its own space: share a link, edit a record, or collect a few details. It manages focus, Escape, outside presses, and returning to where you started.

[dialog/basic](../../examples/components/dialog/ember/basic.gts)

Open Share, then close it with either Close button, Escape, or a press outside. Focus returns to Share.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Dialog`:

```text
Dialog as |d|
├── d.Trigger
├── d.Backdrop
└── d.Content
    ├── d.Title
    ├── d.Description
    └── d.Close
```

The title names the dialog; the description gives it context. A dialog can have several Close parts. Give an icon-only close button an accessible name, as the first example does.

The backdrop is optional. Without one, style the content’s `::backdrop`. For a question that requires an explicit answer, use [Alert Dialog](./alert-dialog.md).

## Usage

Import the root and use the parts it yields:

```gts
import { Dialog } from "ember-ui-sdk/dialog"

<template>
  <Dialog as |d|>
    <d.Trigger>Open</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <d.Title>Project details</d.Title>
      <d.Description>Review the details before continuing.</d.Description>
      <d.Close>Close</d.Close>
    </d.Content>
  </Dialog>
</template>
```

`ember-ui-sdk/dialog` also exports each part by name, such as `DialogContent` and `DialogTrigger`. They take the root's `@handle`, so use the parts the root yields instead.

## Scrollable Content

Keep the header and actions outside the scrolling area. A viewport height limit, a shrinking middle grid row, and `overflow-y: auto` keep long content usable. `@initialFocus="content"` focuses the dialog itself so reading starts at the top.

[dialog/scrollable](../../examples/components/dialog/ember/scrollable.gts)

Open Scrollable Content in a short window. Scroll the terms while the title and Decline/Accept buttons stay in view.

## Forms

A form with `method="dialog"` closes the dialog on a valid submission. The submit button’s `value` becomes the `returnValue`, just like a Close part’s `value`. An ordinary form stays open until you close the dialog yourself.

[dialog/form](../../examples/components/dialog/ember/form.gts)

Open New Article and choose Save Draft or Publish. The console logs the submitted button's value. An empty title prevents submission.

## Focus

Use `@initialFocus` to pick where focus starts, and `@finalFocus` to choose where it goes after closing. Each takes a selector, an element or a function returning one. The default returns to the trigger, or to the element focused before a controller opened the dialog.

```gts
<d.Content @initialFocus="#invite-email" @finalFocus={{this.nextStep}}>…</d.Content>
```

## Controlled

Pass `@open` and update it in `@onOpenChange`. Cancel a proposed change with `details.cancel()` in that callback. `@onOpenChangeComplete` reports when opening or closing has finished.

[dialog/controlled](../../examples/components/dialog/ember/controlled.gts)

Check Open or press Notification Settings, then close the dialog. The console logs each change, its reason and when it finishes.

## Keyboard Shortcut

A trigger’s `@shortcut` opens it from the keyboard. `mod+j` means Command+J on Apple platforms and Control+J elsewhere. The `d.Shortcut` part displays the right keys and the trigger exposes `aria-keyshortcuts`.

[dialog/shortcut](../../examples/components/dialog/ember/shortcut.gts)

Press Command+J or Control+J to open New contact. The button shows the keys, and Escape returns focus to it.

## Animation

The content and backdrop have `data-starting-style` while they open and `data-ending-style` while they close. Transition from those states, and the dialog stays mounted until the exit finishes. `@onOpenChangeComplete` runs after the transition, and `@keepMounted={{true}}` keeps the content in the page while closed.

```css
[data-slot="dialog-content"] {
  transition:
    opacity 0.2s,
    translate 0.25s cubic-bezier(0.22, 1, 0.36, 1),
    scale 0.25s cubic-bezier(0.22, 1, 0.36, 1);

  &:is([data-starting-style], [data-ending-style]) {
    opacity: 0;
    translate: 0 16px;
    scale: 0.96;
  }

  &[data-ending-style] {
    transition-duration: 0.15s;
  }
}
```

[dialog/animation](../../examples/components/dialog/ember/animation.gts)

Open the dialog and close it. The console logs when each animation finishes; focus returns as closing starts.

## Modal

`@modal` controls how the dialog shares the page:

- `true`, the default, makes the page inert, locks scrolling, and keeps Tab inside.
- `"trap-focus"` keeps Tab inside while the page can still scroll and receive clicks. A click on the page also closes the dialog, unless `@closeOnOutsidePress` is false.
- `false` puts the dialog beside the page and lets focus leave it. Escape closes it while focus is inside; outside presses close it only when `@closeOnOutsidePress` is enabled.

To keep a small part of the page usable while a modal dialog is open, like a chat launcher, pass it to `@persistentElements`: an array of elements or selectors, or a function returning elements when the dialog opens. Persistent elements don't change stacking on their own.

Dialogs render where you put them and use the browser's top layer. Set `@container` when their DOM needs to live elsewhere, like a shadow root.

[dialog/modal](../../examples/components/dialog/ember/modal.gts)

Choose a mode, open Notes, and try Tab or clicking the page. Check Close on outside press to compare dismissal.

## Inside a Frame

A dialog opens above the whole page. Set `@inline={{true}}` on the content to keep it and its backdrop where they are in the page, like inside an app preview. Your CSS sizes and places them in their frame. Pair it with `@modal="trap-focus"` so the page around the frame stays usable.

[dialog/inline](../../examples/components/dialog/ember/inline.gts)

Open Delete Draft. The dialog and its dim cover only the frame, and Tab stays inside the dialog.

## Warn Before Closing a Dirty Form

Set `@dismissible={{false}}` while there are unsaved changes. Escape, an outside press, or a back gesture then keeps the dialog open and reports `@onDismissAttempt`. Explicit Close parts and controller calls still work, so you can offer a deliberate way out.

[dialog/dirty-form](../../examples/components/dialog/ember/dirty-form.gts)

Type a post, then press Escape or click outside. Keep editing returns to the field; Discard closes the dialog and clears the draft.

## Nested Dialogs

A dialog opened inside another joins its stack. Escape closes the topmost dialog and returns focus to its trigger. Closing the parent also closes its children. `data-nested-open` and `--dialog-stack` let you show which layer is active.

[dialog/nested](../../examples/components/dialog/ember/nested.gts)

Open Account, then Change Password. Press Escape once to return to Account, and again to close it.

## Opening from a Menu Item

Render the dialog outside the menu and open it with the dialog’s controller. When the item disappears, the menu’s trigger becomes the place to return focus.

[dialog/from-menu](../../examples/components/dialog/ember/from-menu.gts)

Open File Actions and choose Rename. Close the dialog to return focus to the File Actions button.

## Opening from Anywhere

Connect several triggers to one `createDialogController<Payload, Result>()`. Each trigger passes a `@payload`; the content reads it from its state. `controller.open({ payload })` opens it from code and returns a promise that resolves when it closes, with the reason and any `returnValue`. Each trigger remains the return-focus target for the dialog it opened.

[dialog/payload](../../examples/components/dialog/ember/payload.gts)

Open a reminder from either unpaid invoice, or press Open from Code. The same dialog shows that invoice, and the console logs how it closed.

## Presentation

`@presentation="sheet"` presents the same task as a sheet. Use `"auto"` to choose a sheet on small touch screens and a centered dialog elsewhere, decided each time it opens. A swipe down closes a dismissible sheet; a protected one springs back and reports a dismissal attempt.

Style `data-presentation` to support both layouts. The sheet manages its own position and movement, so do not apply the centered dialog’s translation to it. `--sheet-backdrop` styles the dimmed page when no Backdrop part is present.

[dialog/presentation](../../examples/components/dialog/ember/presentation.gts)

Open Edit Profile as a sheet. On a touch screen, drag it down to dismiss it, or use Cancel or Save Changes.

## Custom Rendering

Pass `@render={{true}}` to a part to render it as your own element. It yields `{ part, state }`: bind `part` to your element as a modifier, and read the state in the block.

[dialog/custom-rendering](../../examples/components/dialog/ember/custom-rendering.gts)

Open View Details. The trigger's label and the description come from their state, and Close renders as a link.

## Styling

Each part has a `data-slot`, such as `dialog-content`, and shows its state through the attributes listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/dialog#data-attributes). Use `data-open` and `data-closed` for each state, and `data-starting-style` and `data-ending-style` for transitions.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [dialog reference](https://ui-sdk.dev/docs/react/components/dialog) in the upstream docs.

Pass the root's options as `@` arguments. `@open` is controlled with `@onOpenChange`.

### DialogTrigger

A trigger outside the dialog also takes `@controller`.

### DialogBackdrop

Dims the page behind a modal dialog. Renders a `div`.

### DialogTitle

Names the dialog. Renders an `h2`.

### DialogDescription

Describes the dialog while it's rendered. Renders a `p`.

### DialogClose

Its `@action` receives the event and `{ source }`, how the part was pressed, as [Button](./button.md#changes-after-an-await) describes.

### Controller

Create one with `createDialogController<Payload, Result>()` and pass it as `@controller`, to the dialog and to any triggers outside it.

Every write method takes an optional `{ reason, event }`, passed to `@onOpenChange`. Closing with a controller always works, even when the dialog isn't dismissible or an action is running.

### Events

Callbacks get the new state first, then the details. A controlled `@open` only updates when `@onOpenChange` wasn't canceled.

| Argument                | On       | Receives                                                                                                                      |
| ----------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `@onOpenChange`         | `Dialog` | `(open, details)`: the new state, the [reason](https://ui-sdk.dev/docs/react/components/dialog#reasons) and any `returnValue` |
| `@onOpenChangeComplete` | `Dialog` | `(open)`, after the animation                                                                                                 |
| `@onPayloadChange`      | `Dialog` | `(payload, details)`: the content's new payload, and the [reason](https://ui-sdk.dev/docs/react/components/dialog#reasons)    |
| `@onDismissAttempt`     | `Dialog` | `({ reason, event })`, when a dismissal was refused                                                                           |

## Accessibility

The trigger is a button that opens a dialog, and the dialog follows the [WAI-ARIA modal dialog pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/): `aria-modal` while it's modal, labelled by its title, described by its description only while one is rendered. Every line below is an automated test.

### Keyboard

| Key                  | Does                                                                 |
| -------------------- | -------------------------------------------------------------------- |
| Enter, Space         | On the trigger, opens the dialog                                     |
| Tab, Shift+Tab       | Moves through the dialog's controls, staying inside while it's modal |
| Escape               | Closes the topmost dialog and returns focus to its trigger           |
| A trigger's shortcut | Opens its dialog from anywhere on the page                           |
