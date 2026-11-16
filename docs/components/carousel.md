---
title: Carousel
description: Page through slides with native scrolling, keyboard controls, and optional rotation.
---

Use a Carousel to show a set of slides one view at a time, like product photos or featured stories. It scrolls natively, so swipes and trackpads work, and Previous and Next buttons page through the slides.

[carousel/basic](../../examples/components/carousel/ember/basic.gts)

Use Previous and Next, swipe the slides, or focus the viewport and use the arrow keys.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Carousel`:

```text
Carousel as |c|
├── c.Viewport
│   └── c.Content
│       ├── c.Item
│       └── c.Item
├── c.Previous
└── c.Next
```

Put the slides inside a viewport, then add the controls you need.

The viewport is the scrolling window, and the content is the row of slides inside it, a flex row (a column when vertical). Name the carousel with `aria-label`, like "Featured products", and give Previous, Next, the indicators and the play toggle text, or an `aria-label` when they hold an icon.

## Usage

Import the root and use the parts it yields:

```gts
import { Carousel } from "ember-ui-sdk/carousel"

<template>
  <Carousel aria-label="Featured" as |c|>
    <c.Viewport>
      <c.Content>
        <c.Item>First slide</c.Item>
        <c.Item>Second slide</c.Item>
      </c.Content>
    </c.Viewport>
    <c.Previous>Previous</c.Previous>
    <c.Next>Next</c.Next>
  </Carousel>
