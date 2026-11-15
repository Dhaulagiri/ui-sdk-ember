# Alert Dialog

Ask someone to confirm an action before you continue.

Use an alert dialog when someone needs to answer a question before an action continues, such as deleting a project.

```glimmer-ts title="basic.gts"
import { AlertDialog } from "ember-ui-sdk/alert-dialog"

<template>
  <AlertDialog as |d|>
    <d.Trigger>Delete Project</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="stack">
        <d.Title>Delete this project?</d.Title>
        <d.Description>
          This permanently deletes the project, its files and its deployment
          history for everyone on your team.
        </d.Description>
      </div>
      <div data-slot="row">
        <d.Close>Cancel</d.Close>
        <d.Close data-variant="solid" @value="confirm">Delete</d.Close>
      </div>
    </d.Content>
  </AlertDialog>
</template>
```

Open the dialog with Enter to start on Cancel. Tab stays inside, clicking outside leaves it open, and Escape closes it and returns focus to the trigger.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build an `AlertDialog`:

```text
AlertDialog as |d|
├── d.Trigger
├── d.Backdrop
└── d.Content
    ├── d.Title
    ├── d.Description
    ├── d.Close
    └── d.Close
```

Put the question in `d.Title`, explain what happens in `d.Description`, and use `d.Close` for each answer. Add `d.Backdrop` to dim the page.

