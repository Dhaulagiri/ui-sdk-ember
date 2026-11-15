# Toolbar

Give buttons, toggles, menus and fields one tab stop with arrow-key navigation.

Use a Toolbar to group the controls of an editor, a canvas or a table. Tab enters it once, and the arrow keys move between its buttons, toggles, menus and fields.

```glimmer-ts title="demo.gts"
import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { Bold, Italic, Link, Underline } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const styles = [
  { label: "Bold", icon: Bold },
  { label: "Italic", icon: Italic },
  { label: "Underline", icon: Underline },
]

export default class Demo extends Component {
  log = useLog(this)

  onPressed = (label: string, pressed: boolean) => {
    this.log(`${label} ${pressed ? "on" : "off"}`)
  }

  <template>
    <Toolbar aria-label="Formatting" as |t|>
      {{#each styles key="label" as |style|}}
        <t.Toggle
          aria-label={{style.label}}
          @onPressedChange={{fn this.onPressed style.label}}
          as |p|
        >
          <p.Icon>{{icon style.icon}}</p.Icon>
        </t.Toggle>
      {{/each}}
      <t.Separator />
      <t.Button
        aria-label="Insert link"
        {{on "click" (fn this.log "Insert link")}}
      >
        {{icon Link}}
      </t.Button>
    </Toolbar>
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

Tab into the toolbar, then use Left and Right to move between Bold, Italic, Underline and Insert link. Press Space to toggle the focused style. The console logs each change.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Toolbar`:

```text
Toolbar as |t|
├── t.Button
├── t.Separator
├── t.Group
│   ├── t.Button
│   └── t.Button
├── t.Link
└── t.Input
```

Put buttons, links and fields straight inside the toolbar. `t.Group` names a set of related items, and `t.Separator` draws a line between sets. Toggles and toggle groups join the toolbar on their own, and menu and select triggers join through `t.Button`.

## Usage

Import the root and use the parts it yields:

```gts
import { Toolbar } from "ember-ui-sdk/toolbar"

<template>
  <Toolbar aria-label="Formatting" as |t|>
    <t.Button>Undo</t.Button>
    <t.Button>Redo</t.Button>
    <t.Separator />
    <t.Button>Insert Link</t.Button>
  </Toolbar>
</template>
```

Name the toolbar with `aria-label`, and give every icon-only control its own.

## Toggle Groups

A [Toggle](./toggle.md) group inside a toolbar joins its navigation instead of adding another tab stop. Arrow keys move focus without pressing anything; Enter or Space presses the focused toggle.

```glimmer-ts title="toggle-group.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { AlignCenter, AlignLeft, AlignRight, List, ListOrdered } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const alignments = [
  { value: "left", label: "Align left", icon: AlignLeft },
  { value: "center", label: "Align center", icon: AlignCenter },
  { value: "right", label: "Align right", icon: AlignRight },
]

const lists = [
  { value: "bulleted", label: "Bulleted list", icon: List },
  { value: "numbered", label: "Numbered list", icon: ListOrdered },
]

export default class ToggleGroupExample extends Component {
  log = useLog(this)

  onAlign = (values: string[]) => {
    this.log(`Align ${values[0]}`)
  }

  onList = (values: string[]) => {
    this.log(lists.find((list) => list.value === values[0])?.label ?? "No list")
  }

  <template>
    <Toolbar aria-label="Paragraph" as |t|>
      <t.ToggleGroup
        @defaultValue={{array "left"}}
        @deselectable={{false}}
        @onValueChange={{this.onAlign}}
        aria-label="Alignment"
        as |g|
      >
        {{#each alignments key="value" as |item|}}
          <g.Toggle @value={{item.value}} aria-label={{item.label}} as |p|>
            <p.Icon>{{icon item.icon}}</p.Icon>
          </g.Toggle>
        {{/each}}
      </t.ToggleGroup>
      <t.Separator />
      <t.ToggleGroup @onValueChange={{this.onList}} aria-label="List" as |g|>
        {{#each lists key="value" as |item|}}
          <g.Toggle @value={{item.value}} aria-label={{item.label}} as |p|>
            <p.Icon>{{icon item.icon}}</p.Icon>
          </g.Toggle>
        {{/each}}
      </t.ToggleGroup>
    </Toolbar>
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

Arrow from the alignment group to the list group, then press Space on Align center or Numbered list. The console logs each choice.

## Groups

Use `t.Group` to name related controls. Set `@disabled={{true}}` on the group to disable them together; they stay focusable with `aria-disabled`.

```glimmer-ts title="group.gts"
import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { ClipboardPaste, Copy, Redo, Scissors, Undo } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const clipboard = [
  { label: "Cut", icon: Scissors },
  { label: "Copy", icon: Copy },
  { label: "Paste", icon: ClipboardPaste },
]

