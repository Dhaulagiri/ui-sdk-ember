---
title: Hover Card
description: Preview a link on hover or keyboard focus while keeping its normal navigation.
---

A hover card shows a preview of where a link goes, like a person's profile, to someone who pauses on it. The link still works as a link.

[hover-card/basic](../../examples/components/hover-card/ember/basic.gts)

Hover @hollis, or Tab to it and wait, to open Hollis Grant's profile preview. Move the pointer away or press Escape to close it.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `HoverCard`:

```text
HoverCard as |h|
├── h.Trigger
└── h.Content
    └── h.Arrow
```

The trigger is a link (an `<a>`, so give it an `href`), and pressing it follows the link. The content is the preview, and the arrow is optional.

The card only adds a preview for people who pause on the link: everything in it should be reachable from the page the link goes to, since touch and screen reader users may never open it. For a tip on a button, use a [Tooltip](./tooltip.md). For content that opens with a press, use a [Popover](./popover.md).

## Usage

Import the root and use the parts it yields:

```gts
import { HoverCard } from "ember-ui-sdk/hover-card"

<template>
  <HoverCard as |h|>
    <h.Trigger @href="/people/hollis">@hollis</h.Trigger>
    <h.Content>
      <p>Hollis Grant</p>
      <p>Design engineer on the payments team.</p>
    </h.Content>
  </HoverCard>
</template>
```

## Positioning

`@side` picks where the card opens, `bottom` by default, and `@align` lines it up with the start, center or end of the link. The card flips to the other side when there isn't room and shifts along the link to stay on screen.

`h.Arrow` follows the side the card actually lands on, including after a flip, and gets the same `data-side`. It points at the middle of the link and keeps `@arrowPadding` away from the corners; `data-arrow-clamped` tells you when it can't reach the middle.

[hover-card/side](../../examples/components/hover-card/ember/side.gts)

Choose a side and an alignment, then hover @ines. The card opens there and its arrow points at the link.

`@sideOffset` is the gap to the link, 4 pixels by default. `@alignOffset` shifts the card along it, and `@collisionPadding` is the space kept from the edges of the window. `@anchor` positions the card against something other than the link: an element, a CSS selector, a point like `{ x, y }`, or anything with `getBoundingClientRect()`.

```gts
<h.Content
  @side="right"
  @align="start"
  @sideOffset={{8}}
  @collisionPadding={{16}}
  @anchor={{this.row}}
>…</h.Content>
```

## Delays

`@delay` is how long the pointer rests on the link, or keyboard focus stays on it, before the card opens: 600 milliseconds by default. `@closeDelay` is how long it stays open once the pointer leaves the link and the card: 300 milliseconds by default. The pointer can cross the gap between the link and the card without closing it.

`@disabled={{true}}` stops the card from opening and leaves a plain link.

```gts
<HoverCard @delay={{300}} @closeDelay={{150}} @disabled={{this.previewsOff}} as |h|>…</HoverCard>
```

## Controlled

Pass `@open` and update it in `@onOpenChange`. Every change carries a [reason](https://ui-sdk.dev/docs/react/components/hover-card#reasons), like `trigger-hover`, `trigger-focus`, `focus-out`, `escape-key` or `outside-press`. Call `details.cancel()` to stop it.

## One Card for Many Links

A feed or a list can share one card instead of rendering one per link. Connect the links and the card to one `createHoverCardController<Payload>()`. Each link passes a `@payload`, like its person, and the content reads it from its state. Only the link that opened the card gets `data-open`. `controller.open({ payload })` opens the card from code.

```gts
import { HoverCard, createHoverCardController } from "ember-ui-sdk/hover-card"

const profile = createHoverCardController<Person>()

<template>
  {{#each this.people as |person|}}
    <HoverCard @controller={{profile}} as |h|>
      <h.Trigger
        @controller={{profile}}
        @payload={{person}}
        @href={{person.url}}
      >
        {{person.name}}
      </h.Trigger>
    </HoverCard>
  {{/each}}
</template>
```

A card can have links of its own. Tab from a link with an open card moves into the card, and Tab past its end moves on to the page after the link. Focus leaving the card closes it.

## Container

Cards render in place and show in the top layer, so no ancestor clips or covers them. `@container` renders the card somewhere else, for iframes, shadow roots or a specific stacking context.

```gts
<h.Content @container={{this.shadowRoot}}>…</h.Content>
```

## Animation

The content has `data-starting-style` while it opens and `data-ending-style` while it closes. Transition from those states, and the card stays mounted until the exit finishes. `@onOpenChangeComplete` runs after the transition, and `@keepMounted={{true}}` keeps the closed card in the page, hidden, for animation libraries that drive the exit from state.

```css
[data-slot="hover-card-content"] {
  transition:
    opacity 150ms,
    scale 150ms;

  &:is([data-starting-style], [data-ending-style]) {
    opacity: 0;
    scale: 0.96;
  }
}
```

## Custom Rendering

Pass `@render={{true}}` to a part to render it as your own element. It yields `{ part, state }`: bind `part` to your element as a modifier, and read the state in the block.

```gts
<h.Trigger @href="/people/hollis" @render={{true}} as |t|>
  <a {{t.part}}>
    <span aria-hidden="true">HG</span>
    Hollis Grant
  </a>
</h.Trigger>
```

## Styling

Each part has a `data-slot`, such as `hover-card-content`, and shows its state through the attributes listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/hover-card#data-attributes). Use `data-open` on the trigger to mark the link whose card is showing, and `data-side` to style the content and arrow for the side they landed on. Put `transform-origin: var(--transform-origin)` on the content so it scales from the link.

Keep overflow visible around an arrow that extends outside the card. If the body needs to scroll, put scrolling on an inner element.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [hover-card reference](https://ui-sdk.dev/docs/react/components/hover-card) in the upstream docs.

Pass the root's options as `@` arguments. `@open` is controlled with `@onOpenChange`.

### HoverCardTrigger

A trigger outside the card also takes `@controller`.

### HoverCardArrow

Points at the link from the side the card landed on. Renders a `div`.

### Controller

Create one with `createHoverCardController<Payload>()` and pass it as `@controller`, to the card and to any triggers outside it. `Payload` is the type of the data triggers and `open()` pass.

Every write method takes an optional `{ reason, event }`, passed to `@onOpenChange`.

### Events

Callbacks get the new state first, then the details. A controlled `@open` only updates when `@onOpenChange` wasn't canceled.

| Argument                | On          | Receives                                                                                                                       |
| ----------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------ |
| `@onOpenChange`         | `HoverCard` | `(open, details)`: the new state, and the [reason](https://ui-sdk.dev/docs/react/components/hover-card#reasons)                |
| `@onOpenChangeComplete` | `HoverCard` | `(open)`, after the animation                                                                                                  |
| `@onPayloadChange`      | `HoverCard` | `(payload, details)`: the content's new payload, and the [reason](https://ui-sdk.dev/docs/react/components/hover-card#reasons) |

## Accessibility

The trigger stays a plain link, and the card is a preview beside it, not a dialog. Every line below is an automated test.

### Keyboard

| Key    | Does                                                                          |
| ------ | ----------------------------------------------------------------------------- |
| Tab    | On the link, opens the card after `@delay`; with the card open, moves into it |
| Enter  | Follows the link                                                              |
| Escape | Closes the card and leaves focus on the link                                  |

Keyboard focus opens the card after the same `@delay` as the pointer, so tabbing through a page of links doesn't flash a card at every stop. Focus leaving the card closes it.

Touch screens have no hover, so a tap follows the link without opening the card. Anything in the card should be on the page the link goes to.
