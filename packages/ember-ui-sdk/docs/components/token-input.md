# Token Input

Mix editable text with tokens for files, people, tags, and other references.

A token input is a text field that holds tokens alongside the text, like the people mentioned in a message or the files attached to a prompt. Each token moves, deletes and copies as one piece.

```glimmer-ts title="demo.gts"
import Component from "@glimmer/component"
import { X } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { TokenInput } from "ember-ui-sdk/token-input"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { icon } from "./icon"

const people = [
  { value: "hollis", label: "Hollis Grant" },
  { value: "ines", label: "Inès Moreau" },
  { value: "kofi", label: "Kofi Mensah" },
  { value: "wren", label: "Wren Takahashi" },
  { value: "tomasz", label: "Tomasz Wójcik" },
]

export default class Demo extends Component {
  people = people
  triggers = [{ char: "@", type: "mention", items: people }]

  <template>
    <Field as |f|>
      <f.Label>Message</f.Label>
      <TokenInput @field={{f.field}} as |t|>
        <t.Tokens as |token parts|>
          <parts.Token>
            {{token.label}}
            <parts.Remove>{{icon X}}</parts.Remove>
          </parts.Token>
        </t.Tokens>
        <t.Editor placeholder="Type @ to mention someone…" />
        <TriggerMenu @editor={{t.editor}} @triggers={{this.triggers}} as |m|>
          <m.Content>
            <m.List as |list|>
              {{#each list.state.items key="value" as |item|}}
                <m.Item @value={{item.value}} @label={{item.label}}>
                  {{item.label}}
                </m.Item>
              {{/each}}
            </m.List>
          </m.Content>
        </TriggerMenu>
      </TokenInput>
    </Field>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Type @ and choose a person with the arrow keys and Enter. Remove a token with Backspace, or press its remove button.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

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

```glimmer-ts title="prompt-input.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { ArrowUp, Check, Clock, Code, File, X } from "lucide"
import {
  createTokenInputController,
  toText,
  TokenInput,
  type TokenInputValue,
} from "ember-ui-sdk/token-input"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { icon } from "./icon"
import { useLog } from "./log"

const files = [
  { value: "src/app.tsx", label: "app.tsx", keywords: ["src"] },
  { value: "src/routes.ts", label: "routes.ts", keywords: ["src"] },
  { value: "src/styles.css", label: "styles.css", keywords: ["src"] },
  { value: "README.md", label: "README.md" },
  { value: "package.json", label: "package.json" },
]

const skills = [
  {
    value: "search",
    label: "search",
    arguments: [{ name: "query", hint: "<query>", required: true }],
  },
  { value: "review", label: "review" },
  { value: "summarize", label: "summarize" },
]

const loadFile = () => new Promise<void>((resolve) => setTimeout(resolve, 800))

const isSkill = (token: { type: string }) => token.type === "skill"
const isRunning = (token: { data?: { run?: string } }) =>
  token.data?.run === "running"
const isDone = (token: { data?: { run?: string } }) =>
  token.data?.run === "done"
const labelOf = (token: { type: string; label: string }) =>
  token.type === "skill" ? `/${token.label}` : token.label

export default class PromptInput extends Component {
  log = useLog(this)
  prompt = createTokenInputController()
  triggers = [
    { char: "@", type: "file", items: files },
    { char: "/", boundary: "start", type: "skill", items: skills },
  ]
  isSkill = isSkill
  isRunning = isRunning
  isDone = isDone
  labelOf = labelOf
  @tracked running = false
  sendTimer?: ReturnType<typeof setTimeout>

  willDestroy() {
    super.willDestroy()
    clearTimeout(this.sendTimer)
  }

  keepFocus = (event: MouseEvent) => {
    event.preventDefault()
  }

  attachReadme = () => {
    this.prompt.insert(
      { type: "file", value: "README.md", label: "README.md" },
      { resolve: loadFile() }
    )
  }

