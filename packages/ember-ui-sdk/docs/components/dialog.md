# Dialog

Open a focused task over the page.

A dialog gives a task its own space: share a link, edit a record, or collect a few details. It manages focus, Escape, outside presses, and returning to where you started.

```glimmer-ts title="basic.gts"
import { X } from "lucide"
import { Dialog } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { icon } from "./icon"

<template>
  <Dialog as |d|>
    <d.Trigger>Share</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="stack">
        <d.Title>Share link</d.Title>
        <d.Description>Anyone who has this link will be able to view this.</d.Description>
      </div>
      <Field as |f|>
        <f.Label>Link</f.Label>
        <Input
          @defaultValue="https://example.com/project"
          readonly
          @field={{f.field}}
        />
      </Field>
      <div data-slot="row">
        <d.Close data-variant="solid">Done</d.Close>
      </div>
      <d.Close aria-label="Close">{{icon X}}</d.Close>
    </d.Content>
  </Dialog>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Open Share, then close it with either Close button, Escape, or a press outside. Focus returns to Share.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Dialog`:

```text
Dialog as |d|
├── d.Trigger
├── d.Backdrop
└── d.Content
    ├── d.Title
    ├── d.Description
    └── d.Close
```

The title names the dialog; the description gives it context. A dialog can have several Close parts. Give an icon-only close button an accessible name, as the first example does.

The backdrop is optional. Without one, style the content’s `::backdrop`. For a question that requires an explicit answer, use [Alert Dialog](./alert-dialog.md).

## Usage

Import the root and use the parts it yields:

```gts
import { Dialog } from "ember-ui-sdk/dialog"

<template>
  <Dialog as |d|>
    <d.Trigger>Open</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <d.Title>Project details</d.Title>
      <d.Description>Review the details before continuing.</d.Description>
      <d.Close>Close</d.Close>
    </d.Content>
  </Dialog>
</template>
```

`ember-ui-sdk/dialog` also exports each part by name, such as `DialogContent` and `DialogTrigger`.

## Scrollable Content

Keep the header and actions outside the scrolling area. A viewport height limit, a shrinking middle grid row, and `overflow-y: auto` keep long content usable. `@initialFocus="content"` focuses the dialog itself so reading starts at the top.

```glimmer-ts title="scrollable.gts"
import { Dialog } from "ember-ui-sdk/dialog"

const paragraphs = [
  "These terms govern your use of the service. By creating an account, you agree to them and to the privacy policy that explains how we handle your data.",
  "You're responsible for the content you upload and for keeping your password safe. Tell us right away if you think someone else has used your account.",
  "We may change the service, and these terms, as the product grows. When a change affects you, we'll let you know by email at least 30 days before it takes effect.",
  "You can stop using the service at any time. We'll keep your data for 30 days after you close your account, so you can export it, and then delete it.",
  "The service is provided as is. To the extent the law allows, we aren't liable for indirect damages, lost profits or lost data.",
  "If you have questions about these terms, write to us. We read every message and reply within two working days.",
]

<template>
  <Dialog as |d|>
    <d.Trigger>Scrollable Content</d.Trigger>
    <d.Backdrop />
    <d.Content @initialFocus="content">
      <div data-slot="stack">
        <d.Title>Terms of service</d.Title>
        <d.Description>Please read before you continue.</d.Description>
      </div>
      <div data-slot="scroll">
        {{#each paragraphs key="@identity" as |paragraph|}}
          <p>{{paragraph}}</p>
        {{/each}}
      </div>
      <div data-slot="row">
        <d.Close>Decline</d.Close>
        <d.Close data-variant="solid" @value="accept">Accept</d.Close>
      </div>
    </d.Content>
  </Dialog>
</template>
```

Open Scrollable Content in a short window. Scroll the terms while the title and Decline/Accept buttons stay in view.

## Forms

A form with `method="dialog"` closes the dialog on a valid submission. The submit button’s `value` becomes the `returnValue`, just like a Close part’s `value`. An ordinary form stays open until you close the dialog yourself.

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { Dialog } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { useLog } from "./log"

export default class Form extends Component {
  log = useLog(this)

  onOpenChange = (
    open: boolean,
    details: { reason: string; returnValue?: string }
  ) => {
    if (!open) {
      this.log(
        details.returnValue
          ? `Saved as ${details.returnValue}`
          : `Closed (${details.reason})`
      )
    }
  }