</template>
```

## Vertical

`@orientation="vertical"` scrolls up and down. Give the viewport a height. Up and down arrows page it, not left and right.

[carousel/vertical](../../examples/components/carousel/ember/vertical.gts)

Scroll vertically, or use the up and down controls.

## Loop

`@loop={{true}}` makes the slides go round. Next on the last page goes to the first, which comes in after the last, and a swipe, a drag or a wheel back from the first page reaches the last, with native scrolling all the way. Rotation always wraps.

The slides take turns at the ends of the content with CSS `order` while the carousel rests, so the current page always has slides on both sides. They keep their place in the document, so screen readers and Tab follow the slides' own order. The content needs to lay its slides out in a row with even gaps, as flex and grid do, and hold a page of slides to either side of the current one. With fewer, like two slides one to a view, Next on the last page scrolls back to the first instead.

[carousel/loop](../../examples/components/carousel/ember/loop.gts)

Keep moving forward or backward to wrap around the slides.

## Align

`@align` lines pages up at the viewport's `"start"` (the default), `"center"` or `"end"`. Centered slides narrower than the viewport let their neighbors peek in. The first and last pages stay at the ends of the content, so there's no empty space before the first slide.

[carousel/align](../../examples/components/carousel/ember/align.gts)

Choose Start, Center or End, then page through the slides. Centered slides let their neighbors peek in on both sides.

## Default Page

`@defaultPage` is the page it starts on, when uncontrolled. It's 1 by default.

[carousel/default-page](../../examples/components/carousel/ember/default-page.gts)

Start on the chosen page, then move forward or backward.

## Indicators

Indicators are a tablist: one Tab stop on the current page, arrows to move between them and show their page, Home and End for the ends. Each controls the slides of its page.

Write one per page inside `c.IndicatorGroup`. Those past the page count hide themselves, so the same markup works however many slides fit.

[carousel/indicators](../../examples/components/carousel/ember/indicators.gts)

Choose a named indicator, then use arrows, Home, and End to move between them.

## Pages

`@slidesPerPage` is how many slides a page holds: Next moves that many, and each indicator stands for that many. `"auto"` fits as many as show. Pages that can't reach the start, like the last few slides, merge into the last page. With three slides in view, five slides make three pages at one slide per page, or two pages at three per page.

[carousel/pages](../../examples/components/carousel/ember/pages.gts)

Move through groups of slides using the page controls.

## Thumbnails

A gallery and a strip of thumbnails share the selected page. The thumbnail carousel scrolls freely with `@dragFree={{true}}` and fits as many as show. Pressing a thumbnail selects its slide.

[carousel/thumbnails](../../examples/components/carousel/ember/thumbnails.gts)

Choose a thumbnail to change the gallery, or scroll either strip.

## Autoplay

`@defaultPlaying={{true}}` starts rotating, every `@interval` milliseconds (5000 by default). `c.PlayToggle` starts and stops it; label it from `playing` in its state.

As the carousel pattern asks, rotation stops when keyboard focus moves in and doesn't restart until the user asks, and pauses while the mouse is over it. It also pauses while the tab is hidden, while the carousel is scrolled out of view and while a finger is down. Changing slides yourself stops it. The slides are a polite live region only while it isn't rotating, so screen readers aren't interrupted every few seconds. It doesn't start on its own when the user prefers reduced motion.

`--carousel-interval` on the root is the interval, and `data-paused` is there while it's paused, so a progress bar can time itself with CSS.

[carousel/autoplay](../../examples/components/carousel/ember/autoplay.gts)

Start or stop rotation. Hover to pause it, or move keyboard focus inside to stop it. The console logs each change and why.

## Progress

`--carousel-progress` on the root says how far the slides have scrolled, from 0 at the first page to 1 at the last, on every frame of a scroll or a spring, with no re-renders, so a progress bar can follow it in CSS. With `@loop`, it goes round from 0 to 1 and back to 0. The controller's `getProgress()` reads the same number.

`@onPageChangeComplete` runs once the slides come to rest on a page, after a spring, a drag or a scroll. Start work there that would stutter the motion, like loading the next slides' images.

[carousel/progress](../../examples/components/carousel/ember/progress.gts)

Move through the slides. The progress bar follows the scroll position, and the console logs the slide it rests on.

## Controlled

Pass `@page` and update it in `@onPageChange`, which also receives the reason. Pages count from 1. `@page` without a change handler is a starting value the carousel may change until you pass a new one.

Every change carries a [reason](https://ui-sdk.dev/docs/react/components/carousel#reasons): `next-press` and `previous-press` for the parts, `item-press` for an indicator, `list-navigation` for arrow keys, `swipe` for a finger or a mouse drag, `scroll` for a wheel or trackpad, `timeout` for rotation and `imperative` from a controller. Call `details.cancel()` to stay on the page: a swipe or drag springs back. A controlled page that doesn't change scrolls back too.

[carousel/controlled](../../examples/components/carousel/ember/controlled.gts)

Change the page. The console logs each page and the reason for the change.

## Paging from Anywhere

A controller, from `createCarouselController()`, pages the carousel from anywhere. Pass it as `@controller` to the carousel, and to `c.Previous`, `c.Next`, `c.IndicatorGroup` or `c.PlayToggle` placed outside it, like in a section header.

`@drag={{false}}` turns off swiping and dragging, so only the parts, keys and controllers move it.

[carousel/controller](../../examples/components/carousel/ember/controller.gts)

Use the controls outside the carousel to change its page.

## Swipes and Drags

Touch, trackpads and wheels scroll the viewport natively, with CSS scroll snap doing the paging. Native scrolling and snapping also work before JavaScript loads. A mouse or pen drags the slides too: they follow the pointer, stretch past the ends, and spring from the release velocity to the page a fling would reach. A drag that moved never clicks the link it started on, and fields inside slides keep their pointer.

Without `@skipSnaps`, one swipe moves at most one page. `@dragFree` lets swipes coast to wherever they stop, and the nearest page becomes the current one.

Buttons, keys, indicators, rotation, and controllers animate the scroll position. A second press updates the destination while it is moving. Reduced motion makes those changes immediate.

## Custom Rendering

Pass `@render={{true}}` to a part to render your own element, and bind its yielded `part` to it. A part's block receives its state too: a slide's `index`, `active` and `inView`, a step's `disabled`, an indicator's `page` and `selected`, the play toggle's `playing` and `paused`.

[carousel/render](../../examples/components/carousel/ember/render.gts)

Change slides to see each slide and control describe its current state.

## Styling

Use `data-disabled` on Previous and Next at their end, `data-selected` on the current indicator, `data-active` on the current page's slides, `data-in-view` on slides in view, and `data-playing` and `data-paused` on the root.

Slides size themselves: give them a `flex-basis` of 100% for one to a view or a third for three, and put the gap on the content, taking it out of each basis. The viewport writes the few styles scrolling needs inline: its overflow, `scroll-snap-type` and `overscroll-behavior`. Slides get `flex-shrink: 0` and their snap alignment. Hide the scrollbar with `scrollbar-width: none` if you like.

Each part has a `data-slot`, such as `carousel-item`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/carousel#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [carousel reference](https://ui-sdk.dev/docs/react/components/carousel) in the upstream docs.

Pass the root's options as `@` arguments. `@page` and `@playing` are controlled with `@onPageChange` and `@onPlayingChange`.

### CarouselViewport

The scrolling area. Renders a `div` that scrolls and snaps natively, and takes focus for the arrow keys.

### CarouselContent

Holds the slides. Renders a `div` that announces slides coming into view, except while rotating.

### CarouselItem

One slide. Renders a `div` with the group role, named by its position, like "2 of 5".

### CarouselNext

Shows the next page. Takes the same arguments as `CarouselPrevious`.

### CarouselIndicatorGroup

Groups the indicators. Renders a `div` with the tablist role. Takes the same arguments as `CarouselPrevious`.

### CarouselPlayToggle

Starts and stops rotation. Renders a `button`. Takes the same arguments as `CarouselPrevious`.

### Controller

Create one with `createCarouselController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, passed to the change callback, and returns `false` when the change is canceled or there's nowhere to go.

