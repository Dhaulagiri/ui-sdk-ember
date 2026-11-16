---
title: Input
description: Enter text, add a clear button, and connect the value to your form or state.
---

An input is a native text field for short values like a name, an email address or a search. It works inside a field and a form, and adds a clear button, text around the input, and change reasons.

[input/basic](../../examples/components/input/ember/basic.gts)

Edit the website, then press Clear website. The text clears, focus returns to the input and the console logs the reason. Pressing https:// focuses the input too.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build an `Input` or an `InputGroup`:

```text
Input

InputGroup as |g|
├── Input
└── g.Clear
```

`Input` renders a native `<input>`. Pass its type, placeholder, autocomplete and other native attributes directly. `InputGroup` holds text or buttons around it, and `g.Clear` empties it.

## Usage

Import the parts and put them together:

```gts
import { Input, InputGroup } from "ember-ui-sdk/input"

<template>
  <InputGroup as |g|>
    <Input type="search" aria-label="Search" />
    <g.Clear aria-label="Clear search">✕</g.Clear>
  </InputGroup>
</template>
```

## Fields

Wrap the input in a [Field](./field.md) to give it a visible label, a description and errors. Pass the field's `f.field` to the input as `@field` so the input is connected to the field's label, description and errors.

```gts
<Field @name="username" as |f|>
  <f.Label>Username</f.Label>
  <Input autocomplete="username" @field={{f.field}} />
  <f.Description>Choose a unique username for your account.</f.Description>
</Field>
```

## Disabled and Read Only

Set `@disabled={{true}}` on the input or its field to prevent editing and leave it out of the tab order and the submitted values. A `@readOnly` input can still be focused, selected and submitted.

```gts
<Field @disabled={{true}} as |f|>
  <f.Label>Email</f.Label>
  <Input type="email" @defaultValue="hollis@example.com" @field={{f.field}} />
</Field>

<Field as |f|>
  <f.Label>Profile URL</f.Label>
  <Input @readOnly={{true}} @value="example.com/hollis" @field={{f.field}} />
</Field>
```

## Validation

Use native constraints such as `required`, `type="email"` and `pattern`. The field shows its error after a submit attempt and updates it as the value changes. Set `@invalid={{true}}` on the field for an error your app decides; the input gets `aria-invalid`. [Field](./field.md#validation) covers the error parts and their matches.

```gts
<Field @name="email" @invalid={{this.emailTaken}} as |f|>
  <f.Label>Email</f.Label>
  <Input type="email" required @field={{f.field}} />
  <f.Error @match="valueMissing">Enter your email address.</f.Error>
  <f.Error>That email is already in use.</f.Error>
</Field>
```

## Input Group

Place text or buttons around an input with `InputGroup`. Pressing the group's text focuses the input. The text is display content, not part of the submitted value.

```gts
<InputGroup as |g|>
  <span>https://</span>
  <Input aria-label="Website" placeholder="example" />
  <span>.com</span>
</InputGroup>
```

## Clear Button

`g.Clear` shows while the input has text it can clear. Pressing it empties the value, reports `clear-press` and returns focus to the input.

```gts
<InputGroup as |g|>
  <Input type="search" aria-label="Search people" />
  <g.Clear aria-label="Clear search">✕</g.Clear>
</InputGroup>
```

## Controlled

Pass `@value` and update it in `@onValueChange` to control the input. The callback also receives the change details.

```gts
<Input @value={{this.name}} @onValueChange={{this.onName}} />
```

Input's [reasons](https://ui-sdk.dev/docs/react/components/input#reasons) tell typing, clearing, resetting and controller changes apart.

## Filtering What's Typed

Call `details.cancel()` in `@onValueChange` to reject a change. The previous text and caret position are restored.

```gts
<Input
  inputmode="numeric"
  maxlength={{6}}
  @onValueChange={{this.onDigits}}
/>
```

## Controller

Create one with `createInputController()` for actions outside the input. Its methods update the input through the same change callbacks as typing.

```gts
import { Input, createInputController } from "ember-ui-sdk/input"

const message = createInputController()

<template>
  <Input aria-label="Message" @controller={{message}} />
  <button type="button" {{on "click" this.quickReply}}>Quick Reply</button>
</template>
```

Call `message.setValue("On my way!")`, `message.clear()` or `message.focus()` from any handler.

## Passwords and Files

Use [Password Input](./password-input.md) to show and hide a password. A native file input works with `type="file"`; use [File Input](./file-input.md) for dropping, previews and validation.

## Styling

Each part has a `data-slot`, such as `input-group`, and shows its state through the attributes listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/input#data-attributes). Use `data-filled`, `data-disabled`, `data-readonly` and `data-required` on the input, and the field's validation and focus attributes inside a field. For a group's focus ring, style `:has(input:focus-visible)`, so a focused button inside it keeps its own ring.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [input reference](https://ui-sdk.dev/docs/react/components/input) in the upstream docs.

Options and callbacks are passed as arguments, such as `@value` and `@onValueChange`, plus every native input attribute.

### InputClear

A `<button>` that empties the input in its group and focuses it. It renders only while there's text to clear.

### Controller

Create one with `createInputController()` and pass it as `@controller`.

## Accessibility

Give the input a visible field label or an `aria-label`, and give the clear button an accessible name. The native input keeps standard text editing, selection, autocomplete and form behavior.
