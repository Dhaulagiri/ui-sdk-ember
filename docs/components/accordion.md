---
title: Accordion
description: Show and hide sections of content from their headings.
---

Use an Accordion for content people can explore one section at a time, such as answers, settings, or a course outline. Each heading is a button that opens its panel.

[accordion/basic](../../examples/components/accordion/ember/basic.gts)

Press “What is your return policy?”. Its answer opens and the shipping answer closes. Press the same heading again to close it.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build an `Accordion`:

```text
Accordion as |a|
├── a.Item as |i|
│   ├── i.Header
│   │   └── i.Trigger
│   └── i.Panel
└── a.Item as |i|
    ├── i.Header
    │   └── i.Trigger
    └── i.Panel
```

Give every item a unique `@value`. Put its trigger inside a heading, then add the panel it opens. The accordion's value is always an array of open item values, even when only one can be open.

`i.Header` renders an `h3` by default. Use a heading level that fits the surrounding document. Tab moves between triggers; Enter or Space opens and closes their panels. Arrow keys, Home and End do nothing here: the APG removed them from the pattern, and a screen reader’s heading navigation already reaches each trigger.

## Usage

Import the root and use the parts it yields:

```gts
import { Accordion } from "ember-ui-sdk/accordion"

<template>
  <Accordion as |a|>
    <a.Item @value="shipping" as |i|>
      <i.Header>
        <i.Trigger>Shipping</i.Trigger>
      </i.Header>
      <i.Panel>Orders arrive in five to seven days.</i.Panel>
    </a.Item>
  </Accordion>
</template>
```

`ember-ui-sdk/accordion` also exports each part by name, such as `AccordionItem` and `AccordionTrigger`. They take the root's `@handle`, so use the parts the root yields instead.

## Multiple

Set `@multiple={{true}}` to let several items stay open. Opening one then leaves the others as they are.

[accordion/multiple](../../examples/components/accordion/ember/multiple.gts)

Open Privacy and security. Notification settings stays open; close either section independently.

## Disabled

Set `@disabled={{true}}` on an item or on a single trigger to prevent changes, or on the accordion to disable every item. Disabled triggers stay in the tab order so people can still discover them. A disabled `<fieldset>` around the accordion disables it too.

[accordion/disabled](../../examples/components/accordion/ember/disabled.gts)

Tab to Premium feature information. It stays focusable, and pressing it leaves its panel closed. Try “How do I update my email address?” instead.

<span id="behavior-and-options" />

## Collapsible

Set `@collapsible={{false}}` when the open item should stay open until another item replaces it. Pair it with `@defaultValue={{array "overview"}}` so a panel starts open.

The open trigger reports `aria-disabled="true"` because pressing it leaves its panel open.

```gts
<Accordion @collapsible={{false}} @defaultValue={{array "overview"}} as |a|>…</Accordion>
```

[accordion/collapsible](../../examples/components/accordion/ember/collapsible.gts)

Open Timeline, then press it again. It stays open until you choose another heading.

## Controlled

Pass `@value` and update it in `@onValueChange` to own the open items.

An item can refuse a change: call `details.cancel()` in its `@onOpenChange` callback. Item callbacks run before the accordion's `@onValueChange`, including the item that would close when another opens. Canceling any one of them cancels the whole change. `@onValueChange` also gets the [reason](https://ui-sdk.dev/docs/react/components/accordion#reasons) for the change.

[accordion/controlled](../../examples/components/accordion/ember/controlled.gts)

Press Security to open it, then press it again. Cancel the confirmation and Security stays open; accept it and the section closes.

## Keep Mounted

A closed panel normally unmounts. Add `@keepMounted={{true}}` to one panel or the whole accordion to keep its content hidden in the page. This preserves local state, such as a draft in a field.

[accordion/keep-mounted](../../examples/components/accordion/ember/keep-mounted.gts)

Write a message, switch to Formatting, then return to Reply to this thread. Your draft is still there.

## Find in Page

Add `@hiddenUntilFound={{true}}` to keep closed panels available to the browser's Find command. A match opens the item immediately, without an animation, with the [reason](https://ui-sdk.dev/docs/react/components/accordion#reasons) `find-in-page`.

[accordion/find-in-page](../../examples/components/accordion/ember/find-in-page.gts)

Use your browser’s Find command to search for “pineapple”. The closed “Which fruit do you stock?” panel opens to reveal the match.

<span id="deep-links" />

A link to an element inside a closed panel can reveal it too. Give the target an `id` and link to it with a hash, such as `href="#refund-timeline"`.

[accordion/deep-link](../../examples/components/accordion/ember/deep-link.gts)

Press Jump to the refund timeline. The closed Refunds panel opens and the browser moves to the linked paragraph.

