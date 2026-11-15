# Carousel

Page through slides with native scrolling, keyboard controls, and optional rotation.

Use a Carousel to show a set of slides one view at a time, like product photos or featured stories. It scrolls natively, so swipes and trackpads work, and Previous and Next buttons page through the slides.

```glimmer-ts title="basic.gts"
import { Carousel } from "ember-ui-sdk/carousel"
import { ChevronLeft, ChevronRight } from "lucide"
import { icon } from "./icon"

const slides = [1, 2, 3, 4, 5]

<template>
  <Carousel aria-label="Featured" as |c|>
    <div data-slot="row">
      <c.Previous aria-label="Previous slide">{{icon ChevronLeft}}</c.Previous>
      <c.Viewport>
        <c.Content>
          {{#each slides key="@identity" as |slide|}}
            <c.Item>
              <div data-slot="tile">{{slide}}</div>
            </c.Item>
          {{/each}}
        </c.Content>
      </c.Viewport>
      <c.Next aria-label="Next slide">{{icon ChevronRight}}</c.Next>
    </div>
  </Carousel>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Use Previous and Next, swipe the slides, or focus the viewport and use the arrow keys.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

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

```glimmer-ts title="vertical.gts"
import { Carousel } from "ember-ui-sdk/carousel"
import { ChevronDown, ChevronUp } from "lucide"
import { icon } from "./icon"

const slides = [1, 2, 3, 4, 5]

