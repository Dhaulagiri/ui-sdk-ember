---
title: Rendering Primitives
description: Turn a Core primitive into Ember components with createParts.
---

This page renders the rating from [Compose Behaviors](https://ui-sdk.dev/docs/core/compose-behaviors). Start with that guide's [complete `rating.ts`](https://ui-sdk.dev/docs/core/compose-behaviors#complete-primitive): it already handles selection, arrow keys, and focus. Here we'll connect its `root` and `star` slots to Ember.

## Create the Parts

`createParts` maps slots to elements. Save this beside `rating.ts`:

```ts title="rating-parts.ts"
import { createParts } from "ember-ui-sdk/primitive"
import { rating } from "./rating"

const { Root: Rating } = createParts(rating, {
  root: "div",
  star: "button",
})

export { Rating }
```

`Root` creates the instance. Each other mapped slot becomes a part that the root yields, named in Pascal case: `star` becomes `Star`, and `tab-icon` would become `TabIcon`.

## Render the Rating

The root takes the primitive's options as `@` arguments, and the element's attributes go to its element. Use the parts the root yields, so each one finds the root's instance:

```gts
import { Rating } from "./rating-parts"

<template>
  <Rating @defaultValue={{4}} aria-label="Rating" as |r|>
    <r.Star @value="1" aria-label="1 star">★</r.Star>
    <r.Star @value="2" aria-label="2 stars">★</r.Star>
    <r.Star @value="3" aria-label="3 stars">★</r.Star>
  </Rating>
</template>
```

A part also takes the root's instance as `@handle`, which the yielded parts pass for you. Pass `@handle={{r.handle}}` yourself only to render a part outside the root's block.

## Render Your Own Element

Pass `@render={{true}}` to a root or part to render no element. It yields `{ part, state }`: bind `part` to your element as a modifier, and read `state` for what the slot exposes.

```gts
<Rating as |r|>
  <r.Star @value="1" @render={{true}} as |s|>
    <i {{s.part}}>★</i>
  </r.Star>
</Rating>
```

Attributes you pass to a part with `@render` don't reach your element, so put classes and `href` on it yourself.

## Controls Inside a Field

A control inside a [Field](./components/field.md) takes the field's context as `@field`, which the field yields: `<Input @field={{f.field}} />`.

## Write Your Own Parts

When the generated components are not enough, write a root and its parts with `usePrimitive`, `usePart` and `syncOptions`. See [Custom Parts](./utilities/custom-parts.md).
