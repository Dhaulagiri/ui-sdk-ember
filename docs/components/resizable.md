---
title: Resizable
description: Resize, collapse, and save panel layouts with pointer and keyboard controls.
---

Use a resizable group to let people size the panes of a layout, like a file list beside an editor, by dragging the handle between them or with the keyboard.

[resizable/basic](../../examples/components/resizable/ember/basic.gts)

Drag the handle beside Files, then the one between page.tsx and Terminal.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

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

Import the root and put together the parts it yields:

```gts
import { Resizable } from "ember-ui-sdk/resizable"

<template>
  <Resizable as |r|>
    <r.Panel @defaultSize={{30}}>Files</r.Panel>
    <r.Handle aria-label="Resize files" />
    <r.Panel>Editor</r.Panel>
  </Resizable>
</template>
```

The panel without `@defaultSize` takes what's left, here 70%.

## Vertical

Pass `@orientation="vertical"` to stack the panels, and give the group a height. ArrowUp and ArrowDown move the handle. Every part gets `data-orientation` with the group's direction, so a vertical group's handle is `[data-slot="resizable-handle"][data-orientation="vertical"]`.

[resizable/vertical](../../examples/components/resizable/ember/vertical.gts)

Drag the handle between Inbox and Quarterly report, or focus it and use ArrowUp and ArrowDown.

## Handle

Put anything inside a handle, like a grip that shows it can be dragged. The handle can stay a thin line: its hit area is at least 10 pixels across, centered on it, and 24 for touch, without any styles.

[resizable/handle](../../examples/components/resizable/ember/handle.gts)

Grab the grip beside Channels, or focus the handle and use the arrow keys.

## Collapsible

`@collapsible={{true}}` lets a panel collapse below its `@minSize` to `@collapsedSize`, 0 by default: by dragging past the midpoint to its collapsed size, with Enter or a double-click on its handle, or through the controller. Dragging back past the same point opens it at its minimum, and Enter restores the size it had. A collapsed panel gets `data-collapsed`, and at size 0 its content leaves the tab order and the accessibility tree.

[resizable/collapsible](../../examples/components/resizable/ember/collapsible.gts)

Drag the sidebar closed to leave only its icons, or focus its handle and press Enter to collapse and restore it.

## Sizes in Pixels

Sizes are percentages as numbers, or strings with `%`, `px` or `rem`. Pixel and rem bounds hold as the group resizes, so a navigation with `@minSize="160px"` never gets narrower, and a change they cause reports the `resize` reason.

[resizable/sizes](../../examples/components/resizable/ember/sizes.gts)

Resize Docs. It stays between 160 and 320 pixels wide, whatever the width of the group.

## Default Layout

`@defaultLayout` sets every panel's size at once, in order. Otherwise panels without `@defaultSize` share what's left evenly.

[resizable/default-layout](../../examples/components/resizable/ember/default-layout.gts)

The three mail panels start at 25, 35 and 40 percent. Resize any of them.

## Controlled