  <template>
    <Dialog @onOpenChange={{this.onOpenChange}} as |d|>
      <d.Trigger>New Article</d.Trigger>
      <d.Backdrop />
      <d.Content>
        <div data-slot="stack">
          <d.Title>New article</d.Title>
          <d.Description>Save it as a draft or publish it now.</d.Description>
        </div>
        <form data-slot="stack" method="dialog">
          <Field as |f|>
            <f.Label>Title</f.Label>
            <Input required @defaultValue="Shipping updates for spring" @field={{f.field}} />
          </Field>
          <div data-slot="row">
            <button type="submit" value="draft">Save Draft</button>
            <button
              data-variant="solid"
              type="submit"
              value="published"
            >Publish</button>
          </div>
        </form>
      </d.Content>
    </Dialog>
  </template>
}
```

Open New Article and choose Save Draft or Publish. The console logs the submitted button's value. An empty title prevents submission.

## Focus

Use `@initialFocus` to pick where focus starts, and `@finalFocus` to choose where it goes after closing. Each takes a selector, an element or a function returning one. The default returns to the trigger, or to the element focused before a controller opened the dialog.

```gts
<d.Content @initialFocus="#invite-email" @finalFocus={{this.nextStep}}>…</d.Content>
```

## Controlled

Pass `@open` and update it in `@onOpenChange`. Cancel a proposed change with `details.cancel()` in that callback. `@onOpenChangeComplete` reports when opening or closing has finished.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Dialog } from "ember-ui-sdk/dialog"
import { icon } from "./icon"
import { useLog } from "./log"

const topics = [
  { label: "Product updates", checked: true },
  { label: "Security alerts", checked: true },
  { label: "Weekly digest", checked: false },
]

export default class Controlled extends Component {
  log = useLog(this)
  topics = topics
  @tracked open = false

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.open = next === true
  }

  onOpenChange = (next: boolean, details: { reason: string }) => {
    this.open = next
    this.log(`${next ? "Opened" : "Closed"} (${details.reason})`)
  }

  onOpenChangeComplete = (next: boolean) => {
    this.log(next ? "Finished opening" : "Finished closing")
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <label data-slot="label">
          <Checkbox @checked={{this.open}} @onCheckedChange={{this.onCheckedChange}} as |c|>
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Open
        </label>
      </div>
      <Dialog
        @open={{this.open}}
        @onOpenChange={{this.onOpenChange}}
        @onOpenChangeComplete={{this.onOpenChangeComplete}}
        as |d|
      >
        <d.Trigger>Notification Settings</d.Trigger>
        <d.Backdrop />
        <d.Content>
          <div data-slot="stack">
            <d.Title>Notification settings</d.Title>
            <d.Description>Choose what we email you about.</d.Description>
          </div>
          <div data-slot="stack">
            {{#each this.topics key="label" as |topic|}}
              <label data-slot="label">
                <Checkbox @defaultChecked={{topic.checked}} as |c|>
                  <c.Indicator>{{icon Check}}</c.Indicator>
                </Checkbox>
                {{topic.label}}
              </label>
            {{/each}}
          </div>
          <div data-slot="row">
            <d.Close data-variant="solid">Done</d.Close>
          </div>
        </d.Content>
      </Dialog>
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

Check Open or press Notification Settings, then close the dialog. The console logs each change, its reason and when it finishes.

## Keyboard Shortcut

A trigger’s `@shortcut` opens it from the keyboard. `mod+j` means Command+J on Apple platforms and Control+J elsewhere. The `d.Shortcut` part displays the right keys and the trigger exposes `aria-keyshortcuts`.

```glimmer-ts title="shortcut.gts"
import { Plus } from "lucide"
import { Dialog } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { icon } from "./icon"

<template>
  <Dialog as |d|>
    <d.Trigger @shortcut="mod+j">
      {{icon Plus}}
      New Contact
      <d.Shortcut />
    </d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="stack">
        <d.Title>New contact</d.Title>
        <d.Description>Add someone to your address book.</d.Description>
      </div>
      <form data-slot="stack" method="dialog">
        <Field as |f|>
          <f.Label>Name</f.Label>
          <Input name="name" required placeholder="Kofi Mensah" @field={{f.field}} />
        </Field>
        <Field as |f|>
          <f.Label>Email</f.Label>
          <Input name="email" type="email" required placeholder="kofi@example.com" @field={{f.field}} />
        </Field>
        <div data-slot="row">
          <d.Close>Cancel</d.Close>
          <button data-variant="solid" type="submit" value="save">Save Contact</button>
        </div>
      </form>
    </d.Content>
  </Dialog>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Press Command+J or Control+J to open New contact. The button shows the keys, and Escape returns focus to it.

## Animation

The content and backdrop have `data-starting-style` while they open and `data-ending-style` while they close. Transition from those states, and the dialog stays mounted until the exit finishes. `@onOpenChangeComplete` runs after the transition, and `@keepMounted={{true}}` keeps the content in the page while closed.

```css
[data-slot="dialog-content"] {
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
import Component from "@glimmer/component"
import { Dialog } from "ember-ui-sdk/dialog"
import { useLog } from "./log"

export default class Animation extends Component {
  log = useLog(this)

  onOpenChangeComplete = (open: boolean) => {
    this.log(open ? "Finished opening" : "Finished closing")
  }

  <template>
    <Dialog @onOpenChangeComplete={{this.onOpenChangeComplete}} as |d|>
      <d.Trigger>Slide In</d.Trigger>
      <d.Backdrop />
      <d.Content @keepMounted={{true}}>
        <div data-slot="stack">
          <d.Title>Slide and fade</d.Title>
          <d.Description>300ms in and out. Focus returns as soon as it starts
            closing.</d.Description>
        </div>
        <div data-slot="row">
          <d.Close data-variant="solid">Close</d.Close>
        </div>
      </d.Content>
    </Dialog>
  </template>
}
```

Open the dialog and close it. The console logs when each animation finishes; focus returns as closing starts.

## Modal

`@modal` controls how the dialog shares the page:

- `true`, the default, makes the page inert, locks scrolling, and keeps Tab inside.
- `"trap-focus"` keeps Tab inside while the page can still scroll and receive clicks. A click on the page also closes the dialog, unless `@closeOnOutsidePress` is false.
- `false` puts the dialog beside the page and lets focus leave it. Escape closes it while focus is inside; outside presses close it only when `@closeOnOutsidePress` is enabled.

To keep a small part of the page usable while a modal dialog is open, like a chat launcher, pass it to `@persistentElements`: an array of elements or selectors, or a function returning elements when the dialog opens. Persistent elements don't change stacking on their own.

Dialogs render where you put them and use the browser's top layer. Set `@container` when their DOM needs to live elsewhere, like a shadow root.

