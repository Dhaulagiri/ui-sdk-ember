---
title: Timeline
description: Show dated events in order, like an activity feed, a changelog or an order's progress, with arrow keys between them.
---

Use a Timeline for a list of things that happened, or will: a project's activity, an order's status history, a release's milestones. It's a list for screen readers, with one tab stop for keyboards, and the arrow keys move between events.

[timeline/demo](../../examples/components/timeline/ember/demo.gts)

Tab into the activity, then use Up and Down to move between events. Home and End jump to the first and last.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Timeline`:

```text
Timeline
├── TimelineItem
│   ├── TimelineMarker
│   ├── TimelineConnector
│   ├── TimelineTitle
│   ├── TimelineTime
│   └── TimelineDescription
└── TimelineItem
```

Every part inside an item is optional. `TimelineMarker` is the dot or icon on the line, and `TimelineConnector` the line to the next event. Both are hidden from screen readers, so they're only for looks.

## Usage

Import the root and put together the parts it yields:

```gts
import { Timeline } from "ember-ui-sdk/timeline"

<template>
  <Timeline aria-label="Activity" as |t|>
    <t.Item as |i|>
      <i.Marker />
      <i.Connector />
      <i.Title>Deployed to production</i.Title>
      <i.Time datetime="2026-11-10T14:32">2:32 PM</i.Time>
      <i.Description>Version 2.4.1 is live.</i.Description>
    </t.Item>
  </Timeline>
</template>
```

`Timeline` renders a `<div>` with the `list` role and each item a `<div>` with the `listitem` role. With `@feed={{true}}`, the same markup becomes a feed of articles. Pass `datetime` to `TimelineTime`, so the date is machine readable while the text stays friendly.

When focus lands on an event, screen readers read its title as its name, then its time and description. Links and buttons inside an event stay in the tab order: Tab moves from the event to them, and arrow keys pressed on them stay with them.

## Horizontal

Pass `@orientation="horizontal"` for a row, like a roadmap. Left and Right move between events instead of Up and Down, and they swap in right-to-left text. Pass `@loop={{false}}` to stop at either end.

[timeline/horizontal](../../examples/components/timeline/ember/horizontal.gts)

Tab into the roadmap and press Right to reach Launch. Right again stays there.

## Status

Give each item a `@status` of `"complete"`, `"current"` or `"upcoming"` for a process, like an order's progress. The current event gets `aria-current="step"`, and Tab lands on it first. Every part of an event shows its status with `data-complete`, `data-current` or `data-upcoming`.

Create a controller with `createTimelineController` and call its `focus()` with an item's `@value` to move focus to it from anywhere.

[timeline/status](../../examples/components/timeline/ember/status.gts)

Tab into the order status. Focus starts on Shipped, the current step. Move away, then choose Go to Current Step.

A marker shows status only to sighted people. When the status matters, say it in the title or description too, like "Shipped, in progress".

## Details

Put a [Collapsible](./collapsible.md) inside an item for details that can open. Its trigger is a button inside the event, so Tab reaches it after the event, and arrow keys still move between events.

[timeline/details](../../examples/components/timeline/ember/details.gts)

Tab to What Changed under Version 2.4 and press Enter. Shift+Tab back to the event, then press Down for Version 2.3.

## Feed

Pass `@feed={{true}}` for a timeline that loads more as people scroll, like a social feed. It follows the [WAI-ARIA feed pattern](https://www.w3.org/WAI/ARIA/apg/patterns/feed/): the root becomes a `feed` and each item an `article` with its position and the count, and Page Down and Page Up move between articles from anywhere inside one.

Pass `@busy={{true}}` while you load or change articles. It sets `aria-busy`, so screen readers wait for the new articles before reading on.

[timeline/feed](../../examples/components/timeline/ember/feed.gts)

Tab into the updates and press Page Down. Choose Load More: the feed is busy until three more updates arrive. The console logs each load.

Use a list for most timelines. A feed is for long lists that grow, where a screen reader's reading mode should flow from one article to the next.

## Styling

The parts have no styles. Lay an item out as a grid, with the marker in its own column and the connector positioned along it. `data-orientation` on every part says which way the events run.

Use `data-first` and `data-last` on items to hide the connector after the last event. They're written once the events are in the page; for markup rendered on the server, `:last-child` does the same before it hydrates.

Each part has a `data-slot`, such as `timeline-marker`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/timeline#data-attributes).

`Timeline` writes `--timeline-count`, how many events it holds, and each `TimelineItem` writes `--timeline-index`, its place from 0. Use them for a horizontal row's grid columns, or to stagger an animation.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [timeline reference](https://ui-sdk.dev/docs/react/components/timeline) in the upstream docs.

### TimelineItem

`TimelineMarker`, `TimelineConnector`, `TimelineTime`, `TimelineTitle` and `TimelineDescription` take no arguments of their own.

## Accessibility

A timeline is a `list` of `listitem`s, named with `aria-label`. With `@feed`, it follows the [WAI-ARIA feed pattern](https://www.w3.org/WAI/ARIA/apg/patterns/feed/): a `feed` of `article`s, each with `aria-posinset` and `aria-setsize`, and `aria-busy` while it loads. Each event is named by its title through `aria-labelledby` and described by its time and description through `aria-describedby`. The current event has `aria-current="step"`.

### Keyboard

The events have one tab stop, a roving focus. Tab enters on the current event, else the first, then returns to the event focused last. Markup rendered on the server holds the stop on the first event until it hydrates.

| Key                        | Action                                                     |
| -------------------------- | ---------------------------------------------------------- |
| `ArrowDown` / `ArrowUp`    | Move focus between events in a vertical timeline           |
| `ArrowRight` / `ArrowLeft` | Move focus between events in a horizontal timeline         |
| `Home` / `End`             | Focus the first or last event                              |
| `PageDown` / `PageUp`      | In a feed, focus the next or previous article, from inside |
| `Tab`                      | Move from an event to the links and buttons inside it      |

Arrow keys move only from an event itself, so controls inside keep them. In right-to-left text, Left and Right swap.
