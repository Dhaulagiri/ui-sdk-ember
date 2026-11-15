# Timeline

Show dated events in order, like an activity feed, a changelog or an order's progress, with arrow keys between them.

Use a Timeline for a list of things that happened, or will: a project's activity, an order's status history, a release's milestones. It's a list for screen readers, with one tab stop for keyboards, and the arrow keys move between events.

```glimmer-ts title="demo.gts"
import { Timeline } from "ember-ui-sdk/timeline"

const events = [
  {
    title: "Deployed to production",
    dateTime: "2026-11-10T14:32",
    time: "Today, 2:32 PM",
    description: "Version 2.4.1 is live in every region.",
  },
  {
    title: "Checks passed",
    dateTime: "2026-11-10T14:20",
    time: "Today, 2:20 PM",
    description: "312 tests and the bundle size budget.",
  },
  {
    title: "Pull request merged",
    dateTime: "2026-11-10T13:58",
    time: "Today, 1:58 PM",
    description: "Ada merged Cache search results into main.",
  },
  {
    title: "Review requested",
    dateTime: "2026-11-09T17:05",
    time: "Yesterday, 5:05 PM",
    description: "Grace and Linus were asked to review.",
  },
]

<template>
  <Timeline aria-label="Activity" as |t|>
    {{#each events key="title" as |event|}}
      <t.Item as |item|>
        <item.Marker />
        <item.Connector />
        <item.Title>{{event.title}}</item.Title>
        <item.Time datetime={{event.dateTime}}>{{event.time}}</item.Time>
        <item.Description>{{event.description}}</item.Description>
      </t.Item>
    {{/each}}
  </Timeline>
</template>
```

Tab into the activity, then use Up and Down to move between events. Home and End jump to the first and last.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

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

Import the parts and put them together:

```gts
import {
  Timeline,
  TimelineConnector,
  TimelineDescription,
  TimelineItem,
  TimelineMarker,
  TimelineTime,
  TimelineTitle,
} from "ember-ui-sdk/timeline"

<template>
  <Timeline aria-label="Activity">
    <TimelineItem>
      <TimelineMarker />
      <TimelineConnector />
      <TimelineTitle>Deployed to production</TimelineTitle>
      <TimelineTime datetime="2026-11-10T14:32">2:32 PM</TimelineTime>
      <TimelineDescription>Version 2.4.1 is live.</TimelineDescription>
    </TimelineItem>
  </Timeline>
</template>
```

`Timeline` renders a `<div>` with the `list` role and each item a `<div>` with the `listitem` role. With `@feed={{true}}`, the same markup becomes a feed of articles. Pass `datetime` to `TimelineTime`, so the date is machine readable while the text stays friendly.

When focus lands on an event, screen readers read its title as its name, then its time and description. Links and buttons inside an event stay in the tab order: Tab moves from the event to them, and arrow keys pressed on them stay with them.

## Horizontal

Pass `@orientation="horizontal"` for a row, like a roadmap. Left and Right move between events instead of Up and Down, and they swap in right-to-left text. Pass `@loop={{false}}` to stop at either end.

```glimmer-ts title="horizontal.gts"
import { Timeline } from "ember-ui-sdk/timeline"

const milestones = [
  { title: "Kickoff", dateTime: "2026-01", time: "January" },
  { title: "Design review", dateTime: "2026-03", time: "March" },
  { title: "Beta", dateTime: "2026-06", time: "June" },
  { title: "Launch", dateTime: "2026-09", time: "September" },
]

<template>
  <Timeline @orientation="horizontal" @loop={{false}} aria-label="Roadmap" as |t|>
    {{#each milestones key="title" as |milestone|}}
      <t.Item as |item|>
        <item.Marker />
        <item.Connector />
        <item.Title>{{milestone.title}}</item.Title>
        <item.Time datetime={{milestone.dateTime}}>
          {{milestone.time}}
        </item.Time>
      </t.Item>
    {{/each}}
  </Timeline>
</template>
```

Tab into the roadmap and press Right to reach Launch. Right again stays there.

## Status

Give each item a `@status` of `"complete"`, `"current"` or `"upcoming"` for a process, like an order's progress. The current event gets `aria-current="step"`, and Tab lands on it first. Every part of an event shows its status with `data-complete`, `data-current` or `data-upcoming`.

Create a controller with `createTimelineController` and call its `focus()` with an item's `@value` to move focus to it from anywhere.

