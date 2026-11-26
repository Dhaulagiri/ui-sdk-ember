---
title: Popover
description: Edit or explore something beside its trigger.
---

A popover keeps a small task close to the thing it belongs to. Put fields, buttons, or other interactive content inside; it handles placement, focus, and dismissal.

[popover/basic](../../examples/components/popover/ember/basic.gts)

Press Share to open the popover, then close it with Cancel, Copy Link, Escape, or a press outside. Focus returns to Share.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

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

[popover/form](../../examples/components/popover/ember/form.gts)

Open Edit Profile, change the name, and press Save. The popover closes and the console logs the saved name.

## Keep It Open While Editing

Set `@dismissible` to false while there is unsaved work. Escape and outside presses then keep the popover open and report `@onDismissAttempt`, so you can ask whether to discard it. Focus leaving is refused quietly. The trigger, Close parts, and controller can still close it.

[popover/draft](../../examples/components/popover/ember/draft.gts)

Open Add Note, type something, then press Escape or click outside. Keep Editing returns to the field; Discard closes the popover and clears the note.

## Placement

`@side` chooses an edge of the trigger, `bottom` by default, and `@align` lines the popover up with its start, center, or end. Start and end follow text direction. The popover flips or shifts when the requested position doesn't fit, and `data-side` and `data-align` report where it landed.

[popover/placement](../../examples/components/popover/ember/placement.gts)

Choose a side and an alignment, then open Delivery. Near a window edge, the popover flips or shifts to stay visible.

## Offsets

`@sideOffset` is the gap to the trigger, 4 pixels by default. `@alignOffset` shifts the popover along the trigger's edge, and `@collisionPadding` is the space kept from the edges of the window.

[popover/offsets](../../examples/components/popover/ember/offsets.gts)

Change the offsets and the padding, then open Delivery. The popover moves away from the trigger and along it.

## Arrow

`p.Arrow` follows the side the popover actually uses, including after a flip, and gets the same `data-side`. `@arrowPadding` keeps it away from the corners; `data-arrow-clamped` tells you when it can't point at the middle of the trigger. This example cancels dismissal when you press its side buttons, so the open arrow can move.

[popover/arrow](../../examples/components/popover/ember/arrow.gts)

Open Help, then press Top, Right, Bottom, or Left. The popover stays open while it and its arrow move to that side.

Keep overflow visible around an arrow that extends outside the panel. If the body needs to scroll, put scrolling on an inner element. You can also draw an arrow with `::before`, using `data-side` and `--arrow-offset` to position it.

## Anchor

Set `@anchor` to position against something other than the trigger. It accepts an element, a selector, a point such as `{ x, y }`, or an object with `getBoundingClientRect()`, such as a text range. The position is read again as the anchor moves.

[popover/anchor](../../examples/components/popover/ember/anchor.gts)

Press the filters button. The popover lines up with the search field instead of the small button beside it.

## Modal

`@modal` controls how the popover shares the page:

- `false`, the default, leaves the page usable, and focus leaving the popover closes it.
- `"trap-focus"` keeps Tab inside while the page can still scroll and receive clicks.
- `true` also makes the rest of the page inert and locks scrolling.

[popover/modal](../../examples/components/popover/ember/modal.gts)

Choose a mode, open Add Comment, and try Tab or clicking the page.

## Focus

Use `@initialFocus` to choose the first focused element, or `"none"` to leave focus where it is. `@finalFocus` controls where focus returns. Opening on hover leaves focus alone; opening with touch focuses the panel itself so no on-screen keyboard appears.

[popover/focus](../../examples/components/popover/ember/focus.gts)

Open each one: Rename focuses its field, Publish focuses its Publish button, and Status leaves focus on the trigger.

## Open on Hover

`@openOnHover` adds pointer opening while keeping click, keyboard, and touch activation. `@delay` and `@closeDelay` control the pause before opening and closing. You can cross the gap into the content and interact with it. Another popover or hover card opening on hover closes it, unless that one is inside it, so a row of hover triggers shows one at a time.

[popover/hover](../../examples/components/popover/ember/hover.gts)

Hover @kofi, then move into the popover and press Follow. You can also open it by pressing the trigger.

## Controlled

Pass `@open` and update it in `@onOpenChange` to keep the popover's state in your component. Cancel a proposed change with `details.cancel()` in `@onOpenChange`.

[popover/controlled](../../examples/components/popover/ember/controlled.gts)

Check Open or press Set Status, then close the popover. The console logs each change and its reason.

## Keyboard Shortcut

Set a trigger's `@shortcut` to toggle the popover from the keyboard. `mod+i` means Command+I on Apple platforms and Control+I elsewhere. The Shortcut part displays the platform's keys, and the trigger advertises them through `aria-keyshortcuts`.

[popover/shortcut](../../examples/components/popover/ember/shortcut.gts)

