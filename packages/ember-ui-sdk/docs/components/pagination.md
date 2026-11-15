# Pagination

Navigate pages with buttons, links, or your router.

```glimmer-ts title="basic.gts"
import Component from "@glimmer/component"
import { Pagination } from "ember-ui-sdk/pagination"
import { ChevronLeft, ChevronRight, Ellipsis } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Basic extends Component {
  log = useLog(this)

  isNumber = (item: number | string) => typeof item === "number"

  onPageChange = (page: number, details: { reason: string }) => {
    this.log(`Page ${page} (${details.reason})`)
  }

  <template>
    <Pagination
      aria-label="Pagination"
      @pageCount={{10}}
      @onPageChange={{this.onPageChange}}
      as |p|
    >
      <p.List as |l|>
        <p.Item>
          <p.Previous data-variant="ghost">
            {{icon ChevronLeft}}
            <span data-slot="visually-hidden">Previous</span>
          </p.Previous>
        </p.Item>
        {{#each l.state.items key="@identity" as |item|}}
          <p.Item>
            {{#if (this.isNumber item)}}
              <p.Link data-variant="ghost" @page={{item}} />
            {{else}}
              <p.Ellipsis>{{icon Ellipsis}}</p.Ellipsis>
            {{/if}}
          </p.Item>
        {{/each}}
        <p.Item>
          <p.Next data-variant="ghost">
            <span data-slot="visually-hidden">Next</span>
            {{icon ChevronRight}}
          </p.Next>
        </p.Item>
      </p.List>
    </Pagination>
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

Choose a page, or use Previous and Next. The console logs each page and its reason, and the step at either end stays focusable as a button.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Pagination`:

```text
Pagination as |p|
└── p.List as |l|
    ├── p.Item
    │   └── p.Previous
    ├── p.Item
    │   └── p.Link
    ├── p.Item
    │   └── p.Ellipsis
    ├── p.Item
    │   └── p.Link
    └── p.Item
        └── p.Next
```

Name the navigation with `aria-label`, then put the page links and steps in a list.

The list yields its state, whose `items` contains page numbers and the strings `"ellipsis-start"` and `"ellipsis-end"`. Render a link for each number and an ellipsis for each gap. Key entries by the item itself so a page link keeps its element as the range moves.

`p.Link` shows its page number unless you supply children. The current link gets `aria-current="page"` and `data-current`. `p.Ellipsis` shows “…” and is hidden from screen readers.

Give Previous, Next, First, and Last text or an `aria-label`. At an end, a step gets `aria-disabled="true"` and `data-disabled` and stops changing the page. As a button, it stays in the tab order.

## Usage

Import the root and use the parts it yields:

```gts
import { Pagination } from "ember-ui-sdk/pagination"

<template>
  <Pagination aria-label="Pagination" @pageCount={{10}} as |p|>
    <p.List as |l|>
      <p.Item>
        <p.Previous>Previous</p.Previous>
      </p.Item>
      {{#each l.state.items key="@identity" as |item|}}
        <p.Item>
          {{#if (eq item "ellipsis-start")}}
            <p.Ellipsis />
          {{else if (eq item "ellipsis-end")}}
            <p.Ellipsis />
          {{else}}
            <p.Link @page={{item}} />
          {{/if}}
        </p.Item>
      {{/each}}
      <p.Item>
        <p.Next>Next</p.Next>
      </p.Item>
    </p.List>
  </Pagination>
</template>
```

`ember-ui-sdk/pagination` also exports each part by name, such as `PaginationLink` and `PaginationNext`.

## Total and Page Size

Instead of `@pageCount`, pass `@total`, how many items there are, and `@pageSize`, how many fit on a page (10 by default). Pagination calculates the page count, with a minimum of one. This example resets to page 1 when the page size changes.

A page past the end, like after the count shrinks, reads as the last page.