A Close part reports its `@value` when it closes. `@value="confirm"` is the agreeing answer that the [confirm helper](#confirm) recognizes.

## Usage

Import the root and use the parts it yields:

```gts
import { AlertDialog } from "ember-ui-sdk/alert-dialog"

<template>
  <AlertDialog as |d|>
    <d.Trigger>Delete Project</d.Trigger>
    <d.Content>
      <d.Title>Delete this project?</d.Title>
      <d.Description>The project and its files will be deleted for everyone.</d.Description>
      <d.Close>Cancel</d.Close>
      <d.Close @value="confirm">Delete</d.Close>
    </d.Content>
  </AlertDialog>
</template>
```

## Controlled

Pass `@open` and update it in `@onOpenChange` when your app needs to read or control whether the dialog is open. Canceling a change works the same way as in [Dialog](./dialog.md#controlled).

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { AlertDialog } from "ember-ui-sdk/alert-dialog"

export default class Controlled extends Component {
  @tracked open = false

  onOpenChange = (next: boolean) => {
    this.open = next
  }

  <template>
    <div data-slot="stack">
      <AlertDialog @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |d|>
        <d.Trigger>Review Changes</d.Trigger>
        <d.Backdrop />
        <d.Content>
          <div data-slot="stack">
            <d.Title>Discard unsaved changes?</d.Title>
            <d.Description>Your edits will be lost if you leave without saving.</d.Description>
          </div>
          <div data-slot="row">
            <d.Close>Keep Editing</d.Close>
            <d.Close data-variant="solid" @value="confirm">Discard</d.Close>
          </div>
        </d.Content>
      </AlertDialog>
    </div>
  </template>
}
```

Choose Review Changes, then Keep Editing or Discard.

## Shortcut

Give the trigger a `@shortcut` to open the dialog from the keyboard, and put `d.Shortcut` inside it to show the keys. [Dialog](./dialog.md#keyboard-shortcut) covers the shortcut syntax.

```glimmer-ts title="shortcut.gts"
import { AlertDialog } from "ember-ui-sdk/alert-dialog"

<template>
  <AlertDialog as |d|>
    <d.Trigger @shortcut="mod+shift+h">
      Clear History
      <d.Shortcut />
    </d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="stack">
        <d.Title>Clear your history?</d.Title>
        <d.Description>
          Recent searches and visited pages are removed from this device.
        </d.Description>
      </div>
      <div data-slot="row">
        <d.Close>Cancel</d.Close>
        <d.Close data-variant="solid" @value="confirm">Clear</d.Close>
      </div>
    </d.Content>
  </AlertDialog>
</template>
```

Press Cmd+Shift+H (Ctrl+Shift+H on Windows and Linux) to open the dialog without clicking.

## Animation

The content has `data-starting-style` while it opens and `data-ending-style` while it closes. Transition from those states, and the dialog stays mounted until the exit finishes:

```css
[data-slot="alert-dialog-content"] {
  transition:
    opacity 0.2s,
    translate 0.25s cubic-bezier(0.22, 1, 0.36, 1),
    scale 0.25s cubic-bezier(0.22, 1, 0.36, 1);

  &:is([data-starting-style], [data-ending-style]) {
    opacity: 0;
    translate: 0 16px;
    scale: 0.96;
  }

  &[data-ending-style] {
    transition-duration: 0.15s;
  }
}
```

```glimmer-ts title="animation.gts"
import { AlertDialog } from "ember-ui-sdk/alert-dialog"

<template>
  <AlertDialog as |d|>
    <d.Trigger>Leave Workspace</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="stack">
        <d.Title>Leave this workspace?</d.Title>
        <d.Description>
          You'll lose access to its projects until someone invites you again.
        </d.Description>
      </div>
      <div data-slot="row">
        <d.Close>Cancel</d.Close>
        <d.Close data-variant="solid" @value="confirm">Leave</d.Close>
      </div>
    </d.Content>
  </AlertDialog>
</template>
```

Open and close the dialog. It slides up and fades in, and slides down and fades out before it unmounts.

## Nested

An alert dialog opened inside another joins its stack, such as a second confirmation before something can't be undone. Escape closes the topmost one and returns focus to its trigger. The dialog underneath gets `data-nested-open`, so you can show which layer is active. To close both once the last question is answered, control the outer dialog with `@open` and close it when the inner one's `@onOpenChange` reports `returnValue` `"confirm"`.

```glimmer-ts title="nested.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { AlertDialog } from "ember-ui-sdk/alert-dialog"

export default class Nested extends Component {
  @tracked open = false

  onOpenChange = (next: boolean) => {
    this.open = next
  }

  onNestedOpenChange = (next: boolean, details: { returnValue?: string }) => {
    if (!next && details.returnValue === "confirm") {
      this.open = false
    }
  }

  <template>
    <AlertDialog @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |d|>
      <d.Trigger>Delete Workspace</d.Trigger>
      <d.Backdrop />
      <d.Content>
        <div data-slot="stack">
          <d.Title>Delete this workspace?</d.Title>
          <d.Description>
            All 12 projects and their deployments will be deleted for everyone
            on your team.
          </d.Description>
        </div>
        <div data-slot="row">
          <d.Close>Cancel</d.Close>
          <AlertDialog @onOpenChange={{this.onNestedOpenChange}} as |inner|>
            <inner.Trigger data-variant="solid">Delete</inner.Trigger>
            <inner.Backdrop />
            <inner.Content>
              <div data-slot="stack">
                <inner.Title>Are you absolutely sure?</inner.Title>
                <inner.Description>There's no way to get the workspace back.</inner.Description>
              </div>
              <div data-slot="row">
                <inner.Close>Go Back</inner.Close>
                <inner.Close data-variant="solid" @value="confirm">Delete
                  Workspace</inner.Close>
              </div>
            </inner.Content>
          </AlertDialog>
        </div>
      </d.Content>
    </AlertDialog>
  </template>
}
```

Choose Delete Workspace, then Delete. Press Escape to step back to the first question, or choose Delete Workspace to close both.

## Async Action

An `@action` on a Close part runs before it closes the dialog. Return a Promise to keep the dialog open until the work finishes. A resolved Promise closes it with the reason `action`; a rejection keeps it open and puts the error in that part's state.

```glimmer-ts title="async-action.gts"
import Component from "@glimmer/component"
import { AlertDialog } from "ember-ui-sdk/alert-dialog"

export default class AsyncAction extends Component {
  attempts = 0

  deleteProject = async () => {
    await new Promise((resolve) => setTimeout(resolve, 1200))
    if (this.attempts++ === 0) {
      throw new Error("Couldn't delete the project.")
    }
  }

  <template>
    <div data-slot="stack">
      <AlertDialog @pendingAnnouncement="Deleting project" as |d|>
        <d.Trigger>Delete Project</d.Trigger>
        <d.Backdrop />
        <d.Content>
          <div data-slot="stack">
            <d.Title>Delete project?</d.Title>
            <d.Description>
              This permanently deletes the project, its files and its deployment
              history for everyone on your team.
            </d.Description>
          </div>
          <d.Close
            data-variant="solid"
            @value="confirm"
            @action={{this.deleteProject}}
            @render={{true}}
            as |c|
          >
            <div data-slot="stack">
              <p data-slot="hint" role="alert">
                {{#if c.state.error}}{{c.state.error.message}}{{/if}}
              </p>
              <div data-slot="row">
                <d.Close>Cancel</d.Close>
                <button {{c.part}} type="button">
                  {{#if c.state.pending}}
                    Deleting…
                  {{else if c.state.error}}
                    Try Again
                  {{else}}
                    Delete
                  {{/if}}
                </button>
              </div>
            </div>
          </d.Close>
        </d.Content>
      </AlertDialog>
    </div>
  </template>
}
```

Choose Delete Project, then Delete. The first attempt fails so you can try again. While Deleting… is shown, Cancel and Escape leave the dialog open. A successful retry closes it.

While the action runs, its button stays focusable and gets `data-pending`, `aria-busy`, and `aria-disabled`. Other Close parts and dismissals cannot close the dialog until it settles. `@onDismissAttempt` reports refused dismissals; a controller can still close it.

The root's `@pendingAnnouncement` sets what screen readers hear after a second of waiting. The error clears on the next attempt or when the dialog opens again. The action also receives `{ source }` after its event argument; [Button](./button.md#changes-after-an-await) explains when to use it.

## Confirm From Anywhere

The shared `confirm()` asks a question without any dialog markup. Render `OverlayHost` from `ember-ui-sdk/overlays` once near the root of your app, and it shows each question as an alert dialog. `confirm()` resolves `true` when someone agrees. [Confirm Options](#confirm-options) lists what you can pass.

```glimmer-ts title="confirm-anywhere.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { confirm } from "ember-ui-sdk/alert-dialog"
import { OverlayHost } from "ember-ui-sdk/overlays"
import { useLog } from "./log"

export default class ConfirmAnywhere extends Component {
  log = useLog(this)

  archive = async () => {
    const yes = await confirm({
      title: "Archive this project?",
      description: "It moves to Archived, and you can restore it anytime.",
      confirmLabel: "Archive",
    })
    this.log(yes ? "Archived the project" : "Kept the project")
  }

  <template>
    <button type="button" {{on "click" this.archive}}>Archive Project</button>
    <OverlayHost />
  </template>
}
```

Choose Archive Project, then Archive or Cancel. The console shows the answer.

## Confirm

Use `createConfirm<Payload>()` to ask a question from an event handler and await the answer. Create it once, then pass its `controller` to your alert dialog. The content reads the question's data from its state.

`await this.confirm({ name })` resolves `true` when the Close part with `@value="confirm"` closes the dialog. Cancel, Escape, and other answers resolve `false`. This lets several rows share one dialog:

```glimmer-ts title="confirm.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { fn } from "@ember/helper"
import { AlertDialog, createConfirm } from "ember-ui-sdk/alert-dialog"

const initial = ["Acme", "Globex", "Initech"]

export default class Confirm extends Component {
  confirm = createConfirm<{ name: string }>()
  @tracked projects = initial

  remove = async (name: string, event: Event) => {
    const button = event.currentTarget as HTMLButtonElement
    if (!(await this.confirm({ name }))) {
      return
    }
    const row = button.closest("li")
    const next = (
      row?.nextElementSibling ?? row?.previousElementSibling
    )?.querySelector("button")
    const target =
      next ?? document.querySelector<HTMLButtonElement>("#reset-projects")
    target?.focus()
    this.projects = this.projects.filter((project) => project !== name)
  }

  reset = () => {
    this.projects = initial
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" id="reset-projects" {{on "click" this.reset}}>
          Reset Projects
        </button>
      </div>
      <ul data-slot="list" aria-label="Projects">
        {{#each this.projects key="@identity" as |name|}}
          <li data-slot="row">
            {{name}}
            <button
              type="button"
              data-size="sm"
              aria-label="Delete {{name}}"
              {{on "click" (fn this.remove name)}}
            >
              Delete
            </button>
          </li>
        {{else}}
          <li data-slot="row">All projects deleted.</li>
        {{/each}}
      </ul>
      <AlertDialog @controller={{this.confirm.controller}} as |d|>
        <d.Backdrop />
        <d.Content as |content|>
          <div data-slot="stack">
            <d.Title>Delete {{content.state.payload.name}}?</d.Title>
            <d.Description>
              The project and its files will be deleted for everyone on your
              team.
            </d.Description>
          </div>
          <div data-slot="row">
            <d.Close>Cancel</d.Close>
            <d.Close data-variant="solid" @value="confirm">Delete</d.Close>
          </div>
        </d.Content>
      </AlertDialog>
    </div>
  </template>
}
```

Delete a project. Cancel or Escape keeps it; Delete removes it and focuses a neighboring row's button. Reset Projects brings the list back.

When the action removes the button that opened the dialog, choose a useful place for focus to go. This example focuses a neighboring row, or Reset Projects when the list is empty.

## Queued Questions

Calls to the same confirm function wait their turn. You can ask two questions at once; the second appears only after the first has an answer.

```glimmer-ts title="queue.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { AlertDialog, createConfirm } from "ember-ui-sdk/alert-dialog"
import { useLog } from "./log"

export default class Queue extends Component {
  log = useLog(this)
  confirm = createConfirm<{ name: string }>()

  review = async () => {
    const acme = this.confirm({ name: "Acme" })
    const globex = this.confirm({ name: "Globex" })
    const [first, second] = await Promise.all([acme, globex])
    this.log(`Acme: ${first ? "confirmed" : "canceled"}`)
    this.log(`Globex: ${second ? "confirmed" : "canceled"}`)
  }

  <template>
    <div data-slot="stack">
      <button type="button" {{on "click" this.review}}>Review Two Projects</button>
      <AlertDialog @controller={{this.confirm.controller}} as |d|>
        <d.Backdrop />
        <d.Content as |content|>
          <div data-slot="stack">
            <d.Title>Archive {{content.state.payload.name}}?</d.Title>
            <d.Description>
              Archived projects leave the active list. You can restore them
              later.
            </d.Description>
          </div>
          <div data-slot="row">
            <d.Close>Cancel</d.Close>
            <d.Close data-variant="solid" @value="confirm">Archive</d.Close>
          </div>
        </d.Content>
      </AlertDialog>
    </div>
  </template>
}
```

Choose Review Two Projects. Answer the Acme question, then the Globex question. The console shows both answers once the second one is in.

## Styling

Each part has a `data-slot`, such as `alert-dialog-content`, and shows its state through the attributes listed under [Data Attributes](#data-attributes).

### AlertDialogContent
- `--dialog-stack`: How many dialogs are open above this one, nested inside it. 0 for the topmost.
- `--keyboard-inset`: How many pixels of the page the on-screen keyboard covers, 0 without one.
- `--visual-viewport-width`: The width of the part of the page you can see.
- `--visual-viewport-height`: The height of the part of the page you can see, above the keyboard.
- `--visual-viewport-top`: How far the part of the page you can see is scrolled from the top of the layout, as when the keyboard pushes it up.

## Data Attributes

### AlertDialogTrigger
`[data-slot="alert-dialog-trigger"]`

- `data-closed`: Present while the dialog is closed, including while it animates out.
- `data-disabled`: Present when the trigger is disabled.
- `data-open`: Present while the dialog is open. On a trigger, while it's open from that trigger.

### AlertDialogBackdrop
`[data-slot="alert-dialog-backdrop"]`

- `data-closed`: Present while the dialog is closed, including while it animates out.
- `data-open`: Present while the dialog is open. On a trigger, while it's open from that trigger.
- `data-starting-style`: Present for the first frame. Style the state you animate from.
- `data-ending-style`: Present while the dialog animates out. Style the state you animate to.

### AlertDialogContent
`[data-slot="alert-dialog-content"]`

- `data-closed`: Present while the dialog is closed, including while it animates out.
- `data-open`: Present while the dialog is open. On a trigger, while it's open from that trigger.
- `data-starting-style`: Present for the first frame. Style the state you animate from.
- `data-ending-style`: Present while the dialog animates out. Style the state you animate to.
- `data-keyboard`: Present while the on-screen keyboard covers part of the page.

### AlertDialogClose
`[data-slot="alert-dialog-close"]`

- `data-pending`: Present on a Close part while its action runs.

## API Reference

Alert Dialog shares [Dialog's](./dialog.md) arguments, except `@modal`, `@closeOnOutsidePress`, and `@presentation`. It is always modal, never closes on an outside press, and does not present as a sheet.

### AlertDialog

- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `open?` (`boolean`): Whether the dialog is open. Pass it to control the dialog.
- `defaultOpen?` (`boolean`): Whether the dialog starts open, when uncontrolled. Focus moves into it once it's on the page.
- `onOpenChangeComplete?` (`((open: boolean) => void)`): Runs once the dialog has finished opening or closing, after any animation.
- `dismissible?` (`boolean`): Whether Escape, an outside press and Android's back gesture can close the dialog. Close parts, triggers and the controller always can. Pass `false` while a form has unsaved changes, and ask in `@onDismissAttempt`.
- `onDismissAttempt?` (`((details: DialogDismissAttemptDetails) => void)`): Runs when a dismissal was refused, because `dismissible` is false, an outside press doesn't close it, or a Close part's action is running. Ask "Discard changes?" here.
- `persistentElements?` (`(string | Element)[] | (() => Element[])`): Elements that stay usable while the dialog makes the page inert, like a chat launcher or a password manager's button. Elements, CSS selectors, or a function that returns elements, read when the dialog opens. Presses on them never close it.
- `pendingAnnouncement?` (`string`): What screen readers hear once a Close part's action has been running for a second, so a slow action doesn't pass in silence. Set it in the page's language. An empty string says nothing.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.
- `onOpenChange?` (`((open: boolean, details: DialogOpenChangeDetails<AlertDialogOpenChangeReason>) => void)`): Runs when the alert dialog wants to open or close. `details.reason` says why, `details.cancel()` stops it, and `details.returnValue` is the `value` of the Close part that closed it.
- `onPayloadChange?` (`((payload: unknown, details: ChangeDetails<AlertDialogPayloadChangeReason>) => void)`): Runs when a trigger or a controller with another payload opens the alert dialog, before `@onOpenChange`, or a controller's `open({ payload })` gives the open one another payload. `details.cancel()` keeps the previous payload.
- `controller?` (`PopupController<any, AlertDialogOpenChangeReason, {}, any, DialogPayloadChangeReason>`): Opens, closes and inspects the alert dialog from anywhere. Create one with `createAlertDialogController()` or `createConfirm()`.

### AlertDialogTrigger

- `disabled?` (`boolean`): Stops the trigger from opening the dialog. A native button can't be focused or pressed, unless `focusableWhenDisabled` is set.
- `focusableWhenDisabled?` (`boolean`): Keeps a disabled trigger in the tab order with `aria-disabled` instead of the native attribute, so it can host a tooltip that says why. Presses still do nothing.
- `payload?` (`unknown`): Data for the content to render when this trigger opens the dialog, like the row it belongs to.
- `shortcut?` (`string`): A keyboard shortcut that presses the trigger, like `"mod+k"`. `mod` is Command on Apple platforms and Control elsewhere. Sets `aria-keyshortcuts`, and a Shortcut part inside shows it. A modal dialog pauses the page's shortcuts while it's open.
- `controller?` (`PopupController<any, AlertDialogOpenChangeReason, {}, any, DialogPayloadChangeReason>`): Connects a trigger outside the alert dialog to the alert dialog with this controller.

### AlertDialogBackdrop

Dims the page behind the dialog. Renders a `div`.

### AlertDialogContent

- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `initialFocus?` (`DialogInitialFocus`): Where focus goes when the dialog opens. Opening with touch focuses the dialog itself, so no on-screen keyboard appears.
- `finalFocus?` (`PopupFocusTarget`): Where focus goes when the dialog closes while focus is inside it.
- `keepMounted?` (`boolean`): Whether the dialog stays in the page, hidden, while closed. For animation libraries that drive the exit from state.

### AlertDialogTitle

The question. Renders an `h2`, and the content uses it as its accessible name.

### AlertDialogDescription

What happens if you agree. Renders a `p`, and the content uses it as its accessible description.

### AlertDialogClose

- `value?` (`string`): Reported as `returnValue` in `@onOpenChange` and by the controller's `open()`. `createConfirm()` resolves `true` for `"confirm"`.
- `action?` (`((event: Event | undefined, details: ActionDetails) => unknown)`): Runs when the part is pressed, before the dialog closes. A returned Promise keeps the dialog open while it runs: the part gets `data-pending`, `aria-busy` and `aria-disabled`, screen readers hear the dialog's `pendingAnnouncement` after a second, and nothing but the controller closes the dialog. It closes with reason `"action"` once the Promise resolves. A rejection keeps it open and puts the reason in the part's `error` state until the next press, or until the dialog opens again. `details.source` says how the part was pressed, for changes made after an `await`.

### AlertDialogShortcut

- `shortcut?` (`string`): The keys to show. Inside a trigger, its `shortcut`.

### Confirm Options

The shared `confirm()` function uses these options when an `OverlayHost` renders the question. With your own dialog, `createConfirm<Payload>()` accepts the payload you choose instead.

- `title` (`string`): The question, like "Delete this project?".
- `description?` (`string`): What agreeing does.
- `confirmLabel?` (`string`): The agreeing button's text.
- `cancelLabel?` (`string`): The other button's text.

### State

`AlertDialogContent`:

- `open` (`boolean`): Whether the dialog is open. False while it animates out.
- `modal` (`boolean | "trap-focus"`): The `modal` setting. Always true for an alert dialog.
- `nested` (`boolean`): Whether the dialog was opened from inside another dialog.
- `nestedOpen` (`boolean`): Whether a dialog opened from inside this one is open.
- `stack` (`number`): How many dialogs are open above this one, nested inside it.
- `payload` (`Payload | undefined`): The payload of the last open, from the trigger that opened it or a controller, typed as the controller's `Payload`.
- `pending` (`boolean`): Whether a Close part's action is running.
- `presentation` (`"dialog"`): Always `"dialog"`: an alert dialog never presents as a sheet.

`AlertDialogClose`:

- `pending` (`boolean`): Whether this part's action is running.
- `error` (`unknown`): Why this part's last action failed, until it's pressed again or the dialog opens again.

`AlertDialogShortcut`:

- `text` (`string`): The shortcut formatted for this platform: `⌘K` on Apple platforms and `Ctrl+K` elsewhere. Empty without one.

### Reasons

- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `close-press` (`MouseEvent | KeyboardEvent | SubmitEvent`): A Close part was pressed, or a form with `method="dialog"` was submitted.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `parent-close` (`none`): The parent layer closed.
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `action` (`MouseEvent | KeyboardEvent`): A Close part's `action` finished.
- `shortcut` (`KeyboardEvent`): A keyboard shortcut, like a trigger's `shortcut`.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

`@onPayloadChange(payload, details)` runs before `@onOpenChange` when the dialog opens with another payload. Calling `controller.open({ payload })` on an open dialog updates the payload with the reason `imperative`.

- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `shortcut` (`KeyboardEvent`): A keyboard shortcut, like a trigger's `shortcut`.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Use `createAlertDialogController<Payload, Result>()` for direct control. `createConfirm<Payload>()` returns a confirm function with its own `controller`.

- `isOpen()` (`() => boolean`): Whether it's open. False as soon as it starts closing, while it still animates out.
- `setOpen(open, options?)` (`(open: boolean, options?: PopupChangeOptions<AlertDialogOpenChangeReason> | undefined) => boolean`): Opens or closes it. Returns false when the change was canceled or it was already open or closed.
- `open(options?)` (`(options?: (PopupChangeOptions<DialogPayloadChangeReason> & { payload?: Payload | undefined; anchor?: Anchor | undefined; signal?: AbortSignal | undefined; }) | undefined) => Promise<...>`): Opens it, and resolves once it closes, with why, how and any return value. Resolves exactly once and never rejects: on the next close from any source, when `signal` aborts, or with reason `"unmount"` when the component leaves the page.
- `close(options?)` (`(options?: (PopupChangeOptions<AlertDialogOpenChangeReason> & { returnValue?: Result | undefined; }) | undefined) => boolean`): Closes it. `returnValue` is passed to the promise `open()` returned. Returns false when the close was canceled or it was already closed.
- `toggle(options?)` (`(options?: PopupChangeOptions<AlertDialogOpenChangeReason> | undefined) => boolean`): Opens it when it's closed, and closes it when it's open. Returns false when the change was canceled.
- `getPayload()` (`() => Payload | undefined`): The payload of the last open, from a controller or the trigger that opened it.
- `focus()` (`() => void`): Moves focus to the trigger that opened it last, or the first trigger.

## Accessibility

Give the dialog a title and a description, and put the least destructive answer first. It follows the [WAI-ARIA alert dialog pattern](https://www.w3.org/WAI/ARIA/apg/patterns/alertdialog/).

The dialog uses the `alertdialog` role and keeps the rest of the page inert while it's open. Screen readers announce its title and description. Opening it focuses the first Close part, so put Cancel first. A touch open focuses the content instead, so no on-screen keyboard appears. Escape closes the dialog, but pressing outside never does. [Dialog](./dialog.md#focus) covers other initial and final focus targets.

These behaviors are covered by automated tests:

**Alert dialog**

- Opens with focus on the least destructive action.
- Is described by its message.
- An outside press keeps it open.
- Escape closes it and returns focus to the trigger.
- Tab cycles between its actions.
- The action reports and closes.

Runs in React, Vue and web components.
