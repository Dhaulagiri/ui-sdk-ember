# Tooltip

Name a control or add a short hint on hover and keyboard focus.

A tooltip names a control or adds a short hint when the pointer rests on it or keyboard focus reaches it. Keep it to a few words of plain text.

```glimmer-ts title="basic.gts"
import { Bookmark } from "lucide"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "./icon"

<template>
  <Tooltip @defaultOpen={{true}} as |t|>
    <t.Trigger aria-label="Add to library">{{icon Bookmark}}</t.Trigger>
    <t.Content>Add to library</t.Content>
  </Tooltip>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

The tooltip starts open. Hover the button or reach it with Tab to show it again, and Escape closes it while focus stays on the button.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Tooltip`:

```text
Tooltip as |t|
├── t.Trigger
└── t.Content
    ├── t.Arrow
    └── t.Shortcut
```

Wrap the trigger and its hint in a tooltip. The arrow and the shortcut are optional.

The content has the `tooltip` role, and it's in the page from the start, hidden, so it names or describes its trigger before focus reaches it. It names a trigger without a name of its own, like a button with only an icon, and describes any other: one with text, an `aria-label` or a `title`. `@type="label"` or `@type="description"` overrides the guess. Keep it to plain text: a tooltip can't be focused, so links or buttons inside it can't be reached. For anything interactive, use a [Popover](./popover.md) or a [Hover Card](./hover-card.md).

## Usage

Import the root and use the parts it yields:

```gts
import { Tooltip } from "ember-ui-sdk/tooltip"

<template>
  <Tooltip as |t|>
    <t.Trigger>Share</t.Trigger>
    <t.Content>Anyone with the link can view</t.Content>
  </Tooltip>
</template>
```

## Side

`@side` picks where the tooltip opens: `top` by default. It flips to the other side when there isn't room, and shifts along the trigger to stay on screen. `data-side` says where it landed.

```glimmer-ts title="side.gts"
import { Tooltip } from "ember-ui-sdk/tooltip"

const sides = [
  { side: "top", label: "Top" },
  { side: "left", label: "Left" },
  { side: "right", label: "Right" },
  { side: "bottom", label: "Bottom" },
]

<template>
  <div data-slot="grid">
    {{#each sides key="side" as |entry|}}
      <Tooltip as |t|>
        <t.Trigger>{{entry.label}}</t.Trigger>
        <t.Content @side={{entry.side}}>Add to library</t.Content>
      </Tooltip>
    {{/each}}
  </div>
</template>
```

Hover Top, Left, Right and Bottom. Each tooltip opens on that side of its button, or flips into the middle when there isn't room.

Add a `t.Arrow` to point at the trigger. It follows the side the tooltip lands on, including after a flip.

```gts
<t.Content>
  <t.Arrow />
  Add to library
</t.Content>
```

## Anchor

Position the tooltip against something other than the trigger with `@anchor`: an element, a CSS selector, a point like `{ x, y }`, or anything with `getBoundingClientRect()`. Here a small help button inside a field shows its tooltip along the whole field.

