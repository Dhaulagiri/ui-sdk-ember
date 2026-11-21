# Resizable

Resize, collapse, and save panel layouts with pointer and keyboard controls.

Use a resizable group to let people size the panes of a layout, like a file list beside an editor, by dragging the handle between them or with the keyboard.

```glimmer-ts title="basic.gts"
import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable as |r|>
    <r.Panel @defaultSize={{35}} @minSize={{20}}>
      <h3>Files</h3>
      <ul>
        <li>page.tsx</li>
        <li>layout.tsx</li>
        <li>globals.css</li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize files" />
    <r.Panel @defaultSize={{65}} @minSize={{40}}>
      <Resizable @orientation="vertical" as |r|>
        <r.Panel @defaultSize={{60}} @minSize={{30}}>
          <h3>page.tsx</h3>
          <span data-slot="hint">Saved just now</span>
        </r.Panel>
        <r.Handle aria-label="Resize editor" />
        <r.Panel @defaultSize={{40}} @minSize={{30}}>
          <h3>Terminal</h3>
          <span data-slot="hint">Ready on port 3000</span>
        </r.Panel>
      </Resizable>
    </r.Panel>
  </Resizable>
</template>
```

Drag the handle beside Files, then the one between page.tsx and Terminal.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Resizable`:

```text
Resizable
├── ResizablePanel
├── ResizableHandle
└── ResizablePanel
```

Put a handle between the panels you want to resize, and name it with `aria-label`, like "Resize files". The group lays its panels out in a row, so give it a size, and each panel's size is a percentage of the space the panels share. A group can sit inside a panel, like an editor above a terminal.

## Usage

Import the parts and put them together:

```gts
import {
  Resizable,
  ResizableHandle,
  ResizablePanel,
} from "ember-ui-sdk/resizable"

<template>
  <Resizable>
    <ResizablePanel @defaultSize={{30}}>Files</ResizablePanel>
    <ResizableHandle aria-label="Resize files" />
    <ResizablePanel>Editor</ResizablePanel>
  </Resizable>
</template>
```

The panel without `@defaultSize` takes what's left, here 70%.

## Vertical

Pass `@orientation="vertical"` to stack the panels, and give the group a height. ArrowUp and ArrowDown move the handle. Every part gets `data-orientation` with the group's direction, so a vertical group's handle is `[data-slot="resizable-handle"][data-orientation="vertical"]`.

```glimmer-ts title="vertical.gts"
import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable @orientation="vertical" as |r|>
    <r.Panel @defaultSize={{45}} @minSize={{25}}>
      <h3>Inbox</h3>
      <span data-slot="hint">3 unread messages</span>
    </r.Panel>
    <r.Handle aria-label="Resize inbox" />
    <r.Panel @defaultSize={{55}} @minSize={{25}}>
      <h3>Quarterly report</h3>
      <span data-slot="hint">From Hollis Grant</span>
    </r.Panel>
  </Resizable>
</template>
```

Drag the handle between Inbox and Quarterly report, or focus it and use ArrowUp and ArrowDown.

## Handle

Put anything inside a handle, like a grip that shows it can be dragged. The handle can stay a thin line: its hit area is at least 10 pixels across, centered on it, and 24 for touch, without any styles.

```glimmer-ts title="handle.gts"
import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable as |r|>
    <r.Panel @defaultSize={{35}} @minSize={{20}}>
      <h3>Channels</h3>
      <ul>
        <li>general</li>
        <li>design</li>
        <li>releases</li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize channels">
      <div></div>
    </r.Handle>
    <r.Panel @defaultSize={{65}} @minSize={{20}}>
      <h3>general</h3>
      <span data-slot="hint">Kofi Mensah: The release notes are ready.</span>
    </r.Panel>
  </Resizable>
