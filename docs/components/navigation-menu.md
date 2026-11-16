---
title: Navigation Menu
description: Groups site links into panels that open from a row of triggers.
---

Use a Navigation Menu for a site's main links, grouped into panels that open from a row of triggers. For a list of actions, use a [Menu](./menu.md).

[navigation-menu/basic](../../examples/components/navigation-menu/ember/basic.gts)

Open each section, then use Tab or the arrow keys to move through its links.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `NavigationMenu`:

```text
NavigationMenu as |n|
├── n.List as |l|
│   ├── l.Item as |i|
│   │   ├── i.Trigger
│   │   └── i.Content as |c|
│   │       └── c.Link
│   └── l.Item as |i|
│       ├── i.Trigger
│       └── i.Content as |c|
│           └── c.Link
└── n.Viewport
```

Give the navigation an `aria-label`. Each item holds a trigger and its panel, or a plain link. This follows the [disclosure navigation pattern](https://www.w3.org/WAI/ARIA/apg/patterns/disclosure/examples/disclosure-navigation/): buttons show groups of ordinary links. Use a [Menu](./menu.md) for actions instead.

The viewport holds the open panel and follows its size and position. Size it with `--viewport-width` and `--viewport-height` and clip its overflow when you use one; [Contents in the Viewport](#contents-in-the-viewport) explains the geometry. You can also [leave the viewport out](#without-a-viewport) and position each panel separately.

## Usage

Import the root and use the parts it yields:

```gts
import { NavigationMenu } from "ember-ui-sdk/navigation-menu"

<template>
  <NavigationMenu aria-label="Main" as |n|>
    <n.List as |l|>
      <l.Item @value="guides" as |i|>
        <i.Trigger>Guides</i.Trigger>
        <i.Content as |c|>
          <c.Link href="/docs">Introduction</c.Link>
        </i.Content>
      </l.Item>
    </n.List>
    <n.Viewport />
  </NavigationMenu>
</template>
```

## Link Component

Render your router's link for client-side navigation. `@current` marks the link for the current page with `aria-current="page"` and `data-current`.

Pass `@render={{true}}` to a link to render your router's link component in its place, spreading the yielded part onto it. Routers call `preventDefault()` on a link's click to navigate without a page load. The menu listens on the link element itself, so it still closes after a client-side route change. A press with a modifier key or the middle button opens the link elsewhere and leaves the menu open. Set `@closeOnSelect={{false}}` to keep it open on every press, see [Close on Select](#close-on-select).

[navigation-menu/link-component](../../examples/components/navigation-menu/ember/link-component.gts)

Choose a link to update the current page without reloading the example.

## Icons

Put a link's icon in a `c.LinkIcon`, before its text, like the With Icon panel in the menu at the top of the page. Screen readers skip it, so an SVG's `<title>`, an icon font's glyph or an emoji never joins the link's name.

- **Icons that point a way**, like the arrow on All issues, flip in right-to-left text with `@mirror={{true}}`.
- **Links with only an icon** need an `aria-label`. In development, one with no name warns.
- **Lining up links.** Links with an icon get `data-has-icon`, and the content or list around them gets `data-has-icons` while any link has one, so links without an icon can leave its space: `[data-has-icons] [data-slot="navigation-menu-link"]:not([data-has-icon])`.

## Vertical

`@orientation="vertical"` is for a sidebar: Up and Down move between the items, and panels open beside the menu, at the inline end, unless `@side` says otherwise.

[navigation-menu/vertical](../../examples/components/navigation-menu/ember/vertical.gts)

Use Up and Down between the sidebar items, then open a panel beside its trigger.

## Click Only

Resting the pointer on a trigger opens its panel. With `@openOnHover={{false}}`, the menu opens on click only: pressing a trigger opens and closes its panel, and moving the pointer does nothing. Keyboard and touch work the same either way.

[navigation-menu/click-only](../../examples/components/navigation-menu/ember/click-only.gts)

Click a trigger to open it. Moving the pointer between triggers does not open another panel.

## Nested

A navigation menu inside another menu's content is a submenu. It renders a plain element instead of a second `<nav>` landmark, gets `data-nested`, and closes with its parent when the parent moves on to another item. Without a viewport of its own, its panels open beside its triggers. Pressing a link in it closes every menu.

[navigation-menu/nested](../../examples/components/navigation-menu/ember/nested.gts)

Open Components, then open Overlays or Forms. Escape closes the inner panel first.

## Animation

The viewport and contents get `data-starting-style` for their first frame and `data-ending-style` while they animate out, and stay mounted until their animation finishes. Contents also get `data-motion` while another item takes over: `from-end` or `from-start` on the one coming in, and `to-start` or `to-end` on the one giving way. Order is logical, so in right-to-left layouts the end is on the left. The viewport can transition `width`, `height`, `left` and `top` as it follows the open item.

`@onOpenChangeComplete` runs once the menu has finished opening or closing, after any animation, with the new open state. Switching between items doesn't count.

[navigation-menu/animation](../../examples/components/navigation-menu/ember/animation.gts)

Switch between Guides and Components to see the viewport resize and the panels slide.

The menu waits for whatever animations run, and only those. Turn them off for people who ask for less motion with a `prefers-reduced-motion` media query, and panels switch and close at once.

## Delay

`@delay` is how long the pointer rests on a trigger before its panel opens, and `@closeDelay` how long the panel stays once the pointer leaves the trigger and the panel: 50 milliseconds each by default. The pointer can cross the gap between a trigger and its panel without closing it. Once a panel is open, moving to another trigger switches at once, unless the pointer is only passing over it on the way into the open panel. Coming back right after closing skips the delay.

```gts
<NavigationMenu @delay={{400}} @closeDelay={{600}} aria-label="Main" as |n|>…</NavigationMenu>
```

## Indicator

An indicator sits under the open trigger, or under the top-level link with `@current` while every panel is closed. Its box comes from the `--active-item-*` [variables](#navigationmenuindicator), relative to its positioned ancestor, and it gets `data-visible` while it has something to cover. Screen readers skip it.

```css
[data-slot="navigation-menu"] {
  position: relative;
}

[data-slot="navigation-menu-indicator"] {
  position: absolute;
  left: var(--active-item-left);
  bottom: var(--active-item-bottom);
  width: var(--active-item-width);
  height: 2px;
  opacity: 0;
}

[data-slot="navigation-menu-indicator"][data-visible] {
  opacity: 1;
}
```

## Viewport Placement

The viewport opens below the open trigger, lined up with its start, or beside it in a vertical menu. `@side` and `@align` change that, `@sideOffset` is the gap (4 pixels by default), `@alignOffset` shifts it along the trigger, and `@collisionPadding` is the space kept from the window's edges. It flips and shifts to stay on screen.

`@anchor` positions it against something else: an element, a CSS selector, a point like `{ x, y }`, or anything with `getBoundingClientRect()`. Anchoring to the whole bar gives one dropdown that stays put while its contents change.

```gts
<n.Viewport @side="bottom" @align="center" @sideOffset={{8}} @collisionPadding={{16}} @anchor="#site-header" />
```

## Without a Viewport

Leave the viewport out and each content is its own popup, placed against its trigger. Contents then take the same placement arguments as the viewport: `@side`, `@align`, `@sideOffset`, `@alignOffset`, `@collisionPadding` and `@anchor`. Style each content as a popup rather than positioning it inside one.

## Controlled

Pass `@value` and update it in `@onValueChange` to control which item is open. It's the open item's `value`, or `null` while every panel is closed. Use `@defaultValue` to start with a panel open without controlling it.

Items take a `value`, which is generated when left out. Every change carries a [reason](https://ui-sdk.dev/docs/react/components/navigation-menu#reasons) in `@onValueChange`, like `trigger-hover`, `trigger-press`, `link-press` or `outside-press`. Call `details.cancel()` to stop it.

## Opening from Anywhere

A controller, from `createNavigationMenuController()`, opens, closes and focuses the menu from anywhere, without controlling it. Pass it as `@controller`.

## Keep Mounted

Closed contents leave the page by default. `@keepMounted={{true}}` keeps them in it, hidden, so the server's HTML and crawlers have every link. `@hiddenUntilFound={{true}}` also lets find in page reach them: closed content gets `hidden="until-found"`, and a match opens its item with the `find-in-page` reason. It implies `@keepMounted`.

Closed content stays in its item, with its own classes, and moves into the viewport when it opens. Put padding on an element inside it rather than on the content, so the hidden box has no size where it sits.

## Close on Select

Pressing a link closes the menu by default, like after a route change. With `@closeOnSelect={{false}}` on the menu, it stays open, and a link's own `@closeOnSelect` wins over the menu's.

## Container

Panels render in place and show in the top layer, so no ancestor clips or covers them. `@container` renders the viewport, or each content without one, somewhere else, for iframes, shadow roots or a specific stacking context. Set it on the menu, or on the viewport or a content.

## Custom Rendering

[navigation-menu/custom-rendering](../../examples/components/navigation-menu/ember/custom-rendering.gts)

Open Guides to see its render state, then compare the current link and disabled trigger.

Every part takes `@render={{true}}`, which yields `{ part, state }`: bind `part` to your element as a modifier, and read the state in the block. Here the content reads `motion`, and a disabled trigger shows a badge.

`@disabled={{true}}` on a trigger stops it from opening its panel. Each part's state is listed under [State](https://ui-sdk.dev/docs/react/components/navigation-menu#state).

## Styling

Parts are unstyled. Style them through the attributes they render, which are the same in every framework. Each part has a `data-slot`, such as `navigation-menu-trigger`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/navigation-menu#data-attributes).

### Contents in the Viewport

The viewport is one popup that holds whichever content is open. For it to take that content's size:

- Place contents at the viewport's corner, with their own width: `position: absolute; top: 0; inset-inline-start: 0`, and a width like `400px` or `max-content`. Contents of different widths make the viewport resize as it switches.
- Put padding on the contents, not the viewport. `--viewport-width` and `--viewport-height` are the open content's size plus the viewport's own border.
- Size the viewport with those variables and clip it, so contents sliding in and out stay inside.
- Copy `--available-height` to an inheriting variable such as `--panel-height`, then use it to cap the content and let long panels scroll. The positioning variables themselves do not inherit.

In plain CSS:

```css
[data-slot="navigation-menu-viewport"] {
  --panel-height: var(--available-height);
  width: var(--viewport-width);
  height: var(--viewport-height);
  overflow: hidden;
  transition:
    width 200ms,
    height 200ms,
    left 200ms,
    top 200ms,
    opacity 200ms;
}

[data-slot="navigation-menu-viewport"] > [data-slot="navigation-menu-content"] {
  position: absolute;
  top: 0;
  inset-inline-start: 0;
  max-height: var(--available-height, var(--panel-height));
  overflow-y: auto;
}

[data-slot="navigation-menu-content"][data-motion="from-end"][data-starting-style],
[data-slot="navigation-menu-content"][data-motion="to-end"][data-ending-style] {
  translate: 48px 0;
}

[data-slot="navigation-menu-content"][data-motion="from-start"][data-starting-style],
[data-slot="navigation-menu-content"][data-motion="to-start"][data-ending-style] {
  translate: -48px 0;
}

[data-slot="navigation-menu-content"]:dir(
    rtl
  )[data-motion="from-end"][data-starting-style],
[data-slot="navigation-menu-content"]:dir(
    rtl
  )[data-motion="to-end"][data-ending-style] {
  translate: -48px 0;
}

[data-slot="navigation-menu-content"]:dir(
    rtl
  )[data-motion="from-start"][data-starting-style],
[data-slot="navigation-menu-content"]:dir(
    rtl
  )[data-motion="to-start"][data-ending-style] {
  translate: 48px 0;
}

@media (prefers-reduced-motion: reduce) {
  [data-slot="navigation-menu-viewport"],
  [data-slot="navigation-menu-content"] {
    transition: none;
  }
}
```

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [navigation-menu reference](https://ui-sdk.dev/docs/react/components/navigation-menu) in the upstream docs.

Pass the root's options as `@` arguments. `@value` is controlled with `@onValueChange`.

### NavigationMenuViewport

`NavigationMenuList` takes no arguments of its own.

### NavigationMenuIndicator

The indicator takes no arguments of its own.

### Controller

Create one with `createNavigationMenuController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, passed to `@onValueChange`.

### Events

Callbacks get the new state first, then the details. A controlled `@value` only updates when `@onValueChange` wasn't canceled.

| Argument                | On               | Receives                                                                                                              |
| ----------------------- | ---------------- | --------------------------------------------------------------------------------------------------------------------- |
| `@onValueChange`        | `NavigationMenu` | `(value, details)`: the open item, and the [reason](https://ui-sdk.dev/docs/react/components/navigation-menu#reasons) |
| `@onOpenChangeComplete` | `NavigationMenu` | `(open)`, after the animation                                                                                         |

## Accessibility

The menu follows the [disclosure navigation pattern](https://www.w3.org/WAI/ARIA/apg/patterns/disclosure/examples/disclosure-navigation/): a landmark with a list of buttons that show and hide groups of links.

### Keyboard

Tab moves through the triggers and top-level links in order, like any links on a page. Enter or Space on a trigger opens its panel and leaves focus on the trigger, and Tab from an open trigger moves into its panel, wherever the panel renders. Tab past the panel's last link moves on to the next item, and Shift+Tab from its first link returns to the trigger. Escape closes the panel and returns focus to its trigger, and focus leaving the navigation closes it.

The arrow keys add to Tab, as the pattern allows: Left and Right move between the top-level items (Up and Down in a vertical menu), Home and End go to the first and last, Down (the inline end in a vertical menu) opens a trigger's panel and moves into it, and in a panel Up and Down, or Left and Right, move between the links and Home and End go to the first and last. Nothing wraps, and keys pressed with a modifier, like Alt+Left for Back, are left to the browser.

Touch screens have no hover: a tap on a trigger opens its panel and another tap closes it.
