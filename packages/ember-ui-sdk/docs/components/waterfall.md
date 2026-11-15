# Waterfall

Show a trace or a page's requests as bars on a shared time axis, with spans that expand to show what they started.

Use a Waterfall for anything with a start and a duration that nests: a browser's network requests, an OpenTelemetry trace, the steps of a build. Each span is a row with its own bar, placed on one time axis, and screen reader and keyboard users get a treegrid they can walk span by span.

```glimmer-ts title="network.gts"
import { Waterfall } from "ember-ui-sdk/waterfall"

const requests = [
  { value: "document", label: "/", start: 0, duration: 182 },
  { value: "styles", label: "app.css", start: 190, duration: 96 },
  { value: "script", label: "app.js", start: 192, duration: 410 },
  { value: "font", label: "inter.woff2", start: 300, duration: 220 },
  { value: "user", label: "api/user", start: 610, duration: 240 },
  { value: "avatar", label: "avatar.png", start: 860, duration: 150 },
]

const sizes: Record<string, string> = {
  document: "14 kB",
  styles: "8 kB",
  script: "212 kB",
  font: "48 kB",
  user: "1 kB",
  avatar: "36 kB",
}

const barLabel = (
  request: { value: string },
  { start, duration }: { start: string; duration: string }
) => `${sizes[request.value]}, starts at ${start}, takes ${duration}`

const sizeOf = (value: string) => sizes[value]

<template>
  <Waterfall
    aria-label="Network requests"
    @items={{requests}}
    @getBarLabel={{barLabel}}
    as |w|
  >
    <w.HeaderRow>
      <w.ColumnHeader>Name</w.ColumnHeader>
      <w.ColumnHeader>Size</w.ColumnHeader>
      <w.ColumnHeader aria-label="Timeline">
        <w.Axis @maxTicks={{5}} />
        <w.Mark @time={{620}}>DOMContentLoaded</w.Mark>
      </w.ColumnHeader>
    </w.HeaderRow>
    {{#each requests key="value" as |request|}}
      <w.Row @value={{request.value}} as |row|>
        <row.Header>{{request.label}}</row.Header>
        <row.Cell>{{sizeOf request.value}}</row.Cell>
        <row.Bar />
      </w.Row>
    {{/each}}
  </Waterfall>
</template>
```

Use the arrow keys to move between requests. Press Right to move into a row's cells, where each bar reads out when its request starts and how long it takes.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Waterfall`:

```text
Waterfall as |w|
├── w.HeaderRow
│   ├── w.ColumnHeader
│   └── w.ColumnHeader
│       ├── w.Axis
│       │   └── w.Tick
│       └── w.Mark
├── w.Row as |row|
│   ├── row.Header
│   │   └── row.Indicator
│   ├── row.Cell
│   └── row.Bar
└── w.Row as |row|
    ├── row.Header
    └── row.Bar
```

Pass every span as `@items` and render a `w.Row` for each with the span's `@value`. The rows are flat siblings: the waterfall reads each one's level, place among its siblings and children from `@items`. Give the waterfall an accessible name.

`row.Header` names the span, and holds the `row.Indicator` of a span with children. `row.Bar` is the cell on the time axis. `row.Cell` is any other column, like a status or a size. The header row, the axis and marks are optional.

## Usage

Each span has a `value`, a `label`, a `start` and a `duration` in milliseconds, and the spans it started as `children`:

```gts
import { Waterfall, type WaterfallData } from "ember-ui-sdk/waterfall"

const requests: WaterfallData = [
  { value: "document", label: "/", start: 0, duration: 182 },
  { value: "script", label: "app.js", start: 192, duration: 410 },
]

<template>
  <Waterfall @items={{requests}} aria-label="Network requests" as |w|>
    {{#each requests as |request|}}
      <w.Row @value={{request.value}} as |row|>
        <row.Header>{{request.label}}</row.Header>
        <row.Bar />
      </w.Row>
    {{/each}}
  </Waterfall>
</template>
```

