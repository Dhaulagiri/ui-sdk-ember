---
title: Waterfall
description: Show a trace or a page's requests as bars on a shared time axis, with spans that expand to show what they started.
---

Use a Waterfall for anything with a start and a duration that nests: a browser's network requests, an OpenTelemetry trace, the steps of a build. Each span is a row with its own bar, placed on one time axis, and screen reader and keyboard users get a treegrid they can walk span by span.

[waterfall/network](../../examples/components/waterfall/ember/network.gts)

Use the arrow keys to move between requests. Press Right to move into a row's cells, where each bar reads out when its request starts and how long it takes.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

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

[waterfall/trace](../../examples/components/waterfall/ember/trace.gts)

Expand payments.charge with Right, then press Enter on gateway.capture. The console logs the selected span. Collapse All closes every span.

## Zoom

`@range` sets the stretch of time the axis shows, as `[start, end]`. Change it to zoom or pan: the bars and ticks follow, and a bar outside the range shrinks to its edge. Without it, the axis runs from the earliest start to the latest end.

[waterfall/zoom](../../examples/components/waterfall/ember/zoom.gts)

Press Zoom In twice. The axis shows smaller steps, and the metrics span stretches past the edges.

## Large Traces

A trace can have thousands of spans. Render only the rows in view: flatten the open spans with `visibleWaterfallRows`, and render the nearby rows at their offsets. The waterfall still reports every row's level and place among its siblings, so screen readers hear the whole hierarchy. Give the waterfall `aria-rowcount` with the number of rows that show, and each row `aria-rowindex` with its index plus one, so a screen reader counts rows in the whole trace, not just the ones in the page.

`@onHighlight` reports the index of the row the keyboard moves to. Scroll it into view there, so a row that isn't rendered yet takes focus once it is. An arrow key changes only the two rows it moves between, however long the trace is.

[waterfall/virtualized](../../examples/components/waterfall/ember/virtualized.gts)

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

Each part has a `data-slot`, such as `waterfall-row`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/waterfall#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [waterfall reference](https://ui-sdk.dev/docs/react/components/waterfall) in the upstream docs.

Pass the root's options as `@` arguments.

### Controller

Create one with `createWaterfallController()` and pass it as `@controller`.

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
