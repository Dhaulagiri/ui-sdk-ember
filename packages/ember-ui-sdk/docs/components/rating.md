# Rating

Pick a score from a row of stars, whole or half, with a preview as the pointer moves over them.

Use a rating to collect a score, like how a stay went, or to show one, like an average. Each star is a radio, so it works like a radio group, with one value and a single tab stop.

```glimmer-ts title="basic.gts"
import { Rating } from "ember-ui-sdk/rating"
import { Star } from "lucide"
import { icon } from "./icon"

<template>
  <Rating aria-label="Rating" @defaultValue={{3}} as |r|>
    <r.Item as |i|>{{icon Star}}</r.Item>
  </Rating>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose a star, then use the arrow keys to change the score.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

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

```glimmer-ts title="half-stars.gts"
import { Rating } from "ember-ui-sdk/rating"
import { Star } from "lucide"
import { icon } from "./icon"

<template>
  <Rating aria-label="Rating" @step={{0.5}} @defaultValue={{3.5}} as |r|>
    <r.Item as |i|>{{icon Star}}</r.Item>
  </Rating>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose the first half of a star. Its star fills halfway.

## Preview

While a pointer moves over the stars, they show the score under it: `--rating-fill` follows the pointer, and `data-highlighted` marks the stars up to it. Leaving the stars shows the score again. Touch has no preview, since a tap picks the score at once.

## Deselectable

Set `@deselectable={{true}}` to let people clear their score: a press on the checked star, or Space on it, sets the score back to `null`.

```glimmer-ts title="deselectable.gts"
import { Rating } from "ember-ui-sdk/rating"
import { Star } from "lucide"
import { icon } from "./icon"

<template>
  <Rating aria-label="Rating" @defaultValue={{4}} @deselectable={{true}} as |r|>
    <r.Item as |i|>{{icon Star}}</r.Item>
  </Rating>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Press the fourth star. The score clears.

## Read-Only

Set `@readOnly={{true}}` to show a score that can't change, like an average. Any score shows, like 4.2, which fills a fifth of the last star. The rating becomes one image for screen readers, and its radios are hidden from them.

Name a read-only rating with `@getValueLabel`, so its name includes the score. An `aria-label` would replace it.

```glimmer-ts title="read-only.gts"
import { Rating } from "ember-ui-sdk/rating"
import { Star } from "lucide"
import { icon } from "./icon"

const label = (value: number, max: number) => `Rated ${value} out of ${max}`

<template>
  <Rating @value={{4.2}} @readOnly={{true}} @getValueLabel={{label}} as |r|>
    <r.Item as |i|>{{icon Star}}</r.Item>
  </Rating>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

An average of 4.2, named Rated 4.2 out of 5.

## Disabled

Set `@disabled={{true}}` to stop every star from being focused or changed. A disabled rating submits nothing.

```glimmer-ts title="disabled.gts"
import { Rating } from "ember-ui-sdk/rating"
import { Star } from "lucide"
import { icon } from "./icon"

<template>
  <Rating aria-label="Rating" @defaultValue={{2}} @disabled={{true}} as |r|>
    <r.Item as |i|>{{icon Star}}</r.Item>
  </Rating>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

The rating is disabled, so the stars can't be focused or pressed.

## Controlled

Pass `@value` and update it in `@onValueChange` for the reason. Call `details.cancel()` in the callback to keep the current score. A [controller](#controller) from `createRatingController()`, passed as `@controller`, sets the score from anywhere, like the Clear Rating button below. Create one controller per mounted rating.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Rating, createRatingController } from "ember-ui-sdk/rating"
import { Star } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Controlled extends Component {
  log = useLog(this)
  rating = createRatingController()
  @tracked value: number | null = 4

  clear = () => this.rating.setValue(null)

  onValueChange = (next: number | null, details: { reason: string }) => {
    this.value = next
    this.log(`value: ${next} (${details.reason})`)
  }

  <template>
    <div>
      <div data-slot="controls">
        <button type="button" {{on "click" this.clear}}>Clear Rating</button>
      </div>
      <Rating
        aria-label="Rating"
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @controller={{this.rating}}
        as |r|
      >
        <r.Item as |i|>{{icon Star}}</r.Item>
      </Rating>
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

Choose a star, then press Clear Rating. The console logs each change and its reason.

## Form

Each radio renders a hidden native radio, so the rating takes part in forms. Set `@name` to submit the score; nothing submits without a name or a score. `@required={{true}}` blocks submission until there's a score, and a reset returns to `@defaultValue`.

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { Rating } from "ember-ui-sdk/rating"
import { Star } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Submitted stay=${new FormData(event.currentTarget as HTMLFormElement).get("stay")}`
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <f.Label>Rate your stay</f.Label>
        <Rating @name="stay" @required={{true}} @field={{f.field}} as |r|>
          <r.Item as |i|>{{icon Star}}</r.Item>
        </Rating>
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Send Review</button>
        <button type="reset">Reset</button>
      </div>
    </form>
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