```glimmer-ts title="total.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Pagination } from "ember-ui-sdk/pagination"
import { ChevronLeft, ChevronRight, Ellipsis } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const total = 95

export default class Total extends Component {
  log = useLog(this)
  @tracked page = 2
  @tracked pageSize = 20

  isNumber = (item: number | string) => typeof item === "number"

  get rangeStart() {
    return (this.page - 1) * this.pageSize + 1
  }

  get rangeEnd() {
    return Math.min(this.page * this.pageSize, total)
  }

  onchange = (event: Event) => {
    const select = event.currentTarget as HTMLSelectElement
    this.pageSize = Number(select.value)
    this.page = 1
    this.log(`${select.value} rows per page`)
  }

  onPageChange = (next: number) => {
    this.page = next
    this.log(`Page ${next}`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="row">
        <p>Showing {{this.rangeStart}}–{{this.rangeEnd}} of {{total}}</p>
        <label data-slot="label">
          Rows per page
          <select value={{this.pageSize}} {{on "change" this.onchange}}>
            <option value="10">10</option>
            <option value="20">20</option>
            <option value="50">50</option>
          </select>
        </label>
      </div>
      <Pagination
        @page={{this.page}}
        @total={{total}}
        @pageSize={{this.pageSize}}
        @onPageChange={{this.onPageChange}}
        aria-label="Pagination"
        as |p|
      >
        <p.List as |l|>
          <p.Item>
            <p.Previous data-variant="ghost">
              {{icon ChevronLeft}}
              <span data-slot="visually-hidden">Previous</span>
            </p.Previous>
          </p.Item>
          {{#each l.state.items key="@identity" as |item|}}
            <p.Item>
              {{#if (this.isNumber item)}}
                <p.Link data-variant="ghost" @page={{item}} />
              {{else}}
                <p.Ellipsis>{{icon Ellipsis}}</p.Ellipsis>
              {{/if}}
            </p.Item>
          {{/each}}
          <p.Item>
            <p.Next data-variant="ghost">
              <span data-slot="visually-hidden">Next</span>
              {{icon ChevronRight}}
            </p.Next>
          </p.Item>
        </p.List>
      </Pagination>
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

Choose a page, then change Rows per page. The console logs each change, and a new size starts again at page 1.

## Links

Pass `@getHref` to map each page to a URL. Page links and steps then render as anchors.

```gts
<Pagination aria-label="Pagination" @pageCount={{10}} @getHref={{this.pageHref}} as |p|>…</Pagination>
```

Server-rendered anchors work before JavaScript loads. A normal click changes the page and follows the URL. Modifier clicks and middle clicks leave pagination state alone so the browser can open the link elsewhere.

A step at its end loses its `href` and leaves the tab order, but keeps focus if it already had it. During navigation, its original `href` stays in place so Next cannot accidentally follow the next page's URL.

## Router Links

Render your router's link to page on the client. Parts render `<a>` elements with `@getHref`, so a router that listens for clicks on links pages on the client as they are. Pass `@render={{true}}` to a part and spread its `part` onto your router's link component. The pagination's click handler runs first: when a change is canceled or a step is at its end, it calls `preventDefault()`, and the router leaves the link alone.

Read the page from the URL, like your router's search params, so the route [controls](#controlled) the pagination.

## Controlled

Pass `@page` and update it in `@onPageChange` for the reason.

```gts
<Pagination @page={{this.page}} @onPageChange={{this.onPage}} aria-label="Pagination" @pageCount={{10}} as |p|>…</Pagination>
```

Every change carries a [reason](#reasons): `item-press` for a page, `previous-press`, `next-press`, `first-press` or `last-press` for a step, and `imperative` from a [controller](#controller). Call `details.cancel()` to keep the page, like while a form has unsaved changes. A canceled change also stops a link from navigating.

## Default Page

`@defaultPage` is the page it starts on, when uncontrolled. It's 1 by default.

```gts
<Pagination aria-label="Pagination" @pageCount={{10}} @defaultPage={{5}} as |p|>…</Pagination>
```

## Siblings

`@siblings` is how many pages show on each side of the current one, 1 by default. Near an end, the window slides over instead of shrinking, keeping the range length stable. A gap of one page shows that page instead of an ellipsis.

```gts
<Pagination aria-label="Pagination" @pageCount={{20}} @defaultPage={{10}} @siblings={{2}} as |p|>…</Pagination>
```

## Boundaries

`@boundaries` is how many pages always show at each end, 1 by default.

```gts
<Pagination aria-label="Pagination" @pageCount={{20}} @defaultPage={{10}} @boundaries={{2}} as |p|>…</Pagination>
```

## Paging from Anywhere

A [controller](#controller), from `createPaginationController()`, pages the pagination from anywhere, like buttons elsewhere on the page or a keyboard shortcut, without controlling it. Pass it as `@controller`. Call `pagination.next()` from any handler to move one page.

## Your Own Markup

`paginationRange({ page, pageCount, siblings, boundaries })` is the range the parts use, as a pure function. It runs anywhere, like on the server, in an email or for a UI that isn't a list of pages. Import it from `@ui-sdk/core/pagination`. It can keep a strip of slide dots the same length however many slides there are.

## Custom Rendering

Pass `@render={{true}}` to any part to render your own element. The part yields `{ part, state }`: bind `part` to the element, and read `state` for whether a link is `current`, and for a step, the `page` it goes to and whether it's `disabled`.

```glimmer-ts title="render.gts"
import Component from "@glimmer/component"
import { concat } from "@ember/helper"
import { Pagination } from "ember-ui-sdk/pagination"
import { ArrowLeft, ArrowRight } from "lucide"
import { icon } from "./icon"

