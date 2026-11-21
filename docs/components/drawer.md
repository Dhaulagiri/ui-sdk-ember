---
title: Drawer
description: A sheet you can open, drag, and resize from an edge of the screen.
---

A drawer gives a task its own sheet without leaving the page. It shares [Dialog’s](./dialog.md) focus and dismissal behavior, then adds dragging, snap points, and a handle you can use with the keyboard.

[drawer/basic](../../examples/components/drawer/ember/basic.gts)

Open the drawer, adjust the daily goal, then Submit or Cancel. You can also press Escape, press outside, or drag the sheet toward its edge to close it.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Drawer`:

```text
Drawer as |d|
├── d.Trigger
├── d.Backdrop
└── d.Content
    ├── d.Title
    ├── d.Description
    └── d.Close
```

The content is the sheet. The drawer positions it inside a full-screen viewport and moves it with `translate`. Give it a size, a surface, and corners; leave positioning and translation to the drawer. Give the backdrop a color, such as `bg-black/30`; the drawer manages its opacity.

## Usage

Import the root and use the parts it yields:

```gts
import { Drawer } from "ember-ui-sdk/drawer"

<template>
  <Drawer as |d|>
    <d.Trigger>Filters</d.Trigger>
    <d.Backdrop />
    <d.Content>
      <d.Title>Filters</d.Title>
      <d.Description>Narrow down the results.</d.Description>
      <d.Close>Done</d.Close>
    </d.Content>
  </Drawer>
</template>
```

## Scrollable Content

Put long content in an inner `min-h-0 flex-1 overflow-y-auto` area. A downward drag scrolls that area first; when it reaches the top, the same gesture can move the drawer. `@initialFocus="content"` starts focus on the sheet itself.

Fields, sliders and color areas inside the sheet keep their own drags. For a drag surface of your own, like a canvas or a map, add `data-drawer-no-drag` to it, and a drag that starts there won't move the drawer.

[drawer/scrollable](../../examples/components/drawer/ember/scrollable.gts)

Open the long sheet and scroll its text. At the top, drag downward to move the sheet; on a keyboard, Tab reaches the controls and Escape closes it.

## Sides

`@side` chooses bottom, top, left, or right. Logical `start` and `end` follow text direction. The content’s `data-side` tells you which physical edge to style.

Side drawers can opt into `@preventEdgeSwipe={{true}}` to keep an edge gesture from starting iOS Safari’s back or forward navigation. It also prevents clicks right at those edges, so use it only when you need that tradeoff.

[drawer/sides](../../examples/components/drawer/ember/sides.gts)

Open a sheet from each edge. Drag it back toward that edge, press outside, or press Escape to close it.

## Snap Points

`@snapPoints` are the places the drawer can rest. It opens at the first, or at `@defaultSnapPoint`, and settles at another after a drag. A fast fling can skip intermediate points.

| Value              | Size                                       |
| ------------------ | ------------------------------------------ |
| `0.5`              | Half the viewport along the drawer’s axis. |
| `320` or `"320px"` | Pixels; numbers above 1 are pixel values.  |
| `"20rem"`          | A multiple of the root font size.          |
| `"50%"`            | A percentage of the viewport.              |
| `"content"`        | The sheet’s own size, the default.         |

The sheet’s CSS size is the limit: `1` cannot make a short sheet fill the screen. Use a height such as `h-[calc(100dvh-3rem)]` when the largest point should nearly fill it. The drawer measures again when content or available space changes; a moved resting point reports `content-resize`.

A `d.Handle` is a button with an accessible name. Pressing it moves to the next larger snap point, then wraps to the smallest. Arrow keys along the drawer’s axis move one point without wrapping; Home and End move to the ends.

For a sheet with one snap point, use a decorative bar instead of an inactive button.

[drawer/snap-points](../../examples/components/drawer/ember/snap-points.gts)

Open the sheet at its middle snap point. Drag it, press the handle, or Tab to the handle and use Up, Down, Home and End to try the other resting points.

## Controlled

Pass `@open` and `@snapPoint`, and update them in `@onOpenChange` and `@onSnapPointChange`. You can control opening and snap points independently. Cancel a proposed change with `details.cancel()`; a canceled swipe springs back. `@onOpenChangeComplete` runs after the sheet settles.

```gts
<Drawer
  @open={{this.open}}
  @onOpenChange={{this.onOpenChange}}
  @snapPoints={{array 0.25 0.5 1}}
  @snapPoint={{this.snapPoint}}
  @onSnapPointChange={{this.onSnapPointChange}}
  as |d|