### Events

Callbacks get the new value first, then the details. A controlled `@page` or `@playing` only updates when its change callback wasn't canceled.

| Argument                | On         | Receives                                                                                                     |
| ----------------------- | ---------- | ------------------------------------------------------------------------------------------------------------ |
| `@onPageChange`         | `Carousel` | `(page, details)`: the new page, and the [reason](https://ui-sdk.dev/docs/react/components/carousel#reasons) |
| `@onPageChangeComplete` | `Carousel` | `(page)`: the page the slides came to rest on                                                                |
| `@onPlayingChange`      | `Carousel` | `(playing, details)`: whether it rotates, and the reason                                                     |

## Accessibility

It follows the [WAI-ARIA carousel pattern](https://www.w3.org/WAI/ARIA/apg/patterns/carousel/): a region described as a carousel, slides as groups described as slides and labelled by position, Previous and Next that control the slides, a rotation control, and indicators as a tablist. Every line below is an automated test.

Each slide is labelled by its position, like "1 of 5", unless it has an `aria-label` of its own, which is also how you translate it. Slides less than half in view are `inert` and hidden from screen readers, so Tab and the virtual cursor only reach what shows.

### Keyboard

Arrow keys follow the orientation, and swap left and right in right-to-left text.

| Key                                       | Does                                                                                                    |
| ----------------------------------------- | ------------------------------------------------------------------------------------------------------- |
| Tab                                       | Reaches the play toggle, links and controls in slides in view, Previous, Next and the current indicator |
| ArrowRight, ArrowLeft                     | In the viewport, the next and previous page. ArrowDown and ArrowUp when vertical                        |
| Home, End                                 | In the viewport or the indicators, the first and last page                                              |
| ArrowRight, ArrowLeft, ArrowDown, ArrowUp | In the indicators, the next and previous indicator, which shows its page                                |
| Enter, Space                              | Presses Previous, Next, an indicator or the play toggle                                                 |

Fields and widgets inside slides keep their arrow keys: a text field's caret moves, and the carousel stays put. When arrow keys page away from a slide that has focus, focus moves to the slide that comes in, so it never stays on something out of view. Previous and Next stay focusable at the ends, with `aria-disabled`, so focus never drops to the page when Next reaches the last slide.
