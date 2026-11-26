# Popover

Edit or explore something beside its trigger.

A popover keeps a small task close to the thing it belongs to. Put fields, buttons, or other interactive content inside; it handles placement, focus, and dismissal.

```glimmer-ts title="basic.gts"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Popover } from "ember-ui-sdk/popover"

<template>
  <Popover as |p|>
    <p.Trigger>Share</p.Trigger>
    <p.Content>
      <p.Title>Share this document</p.Title>
      <p.Description>Anyone with the link can view it.</p.Description>
      <Field as |f|>
        <f.Label>Link</f.Label>
        <Input
          @field={{f.field}}
          readonly
          @defaultValue="acme.app/d/q3-roadmap"
        />
      </Field>
      <div data-slot="row">
        <p.Close>Cancel</p.Close>
        <p.Close data-variant="solid">Copy Link</p.Close>
      </div>
    </p.Content>
  </Popover>
</template>
```

Press Share to open the popover, then close it with Cancel, Copy Link, Escape, or a press outside. Focus returns to Share.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Popover`:

```text
Popover as |p|
├── p.Trigger
└── p.Content
    ├── p.Arrow
    ├── p.Title
    ├── p.Description
    └── p.Close
```

The content has the dialog role. Its title names it and its description adds context. The arrow is optional, and a popover can have several Close parts. The trigger can live inside the popover or [connect from elsewhere](#triggers-outside-the-popover).

## Usage

Import the root and use the parts it yields:

```gts
import { Popover } from "ember-ui-sdk/popover"

<template>
  <Popover as |p|>
    <p.Trigger>Share</p.Trigger>
    <p.Content>
      <p.Title>Share this document</p.Title>
      <p.Description>Anyone with the link can view it.</p.Description>
      <p.Close>Done</p.Close>
    </p.Content>
  </Popover>
</template>
```

## Forms

An ordinary form can save a value and then close the popover. Focus starts on the first field and returns to the trigger when the task finishes. A form with `method="dialog"` closes on submission and returns its submit button's value; the [row editor](#triggers-outside-the-popover) shows that version. Inside another form, pass `@container` so the popover's form doesn't nest in it.

```glimmer-ts title="form.gts"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Popover } from "ember-ui-sdk/popover"
import { useLog } from "./log"

export default class Form extends Component {
  log = useLog(this)
  @tracked open = false

  onOpenChange = (open: boolean) => {
    this.open = open
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const form = event.currentTarget as HTMLFormElement
    this.log(`Saved ${new FormData(form).get("name")}`)
    this.open = false
  }

  <template>
    <Popover @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |p|>
      <p.Trigger>Edit Profile</p.Trigger>
      <p.Content>
        <p.Title>Edit profile</p.Title>
        <p.Description>Your name shows on your posts.</p.Description>
        <form data-slot="stack" {{on "submit" this.onSubmit}}>
          <Field as |f|>
            <f.Label>Name</f.Label>
            <Input @field={{f.field}} name="name" required @defaultValue="Hollis Grant" />
          </Field>
          <div data-slot="row">
            <p.Close>Cancel</p.Close>
            <button type="submit" data-variant="solid">Save</button>
          </div>
        </form>
      </p.Content>
    </Popover>
  </template>
}
```

Open Edit Profile, change the name, and press Save. The popover closes and the console logs the saved name.

## Keep It Open While Editing

Set `@dismissible` to false while there is unsaved work. Escape and outside presses then keep the popover open and report `@onDismissAttempt`, so you can ask whether to discard it. Focus leaving is refused quietly. The trigger, Close parts, and controller can still close it.

```glimmer-ts title="draft.gts"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { Popover } from "ember-ui-sdk/popover"
import { useLog } from "./log"

export default class Draft extends Component {
  log = useLog(this)
  @tracked open = false
  @tracked note = ""
  @tracked asking = false

  get dismissible() {
    return this.note === ""
  }

  close = () => {
    this.open = false
    this.note = ""
    this.asking = false
  }

  onOpenChange = (next: boolean) => {
    if (next) {
      this.open = true
    } else {
      this.close()
    }
  }

  onDismissAttempt = (details: { reason: string }) => {
    this.log(`Kept open (${details.reason})`)
    this.asking = true
  }

  onInput = (event: Event) => {
    this.note = (event.currentTarget as HTMLTextAreaElement).value
  }

  keepEditing = (event: MouseEvent) => {
    this.asking = false
    const content = (event.currentTarget as Element).closest(
      '[data-slot="popover-content"]'
    )
    content?.querySelector("textarea")?.focus()
  }

  discard = () => {
    this.log("Discarded the note")
    this.close()
  }

  save = () => {
    this.log(this.note ? "Saved the note" : "Nothing to save")
    this.close()
  }

