# Field

Connect a form control to its label, description, and validation errors.

A field connects a form control to its label, its description and the errors it shows, and wires up `id`, `for` and `aria-describedby` for you.

```glimmer-ts title="input.gts"
import { Field, FieldDescription } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"

<template>
  <div data-slot="stack">
    <Field as |f|>
      <f.Label>Username</f.Label>
      <Input
        name="username"
        placeholder="hollis"
        autocomplete="username"
        @field={{f.field}}
      />
      <f.Description>Choose a unique username for your account.</f.Description>
    </Field>
  </div>
</template>
```

Press Username to focus the input, then type a name.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

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
  <Field name="username" as |f|>
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
  <FieldLegend>Address</FieldLegend>
  <FieldDescription>We need your address to deliver your order.</FieldDescription>
  <FieldGroup>
    <Field as |f|>…</Field>
    <Field as |f|>…</Field>
  </FieldGroup>
</FieldSet>
```

`ember-ui-sdk/field` exports each part by name, such as `FieldSet` and `FieldLegend`.

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

```glimmer-ts title="validation.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { useLog } from "./log"

export default class Validation extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Subscribed ${new FormData(event.currentTarget as HTMLFormElement).get("email")}`
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field @name="email" as |f|>
        <f.Label>Email</f.Label>
        <Input type="email" required placeholder="hollis@example.com" @field={{f.field}} />
        <f.Description>
          {{#if f.state.valid}}Looks good.{{else}}We'll send you a confirmation
            link.{{/if}}
        </f.Description>
        <f.Error @match="valueMissing">Enter your email address.</f.Error>
        <f.Error @match="typeMismatch">Enter an email address like
          hollis@example.com.</f.Error>
      </Field>
      <Field @name="website" as |f|>
        <f.Label>Website</f.Label>
        <Input type="url" required placeholder="https://example.com" @field={{f.field}} />
        <f.Error />
      </Field>
      <button type="submit" data-variant="solid">Subscribe</button>
    </form>
  </template>
}
```

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

```glimmer-ts title="field-set.gts"
import { Field, FieldGroup, FieldSet } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"

<template>
  <FieldSet as |s|>
    <s.Legend>Address</s.Legend>
    <s.Description>We need your address to deliver your order.</s.Description>
    <FieldGroup as |g|>
      <Field @name="street" as |f|>
        <f.Label>Street address</f.Label>
        <Input autocomplete="street-address" @field={{f.field}} />
      </Field>
      <div data-slot="grid">
        <Field @name="city" as |f|>
          <f.Label>City</f.Label>
          <Input autocomplete="address-level2" @field={{f.field}} />
        </Field>
        <Field @name="postal-code" as |f|>
          <f.Label>Postal code</f.Label>
          <Input autocomplete="postal-code" @field={{f.field}} />
        </Field>
      </div>
    </FieldGroup>
  </FieldSet>
</template>
```

Move through the address fields. Their legend and description name the group.

`FieldSet` is a native `<fieldset>` and `FieldLegend` a native `<legend>`, so the set is named, and disabled, before scripts run. Keep the legend the first child.

A `FieldDescription` right inside the set, outside any `Field`, describes the set, so screen readers read it as focus enters. `FieldGroup` is a `<div>` that stacks the fields, with no role and no state: the field set is what names and disables a group.

## Disabled Field Sets

Disabling the set disables its controls and nested field sets. The form leaves their values out of submissions.

