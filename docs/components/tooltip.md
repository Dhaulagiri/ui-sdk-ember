---
title: Tooltip
description: Name a control or add a short hint on hover and keyboard focus.
---

A tooltip names a control or adds a short hint when the pointer rests on it or keyboard focus reaches it. Keep it to a few words of plain text.

[tooltip/basic](../../examples/components/tooltip/ember/basic.gts)

The tooltip starts open. Hover the button or reach it with Tab to show it again, and Escape closes it while focus stays on the button.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

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

[tooltip/side](../../examples/components/tooltip/ember/side.gts)

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

[tooltip/anchor](../../examples/components/tooltip/ember/anchor.gts)

Hover the help button. The tooltip opens below the Webhook URL field and lines up with its start, not with the button.

## Keyboard Shortcut

`@shortcut` on the tooltip, like `"mod+s"`, is a hint for what the trigger's action is bound to, where `mod` is Command on Apple platforms and Control elsewhere. `t.Shortcut` shows the keys for the platform, `⌘S` or `Ctrl+S`, hidden from screen readers, and the trigger gets `aria-keyshortcuts` so they hear it instead. A `t.Shortcut` can show other keys with its own `@shortcut`.

The tooltip doesn't bind the keys. Register the shortcut yourself with `registerShortcut` from `@ui-sdk/core/shortcuts`, as the example does, or use the `@shortcut` of a component that binds keys, like a [Dialog](./dialog.md#keyboard-shortcut) trigger.

[tooltip/shortcut](../../examples/components/tooltip/ember/shortcut.gts)

Hover Save or Share to read its shortcut, then press the button or the keys. The console logs Saved or Shared.

## Disabled Buttons

A natively disabled button can't receive focus, and some browsers send it no pointer events, so its tooltip never shows. When the tooltip explains why an action is unavailable, use `aria-disabled="true"` instead and ignore the button's presses yourself. The button stays in the Tab order, screen readers announce it as dimmed, and the tooltip explains what's missing. `@disabled={{true}}` on the tooltip turns the explanation off once the button works.

[tooltip/disabled-button](../../examples/components/tooltip/ember/disabled-button.gts)

Hover or focus Publish to learn what's missing. Type a title, and Publish works and its tooltip goes away.

## Touch

Touch screens have no hover. A tap on a plain tooltip's trigger only presses it, and the tooltip stays closed, so don't hide anything important in a tooltip.

For an info button whose only job is the tip, add `@toggleable={{true}}`: pressing the trigger opens and closes the tooltip, with a finger, a mouse or the keyboard, and its text is announced when a press opens it. An outside press or Escape closes it too.

[tooltip/toggleable](../../examples/components/tooltip/ember/toggleable.gts)

Press the info button to open the tip, including on a touch screen. Press it again or anywhere else to close it.

## Keep Open on Press

Pressing the trigger closes the tooltip, so it doesn't cover what the press changed, and it stays closed until the pointer leaves. `@closeOnPress={{false}}` keeps it open, like for a copy button whose tooltip turns into "Copied".

[tooltip/copy](../../examples/components/tooltip/ember/copy.gts)

Hover the copy button and press it. The tooltip stays open and changes to Copied.

## Truncated Text

To show a tooltip only when text is cut off, cancel the open in `@onOpenChange` when the text fits. Compare `scrollWidth` with `clientWidth` in the callback. The tooltip repeats the name, so `@type="label"` keeps screen readers from hearing it twice.

[tooltip/truncated](../../examples/components/tooltip/ember/truncated.gts)

Hover or focus each file. Only names that are cut off open a tooltip.

## Controlled

Pass `@open` and read each change in `@onOpenChange`. Every change carries a [reason](https://ui-sdk.dev/docs/react/components/tooltip#reasons), like `trigger-hover`, `trigger-focus`, `trigger-press`, `escape-key` or `outside-press`. Call `details.cancel()` to stop it. To open the tooltip from anywhere, like a step in a guided tour, use a [controller](#controller).

[tooltip/controlled](../../examples/components/tooltip/ember/controlled.gts)

Check Open, or hover Export. The console logs each change and its reason.

## Shared

A toolbar, a chart or a long list can share one tooltip instead of rendering one per item. Connect the triggers and the tooltip to one `createTooltipController<Payload>()`, and the triggers can sit anywhere on the page. Each trigger passes a `@payload`, here its label, and the content reads it from its state. The content renders before the first open, so handle an `undefined` payload.

Only the trigger that opened the tooltip is described by it, so give each trigger a name of its own, like an `aria-label`. The controller's `open()` takes a payload and an `anchor` too, and on an open tooltip, `open({ payload })` replaces the payload, like another trigger taking it over. `@onPayloadChange` reports each change.

[tooltip/shared](../../examples/components/tooltip/ember/shared.gts)

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

[tooltip/animation](../../examples/components/tooltip/ember/animation.gts)

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

[tooltip/custom-rendering](../../examples/components/tooltip/ember/custom-rendering.gts)

Hover Changelog. The trigger renders as a link, and its tooltip says where it goes.

## Styling

Use `data-side` and `data-align` to style the content and arrow for where they landed, and `data-instant` to skip the animation of a tooltip that opened at once. The trigger gets no state attributes of its own, since it's often another component's trigger too, like a menu's. Put `transform-origin: var(--transform-origin)` on the content so it scales from the trigger.

Each part has a `data-slot`, such as `tooltip-content`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/tooltip#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [tooltip reference](https://ui-sdk.dev/docs/react/components/tooltip) in the upstream docs.

Pass the root's options as `@` arguments. `@open` is controlled with `@onOpenChange`.

### TooltipTrigger

A trigger outside the tooltip also takes `@controller`.

### TooltipArrow

Points at the trigger from the side the tooltip landed on. Renders a `div`.

### Controller

Create one with `createTooltipController<Payload>()` and pass it as `@controller`, to the tooltip and to any triggers outside it. `Payload` is the type of the data triggers and `open()` pass.

Every write method takes an optional `{ reason, event }`, passed to `@onOpenChange`.

### Events

Callbacks get the new state first, then the details. A controlled `@open` only updates when `@onOpenChange` wasn't canceled.

| Argument                | On        | Receives                                                                                                                    |
| ----------------------- | --------- | --------------------------------------------------------------------------------------------------------------------------- |
| `@onOpenChange`         | `Tooltip` | `(open, details)`: the new state, and the [reason](https://ui-sdk.dev/docs/react/components/tooltip#reasons)                |
| `@onOpenChangeComplete` | `Tooltip` | `(open)`, after the animation                                                                                               |
| `@onPayloadChange`      | `Tooltip` | `(payload, details)`: the content's new payload, and the [reason](https://ui-sdk.dev/docs/react/components/tooltip#reasons) |

## Accessibility

The trigger is named or described by the tooltip, following the [WAI-ARIA tooltip pattern](https://www.w3.org/WAI/ARIA/apg/patterns/tooltip/). It opens on hover and on keyboard focus, and stays open while the pointer moves onto it.

### Keyboard

| Key          | Does                                                                                           |
| ------------ | ---------------------------------------------------------------------------------------------- |
| Tab          | Focus on the trigger opens the tooltip at once; focus leaving it closes the tooltip            |
| Escape       | Closes the tooltip and leaves focus on the trigger, without closing a dialog or menu around it |
| Enter, Space | Presses the trigger and closes the tooltip; on a `@toggleable` trigger, opens and closes it    |