  <template>
    <Popover
      @open={{this.open}}
      @onOpenChange={{this.onOpenChange}}
      @dismissible={{this.dismissible}}
      @onDismissAttempt={{this.onDismissAttempt}}
      as |p|
    >
      <p.Trigger>Add Note</p.Trigger>
      <p.Content>
        <p.Title>Add a note</p.Title>
        <p.Description>Only your team can see it.</p.Description>
        <Field as |f|>
          <f.Label>Note</f.Label>
          <f.Control @render={{true}} as |control|>
            <textarea
              value={{this.note}}
              placeholder="Call the printer about the proofs."
              {{on "input" this.onInput}}
              {{control.part}}
            ></textarea>
          </f.Control>
        </Field>
        {{#if this.asking}}
          <div data-slot="row" role="alert">
            Discard your note?
            <div data-slot="row">
              <button type="button" data-size="sm" {{on "click" this.keepEditing}}>
                Keep Editing
              </button>
              <button type="button" data-size="sm" data-variant="solid" {{on "click" this.discard}}>
                Discard
              </button>
            </div>
          </div>
        {{else}}
          <div data-slot="row">
            <p.Close>Cancel</p.Close>
            <button type="button" data-variant="solid" {{on "click" this.save}}>
              Save
            </button>
          </div>
        {{/if}}
      </p.Content>
    </Popover>
  </template>
}
```

Open Add Note, type something, then press Escape or click outside. Keep Editing returns to the field; Discard closes the popover and clears the note.

## Placement

`@side` chooses an edge of the trigger, `bottom` by default, and `@align` lines the popover up with its start, center, or end. Start and end follow text direction. The popover flips or shifts when the requested position doesn't fit, and `data-side` and `data-align` report where it landed.

```glimmer-ts title="placement.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Popover } from "ember-ui-sdk/popover"
import { Select } from "ember-ui-sdk/select"
import { icon } from "./icon"

const sides = [
  { value: "top", label: "Top" },
  { value: "right", label: "Right" },
  { value: "bottom", label: "Bottom" },
  { value: "left", label: "Left" },
]
const aligns = [
  { value: "start", label: "Start" },
  { value: "center", label: "Center" },
  { value: "end", label: "End" },
]

type Side = "top" | "right" | "bottom" | "left"
type Align = "start" | "center" | "end"

export default class Placement extends Component {
  @tracked side: Side = "bottom"
  @tracked align: Align = "center"

  onSideChange = (next: string | null) => {
    if (next) {
      this.side = next as Side
    }
  }

  onAlignChange = (next: string | null) => {
    if (next) {
      this.align = next as Align
    }
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select @items={{sides}} @value={{this.side}} @onValueChange={{this.onSideChange}} as |s|>
          <s.Label>Side</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each sides key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <Select @items={{aligns}} @value={{this.align}} @onValueChange={{this.onAlignChange}} as |s|>
          <s.Label>Align</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each aligns key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <Popover as |p|>
        <p.Trigger>Delivery</p.Trigger>
        <p.Content @side={{this.side}} @align={{this.align}} @sideOffset={{8}}>
          <p.Title>Delivery window</p.Title>
          <p.Description>Arrives Tuesday between 9 AM and noon.</p.Description>
        </p.Content>
      </Popover>
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

Choose a side and an alignment, then open Delivery. Near a window edge, the popover flips or shifts to stay visible.

## Offsets

`@sideOffset` is the gap to the trigger, 4 pixels by default. `@alignOffset` shifts the popover along the trigger's edge, and `@collisionPadding` is the space kept from the edges of the window.

```glimmer-ts title="offsets.gts"
import { fn } from "@ember/helper"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Popover } from "ember-ui-sdk/popover"
import { Select } from "ember-ui-sdk/select"
import { icon } from "./icon"

const choices = [
  { name: "sideOffset", label: "Side offset", values: ["4", "8", "16", "24"] },
  { name: "alignOffset", label: "Align offset", values: ["-16", "0", "16"] },
  {
    name: "collisionPadding",
    label: "Collision padding",
    values: ["8", "24", "48"],
  },
] as const

type Name = (typeof choices)[number]["name"]

export default class Offsets extends Component {
  @tracked offsets: Record<Name, string> = {
    sideOffset: "8",
    alignOffset: "0",
    collisionPadding: "8",
  }

  valueOf = (name: Name) => this.offsets[name]

  numberOf = (name: Name) => Number(this.offsets[name])

  onValueChange = (name: Name, next: string | null) => {
    if (next) {
      this.offsets = { ...this.offsets, [name]: next }
    }
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        {{#each choices key="name" as |choice|}}
          <Select
            @items={{choice.values}}
            @value={{this.valueOf choice.name}}
            @onValueChange={{fn this.onValueChange choice.name}}
            as |s|
          >
            <s.Label>{{choice.label}}</s.Label>
            <s.Trigger>
              <s.Value />
              {{icon ChevronDown}}
            </s.Trigger>
            <s.Content>
              {{#each choice.values key="@identity" as |value|}}
                <s.Item @value={{value}} as |item|>
                  {{value}}px
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </s.Item>
              {{/each}}
            </s.Content>
          </Select>
        {{/each}}
      </div>
      <Popover as |p|>
        <p.Trigger>Delivery</p.Trigger>
        <p.Content
          @align="start"
          @sideOffset={{this.numberOf "sideOffset"}}
          @alignOffset={{this.numberOf "alignOffset"}}
          @collisionPadding={{this.numberOf "collisionPadding"}}
        >
          <p.Title>Delivery window</p.Title>
          <p.Description>Arrives Tuesday between 9 AM and noon.</p.Description>
        </p.Content>
      </Popover>
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

Change the offsets and the padding, then open Delivery. The popover moves away from the trigger and along it.

## Arrow

`p.Arrow` follows the side the popover actually uses, including after a flip, and gets the same `data-side`. `@arrowPadding` keeps it away from the corners; `data-arrow-clamped` tells you when it can't point at the middle of the trigger. This example cancels dismissal when you press its side buttons, so the open arrow can move.

```glimmer-ts title="arrow.gts"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { CircleQuestionMark } from "lucide"
import { Popover } from "ember-ui-sdk/popover"
import { icon } from "./icon"

const sides = [
  { value: "top", label: "Top" },
  { value: "right", label: "Right" },
  { value: "bottom", label: "Bottom" },
  { value: "left", label: "Left" },
] as const

type Side = (typeof sides)[number]["value"]

type Details = { reason: string; event?: Event; cancel: () => void }

export default class Arrow extends Component {
  @tracked open = false
  @tracked side: Side = "bottom"

  setSide = (side: Side) => {
    this.side = side
  }

  isPressed = (side: Side) => String(this.side === side)

  onOpenChange = (next: boolean, details: Details) => {
    const target = details.event?.target
    const inControls =
      target instanceof Element && target.closest('[data-slot="controls"]')
    if (inControls && details.reason !== "escape-key") {
      return details.cancel()
    }
    this.open = next
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls" role="group" aria-label="Side">
        {{#each sides key="value" as |option|}}
          <button
            type="button"
            data-size="sm"
            aria-pressed={{this.isPressed option.value}}
            {{on "click" (fn this.setSide option.value)}}
          >
            {{option.label}}
          </button>
        {{/each}}
      </div>
      <Popover @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |p|>
        <p.Trigger aria-label="Help">{{icon CircleQuestionMark}}</p.Trigger>
        <p.Content @side={{this.side}} @sideOffset={{10}} @arrowPadding={{12}}>
          <p.Arrow />
          <p.Title>Keyboard shortcuts</p.Title>
          <p.Description>Press ? anywhere to see them all.</p.Description>
        </p.Content>
      </Popover>
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

Open Help, then press Top, Right, Bottom, or Left. The popover stays open while it and its arrow move to that side.

Keep overflow visible around an arrow that extends outside the panel. If the body needs to scroll, put scrolling on an inner element. You can also draw an arrow with `::before`, using `data-side` and `--arrow-offset` to position it.

## Anchor

Set `@anchor` to position against something other than the trigger. It accepts an element, a selector, a point such as `{ x, y }`, or an object with `getBoundingClientRect()`, such as a text range. The position is read again as the anchor moves.

```glimmer-ts title="anchor.gts"
import { Check, SlidersHorizontal } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Popover } from "ember-ui-sdk/popover"
import { icon } from "./icon"

const types = [
  { label: "Documents", checked: true },
  { label: "Images", checked: false },
  { label: "Shared with me", checked: true },
]

<template>
  <div data-slot="row">
    <input id="file-search" type="search" placeholder="Search files…" aria-label="Search files" />
    <Popover as |p|>
      <p.Trigger aria-label="Search filters">{{icon
          SlidersHorizontal
        }}</p.Trigger>
      <p.Content @anchor="#file-search" @align="start" @sideOffset={{8}}>
        <p.Title>Filters</p.Title>
        <p.Description>Show only these kinds of files.</p.Description>
        <div data-slot="stack">
          {{#each types key="label" as |type|}}
            <label data-slot="label">
              <Checkbox @defaultChecked={{type.checked}} as |c|>
                <c.Indicator>{{icon Check}}</c.Indicator>
              </Checkbox>
              {{type.label}}
            </label>
          {{/each}}
        </div>
        <div data-slot="row">
          <p.Close>Cancel</p.Close>
          <p.Close data-variant="solid">Apply</p.Close>
        </div>
      </p.Content>
    </Popover>
  </div>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Press the filters button. The popover lines up with the search field instead of the small button beside it.

## Modal

`@modal` controls how the popover shares the page:

- `false`, the default, leaves the page usable, and focus leaving the popover closes it.
- `"trap-focus"` keeps Tab inside while the page can still scroll and receive clicks.
- `true` also makes the rest of the page inert and locks scrolling.

```glimmer-ts title="modal.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Popover } from "ember-ui-sdk/popover"
import { Select } from "ember-ui-sdk/select"
import { Textarea } from "ember-ui-sdk/textarea"
import { icon } from "./icon"

const modes = [
  { value: "false", label: "Non-modal" },
  { value: "trap-focus", label: "Trap focus" },
  { value: "true", label: "Modal" },
]

type Mode = "false" | "trap-focus" | "true"

const notes = {
  false: "Tab can leave, and focus leaving closes it.",
  "trap-focus": "Tab stays inside. The page still scrolls and takes clicks.",
  true: "Tab stays inside. The page is inert and doesn't scroll.",
}

export default class Modal extends Component {
  @tracked mode: Mode = "false"

  get modal() {
    return this.mode === "true"
      ? true
      : this.mode === "false"
        ? false
        : "trap-focus"
  }

  get note() {
    return notes[this.mode]
  }

  onValueChange = (next: string | null) => {
    if (next) {
      this.mode = next as Mode
    }
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select @items={{modes}} @value={{this.mode}} @onValueChange={{this.onValueChange}} as |s|>
          <s.Label>Modal</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each modes key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <Popover @modal={{this.modal}} as |p|>
        <p.Trigger>Add Comment</p.Trigger>
        <p.Content>
          <p.Title>Add a comment</p.Title>
          <p.Description>{{this.note}}</p.Description>
          <Field as |f|>
            <f.Label>Comment</f.Label>
            <Textarea @field={{f.field}} @defaultValue="Looks good to me." />
          </Field>
          <div data-slot="row">
            <p.Close>Cancel</p.Close>
            <p.Close data-variant="solid">Comment</p.Close>
          </div>
        </p.Content>
      </Popover>
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

Choose a mode, open Add Comment, and try Tab or clicking the page.

## Focus

Use `@initialFocus` to choose the first focused element, or `"none"` to leave focus where it is. `@finalFocus` controls where focus returns. Opening on hover leaves focus alone; opening with touch focuses the panel itself so no on-screen keyboard appears.

```glimmer-ts title="focus.gts"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Popover } from "ember-ui-sdk/popover"

<template>
  <div data-slot="row">
    <Popover as |p|>
      <p.Trigger>Rename</p.Trigger>
      <p.Content>
        <p.Title>Rename file</p.Title>
        <p.Description>Focus starts in the first field.</p.Description>
        <Field as |f|>
          <f.Label>Name</f.Label>
          <Input @field={{f.field}} @defaultValue="Q3 roadmap.pdf" />
        </Field>
        <div data-slot="row">
          <p.Close>Cancel</p.Close>
          <p.Close data-variant="solid">Save</p.Close>
        </div>
      </p.Content>
    </Popover>
    <Popover as |p|>
      <p.Trigger>Publish</p.Trigger>
      <p.Content @initialFocus="[data-autofocus]">
        <p.Title>Publish changes?</p.Title>
        <p.Description>Focus starts on Publish, not Cancel.</p.Description>
        <div data-slot="row">
          <p.Close>Cancel</p.Close>
          <p.Close data-autofocus="" data-variant="solid">Publish</p.Close>
        </div>
      </p.Content>
    </Popover>
    <Popover as |p|>
      <p.Trigger>Status</p.Trigger>
      <p.Content @initialFocus="none" @finalFocus="none">
        <p.Title>All systems normal</p.Title>
        <p.Description>Focus stays on the trigger.</p.Description>
      </p.Content>
    </Popover>
  </div>
</template>
```

Open each one: Rename focuses its field, Publish focuses its Publish button, and Status leaves focus on the trigger.

## Open on Hover

`@openOnHover` adds pointer opening while keeping click, keyboard, and touch activation. `@delay` and `@closeDelay` control the pause before opening and closing. You can cross the gap into the content and interact with it.

```glimmer-ts title="hover.gts"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { Popover } from "ember-ui-sdk/popover"
import { useLog } from "./log"

export default class Hover extends Component {
  log = useLog(this)

  follow = () => this.log("Followed @kofi")

  <template>
    <Popover @openOnHover={{true}} @delay={{200}} @closeDelay={{150}} as |p|>
      <p.Trigger>@kofi</p.Trigger>
      <p.Content @sideOffset={{8}}>
        <p.Arrow />
        <p.Title>Kofi Mensah</p.Title>
        <p.Description>Engineering manager, platform team.</p.Description>
        <div data-slot="row">
          <button type="button" data-size="sm" data-variant="solid" {{on "click" this.follow}}>
            Follow
          </button>
        </div>
      </p.Content>
    </Popover>
  </template>
}
```

Hover @kofi, then move into the popover and press Follow. You can also open it by pressing the trigger.

## Controlled

Pass `@open` and update it in `@onOpenChange` to keep the popover's state in your component. Cancel a proposed change with `details.cancel()` in `@onOpenChange`.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Popover } from "ember-ui-sdk/popover"
import { icon } from "./icon"
import { useLog } from "./log"

type Details = { reason: string; event?: Event; cancel: () => void }

export default class Controlled extends Component {
  log = useLog(this)
  @tracked open = false

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.open = next === true
  }

  onOpenChange = (next: boolean, details: Details) => {
    const target = details.event?.target
    const inControls =
      target instanceof Element && target.closest('[data-slot="controls"]')
    if (inControls && details.reason !== "escape-key") {
      return details.cancel()
    }
    this.open = next
    this.log(`${next ? "Opened" : "Closed"} (${details.reason})`)
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
      <Popover @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |p|>
        <p.Trigger>Set Status</p.Trigger>
        <p.Content>
          <p.Title>Set a status</p.Title>
          <p.Description>Your team sees it next to your name.</p.Description>
          <Field as |f|>
            <f.Label>Status</f.Label>
            <Input @field={{f.field}} @defaultValue="In a meeting" />
          </Field>
          <div data-slot="row">
            <p.Close>Cancel</p.Close>
            <p.Close data-variant="solid">Save</p.Close>
          </div>
        </p.Content>
      </Popover>
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

Check Open or press Set Status, then close the popover. The console logs each change and its reason.

## Keyboard Shortcut

Set a trigger's `@shortcut` to toggle the popover from the keyboard. `mod+i` means Command+I on Apple platforms and Control+I elsewhere. The Shortcut part displays the platform's keys, and the trigger advertises them through `aria-keyshortcuts`.

```glimmer-ts title="shortcut.gts"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Popover } from "ember-ui-sdk/popover"

<template>
  <Popover as |p|>
    <p.Trigger @shortcut="mod+i">
      Invite
      <p.Shortcut />
    </p.Trigger>
    <p.Content>
      <p.Title>Invite people</p.Title>
      <p.Description>They'll get an email with a link to join.</p.Description>
      <Field as |f|>
        <f.Label>Email</f.Label>
        <Input @field={{f.field}} type="email" placeholder="wren@example.com" />
      </Field>
      <div data-slot="row">
        <p.Close>Cancel</p.Close>
        <p.Close data-variant="solid">Send Invite</p.Close>
      </div>
    </p.Content>
  </Popover>
</template>
```

Press Command+I or Control+I to open Invite. Press the same shortcut again, or Escape, to close it.

## Triggers Outside the Popover

Connect the triggers and popover to one `createPopoverController<Member>()`. Each trigger passes its row as `@payload`; the content reads the active row from its state. Only the active trigger is expanded and receives focus back. Opening from another row updates the same panel, so one editor can serve the whole list.

`controller.open({ payload, anchor })` opens it from code and returns a promise with the closing reason and any `returnValue`. The payload stays available during the exit animation.

```glimmer-ts title="payload.gts"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import {
  Popover,
  PopoverTrigger,
  createPopoverController,
} from "ember-ui-sdk/popover"
import { useLog } from "./log"

type Member = { name: string; role: string }

const roles = ["Admin", "Editor", "Viewer"]

export default class Payload extends Component {
  log = useLog(this)
  popover = createPopoverController<Member>()
  @tracked members: Member[] = [
    { name: "Hollis Grant", role: "Owner" },
    { name: "Inès Moreau", role: "Editor" },
    { name: "Kofi Mensah", role: "Viewer" },
    { name: "Wren Takahashi", role: "Viewer" },
  ]

  get newest() {
    return this.members[this.members.length - 1]
  }

  isOwner = (member: Member) => member.role === "Owner"

  isRole = (role: string, member: Member | undefined) => member?.role === role

  editNewest = async (event: MouseEvent) => {
    const result = await this.popover.open({
      payload: this.newest,
      anchor: event.currentTarget as HTMLElement,
    })
    this.log(
      `Closed (${result.reason}), returned ${result.returnValue ?? "nothing"}`
    )
  }

  onPayloadChange = (payload: unknown) => {
    const member = payload as Member | undefined
    if (member) {
      this.log(`Editing ${member.name}`)
    }
  }

  save = (member: Member | undefined, event: SubmitEvent) => {
    if ((event.submitter as HTMLButtonElement).value !== "save" || !member) {
      return
    }
    const form = event.currentTarget as HTMLFormElement
    const role = String(new FormData(form).get("role"))
    this.members = this.members.map((entry) =>
      entry.name === member.name ? { ...entry, role } : entry
    )
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.editNewest}}>
          Edit Newest Member
        </button>
      </div>
      <ul data-slot="list">
        {{#each this.members key="name" as |member|}}
          <li data-slot="row">
            {{member.name}}
            <span data-slot="hint">{{member.role}}</span>
            <PopoverTrigger
              @controller={{this.popover}}
              @payload={{member}}
              @disabled={{this.isOwner member}}
              data-size="sm"
              data-variant="ghost"
              aria-label="Edit {{member.name}}"
            >
              Edit
            </PopoverTrigger>
          </li>
        {{/each}}
      </ul>
      <Popover @controller={{this.popover}} @onPayloadChange={{this.onPayloadChange}} as |p|>
        <p.Content @align="end" @sideOffset={{8}} as |content|>
          <p.Title>{{content.state.payload.name}}</p.Title>
          <p.Description>Roles decide what they can change.</p.Description>
          <form data-slot="stack" method="dialog" {{on "submit" (fn this.save content.state.payload)}}>
            <Field as |f|>
              <f.Label>Role</f.Label>
              <f.Control @render={{true}} as |control|>
                <select name="role" {{control.part}}>
                  {{#each roles key="@identity" as |role|}}
                    <option
                      selected={{this.isRole role content.state.payload}}
                    >{{role}}</option>
                  {{/each}}
                </select>
              </f.Control>
            </Field>
            <div data-slot="row">
              <button type="submit" value="cancel" formnovalidate>
                Cancel
              </button>
              <button type="submit" value="save" data-variant="solid">
                Save
              </button>
            </div>
          </form>
        </p.Content>
      </Popover>
    </div>
  </template>
}
```

Edit Inès Moreau or Kofi Mensah and save a new role. The owner can't be edited. Edit Newest Member opens the same editor from code, and the console logs how it closed.

## Animation

The content has `data-starting-style` while it opens and `data-ending-style` while it closes. Transition from those states, and the popover stays mounted until the exit finishes. `@onOpenChangeComplete` runs after the transition, and `@keepMounted` keeps the closed content in the page, hidden.

```glimmer-ts title="animation.gts"
import Component from "@glimmer/component"
import { Popover } from "ember-ui-sdk/popover"
import { useLog } from "./log"

export default class Animation extends Component {
  log = useLog(this)

  onOpenChange = (open: boolean) => this.log(open ? "Opening" : "Closing")

  onOpenChangeComplete = (open: boolean) => this.log(open ? "Open" : "Closed")

  <template>
    <Popover @onOpenChange={{this.onOpenChange}} @onOpenChangeComplete={{this.onOpenChangeComplete}} as |p|>
      <p.Trigger>What's New</p.Trigger>
      <p.Content @keepMounted={{true}}>
        <p.Title>What's new</p.Title>
        <p.Description>Comments now support threads and reactions.</p.Description>
        <div data-slot="row">
          <p.Close data-variant="solid">Got It</p.Close>
        </div>
      </p.Content>
    </Popover>
  </template>
}
```

Open What's New, then press Got It. The console logs Opening, Open, Closing, and Closed.

## Presentation

`@presentation="sheet"` shows the task as a sheet; `"auto"` chooses a sheet on small touch screens each time it opens. A sheet is modal by default and can be swiped down to dismiss. If dismissal is disabled, it springs back and reports the attempt.

Style `data-presentation` for both layouts. The sheet manages its own position and movement, so leave its translation alone and avoid the floating panel's fixed width. `--sheet-backdrop` sets the dim behind it.

```glimmer-ts title="presentation.gts"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Popover } from "ember-ui-sdk/popover"

<template>
  <Popover @presentation="sheet" as |p|>
    <p.Trigger>Add Reminder</p.Trigger>
    <p.Content>
      <p.Title>New reminder</p.Title>
      <p.Description>We'll notify you at the time you pick.</p.Description>
      <Field as |f|>
        <f.Label>Remind me to</f.Label>
        <Input @field={{f.field}} @defaultValue="Send the Q3 roadmap" />
      </Field>
      <div data-slot="row">
        <p.Close>Cancel</p.Close>
        <p.Close data-variant="solid">Save</p.Close>
      </div>
    </p.Content>
  </Popover>
</template>
```

Open Add Reminder as a sheet. Dismiss it with Cancel, Save, Escape, the dimmed area, or a downward swipe on a touch screen.

## Container

Popovers render in place by default and use the browser's top layer. `@container` moves their DOM to another element while keyboard order still follows the trigger.

```gts
<Popover @container={{this.container}} as |p|>
  <p.Trigger>Details</p.Trigger>
  <p.Content>...</p.Content>
</Popover>
```

## Custom Rendering

Every part takes `@render={{true}}`, which renders no element and yields `{ part, state }`: bind `part` to your own element as a modifier. Without it, each part still yields `{ part, state }` to its block, so the content can read its payload, as the row editor does.

```glimmer-ts title="custom-rendering.gts"
import { Popover } from "ember-ui-sdk/popover"

<template>
  <Popover as |p|>
    <p.Trigger @shortcut="mod+u" @render={{true}} as |trigger|>
      <button type="button" {{trigger.part}}>
        {{if trigger.state.open "Hide Updates" "Show Updates"}}
        <p.Shortcut as |shortcut|>{{shortcut.state.text}}</p.Shortcut>
      </button>
    </p.Trigger>
    <p.Content>
      <p.Title @render={{true}} as |title|>
        <h3 {{title.part}}>Updates</h3>
      </p.Title>
      <p.Description>Version 2.4 adds threaded comments.</p.Description>
      <p.Close @render={{true}} as |close|>
        <a href="#" {{close.part}}>Read the Changelog</a>
      </p.Close>
    </p.Content>
  </Popover>
</template>
```

Open Show Updates. The trigger's label comes from its state, the title renders as an h3, and Close renders as a link.

## Styling

Use `data-open` on the trigger to mark it while its popover shows, and `data-side` and `data-align` to style the content and arrow for where they landed. Put `transform-origin: var(--transform-origin)` on the content so a scale animation starts from the trigger.

Each part has a `data-slot`, such as `popover-content`, and its state attributes are listed under [Data Attributes](#data-attributes).

### PopoverContent
- `--anchor-width`: Width of the anchor, usually the trigger. Use it to match widths.
- `--anchor-height`: Height of the anchor.
- `--available-width`: Space beside the popup, up to the viewport edge. Not inherited either.
- `--available-height`: Space between the anchor and the viewport edge. Use it for max-height. Not inherited, so a child that needs it copies it on the popup, like `[--list-height:var(--available-height)]`, and reads `max-h-(--list-height)`. The first popup registers both names for the whole page with `CSS.registerProperty`, so they don't inherit anywhere. A page that needs them to inherit calls it first, with `inherits: true`. An `@property` rule can't, since a registration in script wins.
- `--transform-origin`: The point on the anchor the popup opens from. Use it to scale from the right place.
- `--arrow-offset`: Where the anchor's center falls along the popup's edge, kept `arrowPadding` from the corners. Position a ::before arrow with it.
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

`PopoverTitle`, `PopoverDescription` and `PopoverClose` have no state attributes.

### PopoverTrigger
`[data-slot="popover-trigger"]`

- `data-closed`: Present while the popover is closed, including while it animates out.
- `data-disabled`: Present when the trigger is disabled.
- `data-open`: Present while the popover is open. On a trigger, while it's open from that trigger.

### PopoverContent
`[data-slot="popover-content"]`

- `data-closed`: Present while the popover is closed, including while it animates out.
- `data-presentation` (`popover`, `sheet`): How the popover presents this time it's open.
- `data-open`: Present while the popover is open. On a trigger, while it's open from that trigger.
- `data-starting-style`: Present for the first frame. Style the state you animate from.
- `data-ending-style`: Present while the popover animates out. Style the state you animate to.

### PopoverArrow
`[data-slot="popover-arrow"]`

- `data-closed`: Present while the popover is closed, including while it animates out.
- `data-open`: Present while the popover is open. On a trigger, while it's open from that trigger.

## API Reference

Options and callbacks are the same as below, as arguments, like `@onValueChange`. Every part also takes `@render`.

### Popover

- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `open?` (`boolean`): Whether the popover is open. Pass it to control the popover.
- `defaultOpen?` (`boolean`): Whether the popover starts open, when uncontrolled.
- `onOpenChange?` (`((open: boolean, details: ChangeDetails<PopoverOpenChangeReason>) => void)`): Runs when the popover wants to open or close. `details.reason` says why, and `details.cancel()` stops it.
- `onOpenChangeComplete?` (`((open: boolean) => void)`): Runs once the popover has finished opening or closing, after any animation.
- `onPayloadChange?` (`((payload: unknown, details: ChangeDetails<PopoverPayloadChangeReason>) => void)`): Runs when the payload the content shows changes: a trigger with another payload opens the popover, or takes the open popover over, which fires no `@onOpenChange`, and so does a controller's `open({ payload })` on the open popover. `details.cancel()` keeps the previous payload.
- `modal?` (`"trap-focus" | boolean`): `false`: the rest of the page stays usable, and focus leaving the popover closes it. `true`: also traps focus, locks scroll and makes the rest of the page inert, and an outside press only closes the popover. `"trap-focus"`: traps focus but leaves the page scrollable and clickable.
- `openOnHover?` (`boolean`): Whether resting the pointer on the trigger opens the popover. Pressing the trigger still opens it, so keyboard and touch users can too.
- `delay?` (`number`): Milliseconds the pointer rests on the trigger before the popover opens, with `openOnHover`.
- `closeDelay?` (`number`): Milliseconds before the popover closes once the pointer leaves it and its trigger, with `openOnHover`.
- `presentation?` (`PresentationSetting<"popover">`): How the popover presents. `"sheet"` slides it up from the bottom of the screen, where it can be swiped away, and `"auto"` does that on small touch screens. Decided each time it opens; the server renders `"popover"` for `"auto"`.
- `controller?` (`PopupController<any, PopoverOpenChangeReason, {}, string, PopoverPayloadChangeReason>`): Opens, closes and inspects the popover from anywhere, and connects triggers outside it. Create one with `createPopoverController()`.
- `dismissible?` (`boolean`): Whether Escape, an outside press, focus or the window leaving, Android's back gesture and a sheet's swipe can close it. Triggers, Close parts and the controller always can. Pass `false` while it holds unsaved work, and ask in `@onDismissAttempt`.
- `onDismissAttempt?` (`function`): Runs when `dismissible` refused a dismissal made on purpose: Escape, an outside press, back or a swipe. Focus or the window leaving is refused without it. Ask "Discard changes?" here.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### PopoverTrigger

A trigger outside the popover also takes `@controller`.

- `disabled?` (`boolean`): Stops the trigger from opening the popover. A native button can't be focused or pressed, unless `focusableWhenDisabled` is set.
- `focusableWhenDisabled?` (`boolean`): Keeps a disabled trigger in the tab order with `aria-disabled` instead of the native attribute, so it can host a tooltip that says why. Presses still do nothing.
- `payload?` (`unknown`): Data for the content to render when this trigger opens the popover, like the row it belongs to.
- `shortcut?` (`string`): A keyboard shortcut that presses the trigger, like `"mod+i"`. `mod` is Command on Apple platforms and Control elsewhere. Sets `aria-keyshortcuts`.
- `controller?` (`PopupController<any, PopoverOpenChangeReason, {}, string, PopoverPayloadChangeReason>`): Connects a trigger outside the popover, like one per table row, to the popover with this controller.

### PopoverContent

- `side?` (`Side`): Which side of the anchor the popup opens on. Flips to the other side when there isn't room. Which side of the trigger the popover opens on.
- `align?` (`Align`): How the popup lines up with the anchor along that side. `start` and `end` follow the reading direction. How the popover lines up with the trigger along that side.
- `sideOffset?` (`number`): Gap between the anchor and the popup, in pixels. Gap between the trigger and the popover, in pixels.
- `alignOffset?` (`number`): Shift along the anchor, in pixels. Shift along the trigger, in pixels.
- `collisionPadding?` (`number`): Space to keep from the viewport edges, in pixels.
- `arrowPadding?` (`number`): Space to keep between the arrow and the popup's corners, in pixels.
- `anchor?` (`string | Anchor | null`): Positions the popup against this instead of its trigger: an element, a CSS selector, a point like `{ x, y }`, or anything with `getBoundingClientRect()`. It's read on every check, so it can move. A controller's `open({ anchor })` wins for that open.
- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `initialFocus?` (`PopoverInitialFocus`): Where focus goes when the popover opens. Opening on hover never moves focus, and opening with touch focuses the popover itself so no on-screen keyboard appears.
- `finalFocus?` (`PopupFocusTarget`): Where focus goes when the popover closes while focus is inside it.
- `keepMounted?` (`boolean`): Whether the popover stays in the page, hidden, while closed. For animation libraries that drive the exit from state.

### PopoverArrow

Points at the trigger from the side the popover landed on. Renders a `div`.

### PopoverTitle

Names the popover. Renders an `h2`.

### PopoverDescription

Describes the popover while it's rendered. Renders a `p`.

### PopoverClose

Closes the popover. Renders a `button`.

### PopoverShortcut

- `shortcut?` (`string`): The keys to show. Inside a trigger, its `shortcut`.

### State

What `@render={{true}}` yields as `state`, per part.

`PopoverTrigger`:

- `open` (`boolean`): Whether the popover is open from this trigger.
- `disabled` (`boolean`): Set by the trigger's `disabled` prop, which stops it opening the popover.

`PopoverContent`:

- `open` (`boolean`): Whether the popover is open. False while it animates out.
- `modal` (`boolean | "trap-focus"`): The `modal` setting.
- `presentation` (`"popover" | "sheet"`): How it presents this time it's open.
- `payload` (`Payload | undefined`): The payload of the last open, from the trigger that opened it or a controller, typed as the controller's `Payload`.

`PopoverArrow`:

- `open` (`boolean`): Whether the popover is open. False as soon as it starts closing, while it still animates out.

`PopoverShortcut`:

- `text` (`string`): The shortcut formatted for this platform: `⌘I` on Apple platforms and `Ctrl+I` elsewhere. Empty without one.

### Reasons

`details.reason` says why the popover opened or closed.

- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `trigger-hover` (`PointerEvent`): The pointer rested on a trigger, or left it, with hover opening.
- `outside-press` (`MouseEvent`): A press outside the layer.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `focus-out` (`KeyboardEvent | FocusEvent`): Focus left the layer, or Tab moved it out.
- `window-blur` (`FocusEvent`): The window lost focus.
- `close-press` (`MouseEvent | KeyboardEvent | SubmitEvent`): A Close part was pressed, or a form with `method="dialog"` was submitted.
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `shortcut` (`KeyboardEvent`): A keyboard shortcut, like a trigger's `shortcut`.
- `swipe` (`TouchEvent | PointerEvent`): A swipe gesture: a finger, mouse or pen dragged it.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

For a payload change, it says what opened the popover or took it over.

- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `trigger-hover` (`PointerEvent`): The pointer rested on a trigger, or left it, with hover opening.
- `shortcut` (`KeyboardEvent`): A keyboard shortcut, like a trigger's `shortcut`.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

With `@dismissible` false, the refused dismissals `@onDismissAttempt` reports:

- `outside-press` (`MouseEvent`): A press outside the layer.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `swipe` (`TouchEvent | PointerEvent`): A swipe gesture: a finger, mouse or pen dragged it.

### Controller

Create one with `createPopoverController<Payload>()` and pass it as `@controller`, to the popover and to any
triggers outside it. `Payload` is the type of the data triggers and `open()` pass.

Every write method takes an optional `{ reason, event }`, passed to `@onOpenChange`.

- `isOpen()` (`() => boolean`): Whether it's open. False as soon as it starts closing, while it still animates out.
- `setOpen(open, options?)` (`(open: boolean, options?: PopupChangeOptions<PopoverOpenChangeReason> | undefined) => boolean`): Opens or closes it. Returns false when the change was canceled or it was already open or closed.
- `open(options?)` (`(options?: (PopupChangeOptions<PopoverPayloadChangeReason> & { payload?: Payload | undefined; anchor?: Anchor | undefined; signal?: AbortSignal | undefined; }) | undefined) => Promise<...>`): Opens it, and resolves once it closes, with why, how and any return value. Resolves exactly once and never rejects: on the next close from any source, when `signal` aborts, or with reason `"unmount"` when the component leaves the page.
- `close(options?)` (`(options?: (PopupChangeOptions<PopoverOpenChangeReason> & { returnValue?: Result | undefined; }) | undefined) => boolean`): Closes it. `returnValue` is passed to the promise `open()` returned. Returns false when the close was canceled or it was already closed.
- `toggle(options?)` (`(options?: PopupChangeOptions<PopoverOpenChangeReason> | undefined) => boolean`): Opens it when it's closed, and closes it when it's open. Returns false when the change was canceled.
- `getPayload()` (`() => Payload | undefined`): The payload of the last open, from a controller or the trigger that opened it.
- `focus()` (`() => void`): Moves focus to the trigger that opened it last, or the first trigger.

### Events

Callbacks get the new state first, then the details.

| Argument                | On        | Receives                                                                    |
| ----------------------- | --------- | --------------------------------------------------------------------------- |
| `@onOpenChange`         | `Popover` | `(open, details)`: the new state, and the [reason](#reasons)                |
| `@onOpenChangeComplete` | `Popover` | `(open)`, after the animation                                               |
| `@onPayloadChange`      | `Popover` | `(payload, details)`: the content's new payload, and the [reason](#reasons) |
| `@onDismissAttempt`     | `Popover` | `({ reason, event })`, when a dismissal was refused                         |

## Accessibility

The trigger is a button that opens a dialog, and focus inside follows the [WAI-ARIA dialog pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/).

### Tested Behavior

Every line below is an automated test.

**Trigger**

- Reflects the open state.
- Click opens the popover.
- Click on the open trigger closes the popover.
- Enter opens the popover.
- Space opens the popover.
- Points to the popover it controls while open.

**Focus**

- Opening moves focus to the first focusable element.
- Each time focus moves in, the popover is named by its title and described by its description.
- Tab moves through the popover in order.
- Shift+Tab from the first element returns focus to the trigger.
- Tab from the last element moves focus to the element after the trigger.
- Focus leaving the popover closes it.
- Escape closes the popover and returns focus to the trigger.
- Escape after a click returns focus to the trigger.
- The close button closes the popover and returns focus to the trigger.
- With initial focus none, opening leaves focus on the trigger.
- A virtual click from a screen reader moves focus into the popover.
- A touch press focuses the popover itself, so no on-screen keyboard appears.
- Closing after the trigger is gone moves focus to the element after where it was.
- Pressing a button inside keeps the popover open.

**Dismissal**

- Clicking outside closes the popover.
- Clicking inside the popover keeps it open.
- An outside press reaches what it hits.
- A press on empty space returns focus to the trigger.
- Escape while an input method is composing text leaves the popover open.
- Pressing a scrollbar outside the popover leaves it open.
- Pressing a button in a shadow root inside keeps the popover open.
- Tab into a button in a shadow root inside keeps the popover open.
- Escape on a button in a shadow root inside returns focus to the trigger.
- Switching windows leaves the popover open.

**Modal**

- With modal true, Tab stays inside the popover.
- With modal trap-focus, Tab stays inside the popover.
- With modal true, an outside press only closes the popover.
- With modal true, the page doesn't scroll while open.

**Hover**

- Resting the pointer on the trigger opens the popover.
- Moving the pointer into the popover keeps it open.
- Moving the pointer away closes the popover.
- Opening on hover leaves focus where it was.
- Keyboard focus on the trigger doesn't open the popover.
- Escape on a popover opened by hover leaves focus where it was.
- Pressing the trigger still opens the popover.

**Nested popovers**

- Using a nested popover keeps both open.
- Escape closes only the nested popover and returns focus to its trigger.
- Clicking outside closes every popover.

Runs in React, Vue and web components.

Additional behaviors:

**Enhancements**

- The popup writes --arrow-offset, where the trigger's center falls along its edge.
- Without a title, the trigger names the popover.
- Tab from the trigger of a popover opened by hover moves into it.
- A controller opens the popover from anywhere and moves focus in.
- A popover open from the start leaves focus alone.
- Modal popovers make the rest of the page inert and restore it exactly.
- Live regions keep announcing while a modal popover makes the page inert.
- Clicking into an iframe closes the popover.
- An infinite exit animation still unmounts.

**Shortcuts**

- A trigger's shortcut opens and closes the popover.
- The trigger advertises its shortcut, and its Shortcut part shows the keys to sighted users only.
- A Shortcut part shows its own keys.
- A trigger connected through a controller shows and binds its own shortcut.

**Web components**

- A title added after the popover connects names it. Web components only.
- Changing an attribute updates the part. Web components only.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while using the popover with a keyboard.

Runs in React, Vue and web components.