```glimmer-ts title="modal.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Dialog } from "ember-ui-sdk/dialog"
import { Select } from "ember-ui-sdk/select"
import { icon } from "./icon"

const modes = [
  { value: "true", label: "Modal" },
  { value: "trap-focus", label: "Trap focus" },
  { value: "false", label: "Non-modal" },
]

const notes = {
  true: "The rest of the page is inert and doesn't scroll.",
  "trap-focus":
    "Tab stays inside, and the page still scrolls and takes clicks.",
  false:
    "The page stays usable. Tab leaves the notes, and Escape closes them while focus is inside.",
}

export default class Modal extends Component {
  modes = modes
  @tracked mode = "false"
  @tracked outside = false

  get note() {
    return notes[this.mode as keyof typeof notes]
  }

  get modal() {
    return this.mode === "true"
      ? true
      : this.mode === "false"
        ? false
        : "trap-focus"
  }

  get showBackdrop() {
    return this.modal === true
  }

  onModeChange = (next: string | null) => {
    if (next) this.mode = next
  }

  onOutsideChange = (next: boolean | "indeterminate") => {
    this.outside = next === true
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select @items={{this.modes}} @value={{this.mode}} @onValueChange={{this.onModeChange}} as |s|>
          <s.Label>Modal</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.modes key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <label data-slot="label">
          <Checkbox @checked={{this.outside}} @onCheckedChange={{this.onOutsideChange}} as |c|>
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Close on outside press
        </label>
      </div>
      <Dialog @modal={{this.modal}} @closeOnOutsidePress={{this.outside}} as |d|>
        <d.Trigger>Open Notes</d.Trigger>
        {{#if this.showBackdrop}}
          <d.Backdrop />
        {{/if}}
        <d.Content>
          <div data-slot="stack">
            <d.Title>Notes</d.Title>
            <d.Description>{{this.note}}</d.Description>
          </div>
          <textarea aria-label="Notes">Call the printer about the proofs.</textarea>
          <div data-slot="row">
            <d.Close data-variant="solid">Done</d.Close>
          </div>
        </d.Content>
      </Dialog>
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

Choose a mode, open Notes, and try Tab or clicking the page. Check Close on outside press to compare dismissal.

## Warn Before Closing a Dirty Form

Set `@dismissible={{false}}` while there are unsaved changes. Escape, an outside press, or a back gesture then keeps the dialog open and reports `@onDismissAttempt`. Explicit Close parts and controller calls still work, so you can offer a deliberate way out.

```glimmer-ts title="dirty-form.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Dialog } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

export default class DirtyForm extends Component {
  @tracked open = false
  @tracked dirty = false
  @tracked asking = false

  get clean() {
    return !this.dirty
  }

  close = () => {
    this.open = false
    this.dirty = false
    this.asking = false
  }

  onOpenChange = (next: boolean) => {
    if (next) {
      this.open = true
    } else {
      this.close()
    }
  }

  onDismissAttempt = () => {
    this.asking = true
  }

  onInput = (event: Event) => {
    this.dirty = (event.currentTarget as HTMLTextAreaElement).value !== ""
  }

  keepEditing = () => {
    this.asking = false
    document.querySelector<HTMLTextAreaElement>("#post")?.focus()
  }