Press Command+I or Control+I to open Invite. Press the same shortcut again, or Escape, to close it.

## Triggers Outside the Popover

Connect the triggers and popover to one `createPopoverController<Member>()`. Each trigger passes its row as `@payload`; the content reads the active row from its state. Only the active trigger is expanded and receives focus back. Opening from another row updates the same panel, so one editor can serve the whole list.

`controller.open({ payload, anchor })` opens it from code and returns a promise with the closing reason and any `returnValue`. The payload stays available during the exit animation.

[popover/payload](../../examples/components/popover/ember/payload.gts)

Edit Inès Moreau or Kofi Mensah and save a new role. The owner can't be edited. Edit Newest Member opens the same editor from code, and the console logs how it closed.

## Animation

The content has `data-starting-style` while it opens and `data-ending-style` while it closes. Transition from those states, and the popover stays mounted until the exit finishes. `@onOpenChangeComplete` runs after the transition, and `@keepMounted` keeps the closed content in the page, hidden.

[popover/animation](../../examples/components/popover/ember/animation.gts)

Open What's New, then press Got It. The console logs Opening, Open, Closing, and Closed.

## Presentation

`@presentation="sheet"` shows the task as a sheet; `"auto"` chooses a sheet on small touch screens each time it opens. A sheet is modal by default and can be swiped down to dismiss. If dismissal is disabled, it springs back and reports the attempt.

Style `data-presentation` for both layouts. The sheet manages its own position and movement, so leave its translation alone and avoid the floating panel's fixed width. `--sheet-backdrop` sets the dim behind it.

[popover/presentation](../../examples/components/popover/ember/presentation.gts)

Open Add Reminder as a sheet. Dismiss it with Cancel, Save, Escape, the dimmed area, or a downward swipe on a touch screen.

## Container

Popovers render in place by default and use the browser's top layer. `@container` moves their DOM to another element while keyboard order still follows the trigger.

```gts
<Popover @container={{this.container}} as |p|>
  <p.Trigger>Details</p.Trigger>
  <p.Content>...</p.Content>
</Popover>
```

## In Place

A popover opens above the page. Set `@inline={{true}}` on the content to render it where it is, inside its parent's layout and stacking, like a panel that opens out of a corner widget. Your CSS places it, so `@side`, `@align` and the offsets don't apply.

[popover/inline](../../examples/components/popover/ember/inline.gts)

Open Feedback. The panel opens above the button, inside the corner box.

## Custom Rendering

Every part takes `@render={{true}}`, which renders no element and yields `{ part, state }`: bind `part` to your own element as a modifier. Without it, each part still yields `{ part, state }` to its block, so the content can read its payload, as the row editor does.

[popover/custom-rendering](../../examples/components/popover/ember/custom-rendering.gts)

Open Show Updates. The trigger's label comes from its state, the title renders as an h3, and Close renders as a link.

## Styling

Use `data-open` on the trigger to mark it while its popover shows, and `data-side` and `data-align` to style the content and arrow for where they landed. Put `transform-origin: var(--transform-origin)` on the content so a scale animation starts from the trigger.

Each part has a `data-slot`, such as `popover-content`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/popover#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [popover reference](https://ui-sdk.dev/docs/react/components/popover) in the upstream docs.

Options and callbacks are passed as arguments, like `@onValueChange`. Every part also takes `@render`.

### PopoverTrigger

A trigger outside the popover also takes `@controller`.

### PopoverArrow

Points at the trigger from the side the popover landed on. Renders a `div`.

### PopoverTitle

Names the popover. Renders an `h2`.

### PopoverDescription

Describes the popover while it's rendered. Renders a `p`.

### PopoverClose

Closes the popover. Renders a `button`.

### Controller

Create one with `createPopoverController<Payload>()` and pass it as `@controller`, to the popover and to any
triggers outside it. `Payload` is the type of the data triggers and `open()` pass.

Every write method takes an optional `{ reason, event }`, passed to `@onOpenChange`.

### Events

Callbacks get the new state first, then the details.

| Argument                | On        | Receives                                                                                                                    |
| ----------------------- | --------- | --------------------------------------------------------------------------------------------------------------------------- |
| `@onOpenChange`         | `Popover` | `(open, details)`: the new state, and the [reason](https://ui-sdk.dev/docs/react/components/popover#reasons)                |
| `@onOpenChangeComplete` | `Popover` | `(open)`, after the animation                                                                                               |
| `@onPayloadChange`      | `Popover` | `(payload, details)`: the content's new payload, and the [reason](https://ui-sdk.dev/docs/react/components/popover#reasons) |
| `@onDismissAttempt`     | `Popover` | `({ reason, event })`, when a dismissal was refused                                                                         |

## Accessibility

The trigger is a button that opens a dialog, and focus inside follows the [WAI-ARIA dialog pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/).