```gts
<FieldSet @disabled={{this.sameAsShipping}} as |s|>
  <FieldLegend>Billing address</FieldLegend>
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
  <FieldLegend>Notifications</FieldLegend>
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

State is read lazily. A part re-renders for a change only if its render function or slot read that value. Each part's state is listed under [State](#state).

## Styling

Use `data-invalid` and `data-valid` for validation, and `data-focused`, `data-required` and `data-disabled` for the rest. Every part of a field gets the same attributes, so a label can turn red with its control.

Each part has a `data-slot`, such as `field-label`, and its state attributes are listed under [Data Attributes](#data-attributes).

## Data Attributes

### Field
`[data-slot="field"]`

- `data-disabled`: Present when the field is disabled.
- `data-invalid`: Present while the field shows as invalid: with `invalid`, or once a submit finds the control invalid.

### FieldLabel
`[data-slot="field-label"]`

- `data-disabled`: Present when the field is disabled.
- `data-invalid`: Present while the field shows as invalid: with `invalid`, or once a submit finds the control invalid.

### FieldControl
`[data-slot="field-control"]`

- `data-disabled`: Present when the field is disabled.
- `data-invalid`: Present while the field shows as invalid: with `invalid`, or once a submit finds the control invalid.

### FieldDescription
`[data-slot="field-description"]`

- `data-disabled`: Present when the field is disabled.
- `data-invalid`: Present while the field shows as invalid: with `invalid`, or once a submit finds the control invalid.

### FieldError
`[data-slot="field-error"]`

- `data-disabled`: Present when the field is disabled.
- `data-invalid`: Present while the field shows as invalid: with `invalid`, or once a submit finds the control invalid.

### FieldSet
`FieldGroup` has `data-slot="field-group"` and no state attributes.

`[data-slot="field-set"]`

- `data-disabled`: Present when the field set is disabled, by its own prop or a `<fieldset>` around it.

### FieldLegend
`[data-slot="field-legend"]`

- `data-disabled`: Present when the field set is disabled, by its own prop or a `<fieldset>` around it.

### FieldDescription in a FieldSet
`[data-slot="field-description"]`

- `data-disabled`: Present when the field set is disabled, by its own prop or a `<fieldset>` around it.

## API Reference

Options are the same as below, as arguments, such as `@name` and `@invalid`. Every part also takes `@render`.

A field has no change events. Read its state from the parts' data attributes, or from render functions. Set `@debug={{true}}` to log every state change and its reason.

### Field

- `name?` (`string`): The name the control submits under, when the control doesn't set its own.
- `disabled?` (`boolean`): Disables the control, and marks every part.
- `invalid?` (`boolean`): Whether the field shows as invalid, when your code decides, like a form library or an error from the server. `true` shows its errors now, `false` shows none whatever the browser thinks. Leave it out to show the browser's own validation once a submit finds the field invalid.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### FieldError

- `match?` (`boolean | ValidityKey`): When this error shows. `true` shows it always and `false` never. A validity flag, like `"valueMissing"`, shows it only for that problem of the browser's own validation. Without it, any problem shows it.

### FieldSet

- `disabled?` (`boolean`): Disables every control inside it, except those in its legend, and leaves them out of the form.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### State

What `@render={{true}}` yields as `state`.

- `disabled` (`boolean`): Whether the field is disabled, by itself or by a `<fieldset>`.
- `required` (`boolean`): Whether the control is required, read from its `required` or `aria-required`.
- `focused` (`boolean`): Whether focus is inside the control.
- `invalid` (`boolean`): Whether the field shows as invalid: `invalid` when you pass it, else the browser's validation once shown.
- `valid` (`boolean`): Whether the browser's validation passes, once shown. Always false while you pass `invalid`.

- `disabled` (`boolean`): Whether the field is disabled, by itself or by a `<fieldset>`.
- `required` (`boolean`): Whether the control is required, read from its `required` or `aria-required`.
- `focused` (`boolean`): Whether focus is inside the control.
- `invalid` (`boolean`): Whether the field shows as invalid: `invalid` when you pass it, else the browser's validation once shown.
- `valid` (`boolean`): Whether the browser's validation passes, once shown. Always false while you pass `invalid`.
- `message` (`string`): The browser's message for the current problem. Children you pass show instead.

A `FieldDescription` receives the field's state, or only `disabled` when it describes a field set.

- `disabled` (`boolean`): Whether the field set is disabled, by itself or by a field set around it. Whether the field is disabled, by itself or by a `<fieldset>`.
- `required` (`boolean | undefined`): Whether the control is required, read from its `required` or `aria-required`.
- `focused` (`boolean | undefined`): Whether focus is inside the control.
- `invalid` (`boolean | undefined`): Whether the field shows as invalid: `invalid` when you pass it, else the browser's validation once shown.
- `valid` (`boolean | undefined`): Whether the browser's validation passes, once shown. Always false while you pass `invalid`.

Every part of a field set receives the same state.

- `disabled` (`boolean`): Whether the field set is disabled, by itself or by a field set around it.

## Accessibility

The label names the control with `aria-labelledby`, beside a native `<label for>` where the control can take one. The description and any error that shows describe it with `aria-describedby`, and an invalid control has `aria-invalid`. The tests below cover these connections and keyboard behavior.

**Labelling**

- The label names the control.
- The description describes the control.
- Clicking the label of a text field focuses it.

**A label wrapping a field**

- Names the control inside it.
- Checks its control when clicked anywhere.
- Keeps the field's description on its control.
- Names a control that renders after it.
- Keeps the part's data-slot.
- Warns in development only when a label outside a field labels nothing.
- A description and an error outside a field keep their data-slot. Web components only.
- A hidden error outside a field stays hidden whatever display its class gives. Web components only.
- An error outside a field follows its match. Web components only.
- An error outside a field shows a child that arrives after it. Web components only.

**Errors**

- Stay hidden until the form tries to submit.
- Show the browser's message when they have no text of their own.
- Count another library's form-associated element inside the field.
- Describe the control while they show.
- Update as the value changes once shown.
- Update as state set from script changes the value once shown. Web components only.
- A field marked invalid shows its error right away.
- A field marked valid never shows the browser's errors.
- A form reset hides them again.
- Errors in the page replace the browser's message, and the first invalid control takes focus.

Runs in React, Vue and web components.

In a field set:

- The legend names the group.
- A disabled field set disables the controls inside and leaves them out of the form.
- Enabling it again restores the controls.
- A field set disabled from the start disables its required fields.
- Fields in a disabled field set mark their parts disabled.

**Enhancements**

- The description describes the group.

Runs in React, Vue and web components.

In a form:

- The form submits every checked control's name and value.
- Unchecked controls submit nothing.
- A checkbox outside the form joins it with the form attribute.
- Required controls block submission.
- A form reset returns every control to its default.
- A reset returns to the default value, not to nothing.
- A disabled fieldset disables the controls inside it.
- A read-only control still submits.
- A user's change fires native input and change events on the form.

Runs in React, Vue and web components.