```glimmer-ts title="status.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Check } from "lucide"
import {
  createTimelineController,
  Timeline,
  TimelineItem,
} from "ember-ui-sdk/timeline"
import { icon } from "./icon"

const steps = [
  {
    value: "placed",
    title: "Order placed",
    dateTime: "2026-11-01",
    time: "Nov 1",
    description: "We received your order.",
    status: "complete",
    done: true,
  },
  {
    value: "packed",
    title: "Packed",
    dateTime: "2026-11-02",
    time: "Nov 2",
    description: "Your items left the shelf.",
    status: "complete",
    done: true,
  },
  {
    value: "shipped",
    title: "Shipped",
    dateTime: "2026-11-03",
    time: "Nov 3",
    description: "On its way with the carrier.",
    status: "current",
    done: false,
  },
  {
    value: "delivered",
    title: "Delivered",
    dateTime: "2026-11-05",
    time: "Nov 5",
    description: "Expected by Thursday.",
    status: "upcoming",
    done: false,
  },
]

export default class Status extends Component {
  steps = steps
  controller = createTimelineController()

  goToCurrent = () => {
    this.controller.focus("shipped")
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.goToCurrent}}>Go to Current Step</button>
      </div>
      <Timeline aria-label="Order status" @controller={{this.controller}} as |t|>
        {{#each this.steps key="value" as |step|}}
          <t.Item @value={{step.value}} @status={{step.status}} as |item|>
            <item.Marker>
              {{#if step.done}}
                {{icon Check}}
              {{/if}}
            </item.Marker>
            <item.Connector />
            <item.Title>{{step.title}}</item.Title>
            <item.Time datetime={{step.dateTime}}>{{step.time}}</item.Time>
            <item.Description>{{step.description}}</item.Description>
          </t.Item>
        {{/each}}
      </Timeline>
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

Tab into the order status. Focus starts on Shipped, the current step. Move away, then choose Go to Current Step.

A marker shows status only to sighted people. When the status matters, say it in the title or description too, like "Shipped, in progress".

## Details

Put a [Collapsible](./collapsible.md) inside an item for details that can open. Its trigger is a button inside the event, so Tab reaches it after the event, and arrow keys still move between events.

```glimmer-ts title="details.gts"
import { ChevronDown } from "lucide"
import { Collapsible } from "ember-ui-sdk/collapsible"
import { Timeline } from "ember-ui-sdk/timeline"
import { icon } from "./icon"

const releases = [
  {
    title: "Version 2.4",
    dateTime: "2026-10-28",
    time: "October 28",
    description: "Faster search and resumable uploads.",
    changes: [
      "Search now matches file contents, not only names.",
      "Uploads resume after the connection drops.",
    ],
  },
  {
    title: "Version 2.3",
    dateTime: "2026-09-30",
    time: "September 30",
    description: "Shared links and a new sidebar.",
    changes: [
      "Shared links remember the folder they were opened from.",
      "The sidebar collapses to icons on narrow screens.",
    ],
  },
  {
    title: "Version 2.2",
    dateTime: "2026-08-26",
    time: "August 26",
    description: "Dark mode follows your system.",
    changes: ["Dark mode follows the system setting.", "Avatars are sharper."],
  },
]

