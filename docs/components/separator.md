---
title: Separator
description: Divide groups of content with a horizontal or vertical line.
---

Use a separator between groups of content that a reader should take as separate, like a profile's header and its bio.

[separator/basic](../../examples/components/separator/ember/basic.gts)

Read the profile with a screen reader. It announces a separator between Hollis Grant's name and email and the bio below.

## Installation

Add `ember-ui-sdk` to your app. See [Installation](../installation.md).

## Usage

Import the separator and put it between two groups of content:

```gts
import { Separator } from "ember-ui-sdk/separator"

<template>
  <section>
    <h2>Hollis Grant</h2>
    <Separator />
    <p>Designs the billing and onboarding flows.</p>
  </section>
</template>
```

## Vertical

Set `@orientation="vertical"` for a line between items in a row. It takes the row's height.

[separator/vertical](../../examples/components/separator/ember/vertical.gts)

Read across Privacy, Terms and Cookies. A screen reader announces a vertical separator between each link.

## Stacked Content

A vertical separator stretches to the tallest item in its row, so it spans a number and its label.

[separator/menu](../../examples/components/separator/ember/menu.gts)

Compare the lines with the stats. Each one runs the full height of Projects, Followers and Following.

## Rows

Put a separator between each pair of rows to divide a list of details.

[separator/list](../../examples/components/separator/ember/list.gts)

Read the plan details with a screen reader. It announces a separator between Plan, Seats and Renews.

## Decorative

Set `@decorative={{true}}` when the line only adds visual structure and the content around it already conveys the division. It is removed from the accessibility tree instead of being announced.

[separator/decorative](../../examples/components/separator/ember/decorative.gts)

Read the card with a screen reader. The line between the title and the body is not announced.

## Styling

Give the separator a thickness and a background. Its `data-orientation` attribute says whether it is horizontal or vertical, and its `data-slot` is `separator`.

## API Reference

The tables of options, state, data attributes, CSS variables and tested behavior are the same in every framework, with options passed as `@arguments` in Ember. See the [separator reference](https://ui-sdk.dev/docs/react/components/separator) in the upstream docs.

Options are passed as arguments, such as `@orientation`.

## Accessibility

A horizontal or vertical separator has the `separator` role and `aria-orientation`, so a screen reader announces it between the groups it divides. Set `@decorative` when it only creates visual structure.