</template>
```

Grab the grip beside Channels, or focus the handle and use the arrow keys.

## Collapsible

`@collapsible={{true}}` lets a panel collapse below its `@minSize` to `@collapsedSize`, 0 by default: by dragging past the midpoint to its collapsed size, with Enter or a double-click on its handle, or through the controller. Dragging back past the same point opens it at its minimum, and Enter restores the size it had. A collapsed panel gets `data-collapsed`, and at size 0 its content leaves the tab order and the accessibility tree.

```glimmer-ts title="collapsible.gts"
import { Folder, Search, Settings } from "lucide"
import { Resizable } from "ember-ui-sdk/resizable"
import { icon } from "./icon"

<template>
  <Resizable as |r|>
    <r.Panel @defaultSize={{30}} @minSize={{25}} @collapsible={{true}} @collapsedSize="48px">
      <ul>
        <li data-slot="row">
          {{icon Folder}}
          <span>Files</span>
        </li>
        <li data-slot="row">
          {{icon Search}}
          <span>Search</span>
        </li>
        <li data-slot="row">
          {{icon Settings}}
          <span>Settings</span>
        </li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize sidebar">
      <div></div>
    </r.Handle>
    <r.Panel @minSize={{40}}>
      <h3>README.md</h3>
      <span data-slot="hint">Edited by Inès Moreau</span>
    </r.Panel>
  </Resizable>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Drag the sidebar closed to leave only its icons, or focus its handle and press Enter to collapse and restore it.

## Sizes in Pixels

Sizes are percentages as numbers, or strings with `%`, `px` or `rem`. Pixel and rem bounds hold as the group resizes, so a navigation with `@minSize="160px"` never gets narrower, and a change they cause reports the `resize` reason.

```glimmer-ts title="sizes.gts"
import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable as |r|>
    <r.Panel @defaultSize="200px" @minSize="160px" @maxSize="320px">
      <h3>Docs</h3>
      <ul>
        <li>Getting Started</li>
        <li>Components</li>
        <li>Guides</li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize navigation">
      <div></div>
    </r.Handle>
    <r.Panel @minSize={{30}}>
      <h3>Getting Started</h3>
      <span data-slot="hint">Install the packages</span>
    </r.Panel>
  </Resizable>
</template>
```

Resize Docs. It stays between 160 and 320 pixels wide, whatever the width of the group.

## Default Layout

`@defaultLayout` sets every panel's size at once, in order. Otherwise panels without `@defaultSize` share what's left evenly.

```glimmer-ts title="default-layout.gts"
import { array } from "@ember/helper"
import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable @defaultLayout={{array 25 35 40}} as |r|>
    <r.Panel @minSize={{15}}>
      <h3>Mail</h3>
      <ul>
        <li>Inbox</li>
        <li>Drafts</li>
        <li>Sent</li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize folders" />
    <r.Panel @minSize={{15}}>
      <h3>Inbox</h3>
      <ul>
        <li>Hollis Grant</li>
        <li>Inès Moreau</li>
        <li>Kofi Mensah</li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize inbox" />
    <r.Panel @minSize={{15}}>
      <h3>Quarterly report</h3>
      <span data-slot="hint">From Hollis Grant</span>
    </r.Panel>
  </Resizable>
</template>
```

The three mail panels start at 25, 35 and 40 percent. Resize any of them.

## Controlled

Pass `@layout` and update it in `@onLayoutChange`, which also receives the reason. The layout is one percentage per panel, in order, adding up to 100. Every change carries a [reason](#reasons), like `drag`, `step-key` or `collapse`, and `details.cancel()` keeps the current layout.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Resizable } from "ember-ui-sdk/resizable"
import { useLog } from "./log"

const format = (layout: number[]) => layout.map(Math.round).join(" / ")

export default class Controlled extends Component {
  log = useLog(this)
  @tracked layout = [30, 70]

  split = () => {
    this.layout = [50, 50]
  }

  reset = () => {
    this.layout = [30, 70]
  }

  onLayoutChange = (next: number[], details: { reason: string }) => {
    if (format(next) !== format(this.layout)) {
      this.log(`${format(next)} (${details.reason})`)
    }
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.split}}>Split Evenly</button>
        <button type="button" {{on "click" this.reset}}>Reset</button>
      </div>
      <Resizable @layout={{this.layout}} @onLayoutChange={{this.onLayoutChange}} as |r|>
        <r.Panel @minSize={{20}}>
          <h3>Files</h3>
          <ul>
            <li>page.tsx</li>
            <li>layout.tsx</li>
            <li>globals.css</li>
          </ul>
        </r.Panel>
        <r.Handle aria-label="Resize files" />
        <r.Panel @minSize={{20}}>
          <h3>page.tsx</h3>
          <span data-slot="hint">Saved just now</span>
        </r.Panel>
      </Resizable>
    </div>
  </template>
}
```

Resize Files to log the layout and its reason. Split Evenly and Reset set the layout from outside.

## Saving on Complete

`@onLayoutChange` runs on every frame of a drag. `@onLayoutCommit` runs once, when the interaction that changed the layout ends: the pointer lifts, the key comes up, or a panel collapses. Save there.

```glimmer-ts title="complete.gts"
import Component from "@glimmer/component"
import { Resizable } from "ember-ui-sdk/resizable"
import { useLog } from "./log"

