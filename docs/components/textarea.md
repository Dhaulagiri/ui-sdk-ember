---
title: Textarea
description: Enter multiple lines of text, grow the field as you type, and connect it to a form.
---

A textarea is a native multi-line text field for messages, notes and descriptions. It works inside a field and a form, can grow with its text, and reports the same change reasons as Input.

[textarea/basic](../../examples/components/textarea/ember/basic.gts)

Click Message to focus the textarea, then type. Press Enter to start a new line.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Usage

`Textarea` renders a native `<textarea>`. Pass `rows`, `placeholder`, `maxlength` and other native attributes directly.

```gts
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Textarea aria-label="Message" placeholder="Type your message here…" />
</template>
```

## Field

Wrap the textarea in a [Field](./field.md) to give it a visible label and a description. Pass the field's `f.field` as `@field` so the textarea is connected to the field's label, description and errors.

[textarea/field](../../examples/components/textarea/ember/field.gts)

Click Feedback to focus the textarea. A screen reader reads the description with the field.

## Auto Resize

Set `@autoResize={{true}}` to grow and shrink the textarea with its text. CSS `min-height` and `max-height` set its limits; past the maximum, the text scrolls inside it.

[textarea/auto-resize](../../examples/components/textarea/ember/auto-resize.gts)

Type several lines in Notes. The textarea grows with each line until it reaches its maximum height, then scrolls. Delete the lines and it shrinks back.

Browsers that support `field-sizing: content` size it natively. Elsewhere, the component measures it when the value changes, the form resets or its width changes.

## Controlled

Pass `@value` and update it in `@onValueChange`. Here the character count is derived from that value, and the native `maxlength` caps the text.

[textarea/controlled](../../examples/components/textarea/ember/controlled.gts)

Edit Bio and watch the character count under it. The textarea stops accepting text at 160 characters.

Textarea shares Input's [change reasons](https://ui-sdk.dev/docs/react/components/textarea#reasons) and cancellation behavior.

## Form

A textarea submits its value through a native form under its field's `name`. Pass a controller from `createInputController()`, as `@controller`, to change it from outside, here to empty it after sending. The native `required` constraint blocks an empty message.

[textarea/button](../../examples/components/textarea/ember/button.gts)

Type a message and press Send Message. The console logs it and the textarea clears. Pressing Send Message while it's empty is blocked.

## Disabled

Set `@disabled={{true}}` on the textarea or its field to prevent editing and leave it out of the tab order and the submitted values.

[textarea/disabled](../../examples/components/textarea/ember/disabled.gts)

Try to edit Reply or reach it with Tab. The disabled textarea keeps its value but can't be changed.

## Invalid

Set `@invalid={{true}}` on the field for an error your app decides. The field shows its error, associates it with the textarea and sets `aria-invalid`. [Field](./field.md#validation) covers native constraints and error matches.

[textarea/invalid](../../examples/components/textarea/ember/invalid.gts)

Focus Review. The textarea is marked invalid, and the error below says how long the review should be.

## Submit Shortcut

Set `@submitShortcut` to submit the textarea's form from the keyboard. With `"mod+enter"`, Enter still starts a new line and Command or Control+Enter submits. With `"enter"`, Enter submits and Shift+Enter starts a new line. Without it, Enter always starts a new line, and neither submits while an input method is composing.

```gts
<form action="/messages" method="post">
  <Textarea
    name="message"
    aria-label="Message"
    required
    @submitShortcut="mod+enter"
  />
  <button type="submit">Send</button>
</form>
```

The shortcut submits like the Send button, so `required` and the form's submit handler still apply. Pass `@onSubmit` to the textarea to handle the shortcut yourself instead. It receives the value, and the form doesn't submit.

## Styling

Style the native textarea directly, with `data-filled`, `data-disabled`, `data-readonly` and `data-required` for its states. Inside a field it also receives the field's validation attributes, such as `data-invalid`. For `@autoResize`, set `min-height` and `max-height` to bound its growth. Use logical spacing so the text follows the surrounding direction.

The textarea has a `data-slot` of `textarea`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/textarea#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [textarea reference](https://ui-sdk.dev/docs/react/components/textarea) in the upstream docs.

Options and callbacks are passed as arguments, such as `@value` and `@onValueChange`, plus every native textarea attribute.

### Controller

Create one with `createInputController()` and pass it as `@controller`.

## Accessibility

There's no WAI-ARIA pattern for a multi-line text field. The textarea stays a native `<textarea>`, with standard text editing, selection, spell checking and form behavior. Give it a visible field label or an `aria-label`, and keep descriptions and errors in their field parts so they're associated with it.