export default class Group extends Component {
  log = useLog(this)

  <template>
    <Toolbar aria-label="Edit" as |t|>
      <t.Group aria-label="Clipboard" as |g|>
        {{#each clipboard key="label" as |item|}}
          <g.Button aria-label={{item.label}} {{on "click" (fn this.log item.label)}}>
            {{icon item.icon}}
          </g.Button>
        {{/each}}
      </t.Group>
      <t.Separator />
      <t.Group @disabled={{true}} aria-label="History" as |g|>
        <g.Button aria-label="Undo">{{icon Undo}}</g.Button>
        <g.Button aria-label="Redo">{{icon Redo}}</g.Button>
      </t.Group>
    </Toolbar>
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

Move through Cut, Copy and Paste into History with the arrow keys. Undo and Redo stay focusable but do nothing.

## Menus

Render a [Menu](./menu.md) trigger through `t.Button`. In a horizontal toolbar, Down opens the menu while Left and Right keep moving between toolbar items.

```glimmer-ts title="menu.gts"
import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Menu } from "ember-ui-sdk/menu"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { ChevronDown } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

export default class MenuExample extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Shared by ${value}`)
  }

  <template>
    <Toolbar aria-label="Document" as |t|>
      <t.Button {{on "click" (fn this.log "Saved")}}>Save</t.Button>
      <Menu @onAction={{this.onAction}} as |m|>
        <t.Button @render={{true}} as |b|>
          <m.Trigger @render={{true}} as |tr|>
            <button {{b.part}} {{tr.part}}>
              Share
              {{icon ChevronDown}}
            </button>
          </m.Trigger>
        </t.Button>
        <m.Content>
          <m.Item @value="email">Email</m.Item>
          <m.Item @value="link">Copy Link</m.Item>
        </m.Content>
      </Menu>
      <t.Button {{on "click" (fn this.log "Printed")}}>Print</t.Button>
    </Toolbar>
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

Focus Share and press Down, then choose Email or Copy Link. Escape closes the menu and returns focus to Share.

## Selects

A [Select](./select.md) trigger joins the same way. It keeps its select behavior while it takes part in the toolbar's focus order.

```glimmer-ts title="select.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Select } from "ember-ui-sdk/select"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { Check, ChevronsUpDown, ZoomIn, ZoomOut } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const zooms = ["50%", "75%", "100%", "150%", "200%"]

export default class SelectExample extends Component {
  log = useLog(this)
  @tracked zoom = "100%"

  get index() {
    return zooms.indexOf(this.zoom)
  }

  get atStart() {
    return this.index === 0
  }

  get atEnd() {
    return this.index === zooms.length - 1
  }

  change = (value: string) => {
    this.zoom = value
    this.log(`Zoom ${value}`)
  }

  zoomOut = () => this.change(zooms[this.index - 1])
  zoomIn = () => this.change(zooms[this.index + 1])

  onValueChange = (value: string | null) => {
    if (value) {
      this.change(value)
    }
  }

  <template>
    <Toolbar aria-label="View" as |t|>
      <t.Button aria-label="Zoom out" @disabled={{this.atStart}} {{on "click" this.zoomOut}}>
        {{icon ZoomOut}}
      </t.Button>
      <Select @value={{this.zoom}} @onValueChange={{this.onValueChange}} as |s|>
        <t.Button aria-label="Zoom" @render={{true}} as |b|>
          <s.Trigger @render={{true}} as |tr|>
            <button {{b.part}} {{tr.part}}>
              <s.Value />
              {{icon ChevronsUpDown}}
            </button>
          </s.Trigger>
        </t.Button>
        <s.Content>
          {{#each zooms key="@identity" as |zoom|}}
            <s.Item @value={{zoom}} as |item|>
              {{zoom}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </s.Item>
          {{/each}}
        </s.Content>
      </Select>
      <t.Button aria-label="Zoom in" @disabled={{this.atEnd}} {{on "click" this.zoomIn}}>
        {{icon ZoomIn}}
      </t.Button>
    </Toolbar>
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

Open Zoom and choose a value, or step it with Zoom out and Zoom in. Each button turns off at the end of the range.

## Fields

Use `t.Input` for a text field, or render another field through it, like a [Number Input](./number-input.md) control. A field keeps Home, End and the arrow keys while they move its caret. At the matching end, with no text selected, an arrow moves to the next item.

Entering a field with an arrow puts its caret at the far end in that direction: press the same arrow again to leave, or the other arrow to edit. A number input keeps Up and Down for stepping its value.

```glimmer-ts title="input.gts"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { Minus, Plus } from "lucide"
import { icon } from "./icon"

<template>
  <Toolbar aria-label="Text" as |t|>
    <NumberInput @defaultValue={{14}} @min={{8}} @max={{72}} as |n|>
      <n.Group>
        <n.Decrement aria-label="Decrease font size">
          {{icon Minus}}
        </n.Decrement>
        <t.Input @render={{true}} as |field|>
          <n.Control @render={{true}} as |control|>
            <input {{control.part}} {{field.part}} aria-label="Font size" />
          </n.Control>
        </t.Input>
        <n.Increment aria-label="Increase font size">
          {{icon Plus}}
        </n.Increment>
      </n.Group>
    </NumberInput>
    <t.Separator />
    <t.Input aria-label="Find" placeholder="Find…" />
  </Toolbar>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Move into Font size and press Up or Down to change it. In Find, type a word, then move the caret to an edge before that arrow leaves the field.

## Links

`t.Link` joins the same focus order and keeps its link behavior. The demo handles a plain click itself and leaves modified clicks, like opening in a new tab, to the browser.

```glimmer-ts title="link.gts"
import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { Check, MessageSquare } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Link extends Component {
  log = useLog(this)

  follow = (event: MouseEvent) => {
    if (
      event.button !== 0 ||
      event.metaKey ||
      event.ctrlKey ||
      event.shiftKey ||
      event.altKey
    ) {
      return
    }
    event.preventDefault()
    this.log(`Opened ${(event.currentTarget as HTMLAnchorElement).textContent}`)
  }

  <template>
    <Toolbar aria-label="Pull request" as |t|>
      <t.Button
        aria-label="Approve"
        {{on "click" (fn this.log "Approved")}}
      >{{icon Check}}</t.Button>
      <t.Button
        aria-label="Comment"
        {{on "click" (fn this.log "Comment")}}
      >{{icon MessageSquare}}</t.Button>
      <t.Separator />
      <t.Link href="#files" {{on "click" this.follow}}>Files Changed</t.Link>
      <t.Link href="#checks" {{on "click" this.follow}}>Checks</t.Link>
    </Toolbar>
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

Arrow to Files Changed and press Enter. The console logs the page it opened.

## Vertical

Set `@orientation="vertical"` to move with Up and Down, like a canvas tool palette. Separators turn to run across the toolbar.

```glimmer-ts title="vertical.gts"
import Component from "@glimmer/component"
import { array, fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { MousePointer2, Pencil, Square, Trash2, Type } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const tools = [
  { value: "select", label: "Select", icon: MousePointer2 },
  { value: "draw", label: "Draw", icon: Pencil },
  { value: "shape", label: "Shape", icon: Square },
  { value: "text", label: "Text", icon: Type },
]

export default class Vertical extends Component {
  log = useLog(this)

  onTool = (values: string[]) => {
    this.log(`${tools.find((tool) => tool.value === values[0])?.label} tool`)
  }

  <template>
    <Toolbar @orientation="vertical" aria-label="Canvas" as |t|>
      <t.ToggleGroup
        @defaultValue={{array "select"}}
        @deselectable={{false}}
        @orientation="vertical"
        @onValueChange={{this.onTool}}
        aria-label="Tool"
        as |g|
      >
        {{#each tools key="value" as |item|}}
          <g.Toggle @value={{item.value}} aria-label={{item.label}} as |p|>
            <p.Icon>{{icon item.icon}}</p.Icon>
          </g.Toggle>
        {{/each}}
      </t.ToggleGroup>
      <t.Separator />
      <t.Button
        aria-label="Delete"
        {{on "click" (fn this.log "Deleted selection")}}
      >{{icon Trash2}}</t.Button>
    </Toolbar>
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

Use Up and Down to move between the tools and Delete. Space picks the focused tool.

## Disabled

A disabled item stays reachable with `aria-disabled`, so people can find it, but it ignores presses, including keys meant for a component rendered through it. Set `@focusableWhenDisabled={{false}}` to skip it instead.

```glimmer-ts title="disabled.gts"
import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { useLog } from "./log"

export default class Disabled extends Component {
  log = useLog(this)

  <template>
    <Toolbar aria-label="Message" as |t|>
      <t.Button {{on "click" (fn this.log "Reply")}}>Reply</t.Button>
      <t.Button
        @disabled={{true}}
        {{on "click" (fn this.log "Archive")}}
      >Archive</t.Button>
      <t.Button
        @disabled={{true}}
        @focusableWhenDisabled={{false}}
        {{on "click" (fn this.log "Delete")}}
      >Delete</t.Button>
    </Toolbar>
  </template>
}
```

Arrow from Reply to Archive, which is disabled but focusable. Delete is skipped. Only Reply logs a press.

Set `@disabled={{true}}` on the toolbar to disable every item. The toolbar keeps its tab stop, and its fields can't be edited.

```gts
<Toolbar @disabled={{true}} aria-label="Formatting" as |t|>
  <t.Button>Bold</t.Button>
  <t.Input aria-label="Find" />
</Toolbar>
```

## Loop

Arrow keys wrap from the last item to the first by default. Set `@loop={{false}}` to stop at the ends.

```glimmer-ts title="loop.gts"
import Component from "@glimmer/component"
import { concat, fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { useLog } from "./log"

const labels = ["First", "Previous", "Next", "Last"]

export default class Loop extends Component {
  log = useLog(this)

  <template>
    <Toolbar @loop={{false}} aria-label="Pages" as |t|>
      {{#each labels key="@identity" as |label|}}
        <t.Button
          {{on "click" (fn this.log (concat label " page"))}}
        >{{label}}</t.Button>
      {{/each}}
    </Toolbar>
  </template>
}
```

Focus Last and press Right. Focus stays there; Home still moves to First.

## Controller

Create a controller with `createToolbarController()` and pass it as `@controller`. Its `focus()` moves focus to the item focused last, like the Alt+F10 shortcut editors give their toolbars. Create one controller per toolbar.

```glimmer-ts title="controller.gts"
import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { createToolbarController, Toolbar } from "ember-ui-sdk/toolbar"
import { Bold, Italic, Link } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const actions = [
  { label: "Bold", icon: Bold },
  { label: "Italic", icon: Italic },
  { label: "Insert link", icon: Link },
]

export default class Controller extends Component {
  logger = useLog(this)
  toolbar = createToolbarController()

  focusToolbar = () => this.toolbar.focus()

  log = (label: string) => this.logger(label)

  shortcut = (event: KeyboardEvent) => {
    if (event.altKey && event.key === "F10") {
      event.preventDefault()
      this.toolbar.focus()
    }
  }

  <template>
    <div data-slot="stack" {{on "keydown" this.shortcut}}>
      <div data-slot="controls">
        <button type="button" {{on "click" this.focusToolbar}}>Focus Toolbar</button>
      </div>
      <Toolbar @controller={{this.toolbar}} aria-label="Notes formatting" as |t|>
        {{#each actions key="label" as |action|}}
          <t.Button aria-label={{action.label}} {{on "click" (fn this.log action.label)}}>
            {{icon action.icon}}
          </t.Button>
        {{/each}}
      </Toolbar>
      <textarea
        aria-label="Notes"
        placeholder="Type, then press Alt+F10"
      ></textarea>
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

Type in Notes, then press Alt+F10 or choose Focus Toolbar. Press a toolbar button and the console logs it.

## Custom Rendering

Pass `@render={{true}}` to a `t.Button` or `t.Input` to combine its behavior with another component, as the menu, select and number input examples do. Bind the yielded `part` to the inner element so the toolbar's focus and keys stay connected. The menu example shows the pattern.

## Styling

Use `data-orientation` on the root for a row or a column, and on a separator for the way its line runs, across the toolbar. Use `data-disabled` to style unavailable items and groups. Toggles inside keep their own `data-pressed`.

Each part has a `data-slot`, such as `toolbar-button`, and its state attributes are listed under [Data Attributes](#data-attributes).

## Data Attributes

### Toolbar
`[data-slot="toolbar"]`

- `data-orientation` (`horizontal`, `vertical`): The toolbar's orientation. On a separator, which way the line runs: across the toolbar.
- `data-disabled`: Present when disabled, by the item itself, its group or the toolbar.

### ToolbarButton
`[data-slot="toolbar-button"]`

- `data-disabled`: Present when disabled, by the item itself, its group or the toolbar.
- `data-orientation` (`horizontal`, `vertical`): The toolbar's orientation. On a separator, which way the line runs: across the toolbar.

### ToolbarLink
`[data-slot="toolbar-link"]`

- `data-disabled`: Present when disabled, by the item itself, its group or the toolbar.
- `data-orientation` (`horizontal`, `vertical`): The toolbar's orientation. On a separator, which way the line runs: across the toolbar.

### ToolbarInput
`[data-slot="toolbar-input"]`

- `data-disabled`: Present when disabled, by the item itself, its group or the toolbar.
- `data-orientation` (`horizontal`, `vertical`): The toolbar's orientation. On a separator, which way the line runs: across the toolbar.

### ToolbarGroup
`[data-slot="toolbar-group"]`

- `data-disabled`: Present when disabled, by the item itself, its group or the toolbar.
- `data-orientation` (`horizontal`, `vertical`): The toolbar's orientation. On a separator, which way the line runs: across the toolbar.

### ToolbarSeparator
`[data-slot="toolbar-separator"]`

- `data-orientation` (`horizontal`, `vertical`): The toolbar's orientation. On a separator, which way the line runs: across the toolbar.

## API Reference

Options and callbacks are the same as below, as arguments, such as `@orientation` and `@loop`. Every part also takes `@render`.

### Toolbar

- `orientation?` (`ToolbarOrientation`): Which arrow keys move between items: left and right, or up and down.
- `loop?` (`boolean`): Whether arrow keys wrap from the last item to the first.
- `disabled?` (`boolean`): Stops every item from being used. Items stay focusable with `aria-disabled`, so the toolbar keeps its tab stop and stays discoverable.
- `controller?` (`{ focus: () => void; }`): Focuses the toolbar from anywhere. Create one with `createToolbarController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### ToolbarButton

- `disabled?` (`boolean`): Stops the item from being used. It stays focusable with `aria-disabled`, so arrow keys still reach it and a tooltip can say why.
- `focusableWhenDisabled?` (`boolean`): Whether a disabled item stays reachable with arrow keys. Turn it off to skip it, natively disabled.

### ToolbarInput

- `disabled?` (`boolean`): Stops the item from being used. It stays focusable with `aria-disabled`, so arrow keys still reach it and a tooltip can say why.
- `focusableWhenDisabled?` (`boolean`): Whether a disabled item stays reachable with arrow keys. Turn it off to skip it, natively disabled.

### ToolbarGroup

- `disabled?` (`boolean`): Disables every item in the group. They stay focusable with `aria-disabled`.

`t.Link` and `t.Separator` take no options of their own.

### State

What `@render={{true}}` yields as `state` on `t.Button` and `t.Input`:

- `disabled` (`boolean`): Whether the item is disabled, by itself, its group or the toolbar.
- `orientation` (`ToolbarOrientation`): The toolbar's `orientation` option: `"vertical"`, or `"horizontal"` for anything else.

On `t.Link`:

- `disabled` (`boolean`): Whether the link is disabled, by its group or the toolbar.
- `orientation` (`ToolbarOrientation`): The toolbar's `orientation` option: `"vertical"`, or `"horizontal"` for anything else.

On `t.Separator`:

- `orientation` (`ToolbarOrientation`): Which way the line runs: across the toolbar, so vertical in a horizontal toolbar.

### Controller

- `focus()` (`() => void`): Moves focus to the item that holds the toolbar's tab stop: the one focused last, or the first.

## Accessibility

The toolbar follows the [WAI-ARIA toolbar pattern](https://www.w3.org/WAI/ARIA/apg/patterns/toolbar/). The root has the `toolbar` role and `aria-orientation`, and separators have the `separator` role.

### Keyboard

The toolbar has one tab stop, a roving focus. Tab enters on the first enabled item, then returns to the item focused last. The next Tab leaves the toolbar.

| Key                        | Action                                          |
| -------------------------- | ----------------------------------------------- |
| `ArrowRight` / `ArrowLeft` | Move focus in a horizontal toolbar              |
| `ArrowDown` / `ArrowUp`    | Move focus in a vertical toolbar                |
| `Home` / `End`             | Focus the first or last item, except in a field |
| `Enter` / `Space`          | Activate a button or toggle, or open its popup  |

Controls keep the keys they use: Down opens a menu, and Up and Down step a number input. Moving focus never presses a toggle. In right-to-left text, Left and Right swap.

### Tested Behavior

Every line below is an automated test.

- The toolbar is named and has a horizontal orientation.
- Tab lands on the first item, and Tab again leaves the toolbar.
- Shift+Tab from after the toolbar lands on its tab stop.
- ArrowRight moves through every item, into toggle groups and out of fields.
- ArrowRight on the last item wraps to the first, and ArrowLeft back.
- Arrow keys never press a toggle, and Space and Enter do.
- Tab comes back to the item focused last.
- A toggle group in the toolbar is no tab stop of its own.
- A disabled button stays reachable, says it's disabled and does nothing.
- A button runs its action when pressed.
- A menu trigger rendered through a button opens with ArrowDown, and arrows still move past it.
- Choosing from a menu in the toolbar returns focus to its trigger.
- A text field keeps Home and End for its caret.
- Up and Down step a number field in the toolbar.
- Separators run across the toolbar.
- A group of buttons is named.
- A link in the toolbar follows its href with Enter.
- With loop off, arrows stop at the ends.
- A disabled toolbar keeps one tab stop, and every item says it's disabled.

**Vertical**

- ArrowDown and ArrowUp move between items, and Left and Right don't.
- Separators run across a vertical toolbar.

**Disabled groups**

- Toggles and toggle groups in a disabled group are disabled.
- A link in a disabled group is disabled, and follows its href once enabled.
- Enabling a group enables the toggles and buttons in it.

Runs in React, Vue and web components.