For an initial URL hash, [open the item explicitly](#url-hash).

## Animation

Each part has a `data-slot`, such as `accordion-panel`. The panel exposes its measured height as `--accordion-panel-height`. Animate that height to or from zero with `data-starting-style` and `data-ending-style`:

```css
[data-slot="accordion-panel"] {
  height: var(--accordion-panel-height);
  overflow: hidden;
  transition: height 0.15s;

  &:is([data-starting-style], [data-ending-style]) {
    height: 0;
  }
}
```

The panel stays mounted until its exit animation finishes. An item's `@onOpenChangeComplete` runs afterward with the open state. A panel that starts open appears right away, with no animation and no completion callback.

[accordion/animation](../../examples/components/accordion/ember/animation.gts)

Open or close an item. Its panel animates its height.

## Expand All

With `@multiple={{true}}`, a controller's `openAll()` opens every enabled item. `closeAll()` closes every item that may close. Create one with `createAccordionController()` and pass it as `@controller`.

[accordion/expand-all](../../examples/components/accordion/ember/expand-all.gts)

Press Expand all or Collapse all. Open an individual week near the bottom to scroll it into view after its panel opens.

## Nested

Put another accordion inside a panel when a section has its own expandable sections. Each accordion tracks its own items. Give the inner headings a lower level than the outer headings.

[accordion/nested](../../examples/components/accordion/ember/nested.gts)

Open Billing, then Invoices inside it. The inner accordion changes without closing Billing.

## FAQ Search

<span id="faq-with-search" />

Combine a search field with a controlled accordion: filter the questions and set `@value` to the matching items. The example also highlights matches and leaves the triggers usable while the search is active.

[accordion/search](../../examples/components/accordion/ember/search.gts)

Search for “refund” to show and open matching answers. Try “zzz” for the empty result, then clear the search to restore all questions.

## URL Hash

<span id="open-the-item-in-the-url-hash" />

A hash can name an item's `@value` instead of an element inside its panel. Read it after mount and on `hashchange`, then open and focus the matching item through your controller:

```ts
const value = decodeURIComponent(location.hash.slice(1))
if (items.some((item) => item.value === value)) {
  accordion.open(value)
  accordion.focus(value)
}
```

Check the value against your items first. A controller can hold a value even when no item renders it. Remove the `hashchange` listener when the component unmounts.

## Query String

<span id="keep-open-items-in-the-query-string" />

Use `open` query parameters when several items should be shareable. Read the initial values from your router on the server, then write accepted changes back to the URL:

```ts
function saveOpenItems(value: string[]) {
  const url = new URL(location.href)
  url.searchParams.delete("open")
  for (const item of value) url.searchParams.append("open", item)
  history.replaceState(null, "", url)
}
```

Call this from `@onValueChange` after updating your state. If your app already has a router, use its navigation API instead.

## Scroll into View

<span id="scroll-an-item-into-view" />

Scroll after `@onOpenChangeComplete`, when the panel has its full height. Scrolling in `@onOpenChange` would measure it before it opens. The [Expand All example](#expand-all) shows the full setup and scrolls only when someone opens a single item.

## Custom Rendering

<span id="render-functions" />

Pass `@render={{true}}` to a part to choose another heading level or element. The part yields `{ part, state }`: bind `part` to your element as a modifier, and read `state` to add to its content. Accordion's states are listed under [State](https://ui-sdk.dev/docs/react/components/accordion#state).

[accordion/render](../../examples/components/accordion/ember/render.gts)

Each step is an h4 with its number and a Show or Hide hint that follows its open state. Open Import the parts to see it update.

## Styling

Style the parts with the attributes below. This turns the chevron as its panel opens, mirrors it in right to left with `:dir(rtl)`, and dims disabled triggers:

```css
[data-slot="accordion-trigger"] {
  & > svg {
    rotate: -90deg;

    &:dir(rtl) {
      rotate: 90deg;
    }
  }

  &[data-open] > svg {
    rotate: 0deg;
  }

  &[data-disabled] {
    color: gray;
  }
}
```

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [accordion reference](https://ui-sdk.dev/docs/react/components/accordion) in the upstream docs.

Options and callbacks are passed as arguments: `@value`, `@onValueChange`. Every part also takes `@render`. Headers, triggers and panels take their item's value from the item.

### AccordionHeader

The header takes no options of its own, only the attributes of the element it renders.

### Controller

Create one with `createAccordionController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the item and accordion callbacks like a press, and returns `false` when the change is canceled or does nothing.

### Events

Callbacks get the new state first, then the details.

| Argument                | On              | Receives                                                                                                         |
| ----------------------- | --------------- | ---------------------------------------------------------------------------------------------------------------- |
| `@onValueChange`        | `Accordion`     | `(value, details)`: the open items, and the [reason](https://ui-sdk.dev/docs/react/components/accordion#reasons) |
| `@onOpenChange`         | `AccordionItem` | `(open, details)`, before `@onValueChange`                                                                       |
| `@onOpenChangeComplete` | `AccordionItem` | `(open)`, after the panel's animation                                                                            |

## Accessibility

The accordion follows the [WAI-ARIA accordion pattern](https://www.w3.org/WAI/ARIA/apg/patterns/accordion/). Every line below is an automated test.

Every panel is a region labelled by its trigger, so screen readers can list open panels as landmarks. With many panels open at once, such as `@multiple` with Expand all, keep the number of items modest so that list stays short.