export default class Complete extends Component {
  log = useLog(this)

  onLayoutCommit = (layout: number[], details: { reason: string }) => {
    this.log(`Saved ${layout.map(Math.round).join(" / ")} (${details.reason})`)
  }

  <template>
    <Resizable @onLayoutCommit={{this.onLayoutCommit}} as |r|>
      <r.Panel @defaultSize={{40}} @minSize={{20}}>
        <h3>Files</h3>
        <ul>
          <li>page.tsx</li>
          <li>layout.tsx</li>
          <li>globals.css</li>
        </ul>
      </r.Panel>
      <r.Handle aria-label="Resize files" />
      <r.Panel @minSize={{20}}>
        <h3>page.tsx</h3>
        <span data-slot="hint">Saved just now</span>
      </r.Panel>
    </Resizable>
  </template>
}
```

Drag the handle and release it, or press an arrow key. The console logs the layout once, when you let go.

## Persistence

`@autoSaveId` saves the layout in `localStorage` when an interaction completes and restores it when the group attaches in the browser. Server markup starts with the default sizes. Each set of panels keeps its own layout, so a panel that comes and goes gets its sizes back. Give panels an `@id` so the saved layout survives changes elsewhere on the page.

```glimmer-ts title="persistence.gts"
import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable @autoSaveId="docs-persistence" as |r|>
    <r.Panel @id="docs-sidebar" @defaultSize={{30}} @minSize={{20}}>
      <h3>Outline</h3>
      <ul>
        <li>Introduction</li>
        <li>Installation</li>
        <li>Usage</li>
      </ul>
    </r.Panel>
    <r.Handle aria-label="Resize outline">
      <div></div>
    </r.Handle>
    <r.Panel @id="docs-content" @minSize={{30}}>
      <h3>Introduction</h3>
      <span data-slot="hint">Last edited by Wren Takahashi</span>
    </r.Panel>
  </Resizable>
</template>
```

Resize Outline, then reload this page to restore its saved width.

## Storage

`@storage` takes anything with `getItem` and `setItem`, like `sessionStorage` or a cookie store. The layout is saved under `@autoSaveId`.

This example keeps the layout in `sessionStorage`, for the tab's session:

```glimmer-ts title="storage.gts"
import Component from "@glimmer/component"
import { Resizable } from "ember-ui-sdk/resizable"

export default class Storage extends Component {
  session = {
    getItem: (key: string) => sessionStorage.getItem(key),
    setItem: (key: string, value: string) => sessionStorage.setItem(key, value),
  }

  <template>
    <Resizable @autoSaveId="docs-storage" @storage={{this.session}} as |r|>
      <r.Panel @id="session-chats" @defaultSize={{35}} @minSize={{20}}>
        <h3>Messages</h3>
        <ul>
          <li>Inès Moreau</li>
          <li>Kofi Mensah</li>
          <li>Wren Takahashi</li>
        </ul>
      </r.Panel>
      <r.Handle aria-label="Resize messages" />
      <r.Panel @id="session-thread" @minSize={{20}}>
        <h3>Inès Moreau</h3>
        <span data-slot="hint">Can we move the review to Friday?</span>
      </r.Panel>
    </Resizable>
  </template>
}
```

Resize Messages, then reload. The width comes back in this tab, but not in a new one.

A server can't read `localStorage`, so it renders each panel's `@defaultSize` and the saved layout arrives when the page hydrates.

## Controller

A controller, from `createResizableController()`, collapses, expands and resizes panels from anywhere, by `@id` or index, and reads the layout with `getLayout()`. Changes it makes report the `imperative` reason.

```glimmer-ts title="controller.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Resizable, createResizableController } from "ember-ui-sdk/resizable"
import { useLog } from "./log"