<template>
  <Timeline aria-label="Changelog" as |t|>
    {{#each releases key="title" as |release|}}
      <t.Item as |item|>
        <item.Marker />
        <item.Connector />
        <item.Title>{{release.title}}</item.Title>
        <item.Time datetime={{release.dateTime}}>{{release.time}}</item.Time>
        <item.Description>{{release.description}}</item.Description>
        <Collapsible as |c|>
          <c.Trigger>
            What Changed
            {{icon ChevronDown}}
          </c.Trigger>
          <c.Panel>
            <ul>
              {{#each release.changes key="@identity" as |change|}}
                <li>{{change}}</li>
              {{/each}}
            </ul>
          </c.Panel>
        </Collapsible>
      </t.Item>
    {{/each}}
  </Timeline>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Tab to What Changed under Version 2.4 and press Enter. Shift+Tab back to the event, then press Down for Version 2.3.

## Feed

Pass `@feed={{true}}` for a timeline that loads more as people scroll, like a social feed. It follows the [WAI-ARIA feed pattern](https://www.w3.org/WAI/ARIA/apg/patterns/feed/): the root becomes a `feed` and each item an `article` with its position and the count, and Page Down and Page Up move between articles from anywhere inside one.

Pass `@busy={{true}}` while you load or change articles. It sets `aria-busy`, so screen readers wait for the new articles before reading on.

```glimmer-ts title="feed.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Timeline } from "ember-ui-sdk/timeline"
import { useLog } from "./log"

const updates = [
  {
    id: 1,
    author: "Ada",
    date: "2026-11-10",
    time: "Nov 10",
    text: "Shipped the new onboarding flow.",
  },
  {
    id: 2,
    author: "Grace",
    date: "2026-11-10",
    time: "Nov 10",
    text: "Fixed the flaky upload test.",
  },
  {
    id: 3,
    author: "Linus",
    date: "2026-11-09",
    time: "Nov 9",
    text: "Moved the docs to the new theme.",
  },
  {
    id: 4,
    author: "Margaret",
    date: "2026-11-09",
    time: "Nov 9",
    text: "Wrote the launch checklist.",
  },
  {
    id: 5,
    author: "Ada",
    date: "2026-11-08",
    time: "Nov 8",
    text: "Cut search latency in half.",
  },
  {
    id: 6,
    author: "Grace",
    date: "2026-11-07",
    time: "Nov 7",
    text: "Added keyboard shortcuts to the editor.",
  },
  {
    id: 7,
    author: "Linus",
    date: "2026-11-06",
    time: "Nov 6",
    text: "Cleaned up the old billing code.",
  },
  {
    id: 8,
    author: "Margaret",
    date: "2026-11-05",
    time: "Nov 5",
    text: "Ran the accessibility review.",
  },
  {
    id: 9,
    author: "Ada",
    date: "2026-11-04",
    time: "Nov 4",
    text: "Started the mobile layout.",
  },
]

const pageSize = 3

export default class Feed extends Component {
  log = useLog(this)
  updates = updates
  @tracked count = pageSize
  @tracked busy = false

  get visible() {
    return this.updates.slice(0, this.count)
  }

  get exhausted() {
    return this.count >= this.updates.length
  }

  get busyOrDone() {
    return this.busy || this.exhausted
  }

  get label() {
    return this.busy ? "Loading…" : "Load More"
  }

  loadMore = () => {
    this.busy = true
    setTimeout(() => {
      this.count += pageSize
      this.busy = false
      this.log(`Loaded ${pageSize} more updates`)
    }, 600)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" disabled={{this.busyOrDone}} {{on "click" this.loadMore}}>
          {{this.label}}
        </button>
      </div>
      <Timeline @feed={{true}} @busy={{this.busy}} aria-label="Team updates" as |t|>
        {{#each this.visible key="id" as |update|}}
          <t.Item as |item|>
            <item.Marker />
            <item.Connector />
            <item.Title>{{update.author}}</item.Title>
            <item.Time datetime={{update.date}}>{{update.time}}</item.Time>
            <item.Description>{{update.text}}</item.Description>
          </t.Item>
        {{/each}}
      </Timeline>
    </div>
  </template>
}
```

Tab into the updates and press Page Down. Choose Load More: the feed is busy until three more updates arrive. The console logs each load.

Use a list for most timelines. A feed is for long lists that grow, where a screen reader's reading mode should flow from one article to the next.

## Styling

The parts have no styles. Lay an item out as a grid, with the marker in its own column and the connector positioned along it. `data-orientation` on every part says which way the events run.

Use `data-first` and `data-last` on items to hide the connector after the last event. They're written once the events are in the page; for markup rendered on the server, `:last-child` does the same before it hydrates.

Each part has a `data-slot`, such as `timeline-marker`, and its state attributes are listed under [Data Attributes](#data-attributes).

`Timeline` writes `--timeline-count`, how many events it holds, and each `TimelineItem` writes `--timeline-index`, its place from 0. Use them for a horizontal row's grid columns, or to stagger an animation.

### Timeline
- `--timeline-count`: How many events are in the page. Size a horizontal grid's columns with it.

### TimelineItem
- `--timeline-index`: The event's place among the events in the page, 0 for the first. It follows them as they move.

## Data Attributes

### Timeline
`[data-slot="timeline"]`

- `data-orientation` (`horizontal`, `vertical`): Which way the events run.
- `data-busy`: Present while a feed is loading or changing events, with `busy`.

### TimelineItem
`[data-slot="timeline-item"]`

- `data-complete`: Present when the event's status is `complete`.
- `data-orientation` (`horizontal`, `vertical`): Which way the events run.
- `data-current`: Present when the event's status is `current`.
- `data-upcoming`: Present when the event's status is `upcoming`.
- `data-first`: Present on the first event. Written once it's in the page.
- `data-last`: Present on the last event. Written once it's in the page.

### TimelineMarker
`[data-slot="timeline-marker"]`

- `data-complete`: Present when the event's status is `complete`.
- `data-orientation` (`horizontal`, `vertical`): Which way the events run.
- `data-current`: Present when the event's status is `current`.
- `data-upcoming`: Present when the event's status is `upcoming`.

### TimelineConnector
`[data-slot="timeline-connector"]`

- `data-complete`: Present when the event's status is `complete`.
- `data-orientation` (`horizontal`, `vertical`): Which way the events run.
- `data-current`: Present when the event's status is `current`.
- `data-upcoming`: Present when the event's status is `upcoming`.

### TimelineTime
`[data-slot="timeline-time"]`

- `data-complete`: Present when the event's status is `complete`.
- `data-orientation` (`horizontal`, `vertical`): Which way the events run.
- `data-current`: Present when the event's status is `current`.
- `data-upcoming`: Present when the event's status is `upcoming`.

### TimelineTitle
`[data-slot="timeline-title"]`

- `data-complete`: Present when the event's status is `complete`.
- `data-orientation` (`horizontal`, `vertical`): Which way the events run.
- `data-current`: Present when the event's status is `current`.
- `data-upcoming`: Present when the event's status is `upcoming`.

### TimelineDescription
`[data-slot="timeline-description"]`

- `data-complete`: Present when the event's status is `complete`.
- `data-orientation` (`horizontal`, `vertical`): Which way the events run.
- `data-current`: Present when the event's status is `current`.
- `data-upcoming`: Present when the event's status is `upcoming`.

## API Reference

### Timeline

- `orientation?` (`TimelineOrientation`): Which arrow keys move between events: up and down, or left and right.
- `loop?` (`boolean`): Whether arrow keys wrap from the last event to the first.
- `feed?` (`boolean`): Whether the events are a feed that loads more as people scroll, rather than a list. Each event becomes an article with its position, and Page Down and Page Up move between them from anywhere inside one.
- `busy?` (`boolean`): Whether a feed is loading or changing events, which sets `aria-busy` so screen readers wait until it's done. Only a feed reads it.
- `controller?` (`{ focus: (value?: string) => void; }`): Focuses an event from anywhere. Create one with `createTimelineController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### TimelineItem

- `value?` (`string`): Names the event for the controller's `focus()`. Generated when left out.
- `status?` (`TimelineStatus`): Where the event stands in a process. The `"current"` one sets `aria-current="step"` and takes the tab stop first.

`TimelineMarker`, `TimelineConnector`, `TimelineTime`, `TimelineTitle` and `TimelineDescription` take no arguments of their own.

### State

What `@render` parts and state-based class names receive on `Timeline`:

- `orientation` (`TimelineOrientation`): Which way the events run.
- `feed` (`boolean`): Whether the events are a feed rather than a list.
- `busy` (`boolean`): Whether a feed is loading or changing events.

On `TimelineItem` and every part inside it:

- `status` (`TimelineStatus | undefined`): Where the event stands in a process, or `undefined` when it has no status.
- `orientation` (`TimelineOrientation`): Which way the events run.

### Controller

- `focus(value?)` (`(value?: string | undefined) => void`): Moves focus to an event by its `value`, or to the event that holds the tab stop.

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

### Tested Behavior

Every line below is an automated test.

- A busy feed sets aria-busy.

**A list of events**

- The events are a named list of list items.
- Each event is named by its title and described by its time and description.
- Tab lands on the current event, then on the links inside it, then leaves.
- The current event says it's the current step.
- Each event and its parts show its status.
- ArrowDown and ArrowUp move between events.
- ArrowLeft and ArrowRight do nothing in a vertical list.
- Home and End move to the first and last events.
- Arrow keys wrap from the last event to the first.
- Arrow keys on a link inside an event leave focus on the link.
- Page Down does nothing in a list.
- Tab comes back to the event focused last.
- Only the event with the tab stop is in the tab order.
- The first and last events are marked.
- An event added at the top becomes the first.
- Events that change places move the first and last marks.
- Each event carries its place and the list how many there are.
- The tab stop follows the current step when it moves before focus enters.
- The controller moves focus to an event.
- Markers and connectors are hidden from assistive technology.

**A list that doesn't loop**

- Arrow keys stop at either end.

**A horizontal list**

- ArrowRight and ArrowLeft move between events.
- ArrowDown and ArrowUp do nothing.

**A feed**

- The events are a named feed of articles.
- Each article says where it sits and how many there are.
- An article added at the top moves every position.
- Articles moved inside a wrapper take their new places.
- Page Down and Page Up move between articles.
- Page Down from a link inside an article moves to the next article.
- Page Down on the last article stays there.
- The feed isn't busy until it's told.

Runs in React, Vue and web components.
