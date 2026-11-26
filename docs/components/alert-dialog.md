---
title: Alert Dialog
description: Ask someone to confirm an action before you continue.
---

Use an alert dialog when someone needs to answer a question before an action continues, such as deleting a project.

[alert-dialog/basic](../../examples/components/alert-dialog/ember/basic.gts)

Open the dialog with Enter to start on Cancel. Tab stays inside, clicking outside leaves it open, and Escape closes it and returns focus to the trigger.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build an `AlertDialog`:

```text
AlertDialog as |d|
├── d.Trigger
├── d.Backdrop
└── d.Content
    ├── d.Title
    ├── d.Description
    ├── d.Close
    └── d.Close
```

Put the question in `d.Title`, explain what happens in `d.Description`, and use `d.Close` for each answer. Add `d.Backdrop` to dim the page.

A Close part reports its `@value` when it closes. `@value="confirm"` is the agreeing answer that the [confirm helper](#confirm) recognizes.

## Usage

Import the root and use the parts it yields:

```gts
import { AlertDialog } from "ember-ui-sdk/alert-dialog"

<template>
  <AlertDialog as |d|>
    <d.Trigger>Delete Project</d.Trigger>
    <d.Content>
      <d.Title>Delete this project?</d.Title>
      <d.Description>The project and its files will be deleted for everyone.</d.Description>
      <d.Close>Cancel</d.Close>
      <d.Close @value="confirm">Delete</d.Close>
    </d.Content>
  </AlertDialog>
</template>
```

## Controlled

Pass `@open` and update it in `@onOpenChange` when your app needs to read or control whether the dialog is open. Canceling a change works the same way as in [Dialog](./dialog.md#controlled).

[alert-dialog/controlled](../../examples/components/alert-dialog/ember/controlled.gts)

Choose Review Changes, then Keep Editing or Discard.

## Shortcut

Give the trigger a `@shortcut` to open the dialog from the keyboard, and put `d.Shortcut` inside it to show the keys. [Dialog](./dialog.md#keyboard-shortcut) covers the shortcut syntax.

[alert-dialog/shortcut](../../examples/components/alert-dialog/ember/shortcut.gts)

Press Cmd+Shift+H (Ctrl+Shift+H on Windows and Linux) to open the dialog without clicking.

## Animation

The content has `data-starting-style` while it opens and `data-ending-style` while it closes. Transition from those states, and the dialog stays mounted until the exit finishes:

```css
[data-slot="alert-dialog-content"] {
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

[alert-dialog/animation](../../examples/components/alert-dialog/ember/animation.gts)

Open and close the dialog. It slides up and fades in, and slides down and fades out before it unmounts.

## Nested

An alert dialog opened inside another joins its stack, such as a second confirmation before something can't be undone. Escape closes the topmost one and returns focus to its trigger. The dialog underneath gets `data-nested-open`, so you can show which layer is active. To close both once the last question is answered, control the outer dialog with `@open` and close it when the inner one's `@onOpenChange` reports `returnValue` `"confirm"`.

[alert-dialog/nested](../../examples/components/alert-dialog/ember/nested.gts)

Choose Delete Workspace, then Delete. Press Escape to step back to the first question, or choose Delete Workspace to close both.

## Async Action

An `@action` on a Close part runs before it closes the dialog. Return a Promise to keep the dialog open until the work finishes. A resolved Promise closes it with the reason `action`; a rejection keeps it open and puts the error in that part's state.

[alert-dialog/async-action](../../examples/components/alert-dialog/ember/async-action.gts)

Choose Delete Project, then Delete. The first attempt fails so you can try again. While Deleting… is shown, Cancel and Escape leave the dialog open. A successful retry closes it.

While the action runs, its button stays focusable and gets `data-pending`, `aria-busy`, and `aria-disabled`. Other Close parts get `aria-disabled` and `data-disabled`, and neither they nor dismissals can close the dialog until it settles. `@onDismissAttempt` reports refused dismissals; a controller can still close it.

The root's `@pendingAnnouncement` sets what screen readers hear after a second of waiting. The error clears on the next attempt or when the dialog opens again. The action also receives `{ source }` after its event argument; [Button](./button.md#changes-after-an-await) explains when to use it.

## Confirm From Anywhere

The shared `confirm()` asks a question without any dialog markup. Render `OverlayHost` from `ember-ui-sdk/overlays` once near the root of your app, and it shows each question as an alert dialog. `confirm()` resolves `true` when someone agrees. [Confirm Options](#confirm-options) lists what you can pass.

[alert-dialog/confirm-anywhere](../../examples/components/alert-dialog/ember/confirm-anywhere.gts)

Choose Archive Project, then Archive or Cancel. The console shows the answer.

## Confirm

Use `createConfirm<Payload>()` to ask a question from an event handler and await the answer. Create it once, then pass its `controller` to your alert dialog. The content reads the question's data from its state.

`await this.confirm({ name })` resolves `true` when the Close part with `@value="confirm"` closes the dialog. Cancel, Escape, and other answers resolve `false`. This lets several rows share one dialog:

[alert-dialog/confirm](../../examples/components/alert-dialog/ember/confirm.gts)

Delete a project. Cancel or Escape keeps it; Delete removes it and focuses a neighboring row's button. Reset Projects brings the list back.

When the action removes the button that opened the dialog, choose a useful place for focus to go. This example focuses a neighboring row, or Reset Projects when the list is empty.

## Queued Questions

Calls to the same confirm function wait their turn. You can ask two questions at once; the second appears only after the first has an answer.

[alert-dialog/queue](../../examples/components/alert-dialog/ember/queue.gts)

Choose Review Two Projects. Answer the Acme question, then the Globex question. The console shows both answers once the second one is in.

## Styling

Each part has a `data-slot`, such as `alert-dialog-content`, and shows its state through the attributes listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/alert-dialog#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [alert-dialog reference](https://ui-sdk.dev/docs/react/components/alert-dialog) in the upstream docs.

Alert Dialog shares [Dialog's](./dialog.md) arguments, except `@modal`, `@closeOnOutsidePress`, and `@presentation`. It is always modal, never closes on an outside press, and does not present as a sheet.

### AlertDialogBackdrop

Dims the page behind the dialog. Renders a `div`.

### AlertDialogTitle

The question. Renders an `h2`, and the content uses it as its accessible name.

### AlertDialogDescription

What happens if you agree. Renders a `p`, and the content uses it as its accessible description.

### Confirm Options

The shared `confirm()` function uses these options when an `OverlayHost` renders the question. With your own dialog, `createConfirm<Payload>()` accepts the payload you choose instead.

### Controller

Use `createAlertDialogController<Payload, Result>()` for direct control. `createConfirm<Payload>()` returns a confirm function with its own `controller`.

## Accessibility

Give the dialog a title and a description, and put the least destructive answer first. It follows the [WAI-ARIA alert dialog pattern](https://www.w3.org/WAI/ARIA/apg/patterns/alertdialog/).

The dialog uses the `alertdialog` role and keeps the rest of the page inert while it's open. Screen readers announce its title and description. Opening it focuses the first Close part, so put Cancel first. A touch open focuses the content instead, so no on-screen keyboard appears. Escape closes the dialog, but pressing outside never does. [Dialog](./dialog.md#focus) covers other initial and final focus targets.
