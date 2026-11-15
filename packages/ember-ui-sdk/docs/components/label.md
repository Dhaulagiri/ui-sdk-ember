# Label

Name any control with a label, and let a press on the label reach it.

A plain `<label>` only reaches inputs, buttons and selects. Label names any control by its `for`, including a radio group or a slider, and a press on the label moves focus into it.

```glimmer-ts title="basic.gts"
import { Label } from "ember-ui-sdk/label"
import { RadioGroup } from "ember-ui-sdk/radio"

const speeds = [
  { value: "standard", label: "Standard" },
  { value: "express", label: "Express" },
  { value: "overnight", label: "Overnight" },
]

<template>
  <div data-slot="stack">
    <Label for="shipping-speed">Shipping speed</Label>
    <RadioGroup id="shipping-speed" @defaultValue="standard" as |g|>
      {{#each speeds key="value" as |speed|}}
        <Label>
          <g.Radio @value={{speed.value}} as |r|>
            <r.Indicator />
          </g.Radio>
          {{speed.label}}
        </Label>
      {{/each}}
    </RadioGroup>
  </div>
</template>
```

Press Shipping speed. Focus moves to the checked option, and a screen reader names the group Shipping speed.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Usage

Import the label and point its `for` at the control's `id`:

```gts
import { Label } from "ember-ui-sdk/label"
import { RadioGroup } from "ember-ui-sdk/radio"

<template>
  <Label for="plan">Plan</Label>
  <RadioGroup id="plan" @defaultValue="pro" as |g|>
    <g.Radio @value="free" as |r|>…</g.Radio>
    <g.Radio @value="pro" as |r|>…</g.Radio>
  </RadioGroup>
</template>
```

Label renders a native `<label>`. When the browser can reach the control on its own, like an input, it does. For anything else, the control takes the label as its name, and a press on the label focuses it, checks it or clicks it, as a native label would.

Inside a [Field](./field.md), use the field's own label part, which also ties the field's description and errors to the control.

## Slider

A label for a slider names its thumb, so the thumb reads as **Volume**, and a press on the label focuses it.

```glimmer-ts title="slider.gts"
import { Label } from "ember-ui-sdk/label"
import { Slider } from "ember-ui-sdk/slider"

<template>
  <Slider id="volume" @defaultValue={{75}} as |s|>
    <div data-slot="row">
      <Label for="volume">Volume</Label>
      <s.Value />
    </div>
    <s.Control>
      <s.Track>
        <s.Indicator />
        <s.Thumb />
      </s.Track>
    </s.Control>
  </Slider>
</template>
```

Press Volume, then use the arrow keys. The thumb moves, and a screen reader reads it as Volume.

## Switch

Point the label at a switch beside it. A press on the label turns the switch on and off.

```glimmer-ts title="switch.gts"
import { Label } from "ember-ui-sdk/label"
import { Switch } from "ember-ui-sdk/switch"

<template>
  <div data-slot="row">
    <Switch id="updates" as |s|>
      <s.Thumb />
    </Switch>
    <Label for="updates">Email me product updates</Label>
  </div>
</template>
```

Press Email me product updates. The switch turns on.

## Wrapping a Control

Put the control inside the label instead of pointing at it, and you need no `id`.

```glimmer-ts title="wrap.gts"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Label } from "ember-ui-sdk/label"
import { Check } from "lucide"
import { icon } from "./icon"

<template>
  <Label>
    <Checkbox as |c|>
      <c.Indicator>{{icon Check}}</c.Indicator>
    </Checkbox>
    Accept terms and conditions
  </Label>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Press Accept terms and conditions. The checkbox checks, and a double click doesn't select the text.

## Custom Rendering

Pass `@render={{true}}` to use a different element, such as a `<span>`, and spread the part onto it with `{{l.part}}`. A label that isn't a `<label>` still names its control and reaches it on a press.

## Styling

The label is unstyled. It has a `data-slot` of `label`.

A double click on the label doesn't select its text, so you don't need `user-select: none` for that.

## API Reference

Options are the same as below, as arguments, along with a native label's `for`.

### Label

- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

## Accessibility

A native `<label>` names the element its `for` points at only when that element is labelable, like an input or a button. Label names any other control through `aria-labelledby`, unless the control has an `aria-label` or an `aria-labelledby` of its own, which win. Its press does what a native label's does: it checks a checkbox, a switch or a radio, focuses a group's checked radio, and focuses anything else. A press on a disabled control does nothing.

### Tested Behavior

Every line below is an automated test.

- A label names a native input, and a press focuses it.
- A label names a radio group, and a press focuses its checked radio.
- A label for a slider names its thumb, and a press focuses it.
- A label around a checkbox names it, and a press toggles it.
- A press on the label of a disabled group moves no focus.
- A control its author names keeps that name.
- A label names a control that renders after it.
- A double click on a label doesn't select its text.

Runs in React, Vue and web components.
