---
title: Token Input
description: Mix editable text with tokens for files, people, tags, and other references.
---

A token input is a text field that holds tokens alongside the text, like the people mentioned in a message or the files attached to a prompt. Each token moves, deletes and copies as one piece.

[token-input/demo](../../examples/components/token-input/ember/demo.gts)

Type @ and choose a person with the arrow keys and Enter. Remove a token with Backspace, or press its remove button.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `TokenInput`:

```text
TokenInput as |t|
├── t.Tokens as |token parts|
│   ├── parts.Token
│   └── parts.Remove
├── t.Editor
└── TriggerMenu as |m|
```

`TokenInput` holds the value, and `t.Editor` is the text people edit. A [Trigger Menu](./trigger-menu.md) inside it suggests tokens when someone types `@`, `/`, or another trigger. `t.Tokens` renders each token, and its block gives you the token's markup.

## Usage

Import the root and use the parts it yields:

```gts
import { TokenInput } from "ember-ui-sdk/token-input"

const draft = [
  "Explain ",
  { type: "file", value: "src/routes.ts", label: "routes.ts" },
]

<template>
  <TokenInput @defaultValue={{draft}} as |t|>
    <t.Editor aria-label="Prompt" />
  </TokenInput>
</template>
```

A value is an array of text and tokens. Each token has a type, a value for your app, and a label for the reader. The editor manages its own content, including tokens, selection, and undo, so let it render that content and use `t.Tokens` for custom token markup.

## Token Input or Trigger Menu

Token Input holds the text and tokens. [Trigger Menu](./trigger-menu.md) suggests what to insert when someone types a trigger character.

Use Token Input on its own when your code supplies the tokens. Add a Trigger Menu for suggestions, as in the demo above. Trigger Menu also works with ordinary inputs and textareas.

## Prompt Input

Combine file suggestions, skills, and a send action. This example marks files as pending while they load, then uses `updateToken()` to show a skill running. Enter sends; Shift+Enter adds a line. An open suggestion menu or an active input method takes precedence over sending.

[token-input/prompt-input](../../examples/components/token-input/ember/prompt-input.gts)

Type @ for files or / at the start for skills. For /search, enter a query and press Enter to insert the command. Press Enter again to send, and the console logs the message.

## Deleting Tokens

Choose what Backspace does at a token with `@tokenDeletion`:

- `"whole"` removes the token in one press.
- `"select"` selects it first, then removes it on the next press.
- `"revert"` turns it back into editable text, so the trigger menu opens on it again.

[token-input/deletion](../../examples/components/token-input/ember/deletion.gts)

Choose a Backspace behavior, click just after routes.ts, and press Backspace. Undo to try another behavior.

## Codec

A codec converts tokens to text for the clipboard, forms, and saved drafts. The default writes `[@label](type:value)`. Copy that text into another app and paste it back to restore the token.

Use `toText`, `fromText`, and `toLabel` to convert values yourself. Supply a custom codec for another format, as this example does for `<@hollis>`. With `@copy="label"`, copying writes what people read, and pasting back into a token input still restores the tokens. The default parser accepts letters, digits, `_`, and `-` in token types; other types need a custom codec.

[token-input/codec](../../examples/components/token-input/ember/codec.gts)

Edit the message. The console logs it in the custom format, with each mention as <@id>.

## Form

Give the input a `@name` to submit its serialized text. `@required`, `@disabled`, and `@readOnly` control form behavior. `@form` associates it with a form elsewhere on the page, as shown here.

[token-input/form](../../examples/components/token-input/ember/form.gts)

Press Submit to log the prompt's serialized value. Try Disabled and Read-only, then Reset.

## Controlled

Pass `@value` and update it in `@onValueChange`. The change details include the reason, input type, and removed tokens. The input still manages its editing history.

[token-input/controlled](../../examples/components/token-input/ember/controlled.gts)

Type, add a file with @, or remove a token. The console logs the value and the reason for each change.