Pass `@layout` and update it in `@onLayoutChange`, which also receives the reason. The layout is one percentage per panel, in order, adding up to 100. Every change carries a [reason](https://ui-sdk.dev/docs/react/components/resizable#reasons), like `drag`, `step-key` or `collapse`, and `details.cancel()` keeps the current layout.

[resizable/controlled](../../examples/components/resizable/ember/controlled.gts)

Resize Files to log the layout and its reason. Split Evenly and Reset set the layout from outside.

## Saving on Complete

`@onLayoutChange` runs on every frame of a drag. `@onLayoutCommit` runs once, when the interaction that changed the layout ends: the pointer lifts, the key comes up, or a panel collapses. Save there.

[resizable/complete](../../examples/components/resizable/ember/complete.gts)

Drag the handle and release it, or press an arrow key. The console logs the layout once, when you let go.

## Persistence

`@autoSaveId` saves the layout in `localStorage` when an interaction completes and restores it when the group attaches in the browser. Server markup starts with the default sizes. Each set of panels keeps its own layout, so a panel that comes and goes gets its sizes back. Give panels an `id` so the saved layout survives changes elsewhere on the page.

[resizable/persistence](../../examples/components/resizable/ember/persistence.gts)

Resize Outline, then reload this page to restore its saved width.

## Storage

`@storage` takes anything with `getItem` and `setItem`, like `sessionStorage` or a cookie store. The layout is saved under `@autoSaveId`.

This example keeps the layout in `sessionStorage`, for the tab's session:

[resizable/storage](../../examples/components/resizable/ember/storage.gts)

Resize Messages, then reload. The width comes back in this tab, but not in a new one.

A server can't read `localStorage`, so it renders each panel's `@defaultSize` and the saved layout arrives when the page hydrates.

## Controller

A controller, from `createResizableController()`, collapses, expands and resizes panels from anywhere, by id or index, and reads the layout with `getLayout()`. Changes it makes report the `imperative` reason.

[resizable/controller](../../examples/components/resizable/ember/controller.gts)

Use Collapse, Expand and 240px to move Files from outside the group, and Read to log its sizes.

## Step Size

`@step` sets how far an arrow key moves a handle, 1% by default, and `@largeStep` how far Shift with an arrow moves it, 10% by default.

[resizable/keyboard](../../examples/components/resizable/ember/keyboard.gts)

Focus the handle between Original and Changes. The arrow keys move it 5%, Shift with an arrow 25%, and Home and End as far as it goes.

## Disabled

`@disabled={{true}}` on a handle fixes it in place. On the group it fixes every handle. Disabled handles leave the tab order, and their panels keep their sizes. A disabled `<fieldset>` around the group fixes every handle too.

[resizable/disabled](../../examples/components/resizable/ember/disabled.gts)

The handle after Pinned stays fixed. Drag the one after Inbox, then check Lock layout to fix it too.

## Custom Rendering

Pass `@render={{true}}` to a part to render it as your own element. It yields `{ part, state }`, where the state includes a panel's `size` and whether it's `collapsed`, or whether a handle is `dragging` or `hovering`.

[resizable/render](../../examples/components/resizable/ember/render.gts)

Resize Files to see both panels report their size, or collapse it to see Collapsed.

The primitive writes drag sizes directly to panel styles. Reading `size` or `layout` in a template also updates that part on every frame of the drag.

## Styling

Parts are unstyled, apart from the layout they need: the group is a flex row or column, panels take their size as a flex basis, and handles don't shrink and take `touch-action: none`. Give the group a size, the handle a width or height and a background, and style it with `data-hovering`, `data-dragging` and `:focus-visible`. While a handle is hovered or dragged, its cursor shows over the whole page, and points the only way it can go at a limit.

Each part has a `data-slot`, such as `resizable-handle`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/resizable#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [resizable reference](https://ui-sdk.dev/docs/react/components/resizable) in the upstream docs.

Pass the root's options as `@` arguments. `@layout` is controlled with `@onLayoutChange`.

### Controller

Create one with `createResizableController()` and pass it as `@controller`.

Write methods take an optional `{ reason, event }`, run the change callback like a drag, and return `false` when nothing changed or the change was canceled.

### Events

Callbacks get the new layout first, then the details. A controlled `@layout` only updates when `@onLayoutChange` wasn't canceled.

| Argument          | On          | Receives                                                                                                         |
| ----------------- | ----------- | ---------------------------------------------------------------------------------------------------------------- |
| `@onLayoutChange` | `Resizable` | `(layout, details)`: the new layout and the [reason](https://ui-sdk.dev/docs/react/components/resizable#reasons) |
| `@onLayoutCommit` | `Resizable` | `(layout, details)`: the layout once the interaction ends                                                        |

## Accessibility

Handles follow the [WAI-ARIA window splitter pattern](https://www.w3.org/WAI/ARIA/apg/patterns/windowsplitter/). Each is a focusable `separator` whose `aria-valuenow` is the size of the panel before it, with `aria-valuemin` and `aria-valuemax` as far as the panels allow, `aria-controls` pointing at that panel, and `aria-orientation` running across the group. Name each handle with `aria-label`.

### Keyboard

Focus a handle and press the arrow keys along the group's axis to move it by `@step`, or with Shift by `@largeStep`. Home and End move it as far as the panels allow, and Enter collapses or restores a collapsible panel beside it. A panel at its minimum passes the rest of a move on to the next one. Disabled handles leave the tab order.
