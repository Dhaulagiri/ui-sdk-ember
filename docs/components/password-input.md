---
title: Password Input
description: Enter a password, show or hide it, and use it in a native form.
---

A Password Input is a native password field with a button that shows and hides what's typed. It keeps the caret in place, offers the right password to password managers, and hides the password again when its form submits.

[password-input/basic](../../examples/components/password-input/ember/basic.gts)

Type a password, then choose Show password to reveal or hide it. Clicking the toggle keeps the caret in the field. With a keyboard, Tab to the toggle and press Space or Enter.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `PasswordInput`:

```text
PasswordInput as |p|
├── p.Control
└── p.Toggle
```

`PasswordInput` holds the value and visibility state. `p.Control` renders the native input; `p.Toggle` renders the button that shows and hides it. The toggle switches the input between `password` and `text`, and is a `type="button"`, so pressing Enter in the input still submits the form.

Put form options such as `@name`, `@form`, `@required`, `@disabled`, and `@readOnly` on `PasswordInput`. Put other native input attributes, such as `placeholder` or `id`, on `p.Control`.

## Usage

Import the root and use the parts it yields:

```gts
import { PasswordInput } from "ember-ui-sdk/password-input"

<template>
  <PasswordInput @name="password" as |p|>
    <p.Control aria-label="Password" />
    <p.Toggle aria-label="Show password">Show</p.Toggle>
  </PasswordInput>
</template>
```

## New Password

Use `autocomplete="new-password"` on the control when creating or changing a password. It tells the browser and password manager which kind of password to offer. The default is `current-password` for signing in.

The example derives a checklist from the current value. Those rules belong to the example; the component does not impose a password policy.

[password-input/new-password](../../examples/components/password-input/ember/new-password.gts)

Type a password and watch the checklist update. Try adding digits and both uppercase and lowercase letters, then toggle its visibility.

## Shown at First

Set `@defaultVisible={{true}}` to start with the text visible, and `@defaultValue` for its initial value. This can be useful for a Wi-Fi password someone needs to read or copy.

[password-input/default-visible](../../examples/components/password-input/ember/default-visible.gts)

Read the Wi-Fi password, then choose Show password to hide it. Choose it again to reveal the value.

## Caps Lock

Use `data-capslock` or the part's `capsLock` state for a warning. It updates from key events while the input is focused. The example reserves space for the icon and warning.

[password-input/caps-lock](../../examples/components/password-input/ember/caps-lock.gts)

Focus Password and press Caps Lock. The warning appears while Caps Lock is on. Turn it off or leave the field to hide the warning.

## Disabled

Set `@disabled={{true}}` on the root, its Field, or an enclosing fieldset to disable both the input and the toggle. The value is omitted from form submission.

[password-input/disabled](../../examples/components/password-input/ember/disabled.gts)

Try to edit Password or press its toggle. Both controls are disabled and are skipped by Tab.

## Read-Only

Set `@readOnly={{true}}` when the value can be read but not edited. The input stays focusable, the toggle still works, and the value still participates in form submission.

[password-input/read-only](../../examples/components/password-input/ember/read-only.gts)

Choose Show recovery key to read it. Try to type in the input; its value stays unchanged.

## Controlled Visibility

Pass `@visible` and update it in `@onVisibleChange` to control visibility. The [reason](https://ui-sdk.dev/docs/react/components/password-input#reasons) distinguishes a toggle press, form submission, reset, page hide, or a controller action.

[password-input/controlled](../../examples/components/password-input/ember/controlled.gts)

Toggle Show password. The console logs each change and its reason.

Call `details.cancel()` in the change callback to reject a visibility change. During form submission, the native input is temporarily a password field even if the callback rejects hiding it.

## Controller

Create one with `createPasswordInputController()` and pass it as `@controller` for actions outside the input. Read or change the value, toggle visibility, or focus the input. Writes use the `imperative` reason.

[password-input/controller](../../examples/components/password-input/ember/controller.gts)

Choose Suggest to fill and reveal a sample value. Try Toggle, Read, Clear, and Focus to call each action from outside the field.

## Forms

The native input participates in `FormData`, validation, and reset. Use `@form` to associate it with a form elsewhere in the page, as this example does.

[password-input/form](../../examples/components/password-input/ember/form.gts)

Enter an email and password, reveal the password, then press Enter in the field. Submission hides it again, and the console logs its length. Reset clears the form. Empty required fields block submission.

Submission, reset, and page hiding request that the password be hidden again. A reset also restores its default value. Spellcheck, autocorrection, and automatic capitalization stay disabled when the password is visible.

## Controlled Value

Pass `@value` and update it in `@onValueChange`. The [New Password example](#new-password) derives its checklist this way.

## Custom Rendering

Pass `@render={{true}}` to a part to render your own element. The part yields `{ part, state }`: bind `part` to the element, and read `state` for whether the password is `visible`, whether Caps Lock is on (`capsLock`), and whether the field is `filled`.

```gts
<PasswordInput as |p|>
  <p.Control aria-label="Password" />
  <p.Toggle aria-label="Show password" @render={{true}} as |t|>
    <button {{t.part}} type="button">
      {{if t.state.visible "Hide" "Show"}}
    </button>
  </p.Toggle>
</PasswordInput>
```

## Styling

Style the root as the field's box, with the native input and the toggle inside it. `data-visible` marks every part while the password is shown, and the toggle also sets `aria-pressed`. Use `data-capslock` for a Caps Lock warning, and `data-filled`, `data-disabled` and `data-readonly` for the field's other states. Inside Field, the native input also receives validation attributes such as `data-invalid`. Use logical spacing so the field and toggle follow the surrounding direction.

Each part has a `data-slot`, such as `password-input-toggle`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/password-input#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [password-input reference](https://ui-sdk.dev/docs/react/components/password-input) in the upstream docs.

Options and callbacks are passed as arguments, such as `@value` and `@visible`. Every part also takes `@render`.

### Controller

Create one with `createPasswordInputController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, and runs the change callback like typing or a press. `setVisible()` and `toggleVisible()` return `false` when the change is canceled.

### Events

Callbacks get the new value first, then the details.

| Argument           | On              | Receives                                                                                                                                    |
| ------------------ | --------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `@onValueChange`   | `PasswordInput` | `(value, details)`: the new password and the [reason](https://ui-sdk.dev/docs/react/components/password-input#reasons)                      |
| `@onVisibleChange` | `PasswordInput` | `(visible, details)`: whether the password wants to show, and the [reason](https://ui-sdk.dev/docs/react/components/password-input#reasons) |

## Accessibility

There's no WAI-ARIA pattern for a password field. The input stays a native password field named by its Field label or an `aria-label`, and the toggle follows the [WAI-ARIA button pattern](https://www.w3.org/WAI/ARIA/apg/patterns/button/) as a toggle button. Name the toggle by what it does, such as “Show password”, and keep that name the same: its `aria-pressed` state tells screen readers whether the password is shown, and `aria-controls` points to the input.

### Keyboard

Tab moves from the input to the toggle, and Space or Enter on the toggle shows or hides the password. Enter in the input submits its form; it never presses the toggle.

### Focus

A pointer press on the toggle keeps focus in the input, with the caret and selection where they were. A press from elsewhere brings focus back to the input. A keyboard press keeps focus on the toggle.