## Controller

Use `createTokenInputController()` to insert, update, or remove tokens from code. Pass a promise as `resolve` to mark an inserted token as pending until its data is ready. Updating a token doesn't add an undo step.

[token-input/controller](../../examples/components/token-input/ember/controller.gts)

Attach a file and watch it load. Show the first token's full path or remove it, then use Undo or Clear.

## Submit Shortcut

Set `@submitShortcut="mod+enter"` for a multiline message. Enter then inserts a line, and Command or Control+Enter submits.

[token-input/submit-shortcut](../../examples/components/token-input/ember/submit-shortcut.gts)

Write a message. Enter adds a line; Command+Enter on a Mac or Control+Enter elsewhere sends it to the console.

## Custom Rendering

Render each token's content inside `t.Tokens`, using `parts.Token` with a `parts.Remove` inside. The block receives the token, so you can choose an icon by its type or show its `data`. Without it, each token shows its label.

Pass `@render={{true}}` to any part to render it as your own element; each part's state is listed under [State](https://ui-sdk.dev/docs/react/components/token-input#state).

## Styling

Style the editor, the tokens and their remove buttons. The editor shows `data-empty` while it holds nothing; show the placeholder with `content: attr(aria-placeholder)` on its `::before`. Tokens show `data-token-type`, `data-pending`, `data-unresolved` and `data-selected`. Without a token block, the element that holds each token, `token-input-host`, carries the same attributes, so you can style tokens without one.

Each part has a `data-slot`, such as `token-input-token`, and shows its state through the attributes listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/token-input#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [token-input reference](https://ui-sdk.dev/docs/react/components/token-input) in the upstream docs.

Pass the root's options as `@` arguments. `@value` is controlled with `@onValueChange`.

### TokenInput

`t.Tokens` receives each token and renders its content, usually a `parts.Token`.

### TokenInputToken

A token's content, inside `t.Tokens`, with its state for styling. Renders a `span`.

### TokenInputTokenRemove

Removes its token when pressed and keeps focus in the editor. Renders a `span`, hidden from assistive technology, since keyboard users remove tokens with Backspace.

### Controller

Create one with `createTokenInputController()` and pass it as `@controller`.

### Events

Callbacks get the new state first, then the details. A controlled `@value` only updates when `@onValueChange` didn't cancel the change.

| Argument         | On           | Receives                                                                                                                             |
| ---------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------ |
| `@onValueChange` | `TokenInput` | `(value, details)`: the value, the [reason](https://ui-sdk.dev/docs/react/components/token-input#reasons), `inputType` and `removed` |
| `@onSubmit`      | `TokenInput` | `(value, details)`: the value, and the key press or menu choice that submitted                                                       |

## Accessibility

The editor is a multiline text box: it has the `textbox` role with `aria-multiline`, and a Trigger Menu inside it adds `aria-autocomplete` and `aria-haspopup` for its suggestions. Give it a visible label through a [Field](./field.md), or an `aria-label`. Each token reads as its label and its kind, like "routes.ts file", and inserting or removing one is announced. Typing keeps the browser's spelling, autocorrect, and input method support.

### Keyboard

| Key                          | Does                                                                          |
| ---------------------------- | ----------------------------------------------------------------------------- |
| Backspace, Delete            | Removes the token before or after the caret, as `@tokenDeletion` says         |
| ArrowLeft, ArrowRight        | Moves the caret past a token in one press; the caret never stops inside one   |
| Enter                        | Submits. While a trigger menu is open, chooses the highlighted suggestion     |
| Shift+Enter                  | Starts a new line                                                             |
| Command+Enter, Control+Enter | Submits when `@submitShortcut` is `"mod+enter"`; Enter then starts a new line |
| Command+Z, Control+Z         | Undoes the last step. Typing is grouped; pastes and token changes are steps   |
| Shift+Command+Z, Control+Y   | Redoes the last undone step                                                   |
