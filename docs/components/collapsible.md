---
title: Collapsible
description: Show and hide a panel, preserve its contents, and animate its height.
---

Use a collapsible to show and hide one panel of content. For a set of panels, use an [accordion](./accordion.md).

[collapsible/basic](../../examples/components/collapsible/ember/basic.gts)

Press Order #4189, or focus it and press Enter or Space, to show the items.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Collapsible`:

```text
Collapsible as |c|
├── c.Trigger
└── c.Panel
```

The root and panel render divs, and the trigger renders a native button. Put other content around them, like a heading or a summary that always shows.

## Usage

Import the root and use the parts it yields:

```gts
import { Collapsible } from "ember-ui-sdk/collapsible"

<template>
  <Collapsible as |c|>
    <c.Trigger>Order details</c.Trigger>
    <c.Panel>2 × Linen shirt</c.Panel>
  </Collapsible>
</template>
```

`ember-ui-sdk/collapsible` also exports each part by name, such as `CollapsibleTrigger` and `CollapsiblePanel`. They take the root's `@handle`, so use the parts the root yields instead.

## Disabled

Set `@disabled={{true}}` on the root to stop its trigger from opening or closing the panel. The trigger stays in the tab order and reports `aria-disabled="true"`. A disabled fieldset around the collapsible disables it too.

```gts
<Collapsible @disabled={{true}} as |c|>
  <c.Trigger>Gift options</c.Trigger>
  <c.Panel>Add a gift message and wrapping.</c.Panel>
</Collapsible>
```

## Keep Mounted

Panels unmount when they close, so Tab skips their contents. Set `@keepMounted={{true}}` on the panel to keep it mounted and hidden, so a field keeps what you typed into it.

[collapsible/keep-mounted](../../examples/components/collapsible/ember/keep-mounted.gts)

Open Add a delivery note, type a note, then close and reopen the panel. Your note is still there.

## Find in Page

Set `@hiddenUntilFound={{true}}` on the panel to keep it in the DOM as `hidden="until-found"`. Browser Find and links to content inside the panel can reveal it. The panel opens without an animation so the match is visible immediately.

[collapsible/find-in-page](../../examples/components/collapsible/ember/find-in-page.gts)

Leave Ingredients closed. Open your browser's Find command and search for cardamom to reveal the panel.

## Controlled

Pass `@open` and update it in `@onOpenChange`. The callback also gets the change details: call `details.cancel()` in it to cancel the change.

For a button elsewhere on the page, create a [controller](#controller) with `createCollapsibleController()` and pass it as `@controller`. Create one controller per mounted collapsible.

[collapsible/controlled](../../examples/components/collapsible/ember/controlled.gts)

Open Recovery codes with Toggle or its trigger, then press Done. The console logs each change and its reason, and Done returns focus to the trigger.

## Animation

Animate the measured `--collapsible-panel-height` between zero and the content's height. `data-starting-style` marks the opening frame, and `data-ending-style` stays on while it closes. The panel stays mounted until its closing animation finishes, and a panel open on its first paint doesn't animate.

```css
[data-slot="collapsible-panel"] {
  height: var(--collapsible-panel-height);
  overflow: hidden;
  transition: height 0.2s ease-out;

  &:is([data-starting-style], [data-ending-style]) {
    height: 0;
  }
}
```

`@onOpenChangeComplete` reports when opening or closing has finished.

[collapsible/animation](../../examples/components/collapsible/ember/animation.gts)

Open and close Release notes. The console logs when each animation finishes.

## Custom Rendering

Pass `@render={{true}}` to a part to choose its element. The part yields `{ part, state }`, so read `state` in the template to change content. The trigger below renders inside a heading, and the panel renders as an ordered list.

[collapsible/render](../../examples/components/collapsible/ember/render.gts)

Press Track parcel to open the ordered list. The summary changes from Arrives Thursday to 3 updates.

## Styling

Use `data-open`, `data-closed` and `data-disabled` to style each state. The examples turn their chevron from the trigger's `data-open`.

Each part has a `data-slot`, such as `collapsible-panel`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/collapsible#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [collapsible reference](https://ui-sdk.dev/docs/react/components/collapsible) in the upstream docs.

Options and callbacks are passed as arguments, such as `@open` and `@onOpenChange`. Every part also takes `@render`.

### CollapsibleTrigger

The trigger takes no options of its own, only the attributes of the element it renders.

### Controller

Create one with `createCollapsibleController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, and returns `false` when the change was canceled or changed nothing.

### Events

Callbacks get the new state first, then the details.

| Argument                | On            | Receives                                                                                                         |
| ----------------------- | ------------- | ---------------------------------------------------------------------------------------------------------------- |
| `@onOpenChange`         | `Collapsible` | `(open, details)`: the new state, and the [reason](https://ui-sdk.dev/docs/react/components/collapsible#reasons) |
| `@onOpenChangeComplete` | `Collapsible` | `(open)`, after the panel's animation                                                                            |

## Accessibility

The collapsible follows the [WAI-ARIA disclosure pattern](https://www.w3.org/WAI/ARIA/apg/patterns/disclosure/). The trigger says whether the panel is open with `aria-expanded`, and points to the panel with `aria-controls` while it's mounted. Every line below is an automated test.

### Keyboard

| Key          | Does                                                   |
| ------------ | ------------------------------------------------------ |
| Enter, Space | Opens or closes the panel. Focus stays on the trigger. |
| Tab          | Moves from the trigger into an open panel              |

Closing a panel while focus is inside it moves focus back to the trigger.