export default class Render extends Component {
  isNumber = (item: number | string) => typeof item === "number"

  <template>
    <Pagination aria-label="Pagination" @pageCount={{10}} as |p|>
      <p.List as |l|>
        <p.Item>
          <p.Previous aria-label="Previous page" @render={{true}} as |step|>
            <button
              {{step.part}}
              title={{if
                step.state.disabled
                undefined
                (concat "Go to page " step.state.page)
              }}
            >
              {{icon ArrowLeft}}
              {{#unless step.state.disabled}}
                <span aria-hidden="true">{{step.state.page}}</span>
              {{/unless}}
            </button>
          </p.Previous>
        </p.Item>
        {{#each l.state.items key="@identity" as |item|}}
          <p.Item>
            {{#if (this.isNumber item)}}
              <p.Link @page={{item}} as |link|>
                {{#if link.state.current}}Page
                  {{link.state.page}}{{else}}{{link.state.page}}{{/if}}
              </p.Link>
            {{else}}
              <p.Ellipsis />
            {{/if}}
          </p.Item>
        {{/each}}
        <p.Item>
          <p.Next aria-label="Next page" @render={{true}} as |step|>
            <button
              {{step.part}}
              title={{if
                step.state.disabled
                undefined
                (concat "Go to page " step.state.page)
              }}
            >
              {{#unless step.state.disabled}}
                <span aria-hidden="true">{{step.state.page}}</span>
              {{/unless}}
              {{icon ArrowRight}}
            </button>
          </p.Next>
        </p.Item>
      </p.List>
    </Pagination>
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

Choose a page. The current page widens to say Page 3, and each arrow shows the page it goes to.

## Styling

Parts are unstyled. Style them through the attributes they render, which are the same in every framework: `aria-current="page"` or `data-current` on the current page's link, and `aria-disabled` or `data-disabled` on a step at its end.

Each part has a `data-slot`, such as `pagination-link`, and its state attributes are listed under [Data Attributes](#data-attributes). The root, list, items and ellipsis have none.

## Data Attributes

### PaginationLink
`[data-slot="pagination-link"]`

- `data-current`: Present on the current page's link, beside `aria-current="page"`.

### PaginationPrevious
`[data-slot="pagination-previous"]`

- `data-disabled`: Present on a step at the end it goes to, beside `aria-disabled`. It stays focusable and does nothing.

### PaginationNext
`[data-slot="pagination-next"]`

- `data-disabled`: Present on a step at the end it goes to, beside `aria-disabled`. It stays focusable and does nothing.

### PaginationFirst
`[data-slot="pagination-first"]`

- `data-disabled`: Present on a step at the end it goes to, beside `aria-disabled`. It stays focusable and does nothing.

### PaginationLast
`[data-slot="pagination-last"]`

- `data-disabled`: Present on a step at the end it goes to, beside `aria-disabled`. It stays focusable and does nothing.

## API Reference

Options and callbacks are the same as below, as arguments, such as `@page` and `@onPageChange`. Every part also takes `@render`.

### Pagination

- `page?` (`number`): The current page, from 1. Pass it to control the pagination.
- `defaultPage?` (`number`): The page it starts on, when uncontrolled.
- `onPageChange?` (`((page: number, details: ChangeDetails<PaginationPageChangeReason>) => void)`): Runs when the page wants to change: a page link (`"item-press"`), the Previous, Next, First or Last part, or a controller (`"imperative"`). `details.cancel()` keeps the page, and stops a link from navigating.
- `pageCount?` (`number`): How many pages there are. Or pass `total` and `pageSize`.
- `total?` (`number`): How many items there are, for `pageCount` from `pageSize`.
- `pageSize?` (`number`): How many items fit on a page, with `total`.
- `siblings?` (`number`): How many pages show on each side of the current one.
- `boundaries?` (`number`): How many pages always show at each end.
- `getHref?` (`((page: number) => string)`): The URL of a page. With it, parts are links: they navigate, open in a new tab with a modifier key, and work before JavaScript loads. Without it, they're buttons.
- `controller?` (`object`): Pages it from anywhere. Create one with `createPaginationController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### PaginationLink

- `page` (`number`): The page the link goes to, from 1.

`PaginationList`, `PaginationItem`, `PaginationPrevious`, `PaginationNext`, `PaginationFirst`, `PaginationLast` and `PaginationEllipsis` take no options of their own.

### State

What `@render={{true}}` yields as `state`, per part.

`Pagination` and `PaginationList`:

- `page` (`number`): The current page, from 1.
- `pageCount` (`number`): How many pages there are.
- `items` (`PaginationRangeItem[]`): The pages to show, with an ellipsis for each gap. Render a PaginationLink or a PaginationEllipsis for each.

`PaginationLink`:

- `page` (`number`): The page it goes to, from its `page` prop.
- `current` (`boolean`): Whether it's the current page.

`PaginationPrevious`, `PaginationNext`, `PaginationFirst` and `PaginationLast`:

- `page` (`number`): The page it goes to.
- `disabled` (`boolean`): Whether it's at the end it goes to, so it does nothing.

### Reasons

`details.reason` says why the page changed.

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `previous-press` (`MouseEvent | KeyboardEvent`): A pagination's or a carousel's Previous part was pressed.
- `next-press` (`MouseEvent | KeyboardEvent`): A pagination's or a carousel's Next part was pressed.
- `first-press` (`MouseEvent | KeyboardEvent`): A pagination's First part was pressed.
- `last-press` (`MouseEvent | KeyboardEvent`): A pagination's Last part was pressed.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createPaginationController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, passed to `@onPageChange`, and returns `false` when the change is canceled or there's nowhere to go.

- `getPage()` (`() => number`): The current page, from 1.
- `getPageCount()` (`() => number`): How many pages there are.
- `setPage(page, options?)` (`(page: number, options?: PaginationChangeOptions | undefined) => boolean`): Goes to a page, clamped to the range. Returns false when canceled or already there.
- `next(options?)` (`(options?: PaginationChangeOptions | undefined) => boolean`): Goes to the next page. Returns false on the last page.
- `previous(options?)` (`(options?: PaginationChangeOptions | undefined) => boolean`): Goes to the previous page. Returns false on the first page.
- `first(options?)` (`(options?: PaginationChangeOptions | undefined) => boolean`): Goes to the first page.
- `last(options?)` (`(options?: PaginationChangeOptions | undefined) => boolean`): Goes to the last page.

### Events

Callbacks get the new page first, then the details.

| Argument        | On           | Receives                                                    |
| --------------- | ------------ | ----------------------------------------------------------- |
| `@onPageChange` | `Pagination` | `(page, details)`: the new page, and the [reason](#reasons) |

## Accessibility

There's no WAI-ARIA pattern for pagination. It follows the common practice: a `navigation` landmark named with `aria-label`, a list of links or buttons, and `aria-current="page"` on the current one. The list keeps the `list` role even when styled without bullets, which Safari would otherwise drop.

### Focus

Steps rendered as buttons stay focusable at the ends. A clicked page link keeps focus as the range moves; the primitive also tries to restore focus to that page or step if rendering replaces its element. Key range entries by their value rather than their index.

### Tested Behavior

Every line below is an automated test.

- The pagination is a named navigation landmark with a list of pages.
- The first page is current to start with, or the default page.
- Pressing a page goes there.
- Enter on a focused page goes there.
- Space on a focused page goes there.
- Next and Previous step one page.
- First and Last go to the ends.
- First and Previous say they're disabled on the first page, and do nothing.
- Next and Last say they're disabled on the last page, and do nothing.
- A single page has nothing to step to.
- Siblings and boundaries widen the range.
- Ellipses are hidden from screen readers.
- With getHref, pages and steps are links to their pages.
- A link at an end has no href and says it's disabled.
- Pressing a link goes to its page and follows it.
- A change can be canceled.
- A canceled change stops a link from navigating.
- The controller pages it from outside.
- A controlled pagination follows its owner. React and Vue only.

Runs in React, Vue and web components.

Beyond the baseline:

- Pressing Next onto the last page keeps focus on Next.
- Pressing Previous onto the first page keeps focus on Previous.
- Paging through every page with the keyboard never loses focus.
- Pressing a page keeps focus on it while the range moves around it.
- Focus comes back to the same part when the list renders again from scratch. React and Vue only.
- The list has the same number of entries on every page, so nothing shifts under the pointer.
- A gap of one page shows that page instead of an ellipsis.
- A link pressed with a modifier opens elsewhere and leaves the page as it is.
- The list keeps its list role when styled without bullets.
- Steps at the ends stay in the tab order and say they're disabled.
- A Next link goes to the next page, not past it, even after the page renders again.
- A Next link onto the last page still goes there, though it ends there.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while paging with a keyboard.

Runs in React, Vue and web components.