>…</Drawer>
```

## Not Dismissible

With `@dismissible={{false}}`, Escape, outside presses, back gestures, and swipes leave the drawer open. `@onDismissAttempt` tells you what was tried, so you can offer a way to discard unsaved work. Close parts, triggers, and controllers can still close it deliberately.

```gts
<Drawer
  @dismissible={{false}}
  @onDismissAttempt={{this.onDismissAttempt}}
  as |d|
>
  <d.Trigger>Write a Post</d.Trigger>
  <d.Backdrop />
  <d.Content>
    {{#if this.attempt}}
      <d.Close>Discard</d.Close>
    {{/if}}
    <d.Close @value="post">Post</d.Close>
  </d.Content>
</Drawer>
```

## Modal

Set `@modalAbove` when the page should stay usable beside a small sheet. At or below that point there is no dim, inert page, scroll lock, or `aria-modal`. Above it, `@modal` applies. The switch happens when the drawer settles and does not move focus; `data-interactive` exposes the usable-page state.

`@modal` has the same choices as [Dialog](./dialog.md#modal): `true` blocks the page, `"trap-focus"` keeps Tab inside while leaving the page usable, and `false` allows focus to leave. A click on the page also closes a `"trap-focus"` drawer, while a non-modal drawer closes on an outside press only when `@closeOnOutsidePress` is enabled.

[drawer/non-modal](../../examples/components/drawer/ember/non-modal.gts)

Open directions at the small snap point and choose another place behind the sheet. Expand it to make the sheet modal, then collapse it to use the page again.

## Nested Drawers

A drawer opened inside another joins its stack. Escape and outside presses affect the topmost one; closing a parent closes its children. `--drawer-stack` follows the sheets above it as they open and drag, so a parent can scale back with `[scale:calc(1-var(--drawer-stack)*0.04)]`.

[drawer/nested](../../examples/components/drawer/ember/nested.gts)

Open Account, then Change Password. The parent steps back as the child opens; Escape closes one sheet at a time.

## Forms

A Close part’s `@action` can return a Promise. The sheet stays open while it runs, including through Escape or a swipe. A rejection leaves the action’s error state available for a retry. See [Alert Dialog’s async action](./alert-dialog.md#async-action) for the shared pending and error contract.

`@keepMounted={{true}}` preserves unfinished fields, and `@finalFocus` returns focus to the updated profile.

## Outlets

A `d.Outlet` makes another element follow the sheet’s progress. Its `@keyframes` run from collapsed to fully expanded; this example scales and rounds the inbox behind a compose sheet. An outlet outside the drawer connects through its controller.

[drawer/outlet](../../examples/components/drawer/ember/outlet.gts)

Open Compose, then drag the sheet slowly. The inbox behind it scales and rounds with the sheet’s progress.

## Opening from Anywhere

Connect external triggers and the drawer to one `createDrawerController<Payload, Result>()`. Each trigger passes a `@payload`; the content reads it from its state. This lets one sheet serve every row, including disabled triggers for unavailable actions.

Calling `open({ payload })` on the controller returns a Promise with the closing `reason` and `returnValue`. `getSnapPoint()` and `setSnapPoint()` also let code read or move the sheet.

```gts
import { Drawer, createDrawerController } from "ember-ui-sdk/drawer"

const share = createDrawerController<SharedFile, "copy" | "email">()

<template>
  <Drawer @controller={{share}} as |d|>
    <d.Trigger @controller={{share}} @payload={{this.file}}>Share</d.Trigger>
    <d.Backdrop />
    <d.Content>…</d.Content>
  </Drawer>
</template>
```

## Action Sheet

A sheet can offer choices instead of a form. Give each Close part a `@value`; the open Promise returns the chosen action. Escape, an outside press, or a swipe returns no value, which this example treats as Cancel.

Put the least risky action first because a keyboard or code open starts there. Use an [Alert Dialog](./alert-dialog.md) when a choice needs confirmation.

[drawer/action-sheet](../../examples/components/drawer/ember/action-sheet.gts)

Open Photo Options and choose an action. The console logs the returned value; dismissing the sheet counts as Cancel.

## Driver and Physics

`@driver` picks how the sheet moves. `"scroll-snap"` uses native scrolling and CSS snap points for a bottom sheet; `"pointer"` uses pointer dragging and spring motion on every side. The default `"auto"` chooses native scrolling for a bottom sheet on a touch screen, and pointer dragging for mouse and pen, other sides, `@modalAbove`, or `@expandOnScroll={{false}}`. `data-driver` reports the active choice.

Override part of `sheetPhysics.ios` with `@physics` to tune the pointer driver: `response` changes spring timing, `dampingRatio` changes settling, `momentumDampingRatio` affects flings, and `rubberBand` changes resistance past the largest point.

```gts
<Drawer @driver="pointer" @physics={{this.physics}} as |d|>…</Drawer>
```

## Page Integration

`@themeColor={{true}}` dims an existing `<meta name="theme-color">` with the backdrop, so the browser's toolbars can follow it; pages without that tag are left alone. `@persistentElements` keeps selected elements usable while the drawer is modal: an array of elements or selectors, or a function returning elements. Something that must stay above the backdrop also needs its own top-layer surface.

Drawers render in place and use the top layer. `@container` on the content moves the backdrop and viewport elsewhere, for example into a shadow root or out of a surrounding form.

## Styling

Each part has a `data-slot`, such as `drawer-content`, and shows its state through the attributes listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/drawer#data-attributes).

Leave the content's `translate` and the backdrop's opacity to the drawer. You can style scale, corners, colors, and the inner scroll area. A bottom sheet can use an `after` element below its edge to cover the gap during overscroll, as the examples do. The drawer respects reduced motion, fading instead of sliding.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [drawer reference](https://ui-sdk.dev/docs/react/components/drawer) in the upstream docs.

Pass the root's options as `@` arguments. `@open` and `@snapPoint` are controlled with their `@on…Change` callbacks.

### DrawerTrigger

A trigger outside the drawer also takes `@controller`.

### DrawerBackdrop

Dims the page behind a modal drawer, which manages its opacity. Renders a `div`.

### DrawerHandle

Resizes the sheet: a press moves to the next snap point, and arrow keys, Home and End choose one. Renders a `button`.

### DrawerTitle

Names the drawer. Renders an `h2`.

### DrawerDescription

Describes the drawer while it's rendered. Renders a `p`.

### DrawerOutlet

An outlet outside the drawer also takes `@controller`.

### Controller

Create one with `createDrawerController<Payload, Result>()` and pass it as `@controller`, to the drawer and to any triggers and outlets outside it.

Every write method takes an optional `{ reason, event }`, passed to the callbacks. Closing with a controller always works, even when the drawer isn't dismissible or an action is running.

### Events

Callbacks get the new value first, then the details. A controlled `@open` or `@snapPoint` only updates when its change callback wasn't canceled.

| Argument                | On       | Receives                                                                                                                      |
| ----------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| `@onOpenChange`         | `Drawer` | `(open, details)`: the new state, the [reason](https://ui-sdk.dev/docs/react/components/drawer#reasons) and any `returnValue` |
| `@onOpenChangeComplete` | `Drawer` | `(open)`, once it has settled                                                                                                 |
| `@onPayloadChange`      | `Drawer` | `(payload, details)`: the content's new payload, and the [reason](https://ui-sdk.dev/docs/react/components/drawer#reasons)    |
| `@onSnapPointChange`    | `Drawer` | `(snapPoint, details)`: the new snap point and the [reason](https://ui-sdk.dev/docs/react/components/drawer#reasons)          |
| `@onDismissAttempt`     | `Drawer` | `({ reason, event })`, when a dismissal was refused                                                                           |

## Accessibility

The trigger is a button that opens a dialog, and the drawer follows the [WAI-ARIA modal dialog pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/) while it's modal: `aria-modal`, focus trapped inside, the page inert, labelled by its title and described by its description. Escape closes it. The handle is a button that controls the drawer: a press moves to the next snap point, arrow keys along the drawer's axis step, and Home and End go to the ends. Every line below is an automated test.

### Keyboard

| Key                       | Does                                                                          |
| ------------------------- | ----------------------------------------------------------------------------- |
| Enter, Space              | On the trigger, opens the drawer; on the handle, moves to the next snap point |
| Arrow keys along the axis | On the handle, moves one snap point without wrapping                          |
| Home, End                 | On the handle, moves to the smallest or largest snap point                    |
| Tab, Shift+Tab            | Moves through the sheet's controls, staying inside while it's modal           |
| Escape                    | Closes the topmost drawer when it's dismissible                               |

It shares [Dialog’s focus behavior](./dialog.md#focus): focus moves inside on open and returns when it closes. A touch open focuses the content so a field does not summon the keyboard immediately. When the on-screen keyboard opens, the viewport shrinks and the focused field can scroll into view inside the sheet.
