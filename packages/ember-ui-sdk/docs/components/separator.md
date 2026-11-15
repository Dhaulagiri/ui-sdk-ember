# Separator

Divide groups of content with a horizontal or vertical line.

Use a separator between groups of content that a reader should take as separate, like a profile's header and its bio.

```glimmer-ts title="basic.gts"
import { Separator } from "ember-ui-sdk/separator"

<template>
  <div data-slot="stack">
    <div data-slot="stack">
      <h3>Hollis Grant</h3>
      <p data-slot="hint">hollis@example.com</p>
    </div>
    <Separator />
    <p>
      Designs the billing and onboarding flows, and reviews every new pricing
      page.
    </p>
  </div>
</template>
```

Read the profile with a screen reader. It announces a separator between Hollis Grant's name and email and the bio below.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

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

```glimmer-ts title="vertical.gts"
import { Separator } from "ember-ui-sdk/separator"

<template>
  <nav aria-label="Legal" data-slot="row">
    <a href="#privacy">Privacy</a>
    <Separator @orientation="vertical" />
    <a href="#terms">Terms</a>
    <Separator @orientation="vertical" />
    <a href="#cookies">Cookies</a>
  </nav>
</template>
```

Read across Privacy, Terms and Cookies. A screen reader announces a vertical separator between each link.

## Stacked Content

A vertical separator stretches to the tallest item in its row, so it spans a number and its label.

```glimmer-ts title="menu.gts"
import { Separator } from "ember-ui-sdk/separator"

<template>
  <div data-slot="row">
    <div data-slot="stack">
      <span>24</span>
      <span data-slot="hint">Projects</span>
    </div>
    <Separator @orientation="vertical" />
    <div data-slot="stack">
      <span>1,280</span>
      <span data-slot="hint">Followers</span>
    </div>
    <Separator @orientation="vertical" />
    <div data-slot="stack">
      <span>312</span>
      <span data-slot="hint">Following</span>
    </div>
  </div>
</template>
```

Compare the lines with the stats. Each one runs the full height of Projects, Followers and Following.

## Rows

Put a separator between each pair of rows to divide a list of details.

```glimmer-ts title="list.gts"
import { Separator } from "ember-ui-sdk/separator"

<template>
  <div data-slot="stack">
    <dl>
      <dt>Plan</dt>
      <dd>Pro</dd>
    </dl>
    <Separator />
    <dl>
      <dt>Seats</dt>
      <dd>8 of 10</dd>
    </dl>
    <Separator />
    <dl>
      <dt>Renews</dt>
      <dd>December 1, 2026</dd>
    </dl>
  </div>
</template>
```

Read the plan details with a screen reader. It announces a separator between Plan, Seats and Renews.

## Decorative

Set `@decorative={{true}}` when the line only adds visual structure and the content around it already conveys the division. It is removed from the accessibility tree instead of being announced.

```glimmer-ts title="decorative.gts"
import { Separator } from "ember-ui-sdk/separator"

<template>
  <div data-slot="stack">
    <button type="button" data-variant="solid">Sign In with Passkey</button>
    <div data-slot="row">
      <Separator @decorative={{true}} />
      <span>or</span>
      <Separator @decorative={{true}} />
    </div>
    <button type="button">Email Me a Link</button>
  </div>
</template>
```

Read the card with a screen reader. The line between the title and the body is not announced.

## Styling

Give the separator a thickness and a background. Its `data-orientation` attribute says whether it is horizontal or vertical, and its `data-slot` is `separator`.

## Data Attributes

### Separator
`[data-slot="separator"]`

- `data-orientation` (`horizontal`, `vertical`): Which way the line runs.

## API Reference

Options are the same as below, as arguments, such as `@orientation`.

### Separator

- `orientation?` (`SeparatorOrientation`): Which way the line runs. A vertical separator divides items in a row.
- `decorative?` (`boolean`): Hides the separator from assistive technology with `role="none"`, for a line that's only visual. Leave it off when the separator divides content a screen reader should hear as separate, like groups of menu items.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

## Accessibility

A horizontal or vertical separator has the `separator` role and `aria-orientation`, so a screen reader announces it between the groups it divides. Set `@decorative` when it only creates visual structure.

### Tested Behavior

Every line below is an automated test.

- A separator is announced with its orientation.
- A separator can't be focused.
- A separator carries its orientation for styling.

Runs in React, Vue and web components.