  onSelect = (_value: unknown, details: { trigger: string }) =>
    details.trigger === "@" ? loadFile() : undefined

  send = (value: TokenInputValue) => {
    if (this.running || !this.prompt.getLabel().trim()) {
      return
    }
    this.running = true
    const skillTokens = value.filter(
      (segment) => typeof segment !== "string" && segment.type === "skill"
    )
    for (const skill of skillTokens) {
      if (typeof skill !== "string") {
        this.prompt.updateToken(skill.id!, {
          data: { ...skill.data, run: "running" },
        })
      }
    }
    this.sendTimer = setTimeout(() => {
      for (const skill of skillTokens) {
        if (typeof skill !== "string") {
          this.prompt.updateToken(skill.id!, {
            data: { ...skill.data, run: "done" },
          })
        }
      }
      this.log(`Sent ${toText(this.prompt.getValue())}`)
      this.prompt.clear()
      this.running = false
    }, 1500)
  }

  sendPrompt = () => {
    this.send(this.prompt.getValue())
  }

  <template>
    <TokenInput @controller={{this.prompt}} @onSubmit={{this.send}} as |t|>
      <t.Tokens as |token parts|>
        <parts.Token>
          {{#if (this.isSkill token)}}
            {{icon Code}}
          {{else}}
            {{icon File}}
          {{/if}}
          {{this.labelOf token}}
          {{#if (this.isRunning token)}}
            {{icon Clock}}
          {{/if}}
          {{#if (this.isDone token)}}
            {{icon Check}}
          {{/if}}
          <parts.Remove>{{icon X}}</parts.Remove>
        </parts.Token>
      </t.Tokens>
      <div data-slot="card">
        <t.Editor aria-label="Prompt" placeholder="Ask anything. Type @ or /" />
        <div data-slot="row">
          <button
            type="button"
            data-size="sm"
            {{on "mousedown" this.keepFocus}}
            {{on "click" this.attachReadme}}
          >
            Attach README
          </button>
          <button
            type="button"
            data-variant="solid"
            data-size="sm"
            data-shape="round"
            aria-label={{if this.running "Running" "Send"}}
            disabled={{this.running}}
            {{on "click" this.sendPrompt}}
          >
            {{#if this.running}}
              {{icon Clock}}
            {{else}}
              {{icon ArrowUp}}
            {{/if}}
          </button>
        </div>
      </div>
      <TriggerMenu @editor={{t.editor}} @triggers={{this.triggers}} @onSelect={{this.onSelect}} as |m|>
        <m.Hint />
        <m.Content>
          <m.Empty>No matches</m.Empty>
          <m.List as |list|>
            {{#each list.state.items key="value" as |item|}}
              <m.Item @value={{item.value}} @label={{item.label}} @disabled={{item.disabled}}>
                {{item.label}}
              </m.Item>
            {{/each}}
          </m.List>
        </m.Content>
      </TriggerMenu>
    </TokenInput>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Type @ for files or / at the start for skills. For /search, enter a query and press Enter to insert the command. Press Enter again to send, and the console logs the message.

## Deleting Tokens

Choose what Backspace does at a token with `@tokenDeletion`:

- `"whole"` removes the token in one press.
- `"select"` selects it first, then removes it on the next press.
- `"revert"` turns it back into editable text, so the trigger menu opens on it again.

```glimmer-ts title="deletion.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown, File } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { TokenInput } from "ember-ui-sdk/token-input"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { icon } from "./icon"
import { useLog } from "./log"

const modes = [
  { value: "whole", label: "Whole" },
  { value: "select", label: "Select" },
  { value: "revert", label: "Revert" },
]

const files = [
  { value: "src/app.tsx", label: "app.tsx", keywords: ["src"] },
  { value: "src/routes.ts", label: "routes.ts", keywords: ["src"] },
  { value: "src/styles.css", label: "styles.css", keywords: ["src"] },
  { value: "README.md", label: "README.md" },
  { value: "package.json", label: "package.json" },
]

const draft = [
  "Explain ",
  {
    type: "file",
    value: "src/routes.ts",
    label: "routes.ts",
    data: { trigger: "@" },
  },
  " in two sentences.",
]

export default class Deletion extends Component {
  log = useLog(this)
  modes = modes
  files = files
  draft = draft
  triggers = [{ char: "@", type: "file", items: files }]
  @tracked deletion = "whole"

  onDeletionChange = (next: string | null) => {
    if (next) this.deletion = next
  }

  onValueChange = (
    _value: unknown,
    details: { removed: { label: string }[] }
  ) => {
    for (const token of details.removed) {
      this.log(`Removed ${token.label} (${this.deletion})`)
    }
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select
          @items={{this.modes}}
          @value={{this.deletion}}
          @onValueChange={{this.onDeletionChange}}
          as |s|
        >
          <s.Label>Backspace</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.modes key="value" as |mode|}}
              <s.Item @value={{mode.value}} as |item|>
                {{mode.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <Field as |f|>
        <f.Label>Prompt</f.Label>
        <TokenInput
          @tokenDeletion={{this.deletion}}
          @defaultValue={{this.draft}}
          @onValueChange={{this.onValueChange}}
          @field={{f.field}}
          as |t|
        >
          <t.Tokens as |token parts|>
            <parts.Token>
              {{icon File}}
              {{token.label}}
            </parts.Token>
          </t.Tokens>
          <t.Editor />
          <TriggerMenu @editor={{t.editor}} @triggers={{this.triggers}} as |m|>
            <m.Content>
              <m.List as |list|>
                {{#each list.state.items key="value" as |item|}}
                  <m.Item @value={{item.value}} @label={{item.label}}>
                    {{item.label}}
                  </m.Item>
                {{/each}}
              </m.List>
            </m.Content>
          </TriggerMenu>
        </TokenInput>
      </Field>
    </div>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose a Backspace behavior, click just after routes.ts, and press Backspace. Undo to try another behavior.

## Codec

A codec converts tokens to text for the clipboard, forms, and saved drafts. The default writes `[@label](type:value)`. Copy that text into another app and paste it back to restore the token.

Use `toText`, `fromText`, and `toLabel` to convert values yourself. Supply a custom codec for another format, as this example does for `<@hollis>`. With `@copy="label"`, copying writes what people read, and pasting back into a token input still restores the tokens. The default parser accepts letters, digits, `_`, and `-` in token types; other types need a custom codec.

```glimmer-ts title="codec.gts"
import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { fromText, toText, TokenInput } from "ember-ui-sdk/token-input"
import { useLog } from "./log"

const chat = {
  format: (token: { value: string }) => `<@${token.value}>`,
  parse: (text: string) =>
    text.split(/(<@[\w.-]+>)/).map((part) => {
      const id = /^<@([\w.-]+)>$/.exec(part)?.[1]
      return id ? { type: "mention", value: id, label: `@${id}` } : part
    }),
}

const draft = fromText("Ping <@hollis> and <@ines> about the launch", chat)

export default class Codec extends Component {
  log = useLog(this)
  chat = chat
  draft = draft

  onValueChange = (value: Parameters<typeof toText>[0]) => {
    this.log(toText(value, chat))
  }

  <template>
    <Field as |f|>
      <f.Label>Message</f.Label>
      <TokenInput
        @codec={{this.chat}}
        @copy="label"
        @defaultValue={{this.draft}}
        @onValueChange={{this.onValueChange}}
        @field={{f.field}}
        as |t|
      >
        <t.Editor />
      </TokenInput>
    </Field>
  </template>
}
```

Edit the message. The console logs it in the custom format, with each mention as <@id>.

## Form

Give the input a `@name` to submit its serialized text. `@required`, `@disabled`, and `@readOnly` control form behavior. `@form` associates it with a form elsewhere on the page, as shown here.

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { TokenInput } from "ember-ui-sdk/token-input"
import { icon } from "./icon"
import { useLog } from "./log"

const draft = [
  "Explain ",
  { type: "file", value: "src/routes.ts", label: "routes.ts" },
  " in two sentences.",
]

let count = 0

export default class Form extends Component {
  log = useLog(this)
  draft = draft
  formId = `token-input-form-${++count}`
  @tracked disabled = false
  @tracked readOnly = false

  onDisabledChange = (next: boolean | "indeterminate") => {
    this.disabled = next === true
  }

  onReadOnlyChange = (next: boolean | "indeterminate") => {
    this.readOnly = next === true
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Submitted ${new FormData(event.currentTarget as HTMLFormElement).get("prompt") ?? ""}`
    )
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <label data-slot="label">
          <Checkbox @checked={{this.disabled}} @onCheckedChange={{this.onDisabledChange}} as |c|>
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Disabled
        </label>
        <label data-slot="label">
          <Checkbox @checked={{this.readOnly}} @onCheckedChange={{this.onReadOnlyChange}} as |c|>
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Read-only
        </label>
      </div>
      <div data-slot="stack">
        <Field @disabled={{this.disabled}} as |f|>
          <f.Label>Prompt</f.Label>
          <TokenInput
            @form={{this.formId}}
            @name="prompt"
            @required={{true}}
            @defaultValue={{this.draft}}
            @readOnly={{this.readOnly}}
            @field={{f.field}}
            as |t|
          >
            <t.Editor />
          </TokenInput>
        </Field>
        <form id={{this.formId}} data-slot="row" {{on "submit" this.onSubmit}}>
          <button type="submit" data-variant="solid">Submit</button>
          <button type="reset">Reset</button>
        </form>
      </div>
    </div>
  </template>
}
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Press Submit to log the prompt's serialized value. Try Disabled and Read-only, then Reset.

## Controlled

Pass `@value` and update it in `@onValueChange`. The change details include the reason, input type, and removed tokens. The input still manages its editing history.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { toText, TokenInput } from "ember-ui-sdk/token-input"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { useLog } from "./log"

const files = [
  { value: "src/app.tsx", label: "app.tsx", keywords: ["src"] },
  { value: "src/routes.ts", label: "routes.ts", keywords: ["src"] },
  { value: "src/styles.css", label: "styles.css", keywords: ["src"] },
  { value: "README.md", label: "README.md" },
  { value: "package.json", label: "package.json" },
]

const draft = [
  "Explain ",
  { type: "file", value: "src/routes.ts", label: "routes.ts" },
  " in two sentences.",
]

const history = { limit: 50, groupDelay: 1000 }

const describe = (token: { type: string }) =>
  token.type === "file" ? "attached file" : token.type

export default class Controlled extends Component {
  log = useLog(this)
  files = files
  history = history
  describe = describe
  triggers = [{ char: "@", type: "file", items: files }]
  @tracked value = draft

  onValueChange = (
    next: typeof draft,
    details: { reason: string; removed: { label: string }[] }
  ) => {
    this.value = next
    const removed = details.removed.map((token) => token.label).join(", ")
    this.log(
      `${toText(next)} (${details.reason}${removed ? `, removed ${removed}` : ""})`
    )
  }

  <template>
    <Field as |f|>
      <f.Label>Prompt</f.Label>
      <TokenInput
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @history={{this.history}}
        @getTokenDescription={{this.describe}}
        @field={{f.field}}
        as |t|
      >
        <t.Editor />
        <TriggerMenu @editor={{t.editor}} @triggers={{this.triggers}} as |m|>
          <m.Content>
            <m.List as |list|>
              {{#each list.state.items key="value" as |item|}}
                <m.Item @value={{item.value}} @label={{item.label}}>
                  {{item.label}}
                </m.Item>
              {{/each}}
            </m.List>
          </m.Content>
        </TriggerMenu>
      </TokenInput>
    </Field>
  </template>
}
```

Type, add a file with @, or remove a token. The console logs the value and the reason for each change.

## Controller

Use `createTokenInputController()` to insert, update, or remove tokens from code. Pass a promise as `resolve` to mark an inserted token as pending until its data is ready. Updating a token doesn't add an undo step.

```glimmer-ts title="controller.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import {
  createTokenInputController,
  TokenInput,
  type Token,
} from "ember-ui-sdk/token-input"

const draft = [
  "Compare ",
  { type: "file", value: "src/routes.ts", label: "routes.ts" },
  " with ",
]

const loadFile = () => new Promise<void>((resolve) => setTimeout(resolve, 800))

export default class Controller extends Component {
  prompt = createTokenInputController()
  draft = draft

  firstToken = () =>
    this.prompt
      .getValue()
      .find((segment): segment is Token => typeof segment !== "string")

  keepFocus = (event: MouseEvent) => {
    event.preventDefault()
  }

  attachFile = () => {
    this.prompt.insert(
      { type: "file", value: "package.json", label: "package.json" },
      { at: "end", resolve: loadFile() }
    )
  }

  showPath = () => {
    const token = this.firstToken()
    if (token) {
      this.prompt.updateToken(token.id!, { label: token.value })
    }
  }

  removeFirst = () => {
    const token = this.firstToken()
    if (token) {
      this.prompt.removeToken(token.id!)
    }
  }

  undo = () => {
    this.prompt.undo()
  }

  clear = () => {
    this.prompt.clear()
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "mousedown" this.keepFocus}} {{on "click" this.attachFile}}>
          Attach File
        </button>
        <button
          type="button"
          {{on "mousedown" this.keepFocus}}
          {{on "click" this.showPath}}
        >Show Path</button>
        <button
          type="button"
          {{on "mousedown" this.keepFocus}}
          {{on "click" this.removeFirst}}
        >Remove First</button>
        <button
          type="button"
          {{on "mousedown" this.keepFocus}}
          {{on "click" this.undo}}
        >Undo</button>
        <button
          type="button"
          {{on "mousedown" this.keepFocus}}
          {{on "click" this.clear}}
        >Clear</button>
      </div>
      <Field as |f|>
        <f.Label>Prompt</f.Label>
        <TokenInput @controller={{this.prompt}} @defaultValue={{this.draft}} @field={{f.field}} as |t|>
          <t.Editor />
        </TokenInput>
      </Field>
    </div>
  </template>
}
```

Attach a file and watch it load. Show the first token's full path or remove it, then use Undo or Clear.

## Submit Shortcut

Set `@submitShortcut="mod+enter"` for a multiline message. Enter then inserts a line, and Command or Control+Enter submits.

```glimmer-ts title="submit-shortcut.gts"
import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { toLabel, TokenInput } from "ember-ui-sdk/token-input"
import { useLog } from "./log"

export default class SubmitShortcut extends Component {
  log = useLog(this)

  onSubmit = (value: Parameters<typeof toLabel>[0]) => {
    this.log(`Sent ${toLabel(value)}`)
  }

  <template>
    <Field as |f|>
      <f.Label>Message</f.Label>
      <TokenInput @submitShortcut="mod+enter" @onSubmit={{this.onSubmit}} @field={{f.field}} as |t|>
        <t.Editor placeholder="Write a message…" />
      </TokenInput>
    </Field>
  </template>
}
```

Write a message. Enter adds a line; Command+Enter on a Mac or Control+Enter elsewhere sends it to the console.

## Custom Rendering

Render each token's content inside `t.Tokens`, using `parts.Token` with a `parts.Remove` inside. The block receives the token, so you can choose an icon by its type or show its `data`. Without it, each token shows its label.

Pass `@render={{true}}` to any part to render it as your own element; Parts and Composition explains how props merge, and each part's state is listed under [State](#state).

## Styling

Style the editor, the tokens and their remove buttons. The editor shows `data-empty` while it holds nothing; show the placeholder with `content: attr(aria-placeholder)` on its `::before`. Tokens show `data-token-type`, `data-pending`, `data-unresolved` and `data-selected`. Without a token block, the element that holds each token, `token-input-host`, carries the same attributes, so you can style tokens without one.

Each part has a `data-slot`, such as `token-input-token`, and shows its state through the attributes listed under [Data Attributes](#data-attributes).

## Data Attributes

### TokenInputEditor
`[data-slot="token-input-editor"]`

- `data-empty`: Present while the input holds nothing. Show the placeholder with it.
- `data-disabled`: Present when the input is disabled, by its own prop, a field or a `<fieldset>`.
- `data-readonly`: Present when the input is read-only.

### TokenInputToken
`[data-slot="token-input-token"]`

- `data-token-type` (`file`): The token's type, like `file` or `mention`. Also on its host.
- `data-pending`: Present while the token loads. Also on its host.
- `data-disabled`: Present when the input is disabled, by its own prop, a field or a `<fieldset>`.
- `data-readonly`: Present when the input is read-only.
- `data-slot`
- `data-selected`: Present while the token is in the selection, or selected for removal. Also on its host.
- `data-unresolved`: Present while the token needs the user, like an ambiguous mention. Also on its host.

### TokenInputTokenRemove
`[data-slot="token-input-token-remove"]`

- `data-disabled`: Present when the input is disabled, by its own prop, a field or a `<fieldset>`.
- `data-readonly`: Present when the input is read-only.

## API Reference

Pass the root's options as `@` arguments. `@value` is controlled with `@onValueChange`.

### TokenInput

- `value?` (`TokenInputValue`): The value. Pass it to control the input.
- `defaultValue?` (`TokenInputValue`): The value at first, when uncontrolled. A form reset returns to it.
- `onValueChange?` (`((value: TokenInputValue, details: TokenInputValueChangeDetails) => void)`): Runs when typing, pasting, a menu, undo or a controller wants to change the value. `details.reason` says why, `details.removed` lists removed tokens, and `details.cancel()` stops it.
- `onSubmit?` (`((value: TokenInputValue, details: TokenInputSubmitDetails) => void)`): Runs on the submit shortcut, unless an input method is composing or a trigger menu is open. Without it, the shortcut submits the form the input is in. With neither, the key is left alone, so Enter starts a new line.
- `submitShortcut?` (`"enter" | "mod+enter"`): Which keys submit: `"enter"`, with Shift+Enter for a new line, or `"mod+enter"`, with Enter for a new line, which many Japanese and Chinese writers prefer.
- `tokenDeletion?` (`TokenDeletion`): How Backspace and Delete treat a token next to the caret. `"whole"` removes it in one press, `"select"` selects it first and removes it on the second, and `"revert"` turns it back into its text, so a trigger menu opens on it again.
- `copy?` (`"codec" | "label"`): What copying writes as plain text: `"codec"` keeps tokens through any app that pastes text, `"label"` writes what people read.
- `codec?` (`TokenCodec`): How tokens become text and back, for the clipboard and forms.
- `getTokenDescription?` (`((token: Token) => string)`): What a token says to screen readers besides its label, like its kind and status.
- `history?` (`UndoStackOptions`): Undo history: how many steps it keeps, and how long a typing pause starts a new step.
- `disabled?` (`boolean`): Disables the input: it can't be focused or changed, and isn't submitted.
- `readOnly?` (`boolean`): Keeps the input focusable and submitted, but stops changes.
- `required?` (`boolean`): Blocks form submission while the input is empty.
- `name?` (`string`): The name the codec text submits under. Without one, the input submits nothing.
- `form?` (`string`): The id of a form to belong to, when the input isn't inside it.
- `controller?` (`object`): Reads, edits and focuses the input from anywhere. Create one with `createTokenInputController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

`t.Tokens` receives each token and renders its content, usually a `parts.Token`.

### TokenInputEditor

- `placeholder?` (`string`): Text shown while the input is empty, through `aria-placeholder`. Show it with `data-empty:before:content-[attr(aria-placeholder)]`.

### TokenInputToken

A token's content, inside `t.Tokens`, with its state for styling. Renders a `span`.

### TokenInputTokenRemove

Removes its token when pressed and keeps focus in the editor. Renders a `span`, hidden from assistive technology, since keyboard users remove tokens with Backspace.

### Token

- `type` (`string`): Kind, like `"mention"`, `"file"` or `"skill"`.
- `value` (`string`): The id it stands for.
- `label` (`string`): The text it shows, reads as and falls back to.
- `id?` (`string`): Stable identity, generated when missing.
- `status?` (`"pending" | "unresolved"`): `"pending"` while it loads, `"unresolved"` when it needs the user, like an ambiguous mention.
- `data?` (`Record<string, unknown>`): What the chip renders from, like an icon or a run state. Never serialized.

### Codec

- `format` (`(token: Token) => string`): The text a token is written as.
- `parse` (`(text: string) => TokenInputValue`): Text back into a value, with tokens wherever their text appears.
- `escape?` (`((text: string, next: Token | undefined) => string)`): How plain text is written so `parse` reads it back as text. `next` is the token that follows it, if any. Defaults to the text as is.

### State

`TokenInputEditor`:

- `empty` (`boolean`): Whether the input holds nothing.
- `disabled` (`boolean`): Whether the input is disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether the input is read-only: it stays focusable, but typing, pastes and drops don't change it.

`TokenInputToken`:

- `token` (`Token`): The token this part shows: the one the token input renders its content for.
- `selected` (`boolean`): Whether the token is in the selection, or selected for removal.
- `pending` (`boolean`): Whether the token is loading.
- `unresolved` (`boolean`): Whether the token needs the user, like an ambiguous mention.
- `disabled` (`boolean`): Whether the input is disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether the input is read-only, so the token's remove button does nothing.

### Reasons

- `input-change` (`Event`): Typing, pasting or dropping changed a text field's value; in a combobox it can also open or close it, or Enter keeps the typed text as the value.
- `paste` (`ClipboardEvent`): Files were pasted, like a screenshot, or text and tokens into a token input.
- `drop` (`DragEvent`): Files were dropped on a drop zone, or text and tokens on a token input.
- `cut` (`ClipboardEvent`): A selection was cut from a token input.
- `undo` (`KeyboardEvent | InputEvent`): Undo, from the keyboard, the Edit menu or a controller.
- `redo` (`KeyboardEvent | InputEvent`): Redo, from the keyboard, the Edit menu or a controller.
- `remove-press` (`MouseEvent | KeyboardEvent`): A chip's remove part was pressed, or Backspace or Delete removed a chip or a span.
- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `reset` (`none`): A form reset.
- `restore` (`none`): The browser restored state, like after going back, or a saved value was read back from storage.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createTokenInputController()` and pass it as `@controller`.

- `getValue()` (`() => TokenInputValue`): The value: text and tokens.
- `setValue(value, options?)` (`(value: TokenInputValue, options?: TokenInputChangeOptions | undefined) => boolean`): Replaces the value as one undoable step. Returns false when the change was canceled or nothing changed.
- `getText(codec?)` (`(codec?: TokenCodec | undefined) => string`): The value as codec text, like `Ask [@Ada](mention:ada)`.
- `getLabel()` (`() => string`): The value as people read it, with each token's label.
- `insert(content, options?)` (`(content: string | Token | TokenInputValue, options?: (TokenInputChangeOptions & { at?: TextRange | "caret" | "end" | undefined; resolve?: PromiseLike<...> | undefined; }) | undefined) => boolean`): Inserts text, a token or a value at the caret, the end or a range, as one undoable step. With `resolve`, a token is pending until it settles: updated with what it resolves to, removed if it rejects. Returns false when the change was canceled.
- `updateToken(id, patch)` (`(id: string, patch: Partial<Omit<Token, "id">>) => boolean`): Changes a token's status, data or label without an undo step or a caret move. Returns false when there's no such token or nothing changed.
- `removeToken(id, options?)` (`(id: string, options?: TokenInputChangeOptions | undefined) => boolean`): Removes a token as one undoable step. Returns false when the change was canceled or nothing changed.
- `undo()` (`() => boolean`): Undoes the last step. Returns false when there was none or the change was canceled.
- `redo()` (`() => boolean`): Redoes the last undone step. Returns false when there was none or the change was canceled.
- `canUndo()` (`() => boolean`): Whether there's a step to undo.
- `canRedo()` (`() => boolean`): Whether there's a step to redo.
- `clear(options?)` (`(options?: TokenInputChangeOptions | undefined) => boolean`): Empties the input as one undoable step. Returns false when the change was canceled or nothing changed.
- `focus(options?)` (`(options?: { at?: "end" | "start" | undefined; } | undefined) => void`): Focuses the editor, with the caret at its start or end.
- `editor` (`TextEditorAdapter`): The editor a TriggerMenu outside the token input reads and writes. A menu inside it finds it on its own.

### Events

Callbacks get the new state first, then the details. A controlled `@value` only updates when `@onValueChange` didn't cancel the change.

| Argument         | On           | Receives                                                                         |
| ---------------- | ------------ | -------------------------------------------------------------------------------- |
| `@onValueChange` | `TokenInput` | `(value, details)`: the value, the [reason](#reasons), `inputType` and `removed` |
| `@onSubmit`      | `TokenInput` | `(value, details)`: the value, and the key press or menu choice that submitted   |

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

### Tested Behavior

Every line below is an automated test.

**Value**

- Renders text and tokens, each token as one chip.
- Tokens it starts with show their rendered content once, and read as their label and kind.
- Tokens and their remove parts mark a read-only or disabled input.
- Is empty with a placeholder until something is typed.
- Typing after a token goes after it.
- Shift+Enter starts a new line.

**Tokens**

- @ opens the menu inside the input, and choosing inserts a token and a space.
- A controlled input takes tokens from its menu and keeps typing in order.
- Enter in an open menu chooses and doesn't submit.
- One Backspace removes a whole token, and says so.
- Backspace removes tokens one by one, with no keystroke spent on anchors.
- Delete removes the token after the caret.
- The caret crosses a token with one arrow press each way.
- The caret can sit between two adjacent tokens.
- Clicking past a final token and typing lands after it.
- Word deletion stops at a token.
- The remove button removes its token and keeps focus.
- With tokenDeletion select, the first Backspace selects the token and the second removes it.
- With tokenDeletion revert, Backspace turns the token back into text and the menu opens on it.

**History**

- Undo and Redo step through edits, a token insertion on its own.
- Undo brings back a removed token.
- A pending token shows loading, then settles without an undo step.
- A pending token whose load fails is removed.

**Clipboard**

- Copying tokens into plain text and back keeps them.
- Copy writes codec text and HTML with the tokens.
- Pasting codec text makes tokens.
- With copy label, plain text gets what people read.

**Submit**

- Enter submits the codec text.
- With mod+enter, Enter is a new line and Cmd or Ctrl+Enter submits.
- A form submits the codec text under the input's name.
- Enter submits the form the input's form attribute names, not the one it's in.
- Enter while an input method composes doesn't submit.

Runs in React, Vue and web components.
