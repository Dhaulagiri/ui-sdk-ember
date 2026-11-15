# Textarea

Enter multiple lines of text, grow the field as you type, and connect it to a form.

A textarea is a native multi-line text field for messages, notes and descriptions. It works inside a field and a form, can grow with its text, and reports the same change reasons as Input.

```glimmer-ts title="basic.gts"
import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Field @name="message" as |f|>
    <f.Label>Message</f.Label>
    <Textarea placeholder="Type your message here…" @field={{f.field}} />
  </Field>
</template>
```

Click Message to focus the textarea, then type. Press Enter to start a new line.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

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

```glimmer-ts title="field.gts"
import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Field @name="feedback" as |f|>
    <f.Label>Feedback</f.Label>
    <Textarea placeholder="What could we do better?" @field={{f.field}} />
    <f.Description>Only the product team can see this.</f.Description>
  </Field>
</template>
```

Click Feedback to focus the textarea. A screen reader reads the description with the field.

## Auto Resize

Set `@autoResize={{true}}` to grow and shrink the textarea with its text. CSS `min-height` and `max-height` set its limits; past the maximum, the text scrolls inside it.

```glimmer-ts title="auto-resize.gts"
import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Field @name="notes" as |f|>
    <f.Label>Notes</f.Label>
    <Textarea @autoResize={{true}} placeholder="Add notes for the delivery driver…" @field={{f.field}} />
    <f.Description>Your driver sees these notes.</f.Description>
  </Field>
</template>
```

Type several lines in Notes. The textarea grows with each line until it reaches its maximum height, then scrolls. Delete the lines and it shrinks back.

Browsers that support `field-sizing: content` size it natively. Elsewhere, the component measures it when the value changes, the form resets or its width changes.

## Controlled

Pass `@value` and update it in `@onValueChange`. Here the character count is derived from that value, and the native `maxlength` caps the text.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

export default class Controlled extends Component {
  @tracked bio =
    "Product designer in Lisbon. I write about type and interfaces."

  onValueChange = (value: string) => {
    this.bio = value
  }

  <template>
    <Field @name="bio" as |f|>
      <f.Label>Bio</f.Label>
      <Textarea
        @value={{this.bio}}
        @onValueChange={{this.onValueChange}}
        maxlength="160"
        @field={{f.field}}
      />
      <f.Description>{{this.bio.length}} / 160 characters</f.Description>
    </Field>
  </template>
}
```

Edit Bio and watch the character count under it. The textarea stops accepting text at 160 characters.

Textarea shares Input's [change reasons](#reasons) and cancellation behavior.

## Form

A textarea submits its value through a native form under its field's `name`. Pass a controller from `createInputController()`, as `@controller`, to change it from outside, here to empty it after sending. The native `required` constraint blocks an empty message.

```glimmer-ts title="button.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { Textarea, createInputController } from "ember-ui-sdk/textarea"
import { useLog } from "./log"

export default class Button extends Component {
  log = useLog(this)
  message = createInputController()

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = new FormData(event.currentTarget as HTMLFormElement)
    this.log(`Sent “${data.get("message")}”`)
    this.message.clear()
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field @name="message" as |f|>
        <f.Label>Message</f.Label>
        <Textarea
          @controller={{this.message}}
          @field={{f.field}}
          required
          placeholder="Write a reply to Hollis Grant…"
        />
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Send Message</button>
      </div>
    </form>
  </template>
}
```

Type a message and press Send Message. The console logs it and the textarea clears. Pressing Send Message while it's empty is blocked.

## Disabled

Set `@disabled={{true}}` on the textarea or its field to prevent editing and leave it out of the tab order and the submitted values.

```glimmer-ts title="disabled.gts"
import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Field @disabled={{true}} as |f|>
    <f.Label>Reply</f.Label>
    <Textarea @defaultValue="Replies are closed for this thread." @field={{f.field}} />
  </Field>
</template>
```

Try to edit Reply or reach it with Tab. The disabled textarea keeps its value but can't be changed.

## Invalid

Set `@invalid={{true}}` on the field for an error your app decides. The field shows its error, associates it with the textarea and sets `aria-invalid`. [Field](./field.md#validation) covers native constraints and error matches.

```glimmer-ts title="invalid.gts"
import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