Every row sets `--waterfall-start` and `--waterfall-size`, where its span begins and how much of the axis it covers, as percentages. Place the bar with them in plain CSS, with no layout in JavaScript:

```css
[data-slot="waterfall-bar"] {
  position: relative;
}

[data-slot="waterfall-bar"]::before {
  content: "";
  position: absolute;
  inset-block: 6px;
  inset-inline-start: var(--waterfall-start);
  width: var(--waterfall-size);
  background: steelblue;
}
```

Without rows of your own, the waterfall renders a row for every span, with its header and bar.

## Network Requests

The first example adds a header row. `w.Axis` renders a `w.Tick` at round times, at most `@maxTicks` of them, and `w.Mark` draws a moment across every row, like DOMContentLoaded, placed by `--waterfall-mark`. The axis is hidden from screen readers, who hear each bar's own times instead. `@getBarLabel` changes what a bar says; this one adds the request's size.

## Nested Spans

Spans with `children` expand and collapse. Click a span's indicator, or press Right and Left on its row. To render only the rows that show, pass `@expanded` and update it in `@onExpandedChange`, then render the rows from `visibleWaterfallRows(items, expanded)`, which flattens the open spans in order.

Clicking a row, or pressing Enter or Space on it, selects it. `@value` and `@onValueChange` hold the selected span, like the one a details panel shows. `@format` changes how times read, here as narrow milliseconds.

```glimmer-ts title="trace.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { ChevronRight } from "lucide"
import {
  createWaterfallController,
  visibleWaterfallRows,
  Waterfall,
} from "ember-ui-sdk/waterfall"
import { icon } from "./icon"
import { useLog } from "./log"

const trace = [
  {
    value: "checkout",
    label: "POST /checkout",
    start: 0,
    duration: 920,
    children: [
      { value: "auth", label: "auth.verify", start: 12, duration: 64 },
      {
        value: "cart",
        label: "cart.load",
        start: 80,
        duration: 310,
        children: [
          {
            value: "cart-db",
            label: "db.query carts",
            start: 96,
            duration: 140,
          },
          {
            value: "prices",
            label: "pricing.quote",
            start: 240,
            duration: 136,
          },
        ],
      },
      {
        value: "payment",
        label: "payments.charge",
        start: 400,
        duration: 470,
        children: [
          { value: "fraud", label: "fraud.score", start: 410, duration: 120 },
          {
            value: "gateway",
            label: "gateway.capture",
            start: 540,
            duration: 310,
          },
        ],
      },
      { value: "email", label: "email.enqueue", start: 880, duration: 30 },
    ],
  },
]

const format = { style: "unit", unit: "millisecond", unitDisplay: "narrow" }

export default class Trace extends Component {
  log = useLog(this)
  spans = createWaterfallController()
  trace = trace
  format = format
  @tracked expanded = ["checkout"]
  @tracked value: string | null = null

  get rows() {
    return visibleWaterfallRows(this.trace, this.expanded)
  }

  onValueChange = (next: string | null) => {
    this.value = next
    this.log(`Selected ${next}`)
  }

  onExpandedChange = (next: string[]) => {
    this.expanded = next
  }

  expandAll = () => {
    this.spans.expandAll()
  }

  collapseAll = () => {
    this.spans.collapseAll()
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.expandAll}}>Expand All</button>
        <button type="button" {{on "click" this.collapseAll}}>Collapse All</button>
      </div>
      <Waterfall
        aria-label="Checkout trace"
        @items={{this.trace}}
        @controller={{this.spans}}
        @expanded={{this.expanded}}
        @onExpandedChange={{this.onExpandedChange}}
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @format={{this.format}}
        as |w|
      >
        <w.HeaderRow>
          <w.ColumnHeader>Span</w.ColumnHeader>
          <w.ColumnHeader aria-label="Timeline">
            <w.Axis />
          </w.ColumnHeader>
        </w.HeaderRow>
        {{#each this.rows key="@index" as |entry|}}
          <w.Row @value={{entry.item.value}} as |row|>
            <row.Header>
              {{#if entry.item.children}}
                <row.Indicator>{{icon ChevronRight}}</row.Indicator>
              {{/if}}
              {{entry.item.label}}
            </row.Header>
            <row.Bar />
          </w.Row>
        {{/each}}
      </Waterfall>
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

Expand payments.charge with Right, then press Enter on gateway.capture. The console logs the selected span. Collapse All closes every span.

## Zoom

`@range` sets the stretch of time the axis shows, as `[start, end]`. Change it to zoom or pan: the bars and ticks follow, and a bar outside the range shrinks to its edge. Without it, the axis runs from the earliest start to the latest end.

```glimmer-ts title="zoom.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { ChevronRight } from "lucide"
import {
  Waterfall,
  WaterfallTick,
  type WaterfallData,
} from "ember-ui-sdk/waterfall"
import { icon } from "./icon"

