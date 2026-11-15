# Toast

Show notifications with actions, timed dismissal, and screen reader announcements.

A toast tells someone that something happened, like a saved change or a sent message, and goes away on its own. It can offer an action such as Undo, stacks with the toasts before it, and is announced to screen readers without taking focus.

```glimmer-ts title="demo.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { useLog } from "./log"

export default class Demo extends Component {
  log = useLog(this)
  toast = createToaster()

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  createEvent = () => {
    this.toast("Event created", {
      description: "Friday, June 12 at 10:00 AM",
      action: { label: "Undo", onAction: () => this.log("Event removed") },
    })
  }

  <template>
    <button type="button" {{on "click" this.createEvent}}>
      Create Event
    </button>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <div data-slot="stack">
          <t.Title />
          <t.Description />
        </div>
        <t.Action data-variant="solid" />
      </t.Toast>
    </ToastRegion>
  </template>
}
```

Press Create Event. Choose Undo, swipe the toast away, or wait for it to close. Undo logs Event removed.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `ToastRegion`:

```text
ToastRegion as |t|
├── t.Toast
│   ├── t.Title
│   ├── t.Description
│   ├── t.Action
│   └── t.Close
└── t.Toast
    ├── t.Title
    └── t.Description
```

The region renders one `t.Toast` for each toast in its queue, newest first. A toast is named by its title and described by its description. Empty title, description and action parts show the text from the toast's data, so a region's renderer is usually the same few parts.

## Usage

Import the region and create a toaster, then call it from a handler when an action finishes, such as `notify("Event created", { description: "Friday at 10:00 AM" })`:

```gts
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"

const notify = createToaster()

<template>
  <button type="button" {{on "click" this.createEvent}}>Create Event</button>
  <ToastRegion @toaster={{notify}} as |toast item t|>
    <t.Toast>
      <t.Title />
      <t.Description />
    </t.Toast>
  </ToastRegion>
</template>
```

The toaster works from anywhere, not only from components, and returns the toast's id. Place the region once, near your app's root. Without content of its own, it renders each toast's title, description, action and cancel button with unstyled parts.

The examples each call `createToaster()` for a queue of their own and pass it to their region as `@toaster`, so their toasts don't mix.

## Types

`toast.success`, `.info`, `.warning`, `.error` and `.loading` set the toast's type, which the toast exposes as `data-type` for an icon or a color. Errors are announced right away and other types wait for a pause; set `priority` to change that. A loading toast stays until it's updated or dismissed.

```glimmer-ts title="types.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import {
  CircleCheck,
  Info,
  LoaderCircle,
  OctagonX,
  TriangleAlert,
} from "lucide"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { icon } from "./icon"

export default class Types extends Component {
  toast = createToaster()

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  upload = () => new Promise((resolve) => setTimeout(resolve, 2000))

  defaultToast = () => {
    this.toast("Event created")
  }

  successToast = () => {
    this.toast.success("Changes saved")
  }

  infoToast = () => {
    this.toast.info("A new version is available")
  }

  warningToast = () => {
    this.toast.warning("Storage is almost full")
  }

  errorToast = () => {
    this.toast.error("Couldn't save changes")
  }

  loadingToast = () => {
    this.toast.promise(this.upload, {
      loading: "Uploading photos…",
      success: "Photos uploaded",
      error: "Upload failed",
    })
  }

  <template>
    <div data-slot="row">
      <button type="button" {{on "click" this.defaultToast}}>Default</button>
      <button type="button" {{on "click" this.successToast}}>Success</button>
      <button type="button" {{on "click" this.infoToast}}>Info</button>
      <button type="button" {{on "click" this.warningToast}}>Warning</button>
      <button type="button" {{on "click" this.errorToast}}>Error</button>
      <button type="button" {{on "click" this.loadingToast}}>Loading</button>
    </div>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <span data-show="success">{{icon CircleCheck}}</span>
        <span data-show="info">{{icon Info}}</span>
        <span data-show="warning">{{icon TriangleAlert}}</span>
        <span data-show="error">{{icon OctagonX}}</span>
        <span data-show="loading">{{icon LoaderCircle}}</span>
        <t.Title />
      </t.Toast>
    </ToastRegion>
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

Choose a type. Each toast shows its type's icon, and Loading turns into Photos uploaded when it finishes.

## Position

Set the region's `@side` to `top` or `bottom`, and `@align` to `start`, `center` or `end`. Start and end follow the writing direction. A toast can be swiped toward the side and, unless it's centered, toward the end it's aligned to.

```glimmer-ts title="position.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check, ChevronDown } from "lucide"
import { Select } from "ember-ui-sdk/select"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { icon } from "./icon"

