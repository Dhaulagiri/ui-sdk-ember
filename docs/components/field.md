---
title: Field
description: Connect a form control to its label, description, and validation errors.
---

A field connects a form control to its label, its description and the errors it shows, and wires up `id`, `for` and `aria-describedby` for you.

[field/input](../../examples/components/field/ember/input.gts)

Press Username to focus the input, then type a name.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Field`:

```text
Field as |f|
├── f.Label
├── Input
├── f.Description
└── f.Error
```

## Usage

Import the field and pass its `f.field` to the control as `@field`:

```gts
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"

<template>
  <Field @name="username" as |f|>
    <f.Label>Username</f.Label>
    <Input autocomplete="username" required @field={{f.field}} />
    <f.Description>This is your public name.</f.Description>
    <f.Error />
  </Field>
</template>
```

The control is one of ours, like an [Input](./input.md), a [Textarea](./textarea.md), a [Select](./select.md) or a [Checkbox](./checkbox.md), and it wires itself to the field.

The label names the control, and the description and any error that shows describe it.

Group related fields in a [field set](#field-sets):

```gts
<FieldSet as |s|>
  <s.Legend>Address</s.Legend>
  <s.Description>We need your address to deliver your order.</s.Description>
  <FieldGroup>
    <Field as |f|>…</Field>
    <Field as |f|>…</Field>
  </FieldGroup>
</FieldSet>
```

`ember-ui-sdk/field` also exports each part by name, such as `FieldSet` and `FieldLegend`. They take the root's `@handle`, so use the parts the root yields instead.

## Controls

Use an [Input](./input.md) for a line of text and a [Textarea](./textarea.md) for more:

```gts
<Field as |f|>
  <f.Label>Feedback</f.Label>
  <Textarea name="feedback" @field={{f.field}} />
</Field>
```

A [Checkbox](./checkbox.md), [Switch](./switch.md) or [Radio Group](./radio.md) inside a field uses the field's label and description. Pressing the label toggles a checkbox or switch. A radio group takes the field's label as its name, and each radio keeps a label of its own.

## Validation

Use native constraints such as `required`, `type="email"`, and `pattern`. Errors appear after a submit attempt and update as the value changes. The first invalid control takes focus.

Leave an error empty to show the browser's message, or use `@match="valueMissing"` and `@match="typeMismatch"` for your own messages. Adding an error part replaces the browser's validation bubble with that message in the page.

[field/validation](../../examples/components/field/ember/validation.gts)

Press Subscribe with an empty or invalid email, then correct it to clear the error.

## Errors from Your Code

Pass `@invalid={{true}}` when your server or form library supplies an error. Clear the value to return to the browser's validation.

Give this error its own text and leave out `@match`. Named matches such as `valueMissing` still refer to native validation. `@invalid={{false}}` hides the field's invalid state, but does not make an invalid native control pass validation.

```gts
<Field @name="email" @invalid={{this.serverError}} as |f|>
  <f.Label>Email</f.Label>
  <Input type="email" required @field={{f.field}} />
  <f.Error @match="valueMissing">Enter your email address.</f.Error>
  {{#if this.serverError}}
    <f.Error>{{this.serverError}}</f.Error>
  {{/if}}
</Field>
```

## Required and Disabled

A required control marks every part with `data-required`, and the parts' state has `required`, so a label can show a mark with CSS alone.

A disabled field disables its control and marks every part with `data-disabled`, the way a [disabled field set](#disabled-field-sets) does for every field inside it.

## Character Count

Keep the text in state and show its length in the description. Set `maxlength` on the control to enforce the limit.

```gts
<Field as |f|>
  <f.Label>Bio</f.Label>
  <Textarea @value={{this.bio}} @onValueChange={{this.onBio}} maxlength={{280}} @field={{f.field}} />
  <f.Description>{{this.bio.length}} / 280</f.Description>
</Field>
```

## Forms

The control submits its value under its own `name`, or the field's name if it has none. Reset restores the control's default and hides validation errors. Disabled controls are left out of the submitted values.

## Field Sets

A field set groups related fields under a legend, and disables them together.

[field/field-set](../../examples/components/field/ember/field-set.gts)

Move through the address fields. Their legend and description name the group.

`FieldSet` is a native `<fieldset>` and `FieldLegend` a native `<legend>`, so the set is named, and disabled, before scripts run. Keep the legend the first child.

A `FieldDescription` right inside the set, outside any `Field`, describes the set, so screen readers read it as focus enters. `FieldGroup` is a `<div>` that stacks the fields, with no role and no state: the field set is what names and disables a group.

## Disabled Field Sets

Disabling the set disables its controls and nested field sets. The form leaves their values out of submissions.

```gts
<FieldSet @disabled={{this.sameAsShipping}} as |s|>
  <s.Legend>Billing address</s.Legend>
  <Field as |f|>
    <f.Label>Street address</f.Label>
    <Input autocomplete="billing street-address" @field={{f.field}} />
  </Field>
</FieldSet>
```

## Groups in a Field Set

The legend names a [checkbox group](./checkbox.md#group) or a [radio group](./radio.md) inside the set, so the group needs no label of its own.

```gts
<FieldSet as |s|>
  <s.Legend>Notifications</s.Legend>
  <CheckboxGroup @name="notify" @defaultValue={{array "mentions"}} as |g|>
    <label>
      <g.Checkbox @value="mentions" as |c|><c.Indicator>✓</c.Indicator></g.Checkbox>
      Mentions
    </label>
    <label>
      <g.Checkbox @value="follows" as |c|><c.Indicator>✓</c.Indicator></g.Checkbox>
      New followers
    </label>
  </CheckboxGroup>
</FieldSet>
```

## Custom Rendering

Pass `@render={{true}}` to a part to render a different element in its place. The part yields `{ part, state }`, so a `FieldDescription` can change its text from the field's state, and `FieldError`'s state also has the `message` for the current problem.

```gts
<Field as |f|>
  <f.Description @render={{true}} as |d|>
    <p {{d.part}}>{{if d.state.invalid "Use letters and numbers only." "Letters and numbers."}}</p>
  </f.Description>
</Field>
```

State is read lazily. A part re-renders for a change only if its render function or slot read that value. Each part's state is listed under [State](https://ui-sdk.dev/docs/react/components/field#state).

## Styling

Use `data-invalid` and `data-valid` for validation, and `data-focused`, `data-required` and `data-disabled` for the rest. Every part of a field gets the same attributes, so a label can turn red with its control.

Each part has a `data-slot`, such as `field-label`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/field#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [field reference](https://ui-sdk.dev/docs/react/components/field) in the upstream docs.

Options are passed as arguments, such as `@name` and `@invalid`. Every part also takes `@render`.

A field has no change events. Read its state from the parts' data attributes, or from render functions. Set `@debug={{true}}` to log every state change and its reason.

## Accessibility

The label names the control with `aria-labelledby`, beside a native `<label for>` where the control can take one. The description and any error that shows describe it with `aria-describedby`, and an invalid control has `aria-invalid`. The tests below cover these connections and keyboard behavior.