const trace: WaterfallData = [
  {
    value: "render",
    label: "render /dashboard",
    start: 0,
    duration: 1200,
    children: [
      { value: "session", label: "session", start: 20, duration: 80 },
      { value: "metrics", label: "metrics", start: 110, duration: 640 },
      { value: "alerts", label: "alerts", start: 110, duration: 260 },
      { value: "html", label: "stream html", start: 760, duration: 420 },
    ],
  },
]

const full: [number, number] = [0, 1200]

function zoomed([start, end]: [number, number], factor: number) {
  const center = (start + end) / 2
  const half = Math.min(((end - start) * factor) / 2, full[1] / 2)
  const from = Math.min(Math.max(full[0], center - half), full[1] - half * 2)
  return [from, from + half * 2] as [number, number]
}

const spans = [trace[0], ...trace[0].children!]

export default class Zoom extends Component {
  spans = spans
  full = full
  @tracked range: [number, number] = full

  zoomIn = () => {
    this.range = zoomed(this.range, 0.5)
  }

  zoomOut = () => {
    this.range = zoomed(this.range, 2)
  }

  reset = () => {
    this.range = full
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.zoomIn}}>Zoom In</button>
        <button type="button" {{on "click" this.zoomOut}}>Zoom Out</button>
        <button type="button" {{on "click" this.reset}}>Reset</button>
      </div>
      <Waterfall
        aria-label="Dashboard render"
        @items={{trace}}
        @range={{this.range}}
        @defaultExpanded={{array "render"}}
        @defaultValue="metrics"
        as |w|
      >
        <w.HeaderRow>
          <w.ColumnHeader>Span</w.ColumnHeader>
          <w.ColumnHeader aria-label="Timeline">
            <w.Axis as |axis|>
              {{#each axis.state.ticks key="time" as |tick|}}
                <WaterfallTick
                  @handle={{w.handle}}
                  @time={{tick.time}}
                >{{tick.label}}</WaterfallTick>
              {{/each}}
            </w.Axis>
          </w.ColumnHeader>
        </w.HeaderRow>
        {{#each this.spans key="value" as |span|}}
          <w.Row @value={{span.value}} as |row|>
            <row.Header>
              {{#if span.children}}
                <row.Indicator>{{icon ChevronRight}}</row.Indicator>
              {{/if}}
              {{span.label}}
            </row.Header>
            <row.Bar />
          </w.Row>
        {{/each}}
      </Waterfall>
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

Press Zoom In twice. The axis shows smaller steps, and the metrics span stretches past the edges.

## Large Traces

A trace can have thousands of spans. Render only the rows in view: flatten the open spans with `visibleWaterfallRows`, and render the nearby rows at their offsets. The waterfall still reports every row's level and place among its siblings, so screen readers hear the whole hierarchy. Give the waterfall `aria-rowcount` with the number of rows that show, and each row `aria-rowindex` with its index plus one, so a screen reader counts rows in the whole trace, not just the ones in the page.

`@onHighlight` reports the index of the row the keyboard moves to. Scroll it into view there, so a row that isn't rendered yet takes focus once it is. An arrow key changes only the two rows it moves between, however long the trace is.

```glimmer-ts title="virtualized.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronRight } from "lucide"
import { visibleWaterfallRows, Waterfall } from "ember-ui-sdk/waterfall"
import { icon } from "./icon"

const trace = Array.from({ length: 2000 }, (_, job) => ({
  value: `job-${job + 1}`,
  label: `job ${job + 1}`,
  start: job * 4,
  duration: 60,
  children: Array.from({ length: 4 }, (_, step) => ({
    value: `job-${job + 1}/step-${step + 1}`,
    label: `step ${step + 1}`,
    start: job * 4 + step * 15,
    duration: 15,
  })),
}))

const row = 32
const height = 288
const range: [number, number] = [0, 400]

const topOf = (index: number) => index * row
const rowIndexOf = (index: number) => index + 1

export default class Virtualized extends Component {
  trace = trace
  row = row
  range = range
  @tracked scrollTop = 0
  @tracked expanded = ["job-1"]

  get rows() {
    return visibleWaterfallRows(this.trace, this.expanded)
  }

  get visible() {
    const start = Math.max(0, Math.floor(this.scrollTop / row) - 4)
    const end = Math.min(
      this.rows.length,
      Math.ceil((this.scrollTop + height) / row) + 4
    )
    return this.rows.slice(start, end)
  }

  get totalHeight() {
    return `height: ${this.rows.length * row}px`
  }

  topOf = topOf

  rowIndexOf = rowIndexOf

  get rowCount() {
    return this.rows.length
  }

  onScroll = (event: Event) => {
    this.scrollTop = (event.currentTarget as HTMLElement).scrollTop
  }

  onExpandedChange = (next: string[]) => {
    this.expanded = next
  }

  onHighlight = (_value: string, details: { index: number }) => {
    const el = document.querySelector<HTMLElement>("#virtualized-scroll")
    if (!el) return
    const top = topOf(details.index)
    if (top < el.scrollTop) {
      el.scrollTop = top
    } else if (top + row > el.scrollTop + el.clientHeight) {
      el.scrollTop = top + row - el.clientHeight
    }
    this.scrollTop = el.scrollTop
  }

  <template>
    <div id="virtualized-scroll" data-slot="scroll" {{on "scroll" this.onScroll}}>
      <Waterfall
        aria-label="Build trace"
        aria-rowcount={{this.rowCount}}
        @items={{this.trace}}
        @range={{this.range}}
        @expanded={{this.expanded}}
        @onExpandedChange={{this.onExpandedChange}}
        @onHighlight={{this.onHighlight}}
        style={{this.totalHeight}}
        as |w|
      >
        {{#each this.visible key="@index" as |entry|}}
          <w.Row
            @value={{entry.item.value}}
            aria-rowindex={{this.rowIndexOf entry.index}}
            style="top: {{this.topOf entry.index}}px"
            as |row|
          >
            <row.Header>
              {{#if entry.item.children}}
                <row.Indicator>{{icon ChevronRight}}</row.Indicator>
              {{/if}}
              {{entry.item.label}}
            </row.Header>
            <row.Bar />
          </w.Row>
        {{/each}}
      </Waterfall>
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

Press End to focus job 2000, or Page Down to move a page at a time. The trace has 10,000 spans, but only nearby rows render.

## Controlled

Selection and expanded spans are independent:

| Argument    | Shape                    | Change callback     |
| ----------- | ------------------------ | ------------------- |
| `@value`    | A string or `null`.      | `@onValueChange`    |
| `@expanded` | An array of span values. | `@onExpandedChange` |

Pass `@value` or `@expanded` and update them in their callbacks to control one, or use `@defaultValue` and `@defaultExpanded` for starting state. Call `details.cancel()` in a change callback to reject a change.

## Controller

A `createWaterfallController()` instance can expand or collapse spans, change the selection, or focus a row. `reveal(value)` opens a span's ancestors and focuses its row. The Nested Spans example uses one for Expand All and Collapse All.

## Styling

Style a row's state from its `data-selected`, `data-expanded`, `data-branch` and `data-level`, which its header, indicator, cells and bar carry too. Focus moves between rows and cells, so style a focused one with `:focus-visible`. Indent a row's header with `--waterfall-level`, and place its bar with `--waterfall-start` and `--waterfall-size`.

Each part has a `data-slot`, such as `waterfall-row`, and its state attributes are listed under [Data Attributes](#data-attributes).

### WaterfallTick
- `--waterfall-tick`: Where the tick's time sits on the axis, as a percentage. Use it for `inset-inline-start`.

### WaterfallMark
- `--waterfall-mark`: Where the mark's time sits on the axis, as a percentage. Use it for `inset-inline-start`.

### WaterfallRow
- `--waterfall-level`: The span's depth, from 1 at the top level. Use it to indent the row's header.
- `--waterfall-start`: Where the span starts on the axis, as a percentage, clamped to the range. Use it for the bar's `inset-inline-start`.
- `--waterfall-size`: How much of the axis the span covers, as a percentage. Use it for the bar's width. Zero for a span outside the range.

## Data Attributes

### WaterfallMark
`[data-slot="waterfall-mark"]`

- `data-outside`: Present while the mark's time is outside the range, so it doesn't show on the axis.

### WaterfallRow
`[data-slot="waterfall-row"]`

- `data-level` (`1`, `2`): The span's depth, from 1 at the top level. Also in the `--waterfall-level` variable.
- `data-branch`: Present on a span with children.
- `data-expanded`: Present while a span with children is expanded.
- `data-selected`: Present on the selected span's row and its parts.

### WaterfallRowHeader
`[data-slot="waterfall-row-header"]`

- `data-level` (`1`, `2`): The span's depth, from 1 at the top level. Also in the `--waterfall-level` variable.
- `data-branch`: Present on a span with children.
- `data-expanded`: Present while a span with children is expanded.
- `data-selected`: Present on the selected span's row and its parts.

### WaterfallIndicator
`[data-slot="waterfall-indicator"]`

- `data-level` (`1`): The span's depth, from 1 at the top level. Also in the `--waterfall-level` variable.
- `data-branch`: Present on a span with children.
- `data-expanded`: Present while a span with children is expanded.

### WaterfallCell
`[data-slot="waterfall-cell"]`

- `data-level` (`1`, `2`): The span's depth, from 1 at the top level. Also in the `--waterfall-level` variable.
- `data-branch`: Present on a span with children.
- `data-expanded`: Present while a span with children is expanded.
- `data-selected`: Present on the selected span's row and its parts.

### WaterfallBar
`[data-slot="waterfall-bar"]`

- `data-level` (`1`, `2`): The span's depth, from 1 at the top level. Also in the `--waterfall-level` variable.
- `data-branch`: Present on a span with children.
- `data-expanded`: Present while a span with children is expanded.
- `data-selected`: Present on the selected span's row and its parts.

## API Reference

Pass the root's options as `@` arguments.

### Waterfall

- `items` (`WaterfallData`): The spans, each with a `value`, a `label`, a `start`, a `duration` and the spans it started as `children`.
- `range?` (`[number, number]`): The stretch of time the axis shows, as `[start, end]` in milliseconds. Bars outside it shrink to its edges. Change it to zoom or pan.
- `value?` (`string | null`): The selected span's value. Pass it to control the selection. `null` selects nothing.
- `defaultValue?` (`string | null`): The span selected at first, when uncontrolled.
- `onValueChange?` (`((value: string | null, details: ChangeDetails<WaterfallValueChangeReason>) => void)`): Runs when the selection wants to change. `details.reason` says why, and `details.cancel()` stops it.
- `expanded?` (`string[]`): The expanded spans' values. Pass it to control which spans show their children.
- `defaultExpanded?` (`string[]`): The spans expanded at first, when uncontrolled.
- `onExpandedChange?` (`((expanded: string[], details: ChangeDetails<WaterfallExpandedChangeReason>) => void)`): Runs when spans want to expand or collapse. `details.reason` says why, and `details.cancel()` stops it.
- `onHighlight?` (`((value: string, details: ListHighlightDetails) => void)`): Runs when the keyboard moves focus to a row, with its place among the rows that show, from 0. A waterfall that renders only the rows in view scrolls that row into view here, so it can take focus once it renders.
- `format?` (`NumberFormat`): How times read on the axis and to screen readers: `Intl.NumberFormat` options for a number of milliseconds, or a function of it.
- `locale?` (`string`): The locale times are formatted in. Defaults to the page's `lang`, or the browser's language without one, once the page is interactive. Server markup uses English until then, so it never disagrees with the client.
- `getBarLabel?` (`((item: WaterfallDataItem, details: WaterfallBarLabelDetails) => string)`): What screen readers hear for a span's bar. Set it in the page's language.
- `controller?` (`object`): Drives the waterfall from anywhere. Create one with `createWaterfallController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### WaterfallAxis

- `maxTicks?` (`number`): The most ticks the axis shows. Ticks fall on round times, so it may show fewer.

### WaterfallTick and WaterfallMark

- `time` (`number`): The moment it marks, in milliseconds.

### WaterfallRow

- `value` (`string`): The value of the span the row shows.

### Items as Data

Each span in `@items`:

- `value` (`string`): Identifies the span. Unique in the waterfall.
- `label` (`string`): What its row shows, and what typeahead matches.
- `start` (`number`): When it starts, in milliseconds, on the same clock as every other span.
- `duration` (`number`): How long it lasts, in milliseconds.
- `children?` (`WaterfallDataItem[]`): The spans it started. Leave it out for a span with none.

Each row `visibleWaterfallRows(items, expanded)` returns:

- `item` (`WaterfallDataItem`): The span this row shows, the same object you passed in.
- `parent` (`string | null`): The value of the span it's nested in, or `null` at the top level.
- `level` (`number`): Its depth, 1 at the top level.
- `index` (`number`): Its place among the rows that show, from 0.

### State

What `@render` parts and their blocks receive, per part.

`Waterfall`:

- `range` (`[number, number]`): The stretch of time the axis shows, as `[start, end]` in milliseconds.

`WaterfallAxis`:

- `ticks` (`WaterfallTickData[]`): The ticks it shows, at round times inside the range.

`WaterfallTick` and `WaterfallMark`:

- `time` (`number`): The moment it marks, in milliseconds.
- `label` (`string`): The time as `format` and the locale show it.
- `position` (`number`): Where it sits between the range's start and end, from 0 to 100.
- `outside` (`boolean`): Whether its time is outside the range, so it doesn't show on the axis.

`WaterfallRow`, and its `WaterfallRowHeader`, `WaterfallIndicator`, `WaterfallCell` and `WaterfallBar`:

- `expanded` (`boolean`): Whether it's a span with children that's expanded.
- `selected` (`boolean`): Whether it's the selected span.
- `branch` (`boolean`): Whether its span has children.
- `level` (`number`): Its depth, 1 at the top level.

### Reasons

Why spans expanded or collapsed:

- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

Why the selection changed:

- `imperative` (`none`): A controller or `api` call, or a property set on a web component.
- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.

### Controller

Create one with `createWaterfallController()` and pass it as `@controller`.

- `getValue()` (`() => string | null`): The selected span's value, or `null`.
- `setValue(value, options?)` (`(value: string | null, options?: WaterfallChangeOptions<WaterfallValueChangeReason> | undefined) => boolean`): Selects a span, or nothing with `null`. Returns false when canceled.
- `getExpanded()` (`() => string[]`): The values of the expanded spans.
- `setExpanded(expanded, options?)` (`(expanded: string[], options?: WaterfallChangeOptions<WaterfallExpandedChangeReason> | undefined) => boolean`): Expands exactly these spans. Returns false when canceled.
- `isExpanded(value)` (`(value: string) => boolean`): Whether a span is expanded.
- `expand(value, options?)` (`(value: string, options?: WaterfallChangeOptions<WaterfallExpandedChangeReason> | undefined) => boolean`): Expands a span.
- `collapse(value, options?)` (`(value: string, options?: WaterfallChangeOptions<WaterfallExpandedChangeReason> | undefined) => boolean`): Collapses a span. Focus inside it moves to its row.
- `toggle(value, options?)` (`(value: string, options?: WaterfallChangeOptions<WaterfallExpandedChangeReason> | undefined) => boolean`): Expands a collapsed span, or collapses an expanded one.
- `expandAll(options?)` (`(options?: WaterfallChangeOptions<WaterfallExpandedChangeReason> | undefined) => boolean`): Expands every span with children.
- `collapseAll(options?)` (`(options?: WaterfallChangeOptions<WaterfallExpandedChangeReason> | undefined) => boolean`): Collapses every span.
- `reveal(value)` (`(value: string) => void`): Expands a span's ancestors and focuses its row, through `onHighlight` when it isn't rendered.
- `focus(value?)` (`(value?: string | undefined) => void`): Focuses a span's row, or the row with the tab stop.

## Accessibility

The waterfall follows the [WAI-ARIA treegrid pattern](https://www.w3.org/WAI/ARIA/apg/patterns/treegrid/). Rows have the `row` role with `aria-level`, `aria-posinset`, `aria-setsize`, `aria-selected="true"` on the selected row, and `aria-expanded` on spans with children. `row.Header` is a `rowheader`, so screen readers repeat the span's name as focus moves down a column, and each `row.Bar` is a `gridcell` labeled with when its span starts and how long it lasts, like "Starts at 120 ms, lasts 340 ms". Times are formatted with `Intl` in the page's language.

### Keyboard

The waterfall has one tab stop. Tab enters at the selected row, or the first row, then returns to the row or cell focused last.

| Key                  | Action                                                                                  |
| -------------------- | --------------------------------------------------------------------------------------- |
| Down / Up Arrow      | Focus the next or previous row. In a cell, keep the column.                             |
| Right Arrow          | On a row, expand it, or move into its first cell. In a cell, move right.                |
| Left Arrow           | In a cell, move left, then back to the row. On a row, collapse it, or focus its parent. |
| Home / End           | Focus the first or last row. In a cell, the row's first or last cell.                   |
| Ctrl+Home / Ctrl+End | Focus the first or last row, keeping the column.                                        |
| Page Up / Page Down  | Move a page of rows.                                                                    |
| Enter / Space        | Select the row.                                                                         |
| Typing               | Focus the next row whose label starts with that text.                                   |

Command replaces Ctrl on a Mac. In right-to-left text, Left and Right swap.

### Tested Behavior

Every line below is an automated test.

**Rows**

- Spans start collapsed, and only top-level rows show.
- Clicking the indicator expands a span without selecting it.
- Clicking a row's cell selects the row and focuses the cell.
- A change can be canceled.
- A controller expands and collapses everything, and reveals a span.
- Collapsing a span from its indicator moves focus out of it.

**Keyboard**

- The waterfall is one tab stop.
- Down and Up move between rows, Home and End to the first and last.
- Right expands a collapsed row, then moves into its cells.
- Left moves back through the cells to the row, collapses it, then moves to the parent.
- Down and Up in a cell keep its column.
- Home and End in a cell go to the row's ends, and with Control to the column's.
- A focused cell keeps the tab stop.
- A cell hidden by a collapse gives up the tab stop.
- Enter and Space select the focused row.
- Typing moves to the next row whose name starts with it.

**Time axis**

- Each row places its bar as a share of the range.
- Each bar tells screen readers when its span starts and how long it lasts.
- The axis shows round times, hidden from screen readers.

Runs in React, Vue and web components.
