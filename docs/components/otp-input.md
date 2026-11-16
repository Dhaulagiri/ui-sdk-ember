---
title: OTP Input
description: Enter a one-time code with support for pasting, autofill, and native form validation.
---

Use an OTP Input for a short code sent by text or email, like a sign-in or verification code. Each character gets its own slot, and a pasted or autofilled code fills them all at once.

[otp-input/basic](../../examples/components/otp-input/ember/basic.gts)

Type a six-digit code or paste 123-456. Click a slot to edit it, use the arrow keys to move, and use your usual undo shortcut to undo a change.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build an `OTPInput`:

```text
OTPInput as |o|
└── o.Group
    ├── o.Slot
    └── o.Slot
```

`OTPInput` creates the native input and holds the code. `o.Group` lays out a run of slots. Each `o.Slot` displays the character at its zero-based `@index`. Add `o.Separator` between groups when the code is easier to read in sections, like the dash in the example above.

Groups and separators change the presentation of one value. They do not create additional fields or tab stops: the slots display the value of a single native input, which handles selection, paste, undo, form submission, and autofill. It uses `autocomplete="one-time-code"` so supported browsers and password managers can offer a saved or received code.

## Usage

Import the root and use the parts it yields:

```gts
import { OTPInput } from "ember-ui-sdk/otp-input"

<template>
  <OTPInput @maxLength={{4}} aria-label="Verification code" as |o|>
    <o.Group>
      <o.Slot @index={{0}} />
      <o.Slot @index={{1}} />
      <o.Slot @index={{2}} />
      <o.Slot @index={{3}} />
    </o.Group>
  </OTPInput>
</template>
```

## Four Digits

Set `@maxLength` to the code's length and render that many slots. The default length is six.

[otp-input/four-digits](../../examples/components/otp-input/ember/four-digits.gts)

Enter four digits in PIN. Once it is full, typing another digit replaces the selected slot. Click another slot to edit it.

## Alphanumeric

Set `@pattern` to `digits`, `letters`, or `alphanumeric`. The default is `digits`. The pattern filters characters and selects a suitable keyboard on touch devices.

[otp-input/alphanumeric](../../examples/components/otp-input/ember/alphanumeric.gts)

Type letters and digits into Recovery code, or paste ab12-cd34. The hyphen is removed and the eight characters fill the slots.

## Custom Pattern

Pass a regular expression, such as `/[0-9A-F]/i` to accept hexadecimal characters. Use `inputMode` to choose the keyboard separately. The example displays letters in uppercase without changing their stored case.

[otp-input/pattern](../../examples/components/otp-input/ember/pattern.gts)

Try typing 12zzab into Device code. The z characters are rejected; the accepted value is 12ab, displayed as 12AB.

## Validation

Inside a [Field](./field.md), pass `@invalid={{true}}` when your code rejects the value, such as a code the server didn't accept. The field marks the input with `aria-invalid` and connects its `f.Error`. Outside a field, pass `aria-invalid` and `aria-describedby` yourself.

[otp-input/invalid](../../examples/components/otp-input/ember/invalid.gts)

Verification code is marked invalid, and the error below explains why. Edit any digit to clear the error.

## Controlled

Pass `@value` and update it in `@onValueChange`. Call `details.cancel()` in the change callback to reject a change. Incoming values are filtered by the pattern and limited to `@maxLength`, just like typed values.

[otp-input/controlled](../../examples/components/otp-input/ember/controlled.gts)

Enter, paste, or delete digits in One-time password. The console logs each new code and its reason.

The [reason](https://ui-sdk.dev/docs/react/components/otp-input#reasons) distinguishes typing, pasting, undo, and controller actions.

## On Complete

`@onValueCommit` runs when a change fills every slot, including typing, paste, autofill, and controller writes. Changing an already-full code runs it again. Form resets and page restoration do not.

[otp-input/complete](../../examples/components/otp-input/ember/complete.gts)

Fill all six slots. The console logs the complete code and the change reason. Replace a digit to log it again; deleting one logs nothing.

## Forms

Set `@name` to include the code in `FormData`. `@required={{true}}` blocks an empty code, and a partial code fails length validation. Reset restores the default value. Use `@form` to associate a control outside the form with its ID.

[otp-input/form](../../examples/components/otp-input/ember/form.gts)

Choose Verify with an empty or partial code to see validation. Enter all six digits and choose Verify to log the form values. Recovery code sits outside the form but submits with it. Reset clears both fields.

A typed partial code reports `tooShort`. Partial default values and controller writes are checked through the native input's pattern, because browsers do not apply minlength validation to those values.

## Disabled and Read-Only

A disabled input cannot be focused, changed, or submitted. `@readOnly={{true}}` prevents changes while keeping the input focusable and included in form data.

```gts
<OTPInput @disabled={{true}} @defaultValue="123456" aria-label="Disabled code" as |o|>…</OTPInput>
<OTPInput @readOnly={{true}} @defaultValue="654321" aria-label="Read-only code" as |o|>…</OTPInput>
```

## Controller

Create one with `createOTPInputController()` and pass it as `@controller` to read, fill, clear, or focus the input from another control. Writes use the `imperative` reason and pass through the same filtering and change callbacks as typing.

```gts
import { OTPInput, createOTPInputController } from "ember-ui-sdk/otp-input"

const code = createOTPInputController()

<template>
  <OTPInput
    @controller={{code}}
    aria-label="Verification code"
    as |o|
  >…</OTPInput>
</template>
```

Call `code.setValue("123456")`, `code.clear()`, `code.getValue()` or `code.focus()` from any handler.

## Custom Rendering

Pass `@render={{true}}` to a slot to draw its contents yourself. The slot yields `{ part, state }`, where `state` includes `char`, `active`, and `hasFakeCaret`.

## Styling

Draw the active slot and caret with `data-active` and `data-fake-caret`. The examples include the caret animation and disable it for reduced motion. Keep `position: relative` on each slot so its caret stays inside it.

Each part has a `data-slot`, such as `otp-input-slot`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/otp-input#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [otp-input reference](https://ui-sdk.dev/docs/react/components/otp-input) in the upstream docs.

Options and callbacks are passed as arguments, such as `@value` and `@onValueChange`. `id`, `autofocus`, `aria-label`, `aria-labelledby`, `aria-describedby` and `aria-invalid` go to the input.

### Controller

Create one with `createOTPInputController()` and pass it as `@controller`.

`setValue()` and `clear()` take an optional `{ reason, event }`, and run the change callback like typing.

### Events

Callbacks get the code first, then the details.

| Argument         | On         | Receives                                                                                                      |
| ---------------- | ---------- | ------------------------------------------------------------------------------------------------------------- |
| `@onValueChange` | `OTPInput` | `(value, details)`: the new code and the [reason](https://ui-sdk.dev/docs/react/components/otp-input#reasons) |
| `@onValueCommit` | `OTPInput` | `(value, details)`: the full code and the reason that filled it                                               |

## Accessibility

Name the input with a field label, a native label, `aria-label`, or `aria-labelledby`. Screen readers encounter one input with the whole code; the visual slots, groups, and separators are hidden from them.

### Keyboard

The input keeps its native keys. Arrow keys, Home, and End move the selection between slots, Backspace deletes, and your usual shortcuts undo and redo. Pasting a code such as `123-456` removes the separators.
