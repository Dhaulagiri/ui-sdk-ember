# Button

Run an action, show that it's working, and keep it reachable when disabled.

Button renders a native `button` and adds what it doesn't do on its own: it stays pending while an async action runs, so a form can't submit twice, announces slow actions to screen readers, can stay focusable while disabled, and keeps the same behavior when it renders a link. For a plain click handler, a native `button` is enough.

```glimmer-ts title="basic.gts"
import Component from "@glimmer/component"
import { Button } from "ember-ui-sdk/button"
import { useLog } from "./log"

export default class Basic extends Component {
  log = useLog(this)

  pressed = () => this.log("Pressed")

  <template>
    <Button @onClick={{this.pressed}}>Button</Button>
  </template>
}
```

Click Button, or focus it and press Enter or Space. The console logs each press.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Usage

Use `@onClick` to run an action. Button renders a native `<button>` with `type="button"` by default.

```gts
import { Button } from "ember-ui-sdk/button"

<template>
  <Button @onClick={{this.save}}>Save</Button>
</template>
```

## Pending

Return a Promise from `@onClick` to keep the button pending until it settles. The button keeps focus and ignores further presses while it waits.

```gts
<Button @onClick={{this.save}} @pendingAnnouncement="Saving">
  Save
</Button>
```

After one second, it announces "Loading" to screen readers. Set `@pendingAnnouncement` to change that message, as above, or use an empty string to silence it.

```glimmer-ts title="pending.gts"
import Component from "@glimmer/component"
import { Button } from "ember-ui-sdk/button"

const wait = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms))

export default class Pending extends Component {
  save = () => wait(1500)

  <template>
    <Button @onClick={{this.save}} @pendingAnnouncement="Saving">Save</Button>
  </template>
}
```

Press Save, then press it again while it saves. Nothing happens until the first action finishes.

## Pending Content

To change what the button shows while it waits, mark content with `data-show="idle"` or `data-show="pending"` and hide it in the other state with one CSS rule each:

```css
[data-slot="button"]:not([data-pending]) [data-show="pending"],
[data-slot="button"][data-pending] [data-show="idle"] {
  display: none;
}
```

```gts
<Button @onClick={{this.save}}>
  <span data-show="idle">{{icon ArrowDownToLine}}</span>
  <span data-show="pending">{{icon LoaderCircle}}</span>
  Save
</Button>
```

```glimmer-ts title="pending-content.gts"
import Component from "@glimmer/component"
import { Button } from "ember-ui-sdk/button"
import { ArrowDownToLine, LoaderCircle } from "lucide"
import { icon } from "./icon"

const wait = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms))

export default class PendingContent extends Component {
  save = () => wait(1500)

  <template>
    <Button @onClick={{this.save}} @pendingAnnouncement="Saving">
      <span data-show="idle">{{icon ArrowDownToLine}}</span>
      <span data-show="pending" data-slot="spinner">{{icon LoaderCircle}}</span>
      Save
    </Button>
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

Press Save. Its arrow turns into a spinner while it saves.

Keep the label and change only the visual, as above. If the text has to change too, swap it the same way, without an `aria-label`. [Pending Buttons](#pending-buttons) explains why:

```gts
<Button @onClick={{this.save}}>
  <span data-show="idle">Save</span>
  <span data-show="pending">Saving…</span>
</Button>
```

## Handling Errors

If the handler throws or its Promise rejects, `state.error` holds the error. Pass `@render={{true}}` to show it beside the button, or to change its label. The next press clears the error and runs the handler again.

```glimmer-ts title="render.gts"
import Component from "@glimmer/component"
import { Button } from "ember-ui-sdk/button"
import { useLog } from "./log"

const wait = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms))

export default class Render extends Component {
  log = useLog(this)

  save = async () => {
    await wait(1000)
    this.log("Couldn't save. Check your connection and try again.")
    throw new Error("Couldn't save")
  }