Each part has a `data-slot`, such as `rating-item`, and its state attributes are listed under [Data Attributes](#data-attributes).

### RatingItem
- `--rating-fill`: How much of the star the shown score covers, from 0 to 1.

## Data Attributes

### Rating
`[data-slot="rating"]`

- `data-required`: Present when the rating is required.
- `data-readonly`: Present when the rating only shows its score.
- `data-disabled`: Present when the rating is disabled, by its own prop or a `<fieldset>`.

### RatingItem
`[data-slot="rating-item"]`

- `data-filled`: Present on stars the shown score covers whole.
- `data-partial`: Present on the star the shown score covers part of, like the last of 2.5.
- `data-checked`: Present on the star the score ends in.
- `data-disabled`: Present when the rating is disabled, by its own prop or a `<fieldset>`.
- `data-readonly`: Present when the rating only shows its score.
- `data-highlighted`: Present on the stars up to the score a pointer previews.

## API Reference

Options and callbacks are the same as below, as arguments, such as `@value` and `@onValueChange`. Every part also takes `@render`.

### Rating

- `value?` (`number | null`): The score. Pass it to control the rating. `null` means no score yet.
- `defaultValue?` (`number | null`): The score at first, when uncontrolled. A form reset returns to it.
- `onValueChange?` (`((value: number | null, details: ChangeDetails<RatingValueChangeReason>) => void)`): Runs when a user or a form reset wants to change the score. `details.reason` says why, and `details.cancel()` stops it.
- `max?` (`number`): How many stars there are.
- `step?` (`number`): The smallest change, as a fraction of a star: `0.5` makes half stars, each half its own radio.
- `deselectable?` (`boolean`): Lets a press on the checked star clear the score.
- `disabled?` (`boolean`): Disables every star: they can't be focused or changed, and the score isn't submitted.
- `readOnly?` (`boolean`): Shows the score as an image, named by `getValueLabel`, that can't be changed. Any score shows, like an average of 4.2.
- `required?` (`boolean`): Blocks form submission until there's a score, with the browser's own message.
- `name?` (`string`): The name the score submits under. Without one, the rating submits nothing.
- `form?` (`string`): The id of a form to belong to, when the rating isn't inside that form.
- `loop?` (`boolean`): Whether arrow keys wrap from the last star to the first.
- `getValueLabel?` (`((value: number, max: number) => string)`): Names a score, for each star's radio and for a read-only rating.
- `controller?` (`{ getValue: () => number | null; setValue: (value: number | null, details?: RatingChangeOptions) => boolean; focus: () => void; }`): Sets the score from anywhere. Create one with `createRatingController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### State

What `@render={{true}}` yields as `state`.

- `value` (`number | null`): The score, or `null` before anyone rates.
- `highlighted` (`number | null`): The score a pointer previews over the stars, or `null` while none does.
- `disabled` (`boolean`): Whether the rating is disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether the rating only shows its score.
- `required` (`boolean`): Whether a form won't submit until there's a score.

- `index` (`number`): Which star this is, from 1.
- `fill` (`number`): How much of this star the shown score covers, from 0 to 1. Also `--rating-fill`.
- `checked` (`boolean`): Whether the score ends in this star.
- `highlighted` (`boolean`): Whether a pointer previews a score that reaches this star.
- `disabled` (`boolean`): Whether the rating is disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether the rating only shows its score.

### Reasons

`details.reason` says why the score changed.

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `reset` (`none`): A form reset.
- `restore` (`none`): The browser restored state, like after going back, or a saved value was read back from storage.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createRatingController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

- `getValue()` (`() => number | null`): The score, or `null` before anyone rates.
- `setValue(value, details?)` (`(value: number | null, details?: RatingChangeOptions | undefined) => boolean`): Sets the score, as a user would. Disabled and read-only ratings ignore it.
- `focus()` (`() => void`): Moves focus to the checked star, or the first one.

### Events

Callbacks get the new score first, then the details.

| Argument         | On       | Receives                                                            |
| ---------------- | -------- | ------------------------------------------------------------------- |
| `@onValueChange` | `Rating` | `(value, details)`: the score or `null`, and the [reason](#reasons) |

## Accessibility

A rating is a radio group, so it follows the [WAI-ARIA radio group pattern](https://www.w3.org/WAI/ARIA/apg/patterns/radio/) and behaves like native radios that share a name. Each star holds a button with the `radio` role per score it can pick, and a hidden native radio that takes part in forms. Icons inside the stars should be hidden from screen readers with `aria-hidden`, since each radio is already named. A read-only rating has the `img` role instead, named by `@getValueLabel`.

### Keyboard

| Key        | Does                                                                                        |
| ---------- | ------------------------------------------------------------------------------------------- |
| Tab        | Moves into the rating, onto the checked star or the first one                               |
| Arrow keys | Move to the next or previous score and check it, stopping at the ends unless `@loop` is set |
| Space      | Checks the focused star, or clears it when it's checked and `@deselectable`                 |
| Enter      | Submits its form                                                                            |

### Tested Behavior

Every line below is an automated test.

**Selection**

- The default score is checked, and the stars up to it are full.
- Clicking a star checks it and says why.
- A half star fills half of its star.
- Clicking the checked star clears a deselectable rating, and only that one.
- A change can be cancelled.
- A controller sets the score.

**Preview**

- A pointer over a star previews its score, and leaving shows the score again.

**Keyboard**

- Tab lands on the checked star, and the next Tab leaves.
- Arrow keys change the score by a step, and stop at the ends.
- Space on the checked star clears a deselectable rating.

**Read-only**

- A read-only rating is one image, named by its label, that shows any score.

**Forms**

- Each score submits under its rating's name.
- A form reset returns to the default score.
- A disabled rating submits nothing, and its stars can't be focused or checked.

Runs in React, Vue and web components.
