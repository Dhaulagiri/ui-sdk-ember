---
title: Rating
description: Pick a score from a row of stars, whole or half, with a preview as the pointer moves over them.
---

Use a rating to collect a score, like how a stay went, or to show one, like an average. Each star is a radio, so it works like a radio group, with one value and a single tab stop.

[rating/basic](../../examples/components/rating/ember/basic.gts)

Choose a star, then use the arrow keys to change the score.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Composition

Use the following composition to build a `Rating`:

```text
Rating as |r|
└── r.Item
```

`Rating` renders its content once per star, so put one `r.Item` inside it. Without content, it renders an `r.Item` with no icon.

## Usage

Import the root and use the parts it yields:

```gts
import { Rating } from "ember-ui-sdk/rating"
import { Star } from "lucide"
import { icon } from "./icon"

<template>
  <Rating aria-label="Rating" @defaultValue={{3}} as |r|>
    <r.Item as |i|>{{icon Star}}</r.Item>
  </Rating>
</template>
```

Name the rating with `aria-label`, or put it in a [Field](./field.md) whose label names it. Without `@defaultValue`, nothing starts checked and Tab enters on the first star.

## Stars

Put your icon in `r.Item`. Each item says how much of its star the shown score covers: `--rating-fill` goes from 0 to 1, `data-filled` marks a whole star and `data-partial` the star a score ends partway through. The radios that pick the score sit over the icon, so it needs no events of its own.

```css
[data-slot="rating-item"] {
  color: lightgray;
}

[data-slot="rating-item"][data-filled] {
  color: gold;
}
```

For half stars and averages, paint the icon up to `calc(var(--rating-fill) * 100%)`, like with a gradient behind a star-shaped mask.

## Half Stars

Set `@step={{0.5}}` to split each star in two. Each half is its own radio, named like "2.5 stars", and a press on the first half of a star picks the half score.

[rating/half-stars](../../examples/components/rating/ember/half-stars.gts)

Choose the first half of a star. Its star fills halfway.

## Preview

While a pointer moves over the stars, they show the score under it: `--rating-fill` follows the pointer, and `data-highlighted` marks the stars up to it. Leaving the stars shows the score again. Touch has no preview, since a tap picks the score at once.

## Deselectable

Set `@deselectable={{true}}` to let people clear their score: a press on the checked star, or Space on it, sets the score back to `null`.

[rating/deselectable](../../examples/components/rating/ember/deselectable.gts)

Press the fourth star. The score clears.

## Read-Only

Set `@readOnly={{true}}` to show a score that can't change, like an average. Any score shows, like 4.2, which fills a fifth of the last star. The rating becomes one image for screen readers, and its radios are hidden from them.

Name a read-only rating with `@getValueLabel`, so its name includes the score. An `aria-label` would replace it.

[rating/read-only](../../examples/components/rating/ember/read-only.gts)

An average of 4.2, named Rated 4.2 out of 5.

## Disabled

Set `@disabled={{true}}` to stop every star from being focused or changed. A disabled rating submits nothing.

[rating/disabled](../../examples/components/rating/ember/disabled.gts)

The rating is disabled, so the stars can't be focused or pressed.

## Controlled

Pass `@value` and update it in `@onValueChange` for the reason. Call `details.cancel()` in the callback to keep the current score. A [controller](#controller) from `createRatingController()`, passed as `@controller`, sets the score from anywhere, like the Clear Rating button below. Create one controller per mounted rating.

[rating/controlled](../../examples/components/rating/ember/controlled.gts)

Choose a star, then press Clear Rating. The console logs each change and its reason.

## Form

Each radio renders a hidden native radio, so the rating takes part in forms. Set `@name` to submit the score; nothing submits without a name or a score. `@required={{true}}` blocks submission until there's a score, and a reset returns to `@defaultValue`.

[rating/form](../../examples/components/rating/ember/form.gts)

Press Send Review without a score to see the browser's message. Choose a star and send it again.

## Stars and Labels

Set `@max` for the number of stars, and `@loop={{true}}` to let the arrow keys wrap from the last star to the first. Each radio is named by `@getValueLabel`, which gets the score and `max` and says "1 star" or "3 stars" by default.

```gts
<Rating
  aria-label="Difficulty"
  @max={{10}}
  @loop={{true}}
  @getValueLabel={{this.difficultyLabel}}
  as |r|
>…</Rating>
```

## Styling

Parts are unstyled. Use `data-filled`, `data-partial`, `data-checked` and `data-highlighted` on each star, and `--rating-fill` for how full it is. `data-disabled`, `data-readonly` and `data-required` are on the rating and its stars.

Each part has a `data-slot`, such as `rating-item`, and its state attributes are listed under [Data Attributes](https://ui-sdk.dev/docs/react/components/rating#data-attributes).

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [rating reference](https://ui-sdk.dev/docs/react/components/rating) in the upstream docs.

Options and callbacks are passed as arguments, such as `@value` and `@onValueChange`. Every part also takes `@render`.

### Controller

Create one with `createRatingController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

### Events

Callbacks get the new score first, then the details.

| Argument         | On       | Receives                                                                                                           |
| ---------------- | -------- | ------------------------------------------------------------------------------------------------------------------ |
| `@onValueChange` | `Rating` | `(value, details)`: the score or `null`, and the [reason](https://ui-sdk.dev/docs/react/components/rating#reasons) |

## Accessibility

A rating is a radio group, so it follows the [WAI-ARIA radio group pattern](https://www.w3.org/WAI/ARIA/apg/patterns/radio/) and behaves like native radios that share a name. Each star holds a button with the `radio` role per score it can pick, and a hidden native radio that takes part in forms. Icons inside the stars should be hidden from screen readers with `aria-hidden`, since each radio is already named. A read-only rating has the `img` role instead, named by `@getValueLabel`.

### Keyboard

| Key        | Does                                                                                        |
| ---------- | ------------------------------------------------------------------------------------------- |
| Tab        | Moves into the rating, onto the checked star or the first one                               |
| Arrow keys | Move to the next or previous score and check it, stopping at the ends unless `@loop` is set |
| Space      | Checks the focused star, or clears it when it's checked and `@deselectable`                 |
| Enter      | Submits its form                                                                            |