<template>
  <Carousel aria-label="Featured" @orientation="vertical" as |c|>
    <div data-slot="row">
      <c.Previous aria-label="Previous slide">{{icon ChevronUp}}</c.Previous>
      <c.Viewport>
        <c.Content>
          {{#each slides key="@identity" as |slide|}}
            <c.Item>
              <div data-slot="tile">{{slide}}</div>
            </c.Item>
          {{/each}}
        </c.Content>
      </c.Viewport>
      <c.Next aria-label="Next slide">{{icon ChevronDown}}</c.Next>
    </div>
  </Carousel>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Scroll vertically, or use the up and down controls.

## Loop

`@loop={{true}}` makes the slides go round. Next on the last page goes to the first, which comes in after the last, and a swipe, a drag or a wheel back from the first page reaches the last, with native scrolling all the way. Rotation always wraps.

The slides take turns at the ends of the content with CSS `order` while the carousel rests, so the current page always has slides on both sides. They keep their place in the document, so screen readers and Tab follow the slides' own order. The content needs to lay its slides out in a row with even gaps, as flex and grid do, and hold a page of slides to either side of the current one. With fewer, like two slides one to a view, Next on the last page scrolls back to the first instead.

```glimmer-ts title="loop.gts"
import { Carousel } from "ember-ui-sdk/carousel"
import { ChevronLeft, ChevronRight } from "lucide"
import { icon } from "./icon"

const slides = [1, 2, 3, 4, 5]

<template>
  <Carousel aria-label="Featured" @loop={{true}} as |c|>
    <div data-slot="row">
      <c.Previous aria-label="Previous slide">{{icon ChevronLeft}}</c.Previous>
      <c.Viewport>
        <c.Content>
          {{#each slides key="@identity" as |slide|}}
            <c.Item>
              <div data-slot="tile">{{slide}}</div>
            </c.Item>
          {{/each}}
        </c.Content>
      </c.Viewport>
      <c.Next aria-label="Next slide">{{icon ChevronRight}}</c.Next>
    </div>
  </Carousel>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Keep moving forward or backward to wrap around the slides.

## Align

`@align` lines pages up at the viewport's `"start"` (the default), `"center"` or `"end"`. Centered slides narrower than the viewport let their neighbors peek in. The first and last pages stay at the ends of the content, so there's no empty space before the first slide.

```glimmer-ts title="align.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown, ChevronLeft, ChevronRight } from "lucide"
import { Select } from "ember-ui-sdk/select"
import { Carousel } from "ember-ui-sdk/carousel"
import { icon } from "./icon"

const photos = [
  { name: "Dunes" },
  { name: "Forest" },
  { name: "Glacier" },
  { name: "Canyon" },
  { name: "Meadow" },
  { name: "Harbor" },
]

const alignments = [
  { value: "start", label: "Start" },
  { value: "center", label: "Center" },
  { value: "end", label: "End" },
]

export default class Align extends Component {
  photos = photos
  alignments = alignments
  @tracked align: "start" | "center" | "end" = "center"

  onAlignChange = (next: string | null) => {
    if (next) this.align = next as "start" | "center" | "end"
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select @items={{this.alignments}} @value={{this.align}} @onValueChange={{this.onAlignChange}} as |s|>
          <s.Label>Align</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.alignments key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <Carousel aria-label="Photos" @align={{this.align}} @defaultPage={{2}} as |c|>
        <div data-slot="row">
          <c.Previous aria-label="Previous slide">{{icon
              ChevronLeft
            }}</c.Previous>
          <c.Viewport>
            <c.Content>
              {{#each this.photos key="name" as |photo|}}
                <c.Item>
                  <div data-slot="tile">{{photo.name}}</div>
                </c.Item>
              {{/each}}
            </c.Content>
          </c.Viewport>
          <c.Next aria-label="Next slide">{{icon ChevronRight}}</c.Next>
        </div>
      </Carousel>
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

Choose Start, Center or End, then page through the slides. Centered slides let their neighbors peek in on both sides.

## Default Page

`@defaultPage` is the page it starts on, when uncontrolled. It's 1 by default.

```glimmer-ts title="default-page.gts"
import { Carousel } from "ember-ui-sdk/carousel"
import { ChevronLeft, ChevronRight } from "lucide"
import { icon } from "./icon"

const slides = [1, 2, 3, 4, 5]

<template>
  <Carousel aria-label="Featured" @defaultPage={{3}} as |c|>
    <div data-slot="row">
      <c.Previous aria-label="Previous slide">{{icon ChevronLeft}}</c.Previous>
      <c.Viewport>
        <c.Content>
          {{#each slides key="@identity" as |slide|}}
            <c.Item>
              <div data-slot="tile">{{slide}}</div>
            </c.Item>
          {{/each}}
        </c.Content>
      </c.Viewport>
      <c.Next aria-label="Next slide">{{icon ChevronRight}}</c.Next>
    </div>
  </Carousel>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Start on the chosen page, then move forward or backward.

## Indicators

Indicators are a tablist: one Tab stop on the current page, arrows to move between them and show their page, Home and End for the ends. Each controls the slides of its page.

Write one per page inside `c.IndicatorGroup`. Those past the page count hide themselves, so the same markup works however many slides fit.

```glimmer-ts title="indicators.gts"
import Component from "@glimmer/component"
import { Carousel } from "ember-ui-sdk/carousel"

const photos = [
  { name: "Dunes" },
  { name: "Forest" },
  { name: "Glacier" },
  { name: "Canyon" },
  { name: "Meadow" },
  { name: "Harbor" },
]

export default class Indicators extends Component {
  photos = photos

  pageOf = (index: number) => index + 1

  <template>
    <Carousel aria-label="Photos" as |c|>
      <c.Viewport>
        <c.Content>
          {{#each this.photos key="name" as |photo|}}
            <c.Item>
              <div data-slot="tile">
                {{photo.name}}
              </div>
            </c.Item>
          {{/each}}
        </c.Content>
      </c.Viewport>
      <c.IndicatorGroup aria-label="Choose a photo" as |g|>
        {{#each this.photos key="name" as |photo index|}}
          <g.Indicator @page={{this.pageOf index}} aria-label={{photo.name}} />
        {{/each}}
      </c.IndicatorGroup>
    </Carousel>
  </template>
}
```

Choose a named indicator, then use arrows, Home, and End to move between them.

## Pages

`@slidesPerPage` is how many slides a page holds: Next moves that many, and each indicator stands for that many. `"auto"` fits as many as show. Pages that can't reach the start, like the last few slides, merge into the last page. With three slides in view, five slides make three pages at one slide per page, or two pages at three per page.

```glimmer-ts title="pages.gts"
import { ChevronLeft, ChevronRight } from "lucide"
import { Carousel } from "ember-ui-sdk/carousel"
import { icon } from "./icon"

const products = [1, 2, 3, 4, 5, 6, 7, 8]

const pagesOf = (count?: number) =>
  Array.from({ length: count ?? 3 }, (_, index) => index + 1)

<template>
  <Carousel aria-label="Products" @slidesPerPage={{3}} as |c|>
    <div data-slot="row">
      <c.Previous aria-label="Previous page">{{icon ChevronLeft}}</c.Previous>
      <c.Viewport>
        <c.Content>
          {{#each products key="@identity" as |product|}}
            <c.Item>
              <div data-slot="tile">{{product}}</div>
            </c.Item>
          {{/each}}
        </c.Content>
      </c.Viewport>
      <c.Next aria-label="Next page">{{icon ChevronRight}}</c.Next>
    </div>
    <div data-slot="row">
      <c.IndicatorGroup aria-label="Choose a page" as |g|>
        {{#each (pagesOf g.state.pageCount) key="@identity" as |n|}}
          <g.Indicator @page={{n}} aria-label="Page {{n}}" />
        {{/each}}
      </c.IndicatorGroup>
    </div>
  </Carousel>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Move through groups of slides using the page controls.

## Thumbnails

A gallery and a strip of thumbnails share the selected page. The thumbnail carousel scrolls freely with `@dragFree={{true}}` and fits as many as show. Pressing a thumbnail selects its slide.

```glimmer-ts title="thumbnails.gts"
import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Carousel } from "ember-ui-sdk/carousel"

const photos = [
  { name: "Dunes" },
  { name: "Forest" },
  { name: "Glacier" },
  { name: "Canyon" },
  { name: "Meadow" },
  { name: "Harbor" },
]

export default class Thumbnails extends Component {
  photos = photos
  @tracked page = 1

  onPageChange = (next: number) => {
    this.page = next
    const block = document.querySelector("#thumbnails-block")
    block
      ?.querySelectorAll("button")
      [next - 1]?.scrollIntoView({ block: "nearest", inline: "nearest" })
  }

  choose = (index: number) => {
    this.page = index + 1
  }

  isActive = (index: number) => String(this.page === index + 1)

  <template>
    <div id="thumbnails-block" data-slot="stack">
      <Carousel aria-label="Photos" @page={{this.page}} @onPageChange={{this.onPageChange}} as |c|>
        <c.Viewport>
          <c.Content>
            {{#each this.photos key="name" as |photo|}}
              <c.Item>
                <div data-slot="tile">
                  {{photo.name}}
                </div>
              </c.Item>
            {{/each}}
          </c.Content>
        </c.Viewport>
      </Carousel>
      <Carousel aria-label="Thumbnails" @dragFree={{true}} @slidesPerPage="auto" as |c|>
        <c.Viewport>
          <c.Content>
            {{#each this.photos key="name" as |photo index|}}
              <c.Item aria-label={{photo.name}}>
                <button
                  type="button"
                  aria-pressed={{this.isActive index}}
                  {{on "click" (fn this.choose index)}}
                >
                  {{photo.name}}
                </button>
              </c.Item>
            {{/each}}
          </c.Content>
        </c.Viewport>
      </Carousel>
    </div>
  </template>
}
```

Choose a thumbnail to change the gallery, or scroll either strip.

## Autoplay

`@defaultPlaying={{true}}` starts rotating, every `@interval` milliseconds (5000 by default). `c.PlayToggle` starts and stops it; label it from `playing` in its state.

As the carousel pattern asks, rotation stops when keyboard focus moves in and doesn't restart until the user asks, and pauses while the mouse is over it. It also pauses while the tab is hidden, while the carousel is scrolled out of view and while a finger is down. Changing slides yourself stops it. The slides are a polite live region only while it isn't rotating, so screen readers aren't interrupted every few seconds. It doesn't start on its own when the user prefers reduced motion.

`--carousel-interval` on the root is the interval, and `data-paused` is there while it's paused, so a progress bar can time itself with CSS.

```glimmer-ts title="autoplay.gts"
import Component from "@glimmer/component"
import { ChevronLeft, ChevronRight } from "lucide"
import { Carousel } from "ember-ui-sdk/carousel"
import { icon } from "./icon"
import { useLog } from "./log"

const photos = [
  { name: "Dunes" },
  { name: "Forest" },
  { name: "Glacier" },
  { name: "Canyon" },
  { name: "Meadow" },
  { name: "Harbor" },
]

export default class Autoplay extends Component {
  log = useLog(this)
  photos = photos

  onPlayingChange = (playing: boolean, details: { reason: string }) => {
    this.log(`${playing ? "Playing" : "Stopped"} (${details.reason})`)
  }

  <template>
    <Carousel
      aria-label="Photos"
      @defaultPlaying={{true}}
      @interval={{4000}}
      @onPlayingChange={{this.onPlayingChange}}
      as |c|
    >
      <div data-slot="controls">
        <c.PlayToggle as |t|>{{if
            t.state.playing
            "Pause"
            "Play"
          }}</c.PlayToggle>
      </div>
      <div data-slot="row">
        <c.Previous aria-label="Previous slide">{{icon
            ChevronLeft
          }}</c.Previous>
        <c.Viewport>
          <c.Content>
            {{#each this.photos key="name" as |photo|}}
              <c.Item>
                <div data-slot="tile">{{photo.name}}</div>
              </c.Item>
            {{/each}}
          </c.Content>
        </c.Viewport>
        <c.Next aria-label="Next slide">{{icon ChevronRight}}</c.Next>
      </div>
    </Carousel>
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

Start or stop rotation. Hover to pause it, or move keyboard focus inside to stop it. The console logs each change and why.

## Progress

`--carousel-progress` on the root says how far the slides have scrolled, from 0 at the first page to 1 at the last, on every frame of a scroll or a spring, with no re-renders, so a progress bar can follow it in CSS. With `@loop`, it goes round from 0 to 1 and back to 0. The controller's `getProgress()` reads the same number.

`@onPageChangeComplete` runs once the slides come to rest on a page, after a spring, a drag or a scroll. Start work there that would stutter the motion, like loading the next slides' images.

```glimmer-ts title="progress.gts"
import Component from "@glimmer/component"
import { ChevronLeft, ChevronRight } from "lucide"
import { Carousel } from "ember-ui-sdk/carousel"
import { icon } from "./icon"
import { useLog } from "./log"

const slides = [1, 2, 3, 4, 5]

export default class Progress extends Component {
  log = useLog(this)
  slides = slides

  onPageChangeComplete = (page: number) => {
    this.log(`Rested on slide ${page}`)
  }

  <template>
    <Carousel aria-label="Featured" @onPageChangeComplete={{this.onPageChangeComplete}} as |c|>
      <div data-slot="row">
        <c.Previous aria-label="Previous slide">{{icon
            ChevronLeft
          }}</c.Previous>
        <c.Viewport>
          <c.Content>
            {{#each this.slides key="@identity" as |slide|}}
              <c.Item>
                <div data-slot="tile">{{slide}}</div>
              </c.Item>
            {{/each}}
          </c.Content>
        </c.Viewport>
        <c.Next aria-label="Next slide">{{icon ChevronRight}}</c.Next>
      </div>
      <div data-slot="row">
        <div data-slot="bar">
          <div></div>
        </div>
      </div>
    </Carousel>
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

Move through the slides. The progress bar follows the scroll position, and the console logs the slide it rests on.

## Controlled

Pass `@page` and update it in `@onPageChange`, which also receives the reason. Pages count from 1. `@page` without a change handler is a starting value the carousel may change until you pass a new one.

Every change carries a [reason](#reasons): `next-press` and `previous-press` for the parts, `item-press` for an indicator, `list-navigation` for arrow keys, `swipe` for a finger or a mouse drag, `scroll` for a wheel or trackpad, `timeout` for rotation and `imperative` from a controller. Call `details.cancel()` to stay on the page: a swipe or drag springs back. A controlled page that doesn't change scrolls back too.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronLeft, ChevronRight } from "lucide"
import { Carousel } from "ember-ui-sdk/carousel"
import { icon } from "./icon"
import { useLog } from "./log"

const slides = [1, 2, 3, 4, 5]

export default class Controlled extends Component {
  log = useLog(this)
  slides = slides
  @tracked page = 1

  onPageChange = (next: number, details: { reason: string }) => {
    this.page = next
    this.log(`Page ${next} (${details.reason})`)
  }

  <template>
    <Carousel aria-label="Featured" @page={{this.page}} @onPageChange={{this.onPageChange}} as |c|>
      <div data-slot="row">
        <c.Previous aria-label="Previous slide">{{icon
            ChevronLeft
          }}</c.Previous>
        <c.Viewport>
          <c.Content>
            {{#each this.slides key="@identity" as |slide|}}
              <c.Item>
                <div data-slot="tile">{{slide}}</div>
              </c.Item>
            {{/each}}
          </c.Content>
        </c.Viewport>
        <c.Next aria-label="Next slide">{{icon ChevronRight}}</c.Next>
      </div>
    </Carousel>
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

Change the page. The console logs each page and the reason for the change.

## Paging from Anywhere

A controller, from `createCarouselController()`, pages the carousel from anywhere. Pass it as `@controller` to the carousel, and to `c.Previous`, `c.Next`, `c.IndicatorGroup` or `c.PlayToggle` placed outside it, like in a section header.

`@drag={{false}}` turns off swiping and dragging, so only the parts, keys and controllers move it.

```glimmer-ts title="controller.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { ChevronLeft, ChevronRight } from "lucide"
import {
  Carousel,
  CarouselNext,
  CarouselPrevious,
  createCarouselController,
} from "ember-ui-sdk/carousel"
import { icon } from "./icon"

const slides = [1, 2, 3, 4, 5]

export default class ControllerExample extends Component {
  slides = slides
  carousel = createCarouselController()

  showLast = () => {
    this.carousel.setPage(5)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <CarouselPrevious
          @controller={{this.carousel}}
          aria-label="Previous slide"
        >{{icon ChevronLeft}}</CarouselPrevious>
        <CarouselNext
          @controller={{this.carousel}}
          aria-label="Next slide"
        >{{icon ChevronRight}}</CarouselNext>
        <button type="button" {{on "click" this.showLast}}>Show the Last Slide</button>
      </div>
      <Carousel aria-label="Featured" @controller={{this.carousel}} @drag={{false}} as |c|>
        <c.Viewport>
          <c.Content>
            {{#each this.slides key="@identity" as |slide|}}
              <c.Item>
                <div data-slot="tile">{{slide}}</div>
              </c.Item>
            {{/each}}
          </c.Content>
        </c.Viewport>
      </Carousel>
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

Use the controls outside the carousel to change its page.

## Swipes and Drags

Touch, trackpads and wheels scroll the viewport natively, with CSS scroll snap doing the paging. Native scrolling and snapping also work before JavaScript loads. A mouse or pen drags the slides too: they follow the pointer, stretch past the ends, and spring from the release velocity to the page a fling would reach. A drag that moved never clicks the link it started on, and fields inside slides keep their pointer.

Without `@skipSnaps`, one swipe moves at most one page. `@dragFree` lets swipes coast to wherever they stop, and the nearest page becomes the current one.

Buttons, keys, indicators, rotation, and controllers animate the scroll position. A second press updates the destination while it is moving. Reduced motion makes those changes immediate.

## Custom Rendering

Pass `@render={{true}}` to a part to render your own element, and bind its yielded `part` to it. A part's block receives its state too: a slide's `index`, `active` and `inView`, a step's `disabled`, an indicator's `page` and `selected`, the play toggle's `playing` and `paused`.

```glimmer-ts title="render.gts"
import Component from "@glimmer/component"
import { Carousel } from "ember-ui-sdk/carousel"
import { ChevronLeft, ChevronRight } from "lucide"
import { attach } from "ember-ui-sdk/primitive"
import { icon } from "./icon"

const photos = [
  { name: "Dunes" },
  { name: "Forest" },
  { name: "Glacier" },
  { name: "Canyon" },
  { name: "Meadow" },
  { name: "Harbor" },
]

const position = (index: number) => index + 1

export default class Render extends Component {
  photos = photos
  nextFocused = false

  rememberFocus = () => {
    this.nextFocused =
      document.activeElement?.getAttribute("data-slot") === "carousel-next"
  }

  focusIf = (link: HTMLElement) => {
    if (this.nextFocused) {
      link.focus()
    }
  }

  <template>
    <Carousel aria-label="Photos" @onPageChange={{this.rememberFocus}} as |c|>
      <c.Viewport>
        <c.Content>
          {{#each this.photos key="name" as |photo|}}
            <c.Item as |item|>
              <div data-slot="tile">
                {{photo.name}}
                <span data-slot="hint">
                  {{position item.state.index}}
                  /
                  {{this.photos.length}}{{if item.state.active " · showing"}}
                </span>
              </div>
            </c.Item>
          {{/each}}
        </c.Content>
      </c.Viewport>
      <div data-slot="row">
        <c.Previous>
          {{icon ChevronLeft}}
          Previous
        </c.Previous>
        <c.Next @render={{true}} as |next|>
          {{#if next.state.disabled}}
            <a {{attach this.focusIf}} href="https://example.com/gallery">See
              all photos</a>
          {{else}}
            <button {{next.part}}>
              Next
              {{icon ChevronRight}}
            </button>
          {{/if}}
        </c.Next>
      </div>
    </Carousel>
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

Change slides to see each slide and control describe its current state.

## Styling

Use `data-disabled` on Previous and Next at their end, `data-selected` on the current indicator, `data-active` on the current page's slides, `data-in-view` on slides in view, and `data-playing` and `data-paused` on the root.

Slides size themselves: give them a `flex-basis` of 100% for one to a view or a third for three, and put the gap on the content, taking it out of each basis. The viewport writes the few styles scrolling needs inline: its overflow, `scroll-snap-type` and `overscroll-behavior`. Slides get `flex-shrink: 0` and their snap alignment. Hide the scrollbar with `scrollbar-width: none` if you like.

Each part has a `data-slot`, such as `carousel-item`, and its state attributes are listed under [Data Attributes](#data-attributes).

### Carousel
- `--carousel-interval`: How long each page shows while rotating, like `500ms`. Time a progress bar's animation with it.
- `--carousel-progress`: How far the slides have scrolled, from 0 at the first page to 1 at the last, or round the loop. It follows every frame of a scroll or spring.

## Data Attributes

### Carousel
`[data-slot="carousel"]`

- `data-orientation` (`horizontal`, `vertical`): Which way the slides scroll, and which arrow keys page.
- `data-playing`: Present while it rotates on its own.
- `data-paused`: Present while rotation is paused for now: hovered, the tab hidden, scrolled out of view or held. Pause a progress animation with it.

### CarouselViewport
`[data-slot="carousel-viewport"]`

- `data-orientation` (`horizontal`, `vertical`): Which way the slides scroll, and which arrow keys page.
- `data-dragging`: Present while a mouse or pen drags the slides.

### CarouselContent
`[data-slot="carousel-content"]`

- `data-orientation` (`horizontal`, `vertical`): Which way the slides scroll, and which arrow keys page.

### CarouselItem
`[data-slot="carousel-item"]`

- `data-orientation` (`horizontal`, `vertical`): Which way the slides scroll, and which arrow keys page.
- `data-active`: Present on the slides of the current page.
- `data-in-view`: Present on slides at least half in view. Slides without it are inert and hidden from screen readers.

### CarouselPrevious
`[data-slot="carousel-previous"]`

- `data-disabled`: Present on Previous or Next when there's no page that way, beside `aria-disabled`. It stays focusable and does nothing.

### CarouselIndicator
`[data-slot="carousel-indicator"]`

- `data-selected`: Present on the current page's indicator, beside `aria-selected`.

### CarouselPlayToggle
`[data-slot="carousel-play-toggle"]`

- `data-playing`: Present while it rotates on its own.
- `data-paused`: Present while rotation is paused for now: hovered, the tab hidden, scrolled out of view or held. Pause a progress animation with it.

## API Reference

Pass the root's options as `@` arguments. `@page` and `@playing` are controlled with `@onPageChange` and `@onPlayingChange`.

### Carousel

- `page?` (`number`): The current page, from 1. Pass it to control the carousel.
- `defaultPage?` (`number`): The page it starts on, from 1, when uncontrolled.
- `onPageChange?` (`((page: number, details: ChangeDetails<CarouselPageChangeReason>) => void)`): Runs when the page wants to change. `details.reason` says why, and `details.cancel()` stays on the page.
- `onPageChangeComplete?` (`((page: number) => void)`): Runs once the slides come to rest on a page, after a spring, a drag or a scroll, with that page. Start work there that would stutter the motion.
- `playing?` (`boolean`): Whether it rotates through the pages on its own. Pass it to control rotation.
- `defaultPlaying?` (`boolean`): Whether it starts rotating, when uncontrolled. It doesn't when the user prefers reduced motion; the play toggle still starts it.
- `onPlayingChange?` (`((playing: boolean, details: ChangeDetails<CarouselPlayingChangeReason>) => void)`): Runs when rotation wants to start or stop. Keyboard focus moving in and the user paging stop it, as the carousel pattern asks.
- `interval?` (`number`): How long each page shows while rotating, in ms. Hovering, a hidden tab and scrolling the carousel out of view pause it.
- `orientation?` (`CarouselOrientation`): Which way the slides scroll, and which arrow keys page.
- `align?` (`CarouselAlign`): Where a page lines up in the viewport.
- `slidesPerPage?` (`CarouselSlidesPerPage`): How many slides one page holds: Next moves this many, and each indicator stands for this many. `"auto"` fits as many as the viewport shows.
- `loop?` (`boolean`): Whether the slides go round: Next on the last page goes to the first, which comes in after the last, and a swipe back from the first page reaches the last. With fewer than a page of slides to either side, Next on the last page scrolls back to the first instead.
- `skipSnaps?` (`boolean`): Whether a fast swipe can pass over pages. Without it, one swipe moves one page.
- `dragFree?` (`boolean`): Whether swipes and drags coast to wherever they stop instead of a page. The nearest page becomes the current one.
- `drag?` (`boolean`): Whether swiping, dragging and scrolling move the slides. Without it, only the parts, keys and controllers do.
- `controller?` (`object`): Pages the carousel from anywhere. Create one with `createCarouselController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### CarouselViewport

The scrolling area. Renders a `div` that scrolls and snaps natively, and takes focus for the arrow keys.

### CarouselContent

Holds the slides. Renders a `div` that announces slides coming into view, except while rotating.

### CarouselItem

One slide. Renders a `div` with the group role, named by its position, like "2 of 5".

### CarouselPrevious

- `controller?` (`object`): The carousel this part drives when it isn't inside one, like buttons in a page header.

### CarouselNext

Shows the next page. Takes the same arguments as `CarouselPrevious`.

### CarouselIndicatorGroup

Groups the indicators. Renders a `div` with the tablist role. Takes the same arguments as `CarouselPrevious`.

### CarouselIndicator

- `page?` (`number`): The page it shows and selects, from 1. Inferred from the indicators' order when left out.

### CarouselPlayToggle

Starts and stops rotation. Renders a `button`. Takes the same arguments as `CarouselPrevious`.

### State

What `@render` parts and their blocks receive, per part.

`Carousel`:

- `page` (`number`): The current page, from 1.
- `pageCount` (`number | null`): How many pages there are, or null before the slides are measured, like on the server.
- `playing` (`boolean`): Whether it rotates on its own.
- `orientation` (`CarouselOrientation`): Which way the slides scroll.

`CarouselViewport`:

- `orientation` (`CarouselOrientation`): Which way the slides scroll.
- `dragging` (`boolean`): Whether a mouse or pen is dragging the slides.

`CarouselContent`:

- `orientation` (`CarouselOrientation`): Which way the slides scroll.

`CarouselItem`:

- `index` (`number`): The slide's position among the slides, from 0. -1 until it's measured.
- `active` (`boolean`): Whether the slide belongs to the current page.
- `inView` (`boolean`): Whether at least half of the slide shows. Slides out of view are inert.

`CarouselPrevious` and `CarouselNext`:

- `disabled` (`boolean`): Whether there's no page that way, so pressing does nothing. It stays focusable.

`CarouselIndicatorGroup`:

- `page` (`number`): The current page, from 1.
- `pageCount` (`number | null`): How many pages there are, or null before the slides are measured.

`CarouselIndicator`:

- `page` (`number`): The page it stands for, from 1, or 0 before it's known.
- `selected` (`boolean`): Whether its page is the current one.

`CarouselPlayToggle`:

- `playing` (`boolean`): Whether it rotates on its own.
- `paused` (`boolean`): Whether rotation is paused for now: hovered, the tab hidden, scrolled out of view or held.

### Reasons

`details.reason` says why the page changed.

- `previous-press` (`MouseEvent | KeyboardEvent`): A pagination's or a carousel's Previous part was pressed.
- `next-press` (`MouseEvent | KeyboardEvent`): A pagination's or a carousel's Next part was pressed.
- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `swipe` (`TouchEvent | PointerEvent`): A swipe gesture: a finger, mouse or pen dragged it.
- `scroll` (`Event | undefined`): The user scrolled a carousel some other way: a wheel, a trackpad, a scrollbar, or the browser bringing focus or a find in page into view.
- `timeout` (`none`): A duration ran out, like a toast's, or a rotating carousel's interval.
- `content-resize` (`none`): The content or the screen changed size, and the drawer's snap point or the carousel's page went away, so it moved to the nearest one.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

And why rotation started or stopped.

- `previous-press` (`MouseEvent | KeyboardEvent`): A pagination's or a carousel's Previous part was pressed.
- `next-press` (`MouseEvent | KeyboardEvent`): A pagination's or a carousel's Next part was pressed.
- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `swipe` (`TouchEvent | PointerEvent`): A swipe gesture: a finger, mouse or pen dragged it.
- `scroll` (`Event | undefined`): The user scrolled a carousel some other way: a wheel, a trackpad, a scrollbar, or the browser bringing focus or a find in page into view.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.
- `toggle-press` (`MouseEvent | KeyboardEvent`): A toggle was pressed: a password input's, which shows or hides the password, or a carousel's, which starts or stops rotation.
- `focus-in` (`FocusEvent`): Keyboard focus moved into the component, which stops a rotating carousel, as the carousel pattern asks, or onto a canvas item, which brought it into view, or onto a calendar's day another way, like a screen reader's.

### Controller

Create one with `createCarouselController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, passed to the change callback, and returns `false` when the change is canceled or there's nowhere to go.

- `getPage()` (`() => number`): The current page, from 1.
- `getPageCount()` (`() => number | null`): How many pages there are, or null before the carousel has measured its slides.
- `setPage(page, options?)` (`(page: number, options?: CarouselPageOptions | undefined) => boolean`): Goes to a page, from 1, clamped to the pages there are. Returns false when canceled or already there.
- `next(options?)` (`(options?: CarouselPageOptions | undefined) => boolean`): Goes to the next page, or the first one after the last with `loop`. Returns false at the end.
- `previous(options?)` (`(options?: CarouselPageOptions | undefined) => boolean`): Goes to the previous page, or the last one before the first with `loop`. Returns false at the start.
- `canNext()` (`() => boolean`): Whether there's a next page, always with `loop`.
- `canPrevious()` (`() => boolean`): Whether there's a previous page, always with `loop`.
- `getProgress()` (`() => number`): How far the slides have scrolled, from 0 at the first page to 1 at the last, or round the loop. Also `--carousel-progress` on the root.
- `isPlaying()` (`() => boolean`): Whether it rotates on its own.
- `setPlaying(playing, options?)` (`(playing: boolean, options?: CarouselPlayingOptions | undefined) => boolean`): Starts or stops rotation. Returns false when canceled or unchanged.
- `play(options?)` (`(options?: CarouselPlayingOptions | undefined) => boolean`): Starts rotation.
- `pause(options?)` (`(options?: CarouselPlayingOptions | undefined) => boolean`): Stops rotation.

### Events

Callbacks get the new value first, then the details. A controlled `@page` or `@playing` only updates when its change callback wasn't canceled.

| Argument                | On         | Receives                                                    |
| ----------------------- | ---------- | ----------------------------------------------------------- |
| `@onPageChange`         | `Carousel` | `(page, details)`: the new page, and the [reason](#reasons) |
| `@onPageChangeComplete` | `Carousel` | `(page)`: the page the slides came to rest on               |
| `@onPlayingChange`      | `Carousel` | `(playing, details)`: whether it rotates, and the reason    |

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

### Tested Behavior

**Structure**

- The carousel is a named region described as a carousel.
- Each slide is a group described as a slide.
- The first slide shows first.

**Previous and next**

- Next shows the next slide.
- Previous shows the previous slide.
- Previous is disabled on the first slide and Next on the last.
- Next on the last slide does nothing.
- Next and Previous are buttons that don't submit a form.

**Keyboard**

- ArrowRight in a slide shows the next slide, and ArrowLeft the previous.
- ArrowLeft on the first slide stays there.

**Pages**

- With three slides to a view, Next moves one slide, and the last page shows the last three.
- Three slides to a page move three at a time.
- Auto pages fit as many slides as show.
- It can start on another page.
- A controller pages it from outside.

**Rest**

- It reports the page once the slides come to rest.

**Loop**

- Next on the last slide shows the first.
- Previous on the first slide shows the last.
- Previous and Next are never disabled.
- Next on the last slide carries on the same way to the first.
- Pressing Next quickly keeps going forward, round past the last slide.
- A mouse drag back from the first slide shows the last.
- With three slides to a view, the last slide shows before the first.
- A vertical carousel drags down from the first slide to the last.

**Dragging**

- Dragging the slides with a mouse shows the next one.
- A short, slow drag settles back on the same slide.
- Dragging back shows the previous slide.
- A drag that starts on a link doesn't follow it.
- Without dragging, a drag moves nothing.

**More**

- A vertical carousel drags up and down.
- Pressing keys with no waits lands on the right slide.
- A fast flick moves one page, not more.
- The current slide stays in view when the slides change size.

Runs in React, Vue and web components.

Beyond the baseline:

**Focus**

- Next keeps focus when it reaches the last slide.
- Tab reaches only the slides in view.
- Slides out of view are hidden from assistive technology.
- Arrow keys bring the next slide in and move focus to it.
- A text field in a slide keeps its arrow keys.
- Home and End go to the first and last slide.

**Orientation**

- A vertical carousel pages with ArrowDown and ArrowUp.

**Indicators**

- Indicators are a tablist with the current page selected.
- Pressing an indicator shows its page.
- Arrow keys move between indicators and show their page.
- The indicators are one tab stop, on the current page.
- An indicator controls the slides of its page.
- Indicators past the page count hide themselves.

**Changes**

- A change can be canceled.
- A canceled drag springs back.
- Every change says why.
- A horizontal wheel scrolls to the next slide.
- With loop, a wheel back from the first slide scrolls natively to the last.
- --carousel-progress on the root follows the slides, for progress bars in CSS.
- With loop, --carousel-progress goes round, whatever the track's rotation.
- Next outside the carousel works through its controller.

**Rotation**

- It rotates on its own, past the last slide to the first.
- The play toggle stops and starts rotation, and its name says which.
- Keyboard focus moving in stops rotation, as the pattern asks.
- Hovering pauses rotation, and leaving resumes it.
- Pressing Next stops rotation.
- The slides are a live region only while not rotating.
- It doesn't start rotating when the user prefers reduced motion.
- Reduced motion pages without animating.

**Pages**

- Indicators follow a change in size.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while using the carousel with a keyboard.

Runs in React, Vue and web components.