export default class ControllerExample extends Component {
  log = useLog(this)
  editor = createResizableController()

  collapse = () => {
    this.editor.collapse("controller-sidebar")
  }

  expand = () => {
    this.editor.expand("controller-sidebar")
  }

  resize = () => {
    this.editor.resize("controller-sidebar", "240px")
  }

  read = () => {
    const collapsed = this.editor.isCollapsed("controller-sidebar")
      ? ", collapsed"
      : ""
    this.log(
      `Layout ${this.editor.getLayout().map(Math.round).join(" / ")}${collapsed}`
    )
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.collapse}}>Collapse</button>
        <button type="button" {{on "click" this.expand}}>Expand</button>
        <button type="button" {{on "click" this.resize}}>240px</button>
        <button type="button" {{on "click" this.read}}>Read</button>
      </div>
      <Resizable @controller={{this.editor}} as |r|>
        <r.Panel @id="controller-sidebar" @defaultSize={{30}} @minSize={{20}} @collapsible={{true}}>
          <h3>Files</h3>
          <ul>
            <li>page.tsx</li>
            <li>layout.tsx</li>
            <li>globals.css</li>
          </ul>
        </r.Panel>
        <r.Handle aria-label="Resize files" />
        <r.Panel @minSize={{30}}>
          <h3>page.tsx</h3>
          <span data-slot="hint">Saved just now</span>
        </r.Panel>
      </Resizable>
    </div>
  </template>
}
```

Use Collapse, Expand and 240px to move Files from outside the group, and Read to log its sizes.

## Step Size

`@step` sets how far an arrow key moves a handle, 1% by default, and `@largeStep` how far Shift with an arrow moves it, 10% by default.

```glimmer-ts title="keyboard.gts"
import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable @step={{5}} @largeStep={{25}} as |r|>
    <r.Panel @defaultSize={{50}} @minSize={{20}}>
      <h3>Original</h3>
      <span data-slot="hint">v1.2.0</span>
    </r.Panel>
    <r.Handle aria-label="Resize original" />
    <r.Panel @defaultSize={{50}} @minSize={{20}}>
      <h3>Changes</h3>
      <span data-slot="hint">v1.3.0</span>
    </r.Panel>
  </Resizable>
</template>
```

Focus the handle between Original and Changes. The arrow keys move it 5%, Shift with an arrow 25%, and Home and End as far as it goes.

## Disabled

`@disabled={{true}}` on a handle fixes it in place. On the group it fixes every handle. Disabled handles leave the tab order, and their panels keep their sizes. A disabled `<fieldset>` around the group fixes every handle too.

```glimmer-ts title="disabled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Resizable } from "ember-ui-sdk/resizable"
import { icon } from "./icon"