  <template>
    <Dialog
      @open={{this.open}}
      @onOpenChange={{this.onOpenChange}}
      @dismissible={{this.clean}}
      @onDismissAttempt={{this.onDismissAttempt}}
      as |d|
    >
      <d.Trigger>Write a Post</d.Trigger>
      <d.Backdrop />
      <d.Content>
        <div data-slot="stack">
          <d.Title>New post</d.Title>
          <d.Description>Share an update with your team.</d.Description>
        </div>
        <Field as |f|>
          <f.Label>Post</f.Label>
          <Textarea id="post" @field={{f.field}} placeholder="What's new?" {{on "input" this.onInput}} />
        </Field>
        {{#if this.asking}}
          <div data-slot="row" role="alert">
            Discard your changes?
            <div data-slot="row">
              <button type="button" {{on "click" this.keepEditing}}>Keep Editing</button>
              <button
                data-variant="solid"
                type="button"
                {{on "click" this.close}}
              >Discard</button>
            </div>
          </div>
        {{else}}
          <div data-slot="row">
            <d.Close data-variant="solid" @value="post">Post</d.Close>
          </div>
        {{/if}}
      </d.Content>
    </Dialog>
  </template>
}
```

Type a post, then press Escape or click outside. Keep editing returns to the field; Discard closes the dialog and clears the draft.

## Nested Dialogs

A dialog opened inside another joins its stack. Escape closes the topmost dialog and returns focus to its trigger. Closing the parent also closes its children. `data-nested-open` and `--dialog-stack` let you show which layer is active.

```glimmer-ts title="nested.gts"
import { Dialog } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"

<template>
  <Dialog as |d|>
    <d.Trigger>Account</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <div data-slot="stack">
        <d.Title>Account</d.Title>
        <d.Description>Manage how you sign in.</d.Description>
      </div>
      <div data-slot="card">
        <div data-slot="stack">
          <span>Password</span>
          <span data-slot="hint">Last changed 3 months ago</span>
        </div>
        <Dialog as |inner|>
          <inner.Trigger>Change Password</inner.Trigger>
          <inner.Backdrop />
          <inner.Content>
            <div data-slot="stack">
              <inner.Title>Change password</inner.Title>
              <inner.Description>Use at least 12 characters.</inner.Description>
            </div>
            <Field as |f|>
              <f.Label>New password</f.Label>
              <Input type="password" @field={{f.field}} />
            </Field>
            <div data-slot="row">
              <inner.Close>Cancel</inner.Close>
              <inner.Close data-variant="solid">Update</inner.Close>
            </div>
          </inner.Content>
        </Dialog>
      </div>
      <div data-slot="row">
        <d.Close data-variant="solid">Done</d.Close>
      </div>
    </d.Content>
  </Dialog>
</template>
```

Open Account, then Change Password. Press Escape once to return to Account, and again to close it.

## Opening from a Menu Item

Render the dialog outside the menu and open it with the dialog’s controller. When the item disappears, the menu’s trigger becomes the place to return focus.

```glimmer-ts title="from-menu.gts"
import Component from "@glimmer/component"
import { Copy, Ellipsis, Pencil } from "lucide"
import { Dialog, createDialogController } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "./icon"

export default class FromMenu extends Component {
  rename = createDialogController()

  openRename = () => {
    this.rename.open()
  }

  <template>
    <Menu as |m|>
      <m.Trigger aria-label="File actions">{{icon Ellipsis}}</m.Trigger>
      <m.Content>
        <m.Item @onSelect={{this.openRename}}>
          {{icon Pencil}}
          Rename…
        </m.Item>
        <m.Item>
          {{icon Copy}}
          Duplicate
        </m.Item>
      </m.Content>
    </Menu>
    <Dialog @controller={{this.rename}} as |d|>
      <d.Backdrop />
      <d.Content>
        <div data-slot="stack">
          <d.Title>Rename file</d.Title>
          <d.Description>Names must be unique in a folder.</d.Description>
        </div>
        <Field as |f|>
          <f.Label>Name</f.Label>
          <Input @defaultValue="report.pdf" @field={{f.field}} />
        </Field>
        <div data-slot="row">
          <d.Close>Cancel</d.Close>
          <d.Close data-variant="solid" @value="rename">Rename</d.Close>
        </div>
      </d.Content>
    </Dialog>
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

Open File Actions and choose Rename. Close the dialog to return focus to the File Actions button.

## Opening from Anywhere

Connect several triggers to one `createDialogController<Payload, Result>()`. Each trigger passes a `@payload`; the content reads it from its state. `controller.open({ payload })` opens it from code and returns a promise that resolves when it closes, with the reason and any `returnValue`. Each trigger remains the return-focus target for the dialog it opened.

```glimmer-ts title="payload.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import {
  createDialogController,
  Dialog,
  DialogTrigger,
} from "ember-ui-sdk/dialog"
import { useLog } from "./log"

type Invoice = {
  id: string
  customer: string
  amount: string
  status: "Paid" | "Due"
}

const invoices: Invoice[] = [
  { id: "INV-001", customer: "Acme", amount: "$250.00", status: "Paid" },
  { id: "INV-002", customer: "Globex", amount: "$150.00", status: "Due" },
  { id: "INV-003", customer: "Initech", amount: "$350.00", status: "Due" },
]

const isPaid = (invoice: Invoice) => invoice.status === "Paid"

export default class Payload extends Component {
  log = useLog(this)
  invoices = invoices
  isPaid = isPaid
  reminder = createDialogController<Invoice, "send">()

  remindFromCode = async () => {
    const { reason, returnValue } = await this.reminder.open({
      payload: invoices[2],
    })
    this.log(
      returnValue === "send" ? "Reminder sent from code" : `Closed (${reason})`
    )
  }

  onOpenChange = (open: boolean, details: { returnValue?: string }) => {
    if (!open && details.returnValue === "send") {
      this.log("Reminder sent")
    }
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.remindFromCode}}>Open from Code</button>
      </div>
      <ul data-slot="list">
        {{#each this.invoices key="id" as |invoice|}}
          <li data-slot="row">
            {{invoice.customer}}
            <span data-slot="hint">{{invoice.amount}}
              ·
              {{invoice.status}}</span>
            <DialogTrigger
              @controller={{this.reminder}}
              @payload={{invoice}}
              @disabled={{this.isPaid invoice}}
              aria-label="Remind {{invoice.customer}}"
            >
              Remind
            </DialogTrigger>
          </li>
        {{/each}}
      </ul>
      <Dialog @controller={{this.reminder}} @onOpenChange={{this.onOpenChange}} as |d|>
        <d.Backdrop />
        <d.Content as |content|>
          <div data-slot="stack">
            <d.Title>Remind {{content.state.payload.customer}}</d.Title>
            <d.Description>
              {{content.state.payload.id}}
              for
              {{content.state.payload.amount}}
              is due. We'll email the billing contact.
            </d.Description>
          </div>
          <div data-slot="row">
            <d.Close>Cancel</d.Close>
            <d.Close data-variant="solid" @value="send">Send reminder</d.Close>
          </div>
        </d.Content>
      </Dialog>
    </div>
  </template>
}
```

Open a reminder from either unpaid invoice, or press Open from Code. The same dialog shows that invoice, and the console logs how it closed.

## Presentation

`@presentation="sheet"` presents the same task as a sheet. Use `"auto"` to choose a sheet on small touch screens and a centered dialog elsewhere, decided each time it opens. A swipe down closes a dismissible sheet; a protected one springs back and reports a dismissal attempt.

Style `data-presentation` to support both layouts. The sheet manages its own position and movement, so do not apply the centered dialog’s translation to it. `--sheet-backdrop` styles the dimmed page when no Backdrop part is present.

```glimmer-ts title="presentation.gts"
import { Dialog } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"

<template>
  <Dialog @presentation="sheet" as |d|>
    <d.Trigger>Edit Profile</d.Trigger>
    <d.Content>
      <div data-slot="stack">
        <d.Title>Edit profile</d.Title>
        <d.Description>Make changes to your profile here. Save when you're done.</d.Description>
      </div>
      <Field as |f|>
        <f.Label>Name</f.Label>
        <Input @defaultValue="Hollis Grant" @field={{f.field}} />
      </Field>
      <Field as |f|>
        <f.Label>Username</f.Label>
        <Input @defaultValue="@hollis" @field={{f.field}} />
      </Field>
      <div data-slot="row">
        <d.Close>Cancel</d.Close>
        <d.Close data-variant="solid" @value="save">Save Changes</d.Close>
      </div>
    </d.Content>
  </Dialog>
</template>
```

Open Edit Profile as a sheet. On a touch screen, drag it down to dismiss it, or use Cancel or Save Changes.

## Custom Rendering

Pass `@render={{true}}` to a part to render it as your own element. It yields `{ part, state }`: bind `part` to your element as a modifier, and read the state in the block.

```glimmer-ts title="custom-rendering.gts"
import { Dialog } from "ember-ui-sdk/dialog"

<template>
  <Dialog as |d|>
    <d.Trigger @shortcut="mod+i" @render={{true}} as |t|>
      <button {{t.part}} type="button">
        {{if t.state.open "Viewing" "View Details"}}
        <d.Shortcut as |s|>{{s.state.text}}</d.Shortcut>
      </button>
    </d.Trigger>
    <d.Backdrop />
    <d.Content as |content|>
      <div data-slot="stack">
        <d.Title @render={{true}} as |t|>
          <h3 {{t.part}}>Details</h3>
        </d.Title>
        <d.Description>
          {{if
            content.state.nested
            "Opened from another dialog."
            "Quarterly report, updated today."
          }}
        </d.Description>
      </div>
      <div data-slot="row">
        <d.Close>Close</d.Close>
        <d.Close data-variant="solid" @render={{true}} as |c|>
          <a {{c.part}} href="https://example.com/details">Open the Full Page</a>
        </d.Close>
      </div>
    </d.Content>
  </Dialog>
</template>
```

Open View Details. The trigger's label and the description come from their state, and Close renders as a link.

## Styling

Each part has a `data-slot`, such as `dialog-content`, and shows its state through the attributes listed under [Data Attributes](#data-attributes). Use `data-open` and `data-closed` for each state, and `data-starting-style` and `data-ending-style` for transitions.

### DialogContent
- `--dialog-stack`: How many dialogs are open above this one, nested inside it. 0 for the topmost.
- `--keyboard-inset`: Unless it presents as a sheet: how many pixels of the page the on-screen keyboard covers, 0 without one.
- `--visual-viewport-width`: Unless it presents as a sheet: the width of the part of the page you can see.
- `--visual-viewport-height`: Unless it presents as a sheet: the height of the part of the page you can see, above the keyboard.
- `--visual-viewport-top`: Unless it presents as a sheet: how far the part of the page you can see is scrolled from the top of the layout, as when the keyboard pushes it up.
- `--drawer-progress`: While it presents as a sheet: how far open the sheet is, from 0 closed to 1 at its largest snap point. Never past 1.
- `--drawer-dim`: While it presents as a sheet: how dim the page behind is, from 0 to 1. The backdrop's opacity follows it.
- `--drawer-expand`: While it presents as a sheet: 0 at the second-largest snap point and below, 1 at the largest. With one snap point, the whole travel.
- `--drawer-stack`: While it presents as a sheet: how many sheets opened from inside this one are open above it, rising smoothly as each one opens. Push it back with it.
- `--sheet-backdrop`: Set it yourself: the color the page dims to while it presents as a sheet. Black at 0.2 by default.

### Viewport
- `--keyboard-inset`: While it presents as a sheet: how many pixels of the page the on-screen keyboard covers, 0 without one.
- `--visual-viewport-width`: While it presents as a sheet: the width of the part of the page you can see.
- `--visual-viewport-height`: While it presents as a sheet: the height of the part of the page you can see, above the keyboard.
- `--visual-viewport-top`: While it presents as a sheet: how far the part of the page you can see is scrolled from the top of the layout, as when the keyboard pushes it up.

## Data Attributes

### DialogTrigger
`[data-slot="dialog-trigger"]`

- `data-closed`: Present while the dialog is closed, including while it animates out.
- `data-disabled`: Present when the trigger is disabled.
- `data-open`: Present while the dialog is open. On a trigger, while it's open from that trigger.

### DialogBackdrop
`[data-slot="dialog-backdrop"]`

- `data-closed`: Present while the dialog is closed, including while it animates out.
- `data-open`: Present while the dialog is open. On a trigger, while it's open from that trigger.
- `data-starting-style`: Present for the first frame. Style the state you animate from.
- `data-ending-style`: Present while the dialog animates out. Style the state you animate to.

### DialogContent
`[data-slot="dialog-content"]`

- `data-closed`: Present while the dialog is closed, including while it animates out.
- `data-presentation` (`dialog`, `sheet`): How the dialog presents this time it's open.
- `data-open`: Present while the dialog is open. On a trigger, while it's open from that trigger.
- `data-starting-style`: Present for the first frame. Style the state you animate from.
- `data-ending-style`: Present while the dialog animates out. Style the state you animate to.
- `data-keyboard`: Present while the on-screen keyboard covers part of the page.

### DialogClose
`[data-slot="dialog-close"]`

- `data-pending`: Present on a Close part while its action runs.

## API Reference

Pass the root's options as `@` arguments. `@open` is controlled with `@onOpenChange`.

### Dialog

- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `open?` (`boolean`): Whether the dialog is open. Pass it to control the dialog.
- `defaultOpen?` (`boolean`): Whether the dialog starts open, when uncontrolled. Focus moves into it once it's on the page.
- `onOpenChangeComplete?` (`((open: boolean) => void)`): Runs once the dialog has finished opening or closing, after any animation.
- `dismissible?` (`boolean`): Whether Escape, an outside press and Android's back gesture can close the dialog. Close parts, triggers and the controller always can. Pass `false` while a form has unsaved changes, and ask in `@onDismissAttempt`.
- `onDismissAttempt?` (`((details: DialogDismissAttemptDetails) => void)`): Runs when a dismissal was refused, because `dismissible` is false, an outside press doesn't close it, or a Close part's action is running. Ask "Discard changes?" here.
- `persistentElements?` (`(string | Element)[] | (() => Element[])`): Elements that stay usable while the dialog makes the page inert, like a chat launcher or a password manager's button. Elements, CSS selectors, or a function that returns elements, read when the dialog opens. Presses on them never close it.
- `pendingAnnouncement?` (`string`): What screen readers hear once a Close part's action has been running for a second, so a slow action doesn't pass in silence. Set it in the page's language. An empty string says nothing.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.
- `onOpenChange?` (`((open: boolean, details: DialogOpenChangeDetails) => void)`): Runs when the dialog wants to open or close. `details.reason` says why, `details.cancel()` stops it, and `details.returnValue` carries what closed it.
- `onPayloadChange?` (`((payload: unknown, details: ChangeDetails<DialogPayloadChangeReason>) => void)`): Runs when the payload the content shows changes: a trigger with another payload opens the dialog, or takes a non-modal dialog over while it's open, which fires no `@onOpenChange`, and so does a controller's `open({ payload })` on the open dialog. `details.cancel()` keeps the previous payload.
- `modal?` (`"trap-focus" | boolean`): `true`: the rest of the page is inert and doesn't scroll, focus is trapped, and an outside press only closes the dialog. `"trap-focus"`: traps focus, and leaves the page scrollable and clickable. `false`: a dialog beside the page, which Tab can leave and outside presses don't close.
- `closeOnOutsidePress?` (`boolean`): Whether pressing outside the dialog, like on its backdrop, closes it. The press counts once it's released outside too, so dragging a text selection out of a field doesn't close it.
- `presentation?` (`PresentationSetting<"dialog">`): How the dialog presents. `"sheet"` slides it up from the bottom of the screen, where it can be swiped away, and `"auto"` does that on small touch screens. Decided each time it opens; the server renders `"dialog"` for `"auto"`.
- `controller?` (`PopupController<any, DialogOpenChangeReason, {}, any, DialogPayloadChangeReason>`): Opens, closes and inspects the dialog from anywhere, and connects triggers outside it. Create one with `createDialogController()`.

### DialogTrigger

A trigger outside the dialog also takes `@controller`.

- `disabled?` (`boolean`): Stops the trigger from opening the dialog. A native button can't be focused or pressed, unless `focusableWhenDisabled` is set.
- `focusableWhenDisabled?` (`boolean`): Keeps a disabled trigger in the tab order with `aria-disabled` instead of the native attribute, so it can host a tooltip that says why. Presses still do nothing.
- `payload?` (`unknown`): Data for the content to render when this trigger opens the dialog, like the row it belongs to.
- `shortcut?` (`string`): A keyboard shortcut that presses the trigger, like `"mod+k"`. `mod` is Command on Apple platforms and Control elsewhere. Sets `aria-keyshortcuts`, and a Shortcut part inside shows it. A modal dialog pauses the page's shortcuts while it's open.
- `controller?` (`PopupController<any, DialogOpenChangeReason, {}, any, DialogPayloadChangeReason>`): Connects a trigger outside the dialog, like one per table row, to the dialog with this controller.

### DialogBackdrop

Dims the page behind a modal dialog. Renders a `div`.

### DialogContent

- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `initialFocus?` (`DialogInitialFocus`): Where focus goes when the dialog opens. Opening with touch focuses the dialog itself, so no on-screen keyboard appears.
- `finalFocus?` (`PopupFocusTarget`): Where focus goes when the dialog closes while focus is inside it.
- `keepMounted?` (`boolean`): Whether the dialog stays in the page, hidden, while closed. For animation libraries that drive the exit from state.

### DialogTitle

Names the dialog. Renders an `h2`.

### DialogDescription

Describes the dialog while it's rendered. Renders a `p`.

### DialogClose

Its `@action` receives the event and `{ source }`, how the part was pressed, as [Button](./button.md#changes-after-an-await) describes.

- `value?` (`string`): Reported as `returnValue` in `@onOpenChange` and by the controller's `open()`. `createConfirm()` resolves `true` for `"confirm"`.
- `action?` (`((event: Event | undefined, details: ActionDetails) => unknown)`): Runs when the part is pressed, before the dialog closes. A returned Promise keeps the dialog open while it runs: the part gets `data-pending`, `aria-busy` and `aria-disabled`, screen readers hear the dialog's `pendingAnnouncement` after a second, and nothing but the controller closes the dialog. It closes with reason `"action"` once the Promise resolves. A rejection keeps it open and puts the reason in the part's `error` state until the next press, or until the dialog opens again. `details.source` says how the part was pressed, for changes made after an `await`.

### DialogShortcut

- `shortcut?` (`string`): The keys to show. Inside a trigger, its `shortcut`.

### State

What `@render` parts and their blocks receive, per part.

`DialogTrigger`:

- `open` (`boolean`): Whether the dialog is open from this trigger.
- `disabled` (`boolean`): Set by the trigger's `disabled` prop, which stops it opening the dialog.

`DialogBackdrop`:

- `open` (`boolean`): Whether the dialog is open. False while it animates out.
- `nested` (`boolean`): Whether the dialog was opened from inside another dialog.
- `nestedOpen` (`boolean`): Whether a dialog opened from inside this one is open.

`DialogContent`:

- `open` (`boolean`): Whether the dialog is open. False while it animates out.
- `modal` (`boolean | "trap-focus"`): The `modal` setting. Always true for an alert dialog.
- `nested` (`boolean`): Whether the dialog was opened from inside another dialog.
- `nestedOpen` (`boolean`): Whether a dialog opened from inside this one is open.
- `stack` (`number`): How many dialogs are open above this one, nested inside it.
- `payload` (`Payload | undefined`): The payload of the last open, from the trigger that opened it or a controller, typed as the controller's `Payload`.
- `pending` (`boolean`): Whether a Close part's action is running.
- `presentation` (`"dialog" | "sheet"`): How it presents this time it's open.

`DialogClose`:

- `pending` (`boolean`): Whether this part's action is running.
- `error` (`unknown`): Why this part's last action failed, until it's pressed again or the dialog opens again.

`DialogShortcut`:

- `text` (`string`): The shortcut formatted for this platform: `⌘K` on Apple platforms and `Ctrl+K` elsewhere. Empty without one.

### Reasons

`details.reason` says why the dialog opened or closed.

- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `close-press` (`MouseEvent | KeyboardEvent | SubmitEvent`): A Close part was pressed, or a form with `method="dialog"` was submitted.
- `outside-press` (`MouseEvent`): A press outside the layer.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `parent-close` (`none`): The parent layer closed.
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `action` (`MouseEvent | KeyboardEvent`): A Close part's `action` finished.
- `shortcut` (`KeyboardEvent`): A keyboard shortcut, like a trigger's `shortcut`.
- `swipe` (`TouchEvent | PointerEvent`): A swipe gesture: a finger, mouse or pen dragged it.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

For a payload change, it says what opened the dialog or took it over.

- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `shortcut` (`KeyboardEvent`): A keyboard shortcut, like a trigger's `shortcut`.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

The dismissals `@dismissible` can refuse:

- `outside-press` (`MouseEvent`): A press outside the layer.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `swipe` (`TouchEvent | PointerEvent`): A swipe gesture: a finger, mouse or pen dragged it.

### Controller

Create one with `createDialogController<Payload, Result>()` and pass it as `@controller`, to the dialog and to any triggers outside it.

Every write method takes an optional `{ reason, event }`, passed to `@onOpenChange`. Closing with a controller always works, even when the dialog isn't dismissible or an action is running.

- `isOpen()` (`() => boolean`): Whether it's open. False as soon as it starts closing, while it still animates out.
- `setOpen(open, options?)` (`(open: boolean, options?: PopupChangeOptions<DialogOpenChangeReason> | undefined) => boolean`): Opens or closes it. Returns false when the change was canceled or it was already open or closed.
- `open(options?)` (`(options?: (PopupChangeOptions<DialogPayloadChangeReason> & { payload?: Payload | undefined; anchor?: Anchor | undefined; signal?: AbortSignal | undefined; }) | undefined) => Promise<...>`): Opens it, and resolves once it closes, with why, how and any return value. Resolves exactly once and never rejects: on the next close from any source, when `signal` aborts, or with reason `"unmount"` when the component leaves the page.
- `close(options?)` (`(options?: (PopupChangeOptions<DialogOpenChangeReason> & { returnValue?: Result | undefined; }) | undefined) => boolean`): Closes it. `returnValue` is passed to the promise `open()` returned. Returns false when the close was canceled or it was already closed.
- `toggle(options?)` (`(options?: PopupChangeOptions<DialogOpenChangeReason> | undefined) => boolean`): Opens it when it's closed, and closes it when it's open. Returns false when the change was canceled.
- `getPayload()` (`() => Payload | undefined`): The payload of the last open, from a controller or the trigger that opened it.
- `focus()` (`() => void`): Moves focus to the trigger that opened it last, or the first trigger.

### Events

Callbacks get the new state first, then the details. A controlled `@open` only updates when `@onOpenChange` wasn't canceled.

| Argument                | On       | Receives                                                                       |
| ----------------------- | -------- | ------------------------------------------------------------------------------ |
| `@onOpenChange`         | `Dialog` | `(open, details)`: the new state, the [reason](#reasons) and any `returnValue` |
| `@onOpenChangeComplete` | `Dialog` | `(open)`, after the animation                                                  |
| `@onPayloadChange`      | `Dialog` | `(payload, details)`: the content's new payload, and the [reason](#reasons)    |
| `@onDismissAttempt`     | `Dialog` | `({ reason, event })`, when a dismissal was refused                            |

## Accessibility

The trigger is a button that opens a dialog, and the dialog follows the [WAI-ARIA modal dialog pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/): `aria-modal` while it's modal, labelled by its title, described by its description only while one is rendered. Every line below is an automated test.

### Keyboard

| Key                  | Does                                                                 |
| -------------------- | -------------------------------------------------------------------- |
| Enter, Space         | On the trigger, opens the dialog                                     |
| Tab, Shift+Tab       | Moves through the dialog's controls, staying inside while it's modal |
| Escape               | Closes the topmost dialog and returns focus to its trigger           |
| A trigger's shortcut | Opens its dialog from anywhere on the page                           |

### Tested Behavior

**Trigger**

- Advertises a dialog.
- Click opens the dialog.
- Enter opens the dialog.
- Space opens the dialog.

**Focus**

- Opening moves focus to the first focusable element.
- Each time focus moves in, the dialog is named by its title and described by its description.
- Tab moves through the dialog in order.
- Tab from the last element wraps to the first.
- Shift+Tab from the first element wraps to the last.
- Shift+Tab from the first element wraps to the checked radio of a group outside a form.
- Tab reaches radios whose group's checked radio is behind the dialog.
- Tab visits a positive tabindex first, like the browser.
- A positive tabindex keeps Tab inside a dialog that leaves the page usable.
- A positive tabindex slotted into a custom element keeps its host's place.
- With a positive tabindex in the dialog, Tab still moves through a shadow root and slots.
- With a positive tabindex in the dialog, Tab from a focused element outside the tab order goes to the next stop.
- Tab from a custom element with a positive tabindex enters its shadow root.
- Opening focuses the first field even when a later one has a positive tabindex.
- Escape closes the dialog and returns focus to the trigger.
- Escape after a click returns focus to the trigger.
- The close button closes the dialog and returns focus to the trigger.
- A virtual click from a screen reader moves focus into the dialog.
- A touch press focuses the dialog itself, so no on-screen keyboard appears.
- Pressing a button inside keeps the dialog open.

**Dismissal**

- Pressing the backdrop closes the dialog.
- Pressing the backdrop returns focus to the trigger.
- Clicking inside the dialog keeps it open.
- An outside press doesn't reach the page.

**Presses**

- Selecting text in a field and releasing over the backdrop keeps the dialog open.
- Pressing the backdrop and releasing inside the dialog keeps it open.
- A right click on the backdrop keeps the dialog open.
- A dialog styled only with ::backdrop closes when the backdrop is pressed.
- With closeOnOutsidePress false, pressing the backdrop keeps the dialog open.
- Pressing a nested dialog's backdrop closes only the nested dialog.
- While the dialog animates out, a press on its backdrop doesn't reach the page.
- Escape right after opening a nested dialog closes only the nested one.

**Modal**

- Tab never leaves the dialog.
- The page doesn't scroll while the dialog is open.
- The rest of the page is hidden from assistive technology.
- With modal false, the page stays usable.

**Nested dialogs**

- Escape closes only the nested dialog and returns focus to its trigger.
- The nested dialog's close button closes only it.
- The outer dialog's open change hears only the outer dialog.
- Tab stays inside the nested dialog.
- A second Escape closes the outer dialog.

Runs in React, Vue and web components.

Additional behaviors:

**Escape that closes exactly one thing**

- Escape while an input method is composing text keeps the dialog open.
- Escape closes a non-modal dialog only while focus is inside it.

**Focus that always lands somewhere useful**

- Closing returns focus to the trigger before the exit animation finishes.
- Closing after the trigger is gone moves focus to the element after where it was.
- Closing after the trigger is gone skips past a later positive tabindex.
- A dialog open from the start moves focus inside.
- With initial focus on the content, the dialog itself takes focus.

**The outside is inert, except what must stay live**

- The page outside is inert while open and restored exactly after.
- A live region outside the dialog keeps announcing while it's open.

**Non-modal dialogs that behave like the APG**

- Tab leaves a non-modal dialog and the dialog stays open.
- A non-modal dialog stays open when the page is clicked.

**Nested and stacked**

- A dialog opened inside a dialog marks both, for styling.
- Closing the parent closes the nested dialog with reason parent-close.

**Opening from anywhere**

- A controller opens the dialog, moves focus in, and resolves with how it closed.
- Aborting the signal closes the dialog, and the promise resolves once.
- A pending open() resolves with reason unmount when the dialog leaves the page. Web components only.
- A form with method dialog closes the dialog and reports the submitter's value.
- A confirm helper resolves true for the action and false otherwise.
- A confirm opened from inside a modal dialog takes focus and stays usable.
- A confirm opened over a modal dialog with nothing focused stays usable.
- A confirm opened as a modal dialog shows, before the page freezes, stays usable.
- Closing reports why, for every way a dialog closes.

**Shortcuts**

- A trigger connected through a controller shows its shortcut in a Shortcut part, and binds it.

**Web components**

- The open property and attribute open and close the dialog. Web components only.

Runs in React, Vue and web components.

**Opening a dialog from a menu item**

- Choosing the item closes the menu and moves focus into the dialog.
- Choosing the item with the keyboard moves focus into the dialog.

**The page and focus around a dialog opened from a menu item**

- The page around the dialog is inert, the menu's trigger included.
- Closing the dialog returns focus to the menu's trigger.
- A dialog the item opens through its open prop returns focus to the menu's trigger. React and Vue only.

**Shortcuts**

- A trigger's shortcut opens the dialog.
- The trigger advertises its shortcut, and shows it to sighted users only.
- A modal dialog pauses the page's shortcuts and keeps its own.
- A dialog's own shortcut doesn't run while the dialog is closed.
- Menu and popover triggers take shortcuts too.
- Plain keys typed in a text field are text, and modifier shortcuts still run.
- A plain-key shortcut runs outside text fields.

**A dirty form**

- Refuses Escape and outside presses, and reports each attempt.
- A clean form closes on Escape.

**Persistent elements**

- Stay usable while a modal dialog is open, and pressing them keeps it open.

**Async actions**

- Keep the alert dialog open and pending, then close with reason action.
- A failed action keeps the alert dialog open and stops pending.

**Popups inside a portaled popover**

- A menu and a dialog inside it render into the popover's container.

**Android's back gesture**

- Closes the topmost dialog with reason back.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while using the dialog with a keyboard.
- Announcements while using the alert dialog with a keyboard.

Runs in React, Vue and web components.
