---
title: Pagination
description: Navigate pages with buttons, links, or your router.
---

[pagination/basic](../../examples/components/pagination/ember/basic.gts)

Choose a page, or use Previous and Next. The console logs each page and its reason, and the step at either end stays focusable as a button.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

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

Give Previous, Next, First, and Last text or an `aria-label`. At an end, a step gets `aria-disabled="true"` and `data-disabled` and stops changing the page. As a button, it stays in the tab order. Set `@disabled={{true}}` on the root to do the same for every page and step, like while results load. A controller still changes the page.

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

`ember-ui-sdk/pagination` also exports each part by name, such as `PaginationLink` and `PaginationNext`. They take the root's `@handle`, so use the parts the root yields instead.

## Total and Page Size

Instead of `@pageCount`, pass `@total`, how many items there are, and `@pageSize`, how many fit on a page (10 by default). Pagination calculates the page count, with a minimum of one. This example resets to page 1 when the page size changes.

A page past the end, like after the count shrinks, reads as the last page.

[pagination/total](../../examples/components/pagination/ember/total.gts)

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

Every change carries a [reason](https://ui-sdk.dev/docs/react/components/pagination#reasons): `item-press` for a page, `previous-press`, `next-press`, `first-press` or `last-press` for a step, and `imperative` from a [controller](#controller). Call `details.cancel()` to keep the page, like while a form has unsaved changes. A canceled change also stops a link from navigating.

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

[pagination/render](../../examples/components/pagination/ember/render.gts)

Choose a page. The current page widens to say Page 3, and each arrow shows the page it goes to.

## Styling

Parts are unstyled. Style them through the attributes they render, which are the same in every framework: `aria-current="page"` or `data-current` on the current page's link, and `aria-disabled` or `data-disabled` on a step at its end.

Each part has a `data-slot`, such as `pagination-link`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/pagination#data-attributes). The root, list, items and ellipsis have none.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [pagination reference](https://ui-sdk.dev/docs/react/components/pagination) in the upstream docs.

Options and callbacks are passed as arguments, such as `@page` and `@onPageChange`. Every part also takes `@render`.

### PaginationLink

`PaginationList`, `PaginationItem`, `PaginationPrevious`, `PaginationNext`, `PaginationFirst`, `PaginationLast` and `PaginationEllipsis` take no options of their own.

### Controller

Create one with `createPaginationController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, passed to `@onPageChange`, and returns `false` when the change is canceled or there's nowhere to go.

### Events

Callbacks get the new page first, then the details.

| Argument        | On           | Receives                                                                                                       |
| --------------- | ------------ | -------------------------------------------------------------------------------------------------------------- |
| `@onPageChange` | `Pagination` | `(page, details)`: the new page, and the [reason](https://ui-sdk.dev/docs/react/components/pagination#reasons) |

## Accessibility

There's no WAI-ARIA pattern for pagination. It follows the common practice: a `navigation` landmark named with `aria-label`, a list of links or buttons, and `aria-current="page"` on the current one. The list keeps the `list` role even when styled without bullets, which Safari would otherwise drop.

### Focus

Steps rendered as buttons stay focusable at the ends. A clicked page link keeps focus as the range moves; the primitive also tries to restore focus to that page or step if rendering replaces its element. Key range entries by their value rather than their index.