<template>
  <Field @invalid={{true}} as |f|>
    <f.Label>Review</f.Label>
    <Textarea @defaultValue="Great." @field={{f.field}} />
    <f.Error @match={{true}}>Write at least 20 characters.</f.Error>
  </Field>
</template>
```

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

The textarea has a `data-slot` of `textarea`, and its state attributes are listed under [Data Attributes](#data-attributes).

## Data Attributes

### Textarea
`[data-slot="textarea"]`

- `data-filled`: Present while the field holds any text.
- `data-disabled`: Present when the field is disabled, by its own prop or its Field.
- `data-readonly`: Present when the field is read-only.
- `data-required`: Present when the field is required.

## API Reference

Options and callbacks are the same as below, as arguments, such as `@value` and `@onValueChange`, plus every native textarea attribute.

### Textarea

- `value?` (`string`): The value, for a controlled field.
- `defaultValue?` (`string`): The value it starts with. A form reset returns here.
- `onValueChange?` (`((value: string, details: ChangeDetails<InputValueChangeReason>) => void)`): Called when the user changes the value: typing (`"input-change"`), a Clear part (`"clear-press"`), a form reset (`"reset"`) or a controller (`"imperative"`). `details.cancel()` keeps the value as it was.
- `controller?` (`object`): Reads and writes the field from anywhere. Create one with `createInputController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.
- `autoResize?` (`boolean`): Grows and shrinks with the text. Bound it with CSS `min-height` and `max-height`; past the maximum, it scrolls.
- `onSubmit?` (`((value: string, details: TextareaSubmitDetails) => void)`): Runs on the submit shortcut, unless an input method is composing. Without it, the shortcut submits the form the textarea is in. With neither, the key is left alone, so Enter adds a line.
- `submitShortcut?` (`"enter" | "mod+enter"`): Which keys submit: `"enter"`, with Shift+Enter for a new line, or `"mod+enter"`, with Enter for a new line. Without it, Enter always starts a new line.

- `disabled?` (`boolean`): Disables the field.
- `readOnly?` (`boolean`): Makes the field read-only.
- `required?` (`boolean`): Makes the field required.

### State

- `filled` (`boolean`): Whether the field holds any text.
- `disabled` (`boolean`): Whether the field is disabled.
- `readOnly` (`boolean`): Whether the field is read-only.
- `required` (`boolean`): Whether the field is required.

### Reasons

- `input-change` (`Event`): Typing, pasting or dropping changed a text field's value; in a combobox it can also open or close it, or Enter keeps the typed text as the value.
- `clear-press` (`MouseEvent | KeyboardEvent`): A Clear part was pressed, like on an input, a select or a combobox.
- `reset` (`none`): A form reset.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createInputController()` and pass it as `@controller`.

- `getValue()` (`() => string`): The current value.
- `setValue(value, options?)` (`(value: string, options?: ChangeOptions<InputValueChangeReason> | undefined) => boolean`): Sets the value as if the user typed it, so `input` fires. Returns false when the change was canceled or nothing changed.
- `clear(options?)` (`(options?: ChangeOptions<InputValueChangeReason> | undefined) => boolean`): Empties the field, as if the user deleted the text, so `input` fires. Returns false when the change was canceled or nothing changed.
- `focus()` (`() => void`): Moves focus to the field.

## Accessibility

There's no WAI-ARIA pattern for a multi-line text field. The textarea stays a native `<textarea>`, with standard text editing, selection, spell checking and form behavior. Give it a visible field label or an `aria-label`, and keep descriptions and errors in their field parts so they're associated with it.

### Tested Behavior

Every line below is an automated test.

- The label names the textarea and the description describes it.

**Auto resize**

- Grows with its text and shrinks back.
- Stops at its max height and scrolls.
- Shrinks back when a reset empties it.
- Follows text written from code.

**Submit shortcut**

- Without a submit shortcut, Enter starts a new line and doesn't submit.
- With enter, Enter submits the form and Shift+Enter starts a new line.
- With mod+enter, Enter starts a new line and Cmd or Ctrl+Enter submits.
- Enter while an input method composes doesn't submit.

Runs in React, Vue and web components.