  <template>
    <div data-slot="stack">
      <Button @onClick={{this.save}} @render={{true}} as |b|>
        <button {{b.part}}>
          {{#if b.state.pending}}
            Saving…
          {{else if b.state.error}}
            Try Again
          {{else}}
            Save Changes
          {{/if}}
        </button>
      </Button>
    </div>
  </template>
}
```

Choose Save Changes. Saving always fails here: the console shows the error and the label changes to Try Again.

## Disabled

Set `@disabled={{true}}` to prevent presses and remove the button from the tab order. A disabled fieldset around the button disables it too.

```gts
<Button @disabled={{true}}>Disabled</Button>
```

```glimmer-ts title="disabled.gts"
import { Button } from "ember-ui-sdk/button"

<template>
  <Button @disabled={{true}}>Disabled</Button>
</template>
```

Try clicking the button. It does nothing, and Tab skips it.

## Focusable When Disabled

Add `@focusableWhenDisabled={{true}}` when people should still be able to focus a disabled button. It uses `aria-disabled` instead of the native `disabled` attribute. Presses still do nothing.

Use `aria-describedby` to explain why the action is unavailable:

```gts
<Button @disabled={{true}} @focusableWhenDisabled={{true}} aria-describedby="publish-hint">
  Publish
</Button>
<p id="publish-hint">Add a title to publish.</p>
```

```glimmer-ts title="focusable-when-disabled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Button } from "ember-ui-sdk/button"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { useLog } from "./log"

export default class FocusableWhenDisabled extends Component {
  log = useLog(this)
  @tracked title = ""

  get ready() {
    return this.title.trim() !== ""
  }

  get notReady() {
    return !this.ready
  }

  get readyText() {
    return this.ready ? "Ready to publish." : "Add a title to publish."
  }

  onTitle = (value: string) => {
    this.title = value
  }

  publish = () => this.log(`Published “${this.title}”`)

  <template>
    <div data-slot="stack">
      <Field as |f|>
        <f.Label>Title</f.Label>
        <Input @value={{this.title}} @onValueChange={{this.onTitle}} @field={{f.field}} />
      </Field>
      <div data-slot="row">
        <Button
          @disabled={{this.notReady}}
          @focusableWhenDisabled={{true}}
          aria-describedby="publish-hint"
          @onClick={{this.publish}}
        >
          Publish
        </Button>
        <p id="publish-hint" data-slot="hint">{{this.readyText}}</p>
      </div>
    </div>
  </template>
}
```

Focus Title, then press Tab to reach Publish while it is disabled. Enter a title to enable it, then choose Publish. The console logs what was published.

## Links

Pass `@render={{true}}` to render an `<a>`, and spread the part onto it with `{{b.part}}`. It keeps its `href` and link semantics, including opening in a new tab. A disabled link cannot navigate and leaves the tab order.

```gts
<Button @render={{true}} as |b|>
  <a {{b.part}} href="/docs/ember">Get started</a>
</Button>
```

```glimmer-ts title="link.gts"
import { Button } from "ember-ui-sdk/button"

<template>
  <div data-slot="row">
    <Button @render={{true}} as |b|>
      <a {{b.part}} href="#installation">Get Started</a>
    </Button>
    <Button @disabled={{true}} @render={{true}} as |b|>
      <a {{b.part}} href="#changelog">Changelog</a>
    </Button>
  </div>
</template>
```

Choose Get Started to jump to Installation on this page. Changelog is disabled and does not navigate.

## Forms

Set `@type="submit"` to submit a form or `@type="reset"` to restore its default values. The default, `"button"`, does neither.

```gts
<Button @type="submit">Subscribe</Button>
<Button @type="reset">Reset</Button>
```

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Button } from "ember-ui-sdk/button"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { useLog } from "./log"

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const entries = [
      ...new FormData(event.currentTarget as HTMLFormElement),
    ].map(([name, value]) => `${name}=${value}`)
    this.log(
      entries.length ? `Submitted ${entries.join("&")}` : "Submitted nothing"
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <f.Label>Email</f.Label>
        <Input name="email" type="email" @defaultValue="ada@example.com" @field={{f.field}} />
      </Field>
      <div data-slot="row">
        <Button type="submit">Subscribe</Button>
        <Button type="reset">Reset</Button>
      </div>
    </form>
  </template>
}
```

Edit the email and choose Subscribe, or press Enter in the field. The console logs each submission, and Reset restores the original email.

Button tracks the Promise returned by its own `@onClick`, not one from the form's submit handler. For an async submit handler, keep your own pending flag and set `@disabled` on the button while it runs, with [`@focusableWhenDisabled`](#focusable-when-disabled) so the button keeps focus while it waits.

## Styling

Use `data-pending` to show a spinner or waiting cursor, and `data-disabled` to style an unavailable action. The button's `data-slot` is `button`, and its attributes are listed under [Data Attributes](#data-attributes).

## Data Attributes

### Button
`[data-slot="button"]`

- `data-pending`: Present while the Promise its press handler returned is running.
- `data-disabled`: Present when disabled.

## API Reference

Button accepts native button attributes and the options below. With `@render={{true}}`, it yields `{ part, state }`, so a link or another element can read the button's state.

### Button

- `disabled?` (`boolean`): Stops presses. The button is natively disabled, so it leaves the tab order and its form doesn't submit through it, unless `focusableWhenDisabled` is set.
- `focusableWhenDisabled?` (`boolean`): Keeps a disabled button in the tab order with `aria-disabled` instead of the native attribute, so it can hold focus while it becomes disabled and host a tooltip that says why. Presses still do nothing.
- `type?` (`"button" | "reset" | "submit"`): What a native button does in a form: `"submit"` submits it and `"reset"` resets it. Ignored when the button renders as something else.
- `pendingAnnouncement?` (`string`): What screen readers hear once the button has been pending for a second, so a slow action doesn't pass in silence. Set it in the page's language. An empty string says nothing.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### State

- `disabled` (`boolean`): Whether it's disabled, by the `disabled` option or a disabled fieldset around it. A running press shows in `pending` instead.
- `pending` (`boolean`): Whether the Promise the last press returned is still running. Presses do nothing meanwhile.
- `error` (`unknown`): Why the last press failed: what its handler threw, or its Promise rejected with. Cleared by the next press.

### Events

| Argument   | Receives                                                                                                                   |
| ---------- | -------------------------------------------------------------------------------------------------------------------------- |
| `@onClick` | The native click event and `{ source }`, how the button was pressed. A returned Promise keeps it pending until it settles. |

## Accessibility

Give the button a clear text label. If it contains only an icon, add an `aria-label`. Native buttons respond to Enter and Space; links respond to Enter.

### Pending Buttons

While its action runs, the button tells assistive technology it's busy, so you don't need to add anything:

- It sets `aria-busy="true"` and `aria-disabled="true"`, and ignores presses until the action settles. It keeps focus the whole time.
- After a second, it announces `@pendingAnnouncement` ("Loading" by default) through a polite live region. Quick actions stay silent. This is a status message: people hear it without focus moving.

To show progress, keep the label and change only the visual, like a spinner. Changing the text renames the button while it has focus: screen readers don't reliably announce a new name on the focused element, so the change mostly helps sighted users, and the button's width shifts as the text changes length. The announcement already tells everyone it's working.

If the text has to change anyway, swap it with `data-show` and leave out `aria-label`, so the button's name always contains the text on screen. See [Pending Content](#pending-content) for the markup.

References:

- [WCAG 2.5.3 Label in Name](https://www.w3.org/WAI/WCAG22/Understanding/label-in-name.html)
- [WCAG 4.1.3 Status Messages](https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html)
- [WAI-ARIA `aria-busy`](https://www.w3.org/TR/wai-aria-1.2/#aria-busy) and [`aria-disabled`](https://www.w3.org/TR/wai-aria-1.2/#aria-disabled)

### Tested Behavior

The following behaviors are covered by automated tests:

- Clicking a button runs its handler.
- Space presses a focused button.
- Enter presses a focused button.
- A submit button submits its form.
- A reset button resets its form.
- A disabled button can't be focused or pressed.
- A button rendered as a link stays a link.

**Focusable when disabled**

- It stays focusable and says it's disabled.
- Tab reaches it.
- Clicking it runs nothing and submits nothing.
- Space on it runs nothing and submits nothing.
- Enter on it runs nothing and submits nothing.

**Pending**

- A returned Promise makes it busy, and it keeps focus until the Promise settles.
- While pending, it says it's unavailable with aria-disabled and keeps focus.
- Still pending after a second, it tells screen readers it's loading.
- A rejected Promise ends the pending state.

Runs in React, Vue and web components.