export default class Disabled extends Component {
  @tracked locked: boolean | "indeterminate" = false

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.locked = next
  }

  get isLocked() {
    return this.locked === true
  }

  get unlocked() {
    return this.locked !== true
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <label data-slot="label">
          <Checkbox @checked={{this.locked}} @onCheckedChange={{this.onCheckedChange}} as |c|>
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Lock layout
        </label>
      </div>
      <Resizable @disabled={{this.isLocked}} as |r|>
        <r.Panel @minSize={{15}}>
          <h3>Pinned</h3>
          <span data-slot="hint">2 notes</span>
        </r.Panel>
        <r.Handle @disabled={{true}} aria-label="Resize pinned" />
        <r.Panel @minSize={{15}}>
          <h3>Inbox</h3>
          <span data-slot="hint">3 unread</span>
        </r.Panel>
        <r.Handle aria-label="Resize inbox" />
        <r.Panel @minSize={{15}}>
          <h3>Message</h3>
          <span data-slot="hint">From Kofi Mensah</span>
        </r.Panel>
      </Resizable>
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

The handle after Pinned stays fixed. Drag the one after Inbox, then check Lock layout to fix it too.

## Custom Rendering

Pass `@render={{true}}` to a part to render it as your own element. It yields `{ part, state }`, where the state includes a panel's `size` and whether it's `collapsed`, or whether a handle is `dragging` or `hovering`.

```glimmer-ts title="render.gts"
import Component from "@glimmer/component"
import { Resizable } from "ember-ui-sdk/resizable"

const percent = (size: number) => `${Math.round(size)}%`

export default class Render extends Component {
  percent = percent

  <template>
    <Resizable as |r|>
      <r.Panel @defaultSize={{35}} @minSize={{20}} @collapsible={{true}} as |p|>
        <h3>Files</h3>
        <span data-slot="hint">{{if
            p.state.collapsed
            "Collapsed"
            (this.percent p.state.size)
          }}</span>
      </r.Panel>
      <r.Handle aria-label="Resize files" @render={{true}} as |h|>
        <div {{h.part}}></div>
      </r.Handle>
      <r.Panel @minSize={{30}} as |p|>
        <h3>Editor</h3>
        <span data-slot="hint">{{this.percent p.state.size}}</span>
      </r.Panel>
    </Resizable>
  </template>
}
```

Resize Files to see both panels report their size, or collapse it to see Collapsed.

The primitive writes drag sizes directly to panel styles. Reading `size` or `layout` in a template also updates that part on every frame of the drag.

## Styling

Parts are unstyled, apart from the layout they need: the group is a flex row or column, panels take their size as a flex basis, and handles don't shrink and take `touch-action: none`. Give the group a size, the handle a width or height and a background, and style it with `data-hovering`, `data-dragging` and `:focus-visible`. While a handle is hovered or dragged, its cursor shows over the whole page, and points the only way it can go at a limit.

Each part has a `data-slot`, such as `resizable-handle`, and its state attributes are listed under [Data Attributes](#data-attributes).

### ResizablePanel
- `--resizable-panel-size`: The panel's share of the group, as a percentage. Written on every frame of a drag, without a render.

## Data Attributes

### Resizable
`[data-slot="resizable"]`

- `data-orientation` (`horizontal`, `vertical`): The group's direction, on every part. A handle's own `aria-orientation` is the other one, since it runs across the group.
- `data-disabled`: Present when the group, or this handle, is disabled.
- `data-dragging`: Present while a handle of the group is being dragged.

### ResizablePanel
`[data-slot="resizable-panel"]`

- `data-orientation` (`horizontal`, `vertical`): The group's direction, on every part. A handle's own `aria-orientation` is the other one, since it runs across the group.
- `data-collapsed`: Present while a collapsible panel is collapsed.

### ResizableHandle
`[data-slot="resizable-handle"]`

- `data-orientation` (`horizontal`, `vertical`): The group's direction, on every part. A handle's own `aria-orientation` is the other one, since it runs across the group.
- `data-disabled`: Present when the group, or this handle, is disabled.
- `data-dragging`: Present while this handle is being dragged.
- `data-hovering`: Present while the pointer is over the handle or within its hit area, which reaches past the handle itself.

## API Reference

Pass the root's options as `@` arguments. `@layout` is controlled with `@onLayoutChange`.

### Resizable

- `layout?` (`number[]`): Each panel's size in percent, in panel order, like `[25, 75]`. Pass it to control the group.
- `defaultLayout?` (`number[]`): The layout at first, when uncontrolled. Panels' own `defaultSize` is what a server renders, so prefer that with server rendering.
- `onLayoutChange?` (`((layout: number[], details: ResizableLayoutChangeDetails) => void)`): Runs while the layout changes: on every frame of a drag and every key. `details.cancel()` keeps the layout.
- `onLayoutCommit?` (`((layout: number[], details: ResizableLayoutCommitDetails) => void)`): Runs once an interaction that changed the layout ends: the pointer lifts, the key comes up, or a panel collapses. For saving.
- `orientation?` (`"horizontal" | "vertical"`): The direction panels are laid out in. Horizontal panels sit side by side, vertical ones stack.
- `disabled?` (`boolean`): Stops every handle: no drags, no keys, and handles leave the tab order.
- `step?` (`number`): How far an arrow key moves a handle, in percent.
- `largeStep?` (`number`): How far Shift with an arrow key moves a handle, in percent.
- `autoSaveId?` (`string`): Saves the layout when an interaction completes and restores it on the next visit, under this key. Give panels an `@id` so it survives changes elsewhere on the page.
- `storage?` (`ResizableStorage`): Where `autoSaveId` saves: anything with `getItem` and `setItem`, like a cookie store a server can read.
- `controller?` (`object`): Resizes the group from anywhere. Create one with `createResizableController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### ResizablePanel

- `id?` (`string`): Identifies the panel for the controller, `aria-controls` and saved layouts. It's the element's id. Generated when left out.
- `defaultSize?` (`ResizableSize`): Where the panel starts, in percent or with a unit, like `30` or `"240px"`. Without one, panels share what's left evenly. A server renders this size.
- `minSize?` (`ResizableSize`): The smallest the panel gets while open.
- `maxSize?` (`ResizableSize`): The largest the panel gets.
- `collapsible?` (`boolean`): Lets the panel collapse below its minimum to `collapsedSize`: by dragging past half the way there, with Enter or a double-click on its handle, or through the controller.
- `collapsedSize?` (`ResizableSize`): The size a collapsible panel collapses to. At 0, its content leaves the tab order and the accessibility tree.

### ResizableHandle

- `disabled?` (`boolean`): Stops this handle: no drags and no keys, and it leaves the tab order.

### State

What `@render` parts and their blocks receive.

- `orientation` (`"horizontal" | "vertical"`): The direction panels are laid out in.
- `disabled` (`boolean`): Whether the group is disabled.
- `dragging` (`boolean`): Whether a handle is being dragged.
- `layout` (`number[]`): Each panel's size in percent. Reading it renders on every frame of a drag.

Panels:

- `orientation` (`"horizontal" | "vertical"`): The direction panels are laid out in.
- `size` (`number`): The panel's size in percent. Reading it renders on every frame of a drag.
- `collapsed` (`boolean`): Whether the panel is down at its `collapsedSize`, below its minimum.
- `collapsible` (`boolean`): Whether the panel can collapse.

Handles:

- `orientation` (`"horizontal" | "vertical"`): The direction panels are laid out in. The separator itself runs across it.
- `disabled` (`boolean`): Whether the handle can't move.
- `dragging` (`boolean`): Whether the handle is being dragged.
- `hovering` (`boolean`): Whether the pointer is over the handle or within its hit area.

### Reasons

`details.reason` says why the layout changed.

- `drag` (`PointerEvent`): A slider thumb or a resize handle was dragged, or an item was dragged to a new place in a list.
- `step-key` (`KeyboardEvent`): Arrow, Page Up, Page Down, Home or End stepped a slider or a number input.
- `collapse` (`MouseEvent | KeyboardEvent`): Enter or a double-click on a resize handle collapsed the panel beside it, or restored it.
- `resize` (`none`): The group changed size, so panels with sizes in pixels moved to stay within their bounds.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createResizableController()` and pass it as `@controller`.

Write methods take an optional `{ reason, event }`, run the change callback like a drag, and return `false` when nothing changed or the change was canceled.

- `getLayout()` (`() => number[]`): Each panel's size in percent, in order.
- `setLayout(layout, options?)` (`(layout: number[], options?: ResizableChangeOptions | undefined) => boolean`): Sets every panel's size at once, in percent. It's fitted to the panels' bounds and adds up to 100. Returns whether anything changed.
- `collapse(panel, options?)` (`(panel: string | number, options?: ResizableChangeOptions | undefined) => boolean`): Collapses a collapsible panel, by its id or its index. Returns whether it collapsed.
- `expand(panel, options?)` (`(panel: string | number, options?: ResizableChangeOptions | undefined) => boolean`): Expands a collapsed panel to the size it had before it collapsed, or its minimum. Returns whether it expanded.
- `resize(panel, size, options?)` (`(panel: string | number, size: ResizableSize, options?: ResizableChangeOptions | undefined) => boolean`): Resizes one panel, by its id or its index, like `resize("sidebar", "240px")`. Its neighbours give or take the difference.
- `isCollapsed(panel)` (`(panel: string | number) => boolean`): Whether a panel is collapsed.

### Events

Callbacks get the new layout first, then the details. A controlled `@layout` only updates when `@onLayoutChange` wasn't canceled.

| Argument          | On          | Receives                                                       |
| ----------------- | ----------- | -------------------------------------------------------------- |
| `@onLayoutChange` | `Resizable` | `(layout, details)`: the new layout and the [reason](#reasons) |
| `@onLayoutCommit` | `Resizable` | `(layout, details)`: the layout once the interaction ends      |

## Accessibility

Handles follow the [WAI-ARIA window splitter pattern](https://www.w3.org/WAI/ARIA/apg/patterns/windowsplitter/). Each is a focusable `separator` whose `aria-valuenow` is the size of the panel before it, with `aria-valuemin` and `aria-valuemax` as far as the panels allow, `aria-controls` pointing at that panel, and `aria-orientation` running across the group. Name each handle with `aria-label`.

### Keyboard

Focus a handle and press the arrow keys along the group's axis to move it by `@step`, or with Shift by `@largeStep`. Home and End move it as far as the panels allow, and Enter collapses or restores a collapsible panel beside it. A panel at its minimum passes the rest of a move on to the next one. Disabled handles leave the tab order.

### Tested Behavior

Every line below is an automated test.

**Keyboard**

- Starts at each panel's default size, and panels without one share the rest.
- ArrowRight grows the panel before the handle by one step, and ArrowLeft shrinks it.
- Shift with an arrow key moves by the large step.
- Arrows across the group's axis do nothing.
- ArrowDown and ArrowUp move a vertical group's handle.
- Home collapses a collapsible panel, and End grows it to its maximum.
- Home stops at the minimum of a panel that can't collapse.
- Enter collapses the panel before the handle, and restores its size.
- Enter collapses the panel after the handle when only that one can collapse.
- One step past a collapsible panel's minimum collapses it.
- A panel at its minimum passes the rest on to the next one.
- End stops where the panels' bounds meet.
- Keys pressed without waiting all land.
- Keys complete the change once they come up.
- Step and large step set how far keys move.
- A canceled change keeps the layout.
- A controlled group follows its layout.
- A controlled group that ignores a change completes nothing. React and Vue only.
- A disabled handle stops a move from the next one, so the panels past it keep their sizes.
- DefaultLayout sets where the panels start.
- A disabled group's handles leave the tab order and ignore drags.

**Pointer**

- Dragging a handle moves it with the pointer.
- A drag reports its moves with the drag reason and completes once.
- Dragging past a disabled handle moves nothing beyond it.
- Dragging a vertical group's handle moves it up and down.
- Dragging past half a collapsible panel's minimum collapses it, and back opens it.
- A drag stops at the panels' bounds.
- A double-click on a handle collapses its panel, and another restores it.
- A press just beside the thin handle drags it.
- A press farther from the handle doesn't drag.
- Where two handles meet, one drag moves both.
- A drag shows the axis cursor over the whole page until it ends.

**Controller**

- Collapses and expands a panel, with the imperative reason.
- Resizes a panel to a size in pixels.

**Container**

- A panel with a minimum in pixels keeps it as the group shrinks.
- Panels keep their share as the group grows.

**Pages around a group**

- A layer above a handle keeps its presses.
- A press beside a handle doesn't click what's under it.
- Only the main button drags.
- An iframe under the pointer doesn't stop a drag.
- At a limit, the cursor points the only way a handle can go.
- A saved layout is there on the first paint.

Runs in React, Vue and web components.