const sides = [
  { value: "top", label: "Top" },
  { value: "bottom", label: "Bottom" },
]
const aligns = [
  { value: "start", label: "Start" },
  { value: "center", label: "Center" },
  { value: "end", label: "End" },
]

export default class Position extends Component {
  toast = createToaster()
  sides = sides
  aligns = aligns
  @tracked side: "top" | "bottom" = "bottom"
  @tracked align: "start" | "center" | "end" = "end"

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  onSideChange = (next: string | null) => {
    if (next) this.side = next as "top" | "bottom"
  }

  onAlignChange = (next: string | null) => {
    if (next) this.align = next as "start" | "center" | "end"
  }

  createEvent = () => {
    this.toast("Event created", { description: "Friday, June 12 at 10:00 AM" })
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select @items={{this.sides}} @value={{this.side}} @onValueChange={{this.onSideChange}} as |s|>
          <s.Label>Side</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.sides key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <Select @items={{this.aligns}} @value={{this.align}} @onValueChange={{this.onAlignChange}} as |s|>
          <s.Label>Align</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.aligns key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <button type="button" {{on "click" this.createEvent}}>
        Create Event
      </button>
      <ToastRegion @toaster={{this.toast}} @side={{this.side}} @align={{this.align}} as |toast item t|>
        <t.Toast>
          <div data-slot="stack">
            <t.Title />
            <t.Description />
          </div>
        </t.Toast>
      </ToastRegion>
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

Choose a side and an alignment, then press Create Event and look for the toast at that edge of the page.

## Action and Cancel

Add an `action`, like Undo, and a `cancel` button that dismisses the toast. Their callbacks can update your app. `onDismiss` tells you why the toast is closing, and `details.cancel()` keeps it open; a canceled timeout starts the countdown again.

```glimmer-ts title="action.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { useLog } from "./log"

export default class Action extends Component {
  log = useLog(this)
  toast = createToaster()

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  archive = () => {
    this.toast("Message archived", {
      action: { label: "Undo", onAction: () => this.log("Message restored") },
      cancel: { label: "Dismiss", onCancel: () => this.log("Kept archived") },
      onDismiss: ({ reason }) => this.log(`Closed (${reason})`),
    })
  }

  <template>
    <button type="button" {{on "click" this.archive}}>
      Archive Message
    </button>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <t.Title />
        {{#if toast.cancel}}
          <t.Close
            @action={{toast.cancel.onCancel}}
          >{{toast.cancel.label}}</t.Close>
        {{/if}}
        <t.Action data-variant="solid" />
      </t.Toast>
    </ToastRegion>
  </template>
}
```

Press Archive Message, then choose Undo or Dismiss, swipe the toast away, or let it time out. The console logs why it closed.

## Link

Give an action an `href` to render it as a link. It keeps normal link behavior, including opening in a new tab.

```glimmer-ts title="link.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"

export default class Link extends Component {
  toast = createToaster()

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  sendInvoice = () => {
    this.toast("Invoice sent", {
      description: "Hollis Grant · $240.00",
      action: { label: "View", href: "#" },
    })
  }

  <template>
    <button type="button" {{on "click" this.sendInvoice}}>
      Send Invoice
    </button>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <div data-slot="stack">
          <t.Title />
          <t.Description />
        </div>
        <t.Action data-variant="solid" />
      </t.Toast>
    </ToastRegion>
  </template>
}
```

Press Send Invoice, then follow View in the toast.

## Promise

`toast.promise()` shows a loading toast, then updates the same toast when the promise resolves or rejects. Each message can be a string, options with a description or an action, or a function of the result. A toast dismissed while loading stays closed.

```glimmer-ts title="promise.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"

export default class PromiseExample extends Component {
  toast = createToaster()
  attempts = 0

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  save = () => {
    const succeeds = ++this.attempts % 2 === 1
    return new Promise<void>((resolve, reject) =>
      setTimeout(
        () => (succeeds ? resolve() : reject(new Error("Network error"))),
        1500
      )
    )
  }

  saveChanges = () => {
    this.toast.promise(this.save, {
      loading: "Saving changes…",
      success: "Changes saved",
      error: {
        title: "Couldn't save changes",
        description: "Check your connection and try again.",
        action: { label: "Retry", onAction: this.saveChanges },
      },
    })
  }

  <template>
    <button type="button" {{on "click" this.saveChanges}}>Save Changes</button>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <div data-slot="stack">
          <t.Title />
          <t.Description />
        </div>
        <t.Action data-variant="solid" />
      </t.Toast>
    </ToastRegion>
  </template>
}
```

Press Save Changes to see Saving changes become Changes saved. Press it again for the error, then choose Retry.

## Stacking

`@maxVisible` limits how many toasts show at once, three by default; the rest wait in the queue, and their timers start when they show. The stack expands while the pointer or focus is in it. Set `@expanded={{true}}` to keep it open. [Styling](#styling) shows the CSS that lays out the stack.

```glimmer-ts title="stacking.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { icon } from "./icon"

const notifications = [
  { title: "Event created", description: "Friday, June 12 at 10:00 AM" },
  { title: "Message sent" },
  {
    title: "Hollis Grant joined",
    description: "They can now edit the Launch plan and see its comments.",
  },
  { title: "Changes saved" },
  { title: "Invoice sent", description: "Inès Moreau · $240.00" },
  { title: "Photos uploaded", description: "12 photos added to Summer trip" },
]

export default class Stacking extends Component {
  toast = createToaster()
  count = 0
  @tracked expanded = false

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.expanded = next === true
  }

  addToast = () => {
    this.toast(notifications[this.count++ % notifications.length])
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <label data-slot="label">
          <Checkbox @checked={{this.expanded}} @onCheckedChange={{this.onCheckedChange}} as |c|>
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Always expanded
        </label>
      </div>
      <button type="button" {{on "click" this.addToast}}>Add Toast</button>
      <ToastRegion @toaster={{this.toast}} @maxVisible={{4}} @expanded={{this.expanded}} as |toast item t|>
        <t.Toast>
          <div data-slot="stack">
            <t.Title />
            <t.Description />
          </div>
        </t.Toast>
      </ToastRegion>
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

Press Add Toast a few times, then hover the stack to expand it. Past four toasts, the rest wait their turn. Check Always expanded to keep it open.

## Duration

Set `duration` in milliseconds, on the toaster or on one toast, or `Infinity` for a toast that stays until it's dismissed. The default is five seconds. Timers pause while the pointer or focus is in the region, and while the page is hidden or its window is inactive.

```glimmer-ts title="duration.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"

export default class Duration extends Component {
  toast = createToaster()

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  oneSecond = () => {
    this.toast("Link copied", { duration: 1000 })
  }

  fiveSeconds = () => {
    this.toast("Changes saved")
  }

  untilDismissed = () => {
    this.toast("Your session expires in 5 minutes", {
      duration: Infinity,
      dismissible: false,
      cancel: { label: "Got It" },
    })
  }

  <template>
    <div data-slot="row">
      <button type="button" {{on "click" this.oneSecond}}>1 Second</button>
      <button type="button" {{on "click" this.fiveSeconds}}>5 Seconds</button>
      <button type="button" {{on "click" this.untilDismissed}}>
        Until Dismissed
      </button>
    </div>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <t.Title />
        {{#if toast.cancel}}
          <t.Close data-variant="solid" @action={{toast.cancel.onCancel}}>
            {{toast.cancel.label}}
          </t.Close>
        {{/if}}
      </t.Toast>
    </ToastRegion>
  </template>
}
```

Press each button. Hover a toast to pause its timer. The session toast stays until you press Got It.

## Update and Dismiss

Keep the id the toaster returns to update or dismiss that toast, or pass your own `id`. `toast.update()` returns whether the toast was still there, and `toast.dismiss()` without an id closes every toast.

```glimmer-ts title="update.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { CircleCheck, LoaderCircle } from "lucide"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Update extends Component {
  log = useLog(this)
  toast = createToaster()
  timer?: ReturnType<typeof setInterval>

  willDestroy() {
    super.willDestroy()
    clearInterval(this.timer)
    this.toast.dismiss()
  }

  upload = () => {
    clearInterval(this.timer)
    const id = this.toast.loading("Uploading report.pdf… 0%", { id: "upload" })
    let progress = 0
    this.timer = setInterval(() => {
      progress += 20
      const done = progress >= 100
      const open = this.toast.update(
        id,
        done
          ? { title: "Report uploaded", type: "success" }
          : { title: `Uploading report.pdf… ${progress}%` }
      )
      if (!open) {
        this.log("Upload canceled")
      }
      if (done || !open) {
        clearInterval(this.timer)
      }
    }, 700)
  }

  cancelUpload = () => {
    this.toast.dismiss("upload")
  }

  dismissAll = () => {
    this.toast.dismiss()
  }

  <template>
    <div data-slot="row">
      <button type="button" {{on "click" this.upload}}>Upload Report</button>
      <button type="button" {{on "click" this.cancelUpload}}>Cancel Upload</button>
      <button type="button" {{on "click" this.dismissAll}}>Dismiss All</button>
    </div>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <span data-show="success">{{icon CircleCheck}}</span>
        <span data-show="loading">{{icon LoaderCircle}}</span>
        <t.Title />
      </t.Toast>
    </ToastRegion>
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

Press Upload Report and watch one toast count up to Report uploaded. Cancel Upload closes it early, and Dismiss All clears every toast.

## Async Action

Return a promise from an action to keep the toast open while it runs. The action's state has `pending` while it runs and `error` if it fails, so the button can say Restoring… or offer a retry, and presses are ignored until it settles. See [Button](./button.md#changes-after-an-await) for changes made after an `await`.

```glimmer-ts title="async-action.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { useLog } from "./log"

const wait = (ms: number) =>
  new Promise<void>((resolve) => setTimeout(resolve, ms))

export default class AsyncAction extends Component {
  log = useLog(this)
  toast = createToaster({ duration: 6000 })

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  deleteFile = () => {
    this.toast("File deleted", {
      description: "Q3 report.pdf",
      action: {
        label: "Undo",
        onAction: async () => {
          await wait(1500)
          this.log("Q3 report.pdf restored")
        },
      },
    })
  }

  <template>
    <button type="button" {{on "click" this.deleteFile}}>
      Delete File
    </button>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <div data-slot="stack">
          <t.Title />
          <t.Description />
        </div>
        <t.Action data-variant="solid" as |action|>
          {{#if action.state.pending}}Restoring…{{else if
            action.state.error
          }}Retry{{else}}Undo{{/if}}
        </t.Action>
      </t.Toast>
    </ToastRegion>
  </template>
}
```

Press Delete File, then Undo. The button shows Restoring… until the restore finishes, then the toast closes.

## Keyboard Shortcut

F6 moves focus to the newest toast and back. Set the region's `@shortcut` to use another key, or `null` to turn it off. The region advertises it through `aria-keyshortcuts`.

```glimmer-ts title="shortcut.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { useLog } from "./log"

export default class Shortcut extends Component {
  log = useLog(this)
  toast = createToaster({ duration: 10000 })

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  sendMessage = () => {
    this.toast("Message sent", {
      action: { label: "Undo", onAction: () => this.log("Message unsent") },
    })
  }

  <template>
    <button type="button" {{on "click" this.sendMessage}}>
      Send Message
    </button>
    <ToastRegion @toaster={{this.toast}} @shortcut="alt+t" aria-label="Alerts" as |toast item t|>
      <t.Toast>
        <t.Title />
        <t.Action data-variant="solid" />
      </t.Toast>
    </ToastRegion>
  </template>
}
```

Press Send Message, then Alt+T (Option+T on a Mac) to focus the toast. Press Escape to dismiss it, or Alt+T again to go back.

## Overlay Host and Confirm

Instead of placing a region, render `OverlayHost` from `ember-ui-sdk/overlays` once near your app's root. It renders the toaster's region, and `confirm()` questions as alert dialogs. A region you place yourself takes over from the host for its toaster. [Alert Dialog](./alert-dialog.md#confirm-from-anywhere) covers `confirm()`.

```glimmer-ts title="overlay-host.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { fn } from "@ember/helper"
import { AlertDialog, createConfirm } from "ember-ui-sdk/alert-dialog"
import { createOverlays, OverlayHost } from "ember-ui-sdk/overlays"
import { createToaster } from "ember-ui-sdk/toast"
import { icon } from "./icon"
import { CircleCheck } from "lucide"

const initial = ["Acme", "Globex", "Initech"]

export default class OverlayHostExample extends Component {
  overlays = createOverlays()
  toast = createToaster({ overlays: this.overlays })
  confirm = createConfirm({ overlays: this.overlays })
  @tracked projects = initial

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  remove = async (name: string, event: Event) => {
    const button = event.currentTarget as HTMLButtonElement
    const confirmed = await this.confirm({
      title: `Delete ${name}?`,
      description:
        "The project and its files will be deleted for everyone on your team.",
      confirmLabel: "Delete",
      cancelLabel: "Cancel",
    })
    if (!confirmed) {
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
    this.toast.success(`${name} deleted`, { priority: "assertive" })
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
      <OverlayHost @overlays={{this.overlays}} as |toast item t|>
        <t.Toast>
          <span data-show="success">{{icon CircleCheck}}</span>
          <t.Title />
        </t.Toast>
      </OverlayHost>
      <AlertDialog @controller={{this.confirm.controller}} as |d|>
        <d.Backdrop />
        <d.Content as |content|>
          <div data-slot="stack">
            <d.Title>{{content.state.payload.title}}</d.Title>
            <d.Description>{{content.state.payload.description}}</d.Description>
          </div>
          <div data-slot="row">
            <d.Close>{{content.state.payload.cancelLabel}}</d.Close>
            <d.Close data-variant="solid" @value="confirm">
              {{content.state.payload.confirmLabel}}
            </d.Close>
          </div>
        </d.Content>
      </AlertDialog>
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

Press Delete on a project and confirm. The row goes away and a toast says so. Reset Projects brings them back.

## Custom Rendering

Pass anything else your toast needs in `data`, and read it from the toast the region's block receives. Every part also takes `@render={{true}}`, which yields `{ part, state }` so you can bind the part to your own element.

```glimmer-ts title="custom.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { X } from "lucide"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Custom extends Component {
  log = useLog(this)
  toast = createToaster()

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  newMessage = () => {
    this.toast({
      title: "Hollis Grant",
      description: "Can you review the draft?",
      data: { initials: "HG" },
      action: {
        label: "Reply",
        onAction: () => this.log("Replying to Hollis Grant"),
      },
    })
  }

  inertOf = (state: { leaving: boolean; expanded: boolean; index: number }) =>
    state.leaving || (!state.expanded && state.index > 0) ? true : undefined

  <template>
    <button type="button" {{on "click" this.newMessage}}>
      New Message
    </button>
    <ToastRegion @toaster={{this.toast}} aria-label="Messages" as |toast item t|>
      <t.Toast @render={{true}} as |p|>
        <li {{p.part}} inert={{this.inertOf p.state}}>
          <span data-slot="media">{{toast.data.initials}}</span>
          <div data-slot="stack">
            <t.Title />
            <t.Description />
          </div>
          <t.Action data-variant="solid" />
          <t.Close aria-label="Close">{{icon X}}</t.Close>
        </li>
      </t.Toast>
    </ToastRegion>
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

Press New Message to show a toast with Hollis Grant's initials. Choose Reply or close it.

## Styling

Toasts are unstyled, and the region and its toasts carry what you need to animate a stack:

- **The stack.** The region sets `--toast-front-height`, the newest toast's height, and `--toast-stack-height`, all of them added up. Each toast gets `--toast-index`, 0 for the newest, `--toast-offset`, the height of the toasts in front of it, and `--toast-height`, its own height. Position the toasts absolutely in the region and set `height: var(--toast-height)` so changes in height animate.
- **Collapsed and expanded.** `data-front` marks the newest toast. While the stack is collapsed, clip the toasts behind it to `--toast-front-height` and peek them out by their index. While it's expanded, the region and its toasts get `data-expanded`; move each toast by its `--toast-offset`.
- **Swiping.** While a toast is swiped it gets `data-swiping`, and `--toast-swipe-x` and `--toast-swipe-y` hold how far it moved. Translate it by them and turn off transitions. When a swipe dismisses it, `data-swipe-direction` says which way, so it can leave in that direction. A mouse drag that starts on selectable text selects it, so set `user-select: none` on toasts to swipe them from anywhere.
- **Entering and leaving.** A toast has `data-starting-style` for its first frame and `data-ending-style` while it leaves, and stays mounted until its transitions finish.

A stack at the bottom of the page, in plain CSS:

```css
[data-slot="toast-region"] {
  width: 356px;
  height: var(--toast-front-height);
}

[data-slot="toast-region"][data-expanded] {
  height: calc(var(--toast-stack-height) + (var(--toast-count) - 1) * 12px);
}

[data-slot="toast"] {
  --y: calc(var(--toast-index) * -12px);
  position: absolute;
  inset-inline: 0;
  bottom: 0;
  z-index: calc(100 - var(--toast-index));
  overflow: hidden;
  height: var(--toast-height);
  translate: var(--toast-swipe-x, 0px)
    calc(var(--y) + var(--toast-swipe-y, 0px));
  scale: calc(1 - var(--toast-index) * 0.05);
  transition-property: translate, scale, opacity, height;
  transition-duration: 400ms;
  user-select: none;
}

[data-slot="toast"]:not([data-front], [data-expanded]) {
  height: var(--toast-front-height);
}

[data-slot="toast"][data-expanded] {
  --y: calc(-1 * (var(--toast-offset) + var(--toast-index) * 12px));
  scale: 1;
}

[data-slot="toast"][data-starting-style] {
  transition: none;
}

[data-slot="toast"][data-starting-style][data-front] {
  --y: 100%;
}

[data-slot="toast"]:is(
  [data-starting-style]:not([data-front]),
  [data-ending-style]
) {
  opacity: 0;
}

[data-slot="toast"][data-swiping] {
  transition: none;
}

@media (prefers-reduced-motion: reduce) {
  [data-slot="toast"] {
    transition-property: opacity;
  }
}
```

Each part has a `data-slot`, such as `toast`, and its state attributes are listed under [Data Attributes](#data-attributes).

### ToastRegion
- `--toast-front-height`: The newest toast's height. Clip the toasts behind it to it in a collapsed stack.
- `--toast-stack-height`: The toasts' heights added up, for the height of an expanded stack.
- `--toast-count`: How many toasts show.
- `--keyboard-inset`: How many pixels of the page the on-screen keyboard covers, 0 without one.
- `--visual-viewport-width`: The width of the part of the page you can see.
- `--visual-viewport-height`: The height of the part of the page you can see, above the keyboard.
- `--visual-viewport-top`: How far the part of the page you can see is scrolled from the top of the layout, as when the keyboard pushes it up.

### Toast
- `--toast-index`: The toast's place in the stack, 0 for the newest. A closing toast keeps its place.
- `--toast-offset`: The height of the toasts in front of this one, in pixels. Add gaps with `--toast-index` to place an expanded stack.
- `--toast-height`: The toast's own height with its content laid out freely, whatever height it's given. Set it as the height to animate the stack.
- `--toast-swipe-x`: How far a swipe moved the toast sideways, in pixels. Translate the toast by it.
- `--toast-swipe-y`: How far a swipe moved the toast up or down, in pixels.

## Data Attributes

`ToastTitle` and `ToastDescription` have no state attributes. `ToastClose` gets `data-pending`, like `ToastAction`, while a Promise from its `action` runs.

### ToastRegion
`[data-slot="toast-region"]`

- `data-side` (`top`, `bottom`): The edge of the viewport the region sits on.
- `data-align` (`start`, `center`, `end`): Where along that edge.
- `data-expanded`: Present while the stack is expanded: hovered, focused, or always with `expanded`.
- `data-keyboard`: Present on the region while the on-screen keyboard covers part of the page.

### Toast
`[data-slot="toast"]`

- `data-type` (`default`, `success`, `error`, `info`, `warning`, `loading`): What the toast is about.
- `data-front`: Present on the newest toast, in front of a collapsed stack. A closing toast keeps it while it animates out.
- `data-expanded`: Present while the stack is expanded: hovered, focused, or always with `expanded`.
- `data-starting-style`: Present for a toast's first frame. Style the state you animate from.
- `data-ending-style`: Present while a toast animates out. Style the state you animate to.

### ToastAction
`[data-slot="toast-action"]`

- `data-pending`: Present on an action or close button while its handler's Promise runs.

## API Reference

### Toast

- `id?` (`string`): Reuses a toast: a toast with this id that's still showing is updated instead of added again.
- `title?` (`Content`): The main message.
- `description?` (`Content`): More detail, under the title.
- `type?` (`ToastType`): What it's about, for styling through `data-type`, and for how it's announced.
- `duration?` (`number`): How long it shows, in ms, while nothing pauses it. `Infinity` keeps it until dismissed.
- `priority?` (`"assertive" | "polite"`): How screen readers announce it: `"polite"` waits for a pause, `"assertive"` interrupts.
- `action?` (`ToastAction<Content>`): A button that does something, like Undo.
- `cancel?` (`ToastCancel<Content>`): A button that dismisses it, like Cancel.
- `dismissible?` (`boolean`): Whether the user can dismiss it: swiping, Escape and Close parts. Timers and `dismiss()` still close it.
- `data?` (`unknown`): Anything else, for your own rendering, like an avatar.
- `onDismiss?` (`((details: ToastDismissDetails) => void)`): Runs when it closes, with why. Calling `details.cancel()` keeps it.

`toast(message, options)` and `toast(options)` return the toast's id. `toast.success`, `.info`, `.warning`, `.error` and `.loading` set the type. `toast.promise(promise, { loading, success, error })` returns the id too, and `toast.update(id, options)` returns whether the toast was still there. `toast.dismiss(id)` closes one, and `toast.dismiss()` every one.

### Actions

- `label` (`Content`): The button's text.
- `onAction?` (`((event: Event | undefined, details: ToastActionDetails) => unknown)`): Runs when it's pressed. A returned Promise marks the action pending, then dismisses the toast once it resolves. A rejection keeps the toast. `details.source` says how it was pressed, for changes made after an `await`.
- `href?` (`string`): Makes the action a link.
- `dismiss?` (`boolean`): Whether pressing it dismisses the toast.

- `label` (`Content`): The button's text.
- `onCancel?` (`((event: Event | undefined, details: ToastActionDetails) => void)`): Runs when it's pressed, before the toast closes. `details.source` says how it was pressed.

### ToastRegion

- `toaster?` (`Toaster<any>`): The queue it shows. A second toaster, from `createToaster()`, gives a second region its own toasts.
- `side?` (`"bottom" | "top"`): The edge of the viewport it sits on. Swiping toward it dismisses a toast.
- `align?` (`"center" | "end" | "start"`): Where along that edge. `"start"` and `"end"` follow the writing direction, and swiping toward them dismisses too.
- `maxVisible?` (`number`): How many toasts show at once. Older ones wait, with their timers stopped, until there's room.
- `expanded?` (`boolean`): Whether the stack is always expanded. Otherwise it expands while the pointer or focus is in it.
- `shortcut?` (`string | null`): The key that moves focus into the region and back, like `"F6"` or `"alt+t"`. `null` turns it off.
- `pendingAnnouncement?` (`string`): What screen readers hear once a toast's action or close button has been pending for a second, so a slow action doesn't pass in silence. Set it in the page's language. An empty string says nothing.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### ToastAction

- `onAction?` (`((event: Event | undefined, details: ToastActionDetails) => unknown)`): Runs when it's pressed, instead of the toast's own `action.onAction`. A returned Promise marks it pending. `details.source` says how it was pressed, for changes made after an `await`.
- `dismiss?` (`boolean`): Whether pressing it dismisses the toast.

### ToastClose

- `action?` (`((event: Event | undefined, details: ToastActionDetails) => unknown)`): Runs before the toast closes. A returned Promise keeps it open and the button pending until it settles. `details.source` says how it was pressed, for changes made after an `await`.

### Confirm

- `title` (`string`): The question, like "Delete this project?".
- `description?` (`string`): What agreeing does.
- `confirmLabel?` (`string`): The agreeing button's text.
- `cancelLabel?` (`string`): The other button's text.

### State

`ToastRegion`:

- `side` (`"top" | "bottom"`): The edge it sits on.
- `align` (`"start" | "center" | "end"`): Where along that edge.
- `expanded` (`boolean`): Whether the stack is expanded.
- `toasts` (`readonly ToastItem<unknown>[]`): The toasts to render, newest first, including ones animating out.

`Toast`:

- `type` (`ToastType`): What it's about.
- `index` (`number`): Its place in the stack, 0 for the newest.
- `front` (`boolean`): Whether it's the newest, on top of a collapsed stack. A closing toast keeps it.
- `expanded` (`boolean`): Whether the stack is expanded.
- `leaving` (`boolean`): Whether it's animating out.

`ToastAction` and `ToastClose`:

- `pending` (`boolean`): Whether a Promise its handler returned is still running.
- `error` (`unknown`): Why its handler failed, until it's pressed again.

### Reasons

- `timeout` (`none`): A duration ran out, like a toast's, or a rotating carousel's interval.
- `close-press` (`MouseEvent | KeyboardEvent | SubmitEvent`): A Close part was pressed, or a form with `method="dialog"` was submitted.
- `swipe` (`TouchEvent | PointerEvent`): A swipe gesture: a finger, mouse or pen dragged it.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `action` (`MouseEvent | KeyboardEvent`): A Close part's `action` finished.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

## Accessibility

Toasts are announced through shared [live regions](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Guides/Live_regions), once each, without making the visible region live: politely by default and assertively for errors. While it has toasts, the region is a landmark named Notifications; set `aria-label` to name it in the page's language. Keep messages short, and use `duration: Infinity` for one that has to stay available.

### Keyboard

F6, or the region's `@shortcut`, moves focus to the newest toast, and pressing it again returns focus to where it came from. Tab moves through the toasts and their buttons, and Tab past the last one goes back too. Escape dismisses the focused toast; focus then moves to the next toast, or back where it came from after the last one. The region stays reachable while a modal dialog is open, and its timers pause while focus is inside.

### Tested Behavior

Every line below is an automated test.

**Showing**

- A toast shows its title, description and action in the Notifications region.
- Newer toasts come first.
- The newest toast is marked as the front one.
- Each toast says what it's about through data-type.
- The region sits on its side and alignment.
- It shows above everything, in the top layer.
- A promise toast loads, then shows the result.
- A toast with an id that's showing is updated in place.

**Closing**

- A toast closes after its duration.
- Infinity keeps it until it's dismissed.
- The Dismiss button closes it.
- The action runs and closes it.
- Escape on a focused toast closes it.
- A closing toast stays while it animates out.
- A toast that can't be dismissed ignores Escape.

**Timers**

- Hovering the region pauses its timers, and leaving resumes them.
- Focus in the region pauses its timers.

**Keyboard**

- F6 moves focus to the newest toast, and again back where it was.
- The shortcut is configurable.
- The region names its shortcut.
- When the focused toast closes, focus goes to the next one, then back where it was.

**Stacking**

- Only maxVisible toasts show; the rest wait for room.
- The stack expands while hovered or focused.
- Expanded keeps the stack expanded.
- Toasts measure their heights and offsets for the stack.
- A toast measures its content's height, whatever height it's given.
- A toast given its measured height animates to a new one when its content changes.
- A toast measures again when a child, its class or its padding changes.
- A toast closing from the front stays in front while it animates out.

**Swiping**

- Swiping toward the region's side dismisses.
- Swiping toward the aligned edge dismisses too.
- A short swipe snaps back.
- Swiping away from the side never dismisses.
- A toast that can't be dismissed doesn't swipe.

**Over a modal dialog**

- A toast shown from a modal dialog is visible, usable and above it.

**Updates after closing**

- A promise toast dismissed while loading stays closed.
- An update after a toast closed never brings it back.

**More pausing and keys**

- The window losing focus pauses timers, and getting it back resumes them.
- F6 does nothing while there are no toasts, so the browser keeps it.
- A toast on the top edge swipes up, and a swipe down snaps back.

Runs in React, Vue and web components.

Also tested:

**Enhancements**

- Update() says whether the toast was still there.
- A toast beyond maxVisible never expires unseen.
- There's no empty Notifications landmark.
- Focus never falls to the page when a toast focused by the mouse closes.
- A pending action shows it and holds the toast open until it settles.

**Pausing**

- A hidden page pauses timers.
- Pause reasons hold separately: getting the window back doesn't resume while focus is in the region.

**Announcements**

- The live regions exist before the first toast.
- A toast is announced politely, with its title and description.
- An error is announced assertively.
- Toasts that arrive together are announced together.
- The visible region isn't a live region, so nothing is read twice.

**The shortcut**

- F6 works from a text field and types nothing.
- A shortcut of null turns it off.
- Tab past the last toast goes back where F6 came from.

**Over modal dialogs**

- F6 reaches the toasts from inside a modal dialog, and goes back into it.
- Escape on a toast closes the toast, not the dialog beneath.
- A dialog opened after a toast doesn't cover it, and pressing it doesn't close the dialog.

**Swiping**

- Dragging across a toast's text with a mouse selects it instead of dismissing.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while reaching a toast with F6 and leaving it.

Runs in React, Vue and web components.