```glimmer-ts title="anchor.gts"
import { Info } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "./icon"

<template>
  <Field as |f|>
    <f.Label>Webhook URL</f.Label>
    <div id="webhook-row" data-slot="row">
      <Input placeholder="https://" @field={{f.field}} />
      <Tooltip as |t|>
        <t.Trigger aria-label="About webhooks">{{icon Info}}</t.Trigger>
        <t.Content @anchor="#webhook-row" @side="bottom" @align="start">
          We send a POST request here for every new order.
        </t.Content>
      </Tooltip>
    </div>
  </Field>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Hover the help button. The tooltip opens below the Webhook URL field and lines up with its start, not with the button.

## Keyboard Shortcut

`@shortcut` on the tooltip, like `"mod+s"`, is a hint for what the trigger's action is bound to, where `mod` is Command on Apple platforms and Control elsewhere. `t.Shortcut` shows the keys for the platform, `⌘S` or `Ctrl+S`, hidden from screen readers, and the trigger gets `aria-keyshortcuts` so they hear it instead. A `t.Shortcut` can show other keys with its own `@shortcut`.

The tooltip doesn't bind the keys. Register the shortcut yourself with `registerShortcut` from `@ui-sdk/core/shortcuts`, as the example does, or use the `@shortcut` of a component that binds keys, like a [Dialog](./dialog.md#keyboard-shortcut) trigger.

```glimmer-ts title="shortcut.gts"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { registerDestructor } from "@ember/destroyable"
import { Save } from "lucide"
import { on } from "@ember/modifier"
import { registerShortcut } from "@ui-sdk/core/shortcuts"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Shortcut extends Component {
  log = useLog(this)

  constructor(owner: Owner, args: object) {
    super(owner, args)
    const offSave = registerShortcut("mod+s", () => this.log("Saved"))
    const offShare = registerShortcut("mod+shift+e", () => this.log("Shared"))
    registerDestructor(this, () => {
      offSave()
      offShare()
    })
  }

  saved = () => {
    this.log("Saved")
  }

  shared = () => {
    this.log("Shared")
  }

  <template>
    <div data-slot="row">
      <Tooltip @shortcut="mod+s" as |t|>
        <t.Trigger aria-label="Save" {{on "click" this.saved}}>{{icon
            Save
          }}</t.Trigger>
        <t.Content>
          Save
          <t.Shortcut />
        </t.Content>
      </Tooltip>
      <Tooltip @shortcut="mod+shift+e" as |t|>
        <t.Trigger {{on "click" this.shared}}>Share</t.Trigger>
        <t.Content>
          Share with your team
          <t.Shortcut />
        </t.Content>
      </Tooltip>
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

Hover Save or Share to read its shortcut, then press the button or the keys. The console logs Saved or Shared.

## Disabled Buttons

A natively disabled button can't receive focus, and some browsers send it no pointer events, so its tooltip never shows. When the tooltip explains why an action is unavailable, use `aria-disabled="true"` instead and ignore the button's presses yourself. The button stays in the Tab order, screen readers announce it as dimmed, and the tooltip explains what's missing. `@disabled={{true}}` on the tooltip turns the explanation off once the button works.

```glimmer-ts title="disabled-button.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { useLog } from "./log"

export default class DisabledButton extends Component {
  log = useLog(this)
  @tracked title = ""

  get blocked() {
    return !this.title.trim()
  }

  get notBlocked() {
    return !this.blocked
  }

  onTitleChange = (next: string) => {
    this.title = next
  }

  publish = () => {
    if (!this.blocked) {
      this.log(`Published “${this.title.trim()}”`)
    }
  }

  <template>
    <div data-slot="stack">
      <Field as |f|>
        <f.Label>Post title</f.Label>
        <Input @value={{this.title}} @onValueChange={{this.onTitleChange}} @field={{f.field}} />
      </Field>
      <Tooltip @disabled={{this.notBlocked}} as |t|>
        <t.Trigger data-variant="solid" aria-disabled={{if this.blocked "true"}} {{on "click" this.publish}}>
          Publish
        </t.Trigger>
        <t.Content @side="right">Add a title to publish</t.Content>
      </Tooltip>
    </div>
  </template>
}
```

Hover or focus Publish to learn what's missing. Type a title, and Publish works and its tooltip goes away.

## Touch

Touch screens have no hover. A tap on a plain tooltip's trigger only presses it, and the tooltip stays closed, so don't hide anything important in a tooltip.

For an info button whose only job is the tip, add `@toggleable={{true}}`: pressing the trigger opens and closes the tooltip, with a finger, a mouse or the keyboard, and its text is announced when a press opens it. An outside press or Escape closes it too.

```glimmer-ts title="toggleable.gts"
import { Info } from "lucide"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "./icon"

<template>
  <div data-slot="row">
    <span data-slot="label">Storage</span>
    <Tooltip @toggleable={{true}} as |t|>
      <t.Trigger aria-label="About storage" data-size="sm">{{icon
          Info
        }}</t.Trigger>
      <t.Content>Files in the trash still use storage.</t.Content>
    </Tooltip>
    <span data-slot="hint">12.4 of 15 GB used</span>
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

Press the info button to open the tip, including on a touch screen. Press it again or anywhere else to close it.

## Keep Open on Press

Pressing the trigger closes the tooltip, so it doesn't cover what the press changed, and it stays closed until the pointer leaves. `@closeOnPress={{false}}` keeps it open, like for a copy button whose tooltip turns into "Copied".

```glimmer-ts title="copy.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check, Copy } from "lucide"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "./icon"

const command = "npm install ember-ui-sdk"

export default class CopyExample extends Component {
  command = command
  @tracked copied = false

  get label() {
    return this.copied ? "Copied" : "Copy"
  }

  copy = () => {
    navigator.clipboard?.writeText(command).catch(() => {})
    this.copied = true
  }

  onOpenChangeComplete = (open: boolean) => {
    if (!open) {
      this.copied = false
    }
  }

  <template>
    <div data-slot="row">
      <code>{{this.command}}</code>
      <Tooltip @closeOnPress={{false}} @onOpenChangeComplete={{this.onOpenChangeComplete}} as |t|>
        <t.Trigger aria-label={{this.label}} {{on "click" this.copy}}>
          {{#if this.copied}}
            {{icon Check}}
          {{else}}
            {{icon Copy}}
          {{/if}}
        </t.Trigger>
        <t.Content>{{this.label}}</t.Content>
      </Tooltip>
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

Hover the copy button and press it. The tooltip stays open and changes to Copied.

## Truncated Text

To show a tooltip only when text is cut off, cancel the open in `@onOpenChange` when the text fits. Compare `scrollWidth` with `clientWidth` in the callback. The tooltip repeats the name, so `@type="label"` keeps screen readers from hearing it twice.

```glimmer-ts title="truncated.gts"
import Component from "@glimmer/component"
import { File } from "lucide"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "./icon"

const files = [
  "Quarterly report, final revised version for the board.pdf",
  "Notes.txt",
  "Design review recording, October 2nd.mp4",
  "Budget.xlsx",
]

export default class Truncated extends Component {
  files = files

  fitsOnOpen = (
    open: boolean,
    details: { event?: Event; cancel: () => void }
  ) => {
    const row = (details.event?.target as Element | undefined)?.closest("li")
    const span = row?.querySelector("span:not([data-slot])") as
      HTMLSpanElement | null | undefined
    if (open && span && span.scrollWidth <= span.clientWidth) {
      details.cancel()
    }
  }

  <template>
    <ul>
      {{#each this.files key="@identity" as |file|}}
        <li>
          <Tooltip @type="label" @onOpenChange={{this.fitsOnOpen}} as |t|>
            <t.Trigger>
              {{icon File}}
              <span>{{file}}</span>
            </t.Trigger>
            <t.Content>{{file}}</t.Content>
          </Tooltip>
        </li>
      {{/each}}
    </ul>
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

Hover or focus each file. Only names that are cut off open a tooltip.

## Controlled

Pass `@open` and read each change in `@onOpenChange`. Every change carries a [reason](#reasons), like `trigger-hover`, `trigger-focus`, `trigger-press`, `escape-key` or `outside-press`. Call `details.cancel()` to stop it. To open the tooltip from anywhere, like a step in a guided tour, use a [controller](#controller).

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Controlled extends Component {
  log = useLog(this)
  @tracked open = false

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.open = next === true
  }

  onOpenChange = (
    next: boolean,
    details: { reason: string; event?: Event; cancel: () => void }
  ) => {
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
      <Tooltip @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |t|>
        <t.Trigger>Export</t.Trigger>
        <t.Content>Download as CSV</t.Content>
      </Tooltip>
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

Check Open, or hover Export. The console logs each change and its reason.

## Shared

A toolbar, a chart or a long list can share one tooltip instead of rendering one per item. Connect the triggers and the tooltip to one `createTooltipController<Payload>()`, and the triggers can sit anywhere on the page. Each trigger passes a `@payload`, here its label, and the content reads it from its state. The content renders before the first open, so handle an `undefined` payload.

Only the trigger that opened the tooltip is described by it, so give each trigger a name of its own, like an `aria-label`. The controller's `open()` takes a payload and an `anchor` too, and on an open tooltip, `open({ payload })` replaces the payload, like another trigger taking it over. `@onPayloadChange` reports each change.

```glimmer-ts title="shared.gts"
import Component from "@glimmer/component"
import { Bold, Italic, Underline } from "lucide"
import {
  Tooltip,
  TooltipTrigger,
  createTooltipController,
} from "ember-ui-sdk/tooltip"
import { icon } from "./icon"

const formats = [
  { icon: Bold, label: "Bold" },
  { icon: Italic, label: "Italic" },
  { icon: Underline, label: "Underline" },
]

export default class Shared extends Component {
  formats = formats
  tooltip = createTooltipController<string>()

  <template>
    <div data-slot="row" role="group" aria-label="Formatting">
      {{#each this.formats key="label" as |format|}}
        <TooltipTrigger @controller={{this.tooltip}} @payload={{format.label}} aria-label={{format.label}}>
          {{icon format.icon}}
        </TooltipTrigger>
      {{/each}}
      <Tooltip @controller={{this.tooltip}} as |t|>
        <t.Content as |c|>{{c.state.payload}}</t.Content>
      </Tooltip>
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

Move along Bold, Italic and Underline. One tooltip follows the pointer and shows each button's label.

## Animation

The content has `data-starting-style` while it opens and `data-ending-style` while it closes. Transition from those states, and the tooltip stays mounted until its exit finishes. Put `transform-origin: var(--transform-origin)` on the content so it grows out of its trigger. A tooltip that opens at once, as the next one in a group does, gets `data-instant`, so skip the transition there.

```css
[data-slot="tooltip-content"] {
  transform-origin: var(--transform-origin);
  transition:
    opacity 150ms ease-out,
    scale 150ms ease-out;

  &:is([data-starting-style], [data-ending-style]) {
    opacity: 0;
    scale: 0.9;
  }

  &[data-instant] {
    transition: none;
  }
}
```

For people who ask for less motion, drop the scale in a `prefers-reduced-motion` query and keep the fade. `@onOpenChangeComplete` runs once the tooltip has finished opening or closing, after any animation, with the new open state.

```glimmer-ts title="animation.gts"
import Component from "@glimmer/component"
import { Archive } from "lucide"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Animation extends Component {
  log = useLog(this)

  onOpenChange = (open: boolean) => {
    this.log(open ? "Opening" : "Closing")
  }

  onOpenChangeComplete = (open: boolean) => {
    this.log(open ? "Open" : "Closed")
  }

  <template>
    <Tooltip @onOpenChange={{this.onOpenChange}} @onOpenChangeComplete={{this.onOpenChangeComplete}} as |t|>
      <t.Trigger aria-label="Archive">{{icon Archive}}</t.Trigger>
      <t.Content>Archive</t.Content>
    </Tooltip>
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

Hover Archive, then move away. The tooltip grows out of the button and fades, and the console logs Opening, Open, Closing and Closed.

## Delay and Grouping

`@delay` is how long the pointer rests on the trigger before the tooltip opens, 600 milliseconds by default. `@closeDelay` is how long it stays once the pointer leaves the trigger and the tooltip, 0 by default. Keyboard focus opens it at once.

Tooltips group without a provider. Once one is open, or was a moment ago, hovering the next opens it at once, and only one is open at a time, so moving along a toolbar reads like one tooltip that follows the pointer. A tooltip that opened at once gets `data-instant`, so it can skip its animation.

`@disabled={{true}}` stops a tooltip from opening, while its trigger keeps working.

```gts
<Tooltip @delay={{300}} @closeDelay={{150}} @disabled={{this.hideHints}} as |t|>…</Tooltip>
```

## Offset

`@sideOffset` is the gap to the trigger, 4 pixels by default. `@alignOffset` shifts along it, `@align` lines it up with the start, center or end of the trigger, and `@collisionPadding` is the space kept from the edges of the window.

```gts
<t.Content @align="start" @sideOffset={{8}} @alignOffset={{4}} @collisionPadding={{16}}>…</t.Content>
```

## Container

Tooltips render in place and show in the top layer, so no ancestor clips or covers them. `@container` renders the tooltip somewhere else, for iframes, shadow roots or a specific stacking context.

```gts
<t.Content @container={{this.shadowRoot}}>…</t.Content>
```

## Custom Rendering

Pass `@render={{true}}` to a part to render it as your own element. It yields `{ part, state }`: bind `part` to your element as a modifier, and read the state in the block.

```glimmer-ts title="custom-rendering.gts"
import { Tooltip } from "ember-ui-sdk/tooltip"

<template>
  <Tooltip as |t|>
    <t.Trigger @render={{true}} as |tr|>
      <a
        {{tr.part}}
        href="https://example.com/changelog"
        data-variant="link"
      >Changelog</a>
    </t.Trigger>
    <t.Content>See what's new in 2.0</t.Content>
  </Tooltip>
</template>
```

Hover Changelog. The trigger renders as a link, and its tooltip says where it goes.

## Styling

Use `data-side` and `data-align` to style the content and arrow for where they landed, and `data-instant` to skip the animation of a tooltip that opened at once. The trigger gets no state attributes of its own, since it's often another component's trigger too, like a menu's. Put `transform-origin: var(--transform-origin)` on the content so it scales from the trigger.

Each part has a `data-slot`, such as `tooltip-content`, and its state attributes are listed under [Data Attributes](#data-attributes).

### TooltipContent
- `--anchor-width`: Width of the anchor, usually the trigger. Use it to match widths.
- `--anchor-height`: Height of the anchor.
- `--available-width`: Space beside the popup, up to the viewport edge. Not inherited either.
- `--available-height`: Space between the anchor and the viewport edge. Use it for max-height. Not inherited, so a child that needs it copies it on the popup, like `[--list-height:var(--available-height)]`, and reads `max-h-(--list-height)`. The first popup registers both names for the whole page with `CSS.registerProperty`, so they don't inherit anywhere. A page that needs them to inherit calls it first, with `inherits: true`. An `@property` rule can't, since a registration in script wins.
- `--transform-origin`: The point on the anchor the popup opens from. Use it to scale from the right place.
- `--arrow-offset`: Where the anchor's center falls along the popup's edge, kept `arrowPadding` from the corners. Position a ::before arrow with it.

## Data Attributes

`TooltipTrigger` and `TooltipShortcut` have no state attributes.

### TooltipContent
`[data-slot="tooltip-content"]`

- `data-closed`: Present while the tooltip is closed, including while it animates out.
- `data-open`: Present while the tooltip is open.
- `data-starting-style`: Present for the first frame. Style the state you animate from.
- `data-ending-style`: Present while the tooltip animates out. Style the state you animate to.

### TooltipArrow
`[data-slot="tooltip-arrow"]`

- `data-closed`: Present while the tooltip is closed, including while it animates out.
- `data-open`: Present while the tooltip is open.

## API Reference

Pass the root's options as `@` arguments. `@open` is controlled with `@onOpenChange`.

### Tooltip

- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `open?` (`boolean`): Whether the tooltip is open. Pass it to control the tooltip.
- `defaultOpen?` (`boolean`): Whether the tooltip starts open, when uncontrolled.
- `onOpenChange?` (`((open: boolean, details: ChangeDetails<TooltipOpenChangeReason>) => void)`): Runs when the tooltip wants to open or close. `details.reason` says why, and `details.cancel()` stops it.
- `onOpenChangeComplete?` (`((open: boolean) => void)`): Runs once the tooltip has finished opening or closing, after any animation.
- `onPayloadChange?` (`((payload: unknown, details: ChangeDetails<TooltipPayloadChangeReason>) => void)`): Runs when the payload the content shows changes: a trigger with another payload opens the tooltip, or takes the open tooltip over, which fires no `@onOpenChange`, and so does a controller's `open({ payload })` on the open tooltip. `details.cancel()` keeps the previous payload.
- `delay?` (`number`): Milliseconds the pointer rests on the trigger before the tooltip opens. While another tooltip is open, or was a moment ago, the next one opens at once, without a provider.
- `closeDelay?` (`number`): Milliseconds before the tooltip closes once the pointer leaves the trigger and the tooltip.
- `disabled?` (`boolean`): Stops the tooltip from opening. The trigger keeps working.
- `toggleable?` (`boolean`): Whether pressing the trigger opens and closes the tooltip, so touch screens can show it too. For info buttons whose only job is the tip. The text is announced when a press opens it.
- `closeOnPress?` (`boolean`): Whether pressing the trigger closes the tooltip. Set it to `false` to keep it open, like for a copy button whose tooltip turns into "Copied".
- `type?` (`"description" | "label"`): Whether the tooltip names its trigger (`"label"`) or adds a description to it (`"description"`). By default it names a trigger that has no name of its own, like an icon button, and describes any other.
- `shortcut?` (`string`): The keyboard shortcut of what the trigger does, like `"mod+s"`, as a hint. A `TooltipShortcut` shows it, and the trigger gets `aria-keyshortcuts`. It doesn't bind the keys: the trigger's own `shortcut`, or `registerShortcut`, does.
- `controller?` (`PopupController<any, TooltipOpenChangeReason, {}, string, TooltipPayloadChangeReason>`): Opens, closes and inspects the tooltip from anywhere, and connects triggers outside it. Create one with `createTooltipController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### TooltipTrigger

A trigger outside the tooltip also takes `@controller`.

- `payload?` (`unknown`): Data for the content to render when this trigger opens the tooltip, like the row it belongs to.
- `controller?` (`PopupController<any, TooltipOpenChangeReason, {}, string, TooltipPayloadChangeReason>`): Connects a trigger outside the tooltip, like one per table row, to the tooltip with this controller.

### TooltipContent

- `side?` (`Side`): Which side of the anchor the popup opens on. Flips to the other side when there isn't room. Which side of the trigger the tooltip opens on.
- `align?` (`Align`): How the popup lines up with the anchor along that side. `start` and `end` follow the reading direction. How the tooltip lines up with the trigger along that side.
- `sideOffset?` (`number`): Gap between the anchor and the popup, in pixels. Gap between the trigger and the tooltip, in pixels.
- `alignOffset?` (`number`): Shift along the anchor, in pixels. Shift along the trigger, in pixels.
- `collisionPadding?` (`number`): Space to keep from the viewport edges, in pixels.
- `arrowPadding?` (`number`): Space to keep between the arrow and the popup's corners, in pixels.
- `anchor?` (`string | Anchor | null`): Positions the popup against this instead of its trigger: an element, a CSS selector, a point like `{ x, y }`, or anything with `getBoundingClientRect()`. It's read on every check, so it can move. A controller's `open({ anchor })` wins for that open.
- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.

### TooltipArrow

Points at the trigger from the side the tooltip landed on. Renders a `div`.

### TooltipShortcut

- `shortcut?` (`string`): The keys to show. By default, the tooltip's `shortcut`.

### State

What `@render` parts and their blocks receive, per part.

`TooltipTrigger`:

- `open` (`boolean`): Whether the tooltip is open from this trigger.

`TooltipContent`:

- `open` (`boolean`): Whether the tooltip is open. False while it animates out.
- `instant` (`boolean`): Whether it opened at once, because another tooltip was open a moment ago. Animations can skip.
- `payload` (`Payload | undefined`): The payload of the last open, from the trigger that opened it or a controller, typed as the controller's `Payload`.

`TooltipArrow`:

- `open` (`boolean`): Whether the tooltip is open. False as soon as it starts closing, while it still animates out.

`TooltipShortcut`:

- `text` (`string`): The shortcut formatted for this platform: `⌘S` on Apple platforms and `Ctrl+S` elsewhere. Empty without one.

### Reasons

`details.reason` says why the tooltip opened or closed.

- `trigger-hover` (`PointerEvent`): The pointer rested on a trigger, or left it, with hover opening.
- `trigger-focus` (`FocusEvent`): Keyboard focus reached a trigger that opens on focus, like a tooltip's.
- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `focus-out` (`KeyboardEvent | FocusEvent`): Focus left the layer, or Tab moved it out.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `close-press` (`MouseEvent | KeyboardEvent | SubmitEvent`): A Close part was pressed, or a form with `method="dialog"` was submitted.
- `outside-press` (`MouseEvent`): A press outside the layer.
- `window-blur` (`FocusEvent`): The window lost focus.
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

For a payload change, it says what opened the tooltip or took it over.

- `trigger-hover` (`PointerEvent`): The pointer rested on a trigger, or left it, with hover opening.
- `trigger-focus` (`FocusEvent`): Keyboard focus reached a trigger that opens on focus, like a tooltip's.
- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createTooltipController<Payload>()` and pass it as `@controller`, to the tooltip and to any triggers outside it. `Payload` is the type of the data triggers and `open()` pass.

Every write method takes an optional `{ reason, event }`, passed to `@onOpenChange`.

- `isOpen()` (`() => boolean`): Whether it's open. False as soon as it starts closing, while it still animates out.
- `setOpen(open, options?)` (`(open: boolean, options?: PopupChangeOptions<TooltipOpenChangeReason> | undefined) => boolean`): Opens or closes it. Returns false when the change was canceled or it was already open or closed.
- `open(options?)` (`(options?: (PopupChangeOptions<TooltipPayloadChangeReason> & { payload?: Payload | undefined; anchor?: Anchor | undefined; signal?: AbortSignal | undefined; }) | undefined) => Promise<...>`): Opens it, and resolves once it closes, with why, how and any return value. Resolves exactly once and never rejects: on the next close from any source, when `signal` aborts, or with reason `"unmount"` when the component leaves the page.
- `close(options?)` (`(options?: (PopupChangeOptions<TooltipOpenChangeReason> & { returnValue?: string | undefined; }) | undefined) => boolean`): Closes it. `returnValue` is passed to the promise `open()` returned. Returns false when the close was canceled or it was already closed.
- `toggle(options?)` (`(options?: PopupChangeOptions<TooltipOpenChangeReason> | undefined) => boolean`): Opens it when it's closed, and closes it when it's open. Returns false when the change was canceled.
- `getPayload()` (`() => Payload | undefined`): The payload of the last open, from a controller or the trigger that opened it.
- `focus()` (`() => void`): Moves focus to the trigger that opened it last, or the first trigger.

### Events

Callbacks get the new state first, then the details. A controlled `@open` only updates when `@onOpenChange` wasn't canceled.

| Argument                | On        | Receives                                                                    |
| ----------------------- | --------- | --------------------------------------------------------------------------- |
| `@onOpenChange`         | `Tooltip` | `(open, details)`: the new state, and the [reason](#reasons)                |
| `@onOpenChangeComplete` | `Tooltip` | `(open)`, after the animation                                               |
| `@onPayloadChange`      | `Tooltip` | `(payload, details)`: the content's new payload, and the [reason](#reasons) |

## Accessibility

The trigger is named or described by the tooltip, following the [WAI-ARIA tooltip pattern](https://www.w3.org/WAI/ARIA/apg/patterns/tooltip/). It opens on hover and on keyboard focus, and stays open while the pointer moves onto it.

### Keyboard

| Key          | Does                                                                                           |
| ------------ | ---------------------------------------------------------------------------------------------- |
| Tab          | Focus on the trigger opens the tooltip at once; focus leaving it closes the tooltip            |
| Escape       | Closes the tooltip and leaves focus on the trigger, without closing a dialog or menu around it |
| Enter, Space | Presses the trigger and closes the tooltip; on a `@toggleable` trigger, opens and closes it    |

### Tested Behavior

Every line below is an automated test.

**Pointer**

- Resting the pointer on the trigger opens the tooltip.
- The tooltip waits for its delay before opening.
- Leaving the trigger before the delay keeps the tooltip closed.
- Moving the pointer away closes the tooltip.
- The pointer can move onto the tooltip without closing it.
- Opening on hover leaves focus where it was.
- Pressing the trigger closes the tooltip and runs the button.
- After a press, the tooltip stays closed until the pointer comes back.

**Keyboard**

- Keyboard focus on the trigger opens the tooltip.
- Focus leaving the trigger closes the tooltip.
- Escape closes the tooltip and leaves focus on the trigger.
- Escape closes a tooltip opened by hover.
- Tab through the toolbar shows each tooltip in turn.
- A click that focuses the trigger doesn't open the tooltip from focus.

**Several tooltips**

- Only one tooltip is open at a time.
- Once the pointer has been away a while, the delay applies again.

**Positioning**

- The tooltip opens above the trigger.
- The tooltip flips below the trigger when there is no room above.
- The tooltip opens on the requested side.
- The arrow points at the middle of the trigger.

**A tooltip on a popover trigger**

- Hovering shows the tooltip, and pressing opens the popover instead.
- Escape closes the tooltip and leaves the popover open.

**Disabled buttons**

- Browsers send hover events to a disabled button.
- An aria-disabled trigger shows its tooltip on hover and focus and ignores presses.

**Animation**

- The tooltip animates in from its starting style.
- The tooltip stays in the page while it animates out.

**Hidden while closed**

- A class that sets display on the content doesn't show it while closed.

**Options and dismissal**

- Escape closes only a tooltip that keyboard focus opened inside a popover.
- The pointer can leave the trigger sideways on its way to the tooltip.
- With closeOnPress false, pressing the trigger keeps the tooltip open.
- Disabled tooltips never open.
- A tap on a plain tooltip's trigger only presses it.

Runs in React, Vue and web components.

Also tested:

**Enhancements**

- Focus returning to the trigger after its popover closes doesn't reopen the tooltip.
- Tooltips open at once after another one, without a provider.
- Focus coming back with the window doesn't reopen the tooltip.
- A controller opens the tooltip without moving focus.
- A trigger that's a disabled button warns in development.

**Shortcuts**

- A trigger connected through a controller shows its tooltip's shortcut in a Shortcut part.

**Toggleable**

- Pressing a toggleable trigger opens and closes the tooltip.
- Pressing outside closes a toggleable tooltip.
- Enter toggles the tooltip from the keyboard and keeps focus on the trigger.
- A press announces the tooltip's text to screen readers.
- A tap opens a toggleable tooltip on a touch screen.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while tabbing through triggers with tooltips.

Runs in React, Vue and web components.
