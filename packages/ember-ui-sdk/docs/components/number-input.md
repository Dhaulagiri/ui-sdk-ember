# Number Input

Enter numbers, step through values, and format them for a locale.

Use a Number Input for quantities, prices and measurements. It keeps a numeric value while showing formatted text, and steps it with the keyboard, the step buttons, or a drag on its label.

```glimmer-ts title="basic.gts"
import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, MoveHorizontal, Plus } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Basic extends Component {
  log = useLog(this)

  onValueCommit = (value: number | null) => {
    this.log(`Quantity ${value ?? "empty"}`)
  }

  <template>
    <Field as |f|>
      <NumberInput
        @defaultValue={{1}}
        @min={{1}}
        @field={{f.field}}
        @onValueCommit={{this.onValueCommit}}
        as |n|
      >
        <n.ScrubArea @pixelsPerStep={{4}}>
          <f.Label>Quantity</f.Label>
          <n.ScrubAreaCursor>{{icon MoveHorizontal}}</n.ScrubAreaCursor>
        </n.ScrubArea>
        <n.Group>
          <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
          <n.Control />
          <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
        </n.Group>
      </NumberInput>
    </Field>
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

Drag the Quantity label sideways to scrub the value, or click it to focus the input. Type a number, press ArrowUp or ArrowDown, or hold a step button. The console logs the value once each change is committed.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `NumberInput`:

```text
NumberInput as |n|
├── n.ScrubArea
│   └── n.ScrubAreaCursor
└── n.Group
    ├── n.Decrement
    ├── n.Control
    └── n.Increment
```

`NumberInput` holds the numeric value. `n.Group` wraps the text input and the optional step buttons. `n.Control` renders the input; `n.Decrement` and `n.Increment` change its value and repeat while held. `n.ScrubArea` is optional and changes the value as you drag it.

Typing updates the value when the text is valid and within bounds. Enter or blur commits it: the text is parsed, clamped, snapped to the step, and formatted. An empty input has the value `null`.

## Usage

Import the root and use the parts it yields:

```gts
import { NumberInput } from "ember-ui-sdk/number-input"

<template>
  <NumberInput @defaultValue={{1}} @min={{0}} as |n|>
    <n.Group>
      <n.Decrement aria-label="Decrease">−</n.Decrement>
      <n.Control aria-label="Quantity" />
      <n.Increment aria-label="Increase">+</n.Increment>
    </n.Group>
  </NumberInput>
</template>
```

## Field

Wrap the number input in [Field](./field.md) to give it a visible label and a description.

```glimmer-ts title="field.gts"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "./icon"

<template>
  <Field as |f|>
    <f.Label>Tickets</f.Label>
    <NumberInput @defaultValue={{2}} @min={{1}} @field={{f.field}} as |n|>
      <n.Group>
        <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
        <n.Control />
        <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
      </n.Group>
    </NumberInput>
    <f.Description>Each ticket admits one person to the workshop.</f.Description>
  </Field>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Click Tickets to focus the input, then type or step its value. Screen readers read the description with the field.

## Min and Max

Use `@min` and `@max` to set bounds. A step button disables at its bound. Typed values outside the bounds are clamped when committed.

```glimmer-ts title="min-max.gts"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "./icon"

<template>
  <Field as |f|>
    <f.Label>Guests</f.Label>
    <NumberInput @defaultValue={{2}} @min={{1}} @max={{8}} @field={{f.field}} as |n|>
      <n.Group>
        <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
        <n.Control />
        <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
      </n.Group>
    </NumberInput>
    <f.Description>Tables seat between 1 and 8 guests.</f.Description>
  </Field>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Change Guests between 1 and 8. Type 20 and press Enter to clamp it to 8. At either bound, that direction's step button is disabled.

## Step and Large Step

`@step` sets the usual increment, and defaults to 1. Steps are measured from `@min`, or from zero when no minimum is set. When they don't land on `@max`, End and the increment button stop at the highest step below it, so stepping keeps the value on the step grid, as [Slider](./slider.md#step-and-bounds) does. Shift, Page Up and Page Down use `@largeStep`, ten steps by default, and Alt (Option) with an arrow key uses `@smallStep`, a tenth of a step. [Keyboard](#keyboard) lists every key.

```glimmer-ts title="step.gts"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "./icon"

<template>
  <Field as |f|>
    <f.Label>Hours</f.Label>
    <NumberInput
      @defaultValue={{1.5}}
      @min={{0}}
      @max={{24}}
      @step={{0.25}}
      @largeStep={{1}}
      @smallStep={{0.05}}
      @field={{f.field}}
      as |n|
    >
      <n.Group>
        <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
        <n.Control />
        <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
      </n.Group>
    </NumberInput>
    <f.Description>Logged in quarter hours.</f.Description>
  </Field>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Step Hours by 0.25. Hold Shift to move by 1, or hold Alt (Option) with an arrow key to move by 0.05. Home and End go to 0 and 24.

## Format

Pass `Intl.NumberFormat` options through `@format`. The input displays and parses that format while keeping a numeric value. For percentages, `0.15` is displayed as `15%`, and `@step` defaults to the smallest percent the format shows: `0.01` for whole percents, `0.0001` with two fraction digits.

```glimmer-ts title="format.gts"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "./icon"

const fields = [
  {
    label: "Price",
    defaultValue: 19.99,
    step: 0.01,
    format: { style: "currency" as const, currency: "USD" },
  },
  {
    label: "Discount",
    defaultValue: 0.15,
    step: 0.01,
    format: { style: "percent" as const },
  },
  {
    label: "Weight",
    defaultValue: 2.5,
    step: 0.1,
    format: { style: "unit" as const, unit: "kilogram" },
  },
]

<template>
  <div data-slot="stack">
    {{#each fields key="label" as |item|}}
      <Field as |f|>
        <f.Label>{{item.label}}</f.Label>
        <NumberInput
          @defaultValue={{item.defaultValue}}
          @step={{item.step}}
          @format={{item.format}}
          @min={{0}}
          @field={{f.field}}
          as |n|
        >
          <n.Group>
            <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
            <n.Control />
            <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
          </n.Group>
        </NumberInput>
      </Field>
    {{/each}}
  </div>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Edit Price, Discount, or Weight and leave the field to format it. Try entering 5 in Price or 25% in Discount, then use the step buttons.

## Locale

Set `@locale` to choose separators, currency symbols, and grouping. Without it, the input follows the page's language or the browser's language after mounting. Server markup uses English when no locale is provided; set a locale explicitly when that first render matters.

```glimmer-ts title="locale.gts"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "./icon"

const fields = [
  {
    label: "Preis",
    locale: "de-DE",
    defaultValue: 1234.5,
    step: 0.01,
    format: { style: "currency" as const, currency: "EUR" },
  },
  {
    label: "Budget",
    locale: "en-IN",
    defaultValue: 1234567,
    step: 1000,
    format: {
      style: "currency" as const,
      currency: "INR",
      maximumFractionDigits: 0,
    },
  },
]

<template>
  <div data-slot="stack">
    {{#each fields key="label" as |item|}}
      <Field as |f|>
        <f.Label>{{item.label}}</f.Label>
        <NumberInput
          @defaultValue={{item.defaultValue}}
          @step={{item.step}}
          @format={{item.format}}
          @locale={{item.locale}}
          @min={{0}}
          @field={{f.field}}
          as |n|
        >
          <n.Group>
            <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
            <n.Control />
            <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
          </n.Group>
        </NumberInput>
        <f.Description>Formatted for {{item.locale}}.</f.Description>
      </Field>
    {{/each}}
  </div>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Edit Preis using a comma for decimals, or step Budget to see Indian digit grouping. The displayed and accepted formats follow each field's locale.

## Mouse Wheel

Set `@wheel={{true}}` to step with the mouse wheel while the input is focused. It is off by default.

```glimmer-ts title="wheel.gts"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "./icon"

<template>
  <Field as |f|>
    <f.Label>Font size</f.Label>
    <NumberInput @defaultValue={{16}} @min={{8}} @max={{72}} @wheel={{true}} @field={{f.field}} as |n|>
      <n.Group>
        <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
        <n.Control />
        <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
      </n.Group>
    </NumberInput>
    <f.Description>Focus the input, then scroll over it.</f.Description>
  </Field>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Focus Font size and scroll over it to change the value. Move focus away and scroll again; the value stays unchanged.

## Scrub Area

`n.ScrubArea` changes the value while you drag it. The handle can be any element inside the number input: the label, as in the first example, or a letter or icon inside the group, as in a design tool. Right and up increase the value. `@orientation` chooses an axis, and `@pixelsPerStep` controls how far the pointer moves per step. Shift and Alt (Option) use the large and small increments.

```glimmer-ts title="scrub.gts"
import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { NumberInput } from "ember-ui-sdk/number-input"
import { MoveHorizontal } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const fields = [
  { label: "X position", handle: "X", defaultValue: 120 },
  { label: "Y position", handle: "Y", defaultValue: 48 },
  { label: "Width", handle: "W", defaultValue: 320, min: 0 },
  { label: "Height", handle: "H", defaultValue: 240, min: 0 },
]

export default class Scrub extends Component {
  log = useLog(this)

  onValueCommit = (label: string, value: number | null) => {
    this.log(`${label} ${value ?? "empty"}`)
  }

  <template>
    <div data-slot="card" role="group" aria-labelledby="frame-title">
      <h3 id="frame-title">Frame</h3>
      <div data-slot="grid">
        {{#each fields key="label" as |item|}}
          <NumberInput
            @defaultValue={{item.defaultValue}}
            @min={{item.min}}
            @onValueCommit={{fn this.onValueCommit item.label}}
            as |n|
          >
            <n.Group>
              <n.ScrubArea @pixelsPerStep={{1}}>
                <span aria-hidden="true">{{item.handle}}</span>
                <n.ScrubAreaCursor>{{icon MoveHorizontal}}</n.ScrubAreaCursor>
              </n.ScrubArea>
              <n.Control aria-label={{item.label}} />
            </n.Group>
          </NumberInput>
        {{/each}}
      </div>
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

Drag the X, Y, W or H letter sideways to change that value. Hold Shift for larger steps or Alt (Option) for smaller ones. The console logs each value when the drag ends.

Where pointer lock is available, the drag can continue past the edge of the screen. `n.ScrubAreaCursor` draws a replacement cursor while it is locked. The cursor is placed in the document body with an inline translation; center your icon with negative margins.

To place a scrub area outside its number input, such as on an icon in a toolbar, pass the same [controller](#controller) to both. More than one scrub area can control the same field.

## Disabled

Set `@disabled={{true}}` on the component or its enclosing fieldset to prevent focus, changes, and form submission. Set `@disabled={{true}}` on one step button to turn off only that direction. The other button still steps.

## Read-Only

Set `@readOnly={{true}}` to keep the value focusable and included in form data while preventing edits and steps.

## Validation

Use `@required={{true}}` to block an empty value. Field associates its error with the input and marks it invalid after an unsuccessful submit. Here, choosing **Continue** while Age is empty shows "Enter your age."

```gts
<form>
  <Field as |f|>
    <f.Label>Age</f.Label>
    <NumberInput @name="age" @required={{true}} @min={{18}} @max={{120}} @field={{f.field}} as |n|>
      <n.Group>
        <n.Decrement aria-label="Decrease">−</n.Decrement>
        <n.Control />
        <n.Increment aria-label="Increase">+</n.Increment>
      </n.Group>
    </NumberInput>
    <f.Error @match="valueMissing">Enter your age.</f.Error>
  </Field>
  <button type="submit">Continue</button>
</form>
```

## Controlled

Pass `@value` and update it in `@onValueChange` for the reason. `@onValueChange` reports valid changes while an interaction is in progress. `@onValueCommit` runs when typing is committed, a step key or button is released, or a scrub ends. Use the commit event for work that should happen after the interaction.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Controlled extends Component {
  log = useLog(this)
  @tracked value: number | null = 4

  reset = () => {
    this.value = 4
  }

  clear = () => {
    this.value = null
  }

  onValueChange = (next: number | null, details: { reason: string }) => {
    this.value = next
    this.log(`Value ${next ?? "empty"} (${details.reason})`)
  }

  onValueCommit = (next: number | null, details: { reason: string }) => {
    this.log(`Committed ${next ?? "empty"} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.reset}}>Reset to 4</button>
        <button type="button" {{on "click" this.clear}}>Clear</button>
      </div>
      <Field as |f|>
        <f.Label>Servings</f.Label>
        <NumberInput
          @value={{this.value}}
          @onValueChange={{this.onValueChange}}
          @onValueCommit={{this.onValueCommit}}
          @min={{1}}
          @max={{12}}
          @field={{f.field}}
          as |n|
        >
          <n.Group>
            <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
            <n.Control />
            <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
          </n.Group>
        </NumberInput>
      </Field>
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

Hold a Servings step button. The console logs each value as it changes, then one Committed line when you let go. Clear sets the value to null, and Reset to 4 restores it.

## Controller

Create one with `createNumberInputController()` and pass it as `@controller` to change or focus the input from other controls. `increment()` and `decrement()` step the value; pass `{ large: true }` for a large step. `setValue()`, `getValue()`, and `focus()` cover direct updates and inspection.

```glimmer-ts title="controller.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import {
  NumberInput,
  createNumberInputController,
} from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const percent = { style: "unit", unit: "percent" } as const

export default class Controller extends Component {
  log = useLog(this)
  percent = percent
  zoom = createNumberInputController()

  zoomOut = () => this.zoom.decrement({ large: true })
  zoomIn = () => this.zoom.increment({ large: true })
  actualSize = () => this.zoom.setValue(100)
  read = () => this.log(`Zoom is ${this.zoom.getValue()}%`)
  focus = () => this.zoom.focus()

  onValueChange = (value: number | null, details: { reason: string }) => {
    this.log(`Zoom ${value ?? "empty"}% (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.zoomOut}}>Zoom Out</button>
        <button type="button" {{on "click" this.zoomIn}}>Zoom In</button>
        <button type="button" {{on "click" this.actualSize}}>Actual Size</button>
        <button type="button" {{on "click" this.read}}>Read</button>
        <button type="button" {{on "click" this.focus}}>Focus</button>
      </div>
      <Field as |f|>
        <f.Label>Zoom</f.Label>
        <NumberInput
          @defaultValue={{100}}
          @min={{10}}
          @max={{400}}
          @step={{10}}
          @format={{this.percent}}
          @controller={{this.zoom}}
          @onValueChange={{this.onValueChange}}
          @field={{f.field}}
          as |n|
        >
          <n.Group>
            <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
            <n.Control />
            <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
          </n.Group>
        </NumberInput>
      </Field>
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

Press Zoom In and Zoom Out to move by 100%, then Actual Size to restore 100%. Read logs the current value, and Focus moves into the field.

## Form

A hidden input submits the plain numeric value under `@name`. Formatting does not change form data: a displayed amount of $4.50 still submits `4.5`. Empty values submit an empty string.

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const usd = { style: "currency", currency: "USD" } as const

export default class Form extends Component {
  log = useLog(this)
  usd = usd

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = [...new FormData(event.currentTarget as HTMLFormElement)].map(
      ([name, value]) => `${name}=${value}`
    )
    this.log(`Submitted ${data.join(", ")}`)
  }

  <template>
    <div data-slot="stack">
      <form data-slot="stack" id="number-form" {{on "submit" this.onSubmit}}>
        <Field as |f|>
          <f.Label>Quantity</f.Label>
          <NumberInput @name="quantity" @defaultValue={{2}} @min={{1}} @field={{f.field}} as |n|>
            <n.Group>
              <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
              <n.Control />
              <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
            </n.Group>
          </NumberInput>
        </Field>
        <Field as |f|>
          <f.Label>Tip</f.Label>
          <NumberInput
            @name="tip"
            @defaultValue={{4.5}}
            @min={{0}}
            @step={{0.5}}
            @format={{this.usd}}
            @field={{f.field}}
            as |n|
          >
            <n.Group>
              <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
              <n.Control />
              <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
            </n.Group>
          </NumberInput>
        </Field>
      </form>
      <Field as |f|>
        <f.Label>Gift cards</f.Label>
        <NumberInput
          @name="gift-cards"
          @form="number-form"
          @defaultValue={{0}}
          @min={{0}}
          @field={{f.field}}
          as |n|
        >
          <n.Group>
            <n.Decrement aria-label="Decrease">{{icon Minus}}</n.Decrement>
            <n.Control />
            <n.Increment aria-label="Increase">{{icon Plus}}</n.Increment>
          </n.Group>
        </NumberInput>
      </Field>
      <div data-slot="row">
        <button type="reset" form="number-form">Reset</button>
        <button
          type="submit"
          form="number-form"
          data-variant="solid"
        >Save</button>
      </div>
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

Change Quantity or Tip and press Save: the console logs the plain numeric values. Gift cards belongs to the same form through its form ID. Reset restores the defaults.

Set `@form` to associate the input with a form elsewhere in the page. A form reset restores the default value and reports the `reset` reason.

## Custom Rendering

Pass `@render={{true}}` to a part to render your own element. The part yields `{ part, state }`: bind `part` to the element, and read `state` to change its content. Here the decrement button adds a tooltip, and the increment button shows Max once the value reaches its bound.

```glimmer-ts title="render.gts"
import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { NumberInput } from "ember-ui-sdk/number-input"
import { Minus, Plus } from "lucide"
import { icon } from "./icon"

const celsius = { style: "unit", unit: "celsius" } as const

export default class Render extends Component {
  celsius = celsius

  <template>
    <Field as |f|>
      <f.Label>Temperature</f.Label>
      <NumberInput
        @defaultValue={{-2}}
        @min={{-20}}
        @max={{40}}
        @format={{this.celsius}}
        @field={{f.field}}
        as |n|
      >
        <n.Group>
          <n.Decrement @render={{true}} aria-label="Colder" as |d|>
            <button {{d.part}} title={{if d.state.atBound "As cold as it goes" "Colder"}} aria-label="Colder">
              {{icon Minus}}
            </button>
          </n.Decrement>
          <n.Control />
          <n.Increment aria-label="Warmer" as |i|>
            {{#if i.state.atBound}}
              <span>Max</span>
            {{else}}
              {{icon Plus}}
            {{/if}}
          </n.Increment>
        </n.Group>
      </NumberInput>
    </Field>
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

Press End in Temperature to jump to 40°C. The increment button reads Max; hover the decrement button to see its tooltip.

Each part's state is listed under [State](#state).

## Styling

Style the group as the field's box, and the input and step buttons inside it. `data-disabled` on a step button also means it has reached its bound, and `data-scrubbing` marks every part while a drag changes the value. Inside Field, the native input receives validation attributes such as `data-invalid`. Use logical spacing so the layout follows the surrounding direction.

Each part has a `data-slot`, such as `number-input-group`, and its state attributes are listed under [Data Attributes](#data-attributes).

## Data Attributes

### NumberInput
`[data-slot="number-input"]`

- `data-disabled`: Present when disabled, by its own prop or a `<fieldset>`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-scrubbing`: Present while a drag on the scrub area changes the value.

### NumberInputScrubArea
`[data-slot="number-input-scrub-area"]`

- `data-disabled`: Present when disabled, by its own prop or a `<fieldset>`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-orientation` (`horizontal`, `vertical`): Which way to drag.
- `data-scrubbing`: Present while a drag on the scrub area changes the value.

### NumberInputScrubAreaCursor
`[data-slot="number-input-scrub-area-cursor"]`

- `data-disabled`: Present when disabled, by its own prop or a `<fieldset>`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-scrubbing`: Present while a drag on the scrub area changes the value.

### NumberInputGroup
`[data-slot="number-input-group"]`

- `data-disabled`: Present when disabled, by its own prop or a `<fieldset>`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-scrubbing`: Present while a drag on the scrub area changes the value.

### NumberInputDecrement
`[data-slot="number-input-decrement"]`

- `data-disabled`: Present when the button can't step: it or the field is disabled, the field is read-only, or the value is at `min`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-at-bound`
- `data-scrubbing`: Present while a drag on the scrub area changes the value.

### NumberInputControl
`[data-slot="number-input-control"]`

- `data-disabled`: Present when disabled, by its own prop or a `<fieldset>`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-scrubbing`: Present while a drag on the scrub area changes the value.

### NumberInputIncrement
`[data-slot="number-input-increment"]`

- `data-disabled`: Present when the button can't step: it or the field is disabled, the field is read-only, or the value is at `max`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-scrubbing`: Present while a drag on the scrub area changes the value.

## API Reference

Options and callbacks are the same as below, as arguments, such as `@value` and `@onValueChange`. Every part also takes `@render`.

### NumberInput

- `value?` (`number | null`): The value, or null for an empty field. Pass it to control the field.
- `defaultValue?` (`number | null`): The value at first, when uncontrolled. A form reset returns to it.
- `onValueChange?` (`((value: number | null, details: ChangeDetails<NumberInputValueChangeReason>) => void)`): Runs when the value changes: as a typed number becomes valid, and on every step. `details.cancel()` stops it.
- `onValueCommit?` (`((value: number | null, details: CommitDetails<NumberInputValueChangeReason>) => void)`): Runs once an interaction that changed the value ends: typing is committed, a key or a button is released, or a scrub ends. For saving.
- `min?` (`number`): The lowest value. Typed values below it are raised to it when committed.
- `max?` (`number`): The highest value. Typed values above it are lowered to it when committed.
- `step?` (`number`): How far one step moves. Committed values snap to steps from `min`, or from 0 without one.
- `largeStep?` (`number`): How far Page Up, Page Down, and Shift with an arrow key, a button, the wheel or a scrub move.
- `smallStep?` (`number`): How far Alt (Option on a Mac) with an arrow key, the wheel or a scrub moves, for fine changes. Values it reaches snap to it rather than to `step`.
- `format?` (`Intl.NumberFormatOptions`): How the value shows: `Intl.NumberFormat` options, like `{ style: "currency", currency: "USD" }`. Typing accepts the same format in the locale, and percents are fractions: 50% is 0.5.
- `locale?` (`string`): The locale for formatting and reading typed numbers. Defaults to the page's `lang`, or the browser's language without one, once the page is interactive. Server markup uses English until then, so it never disagrees with the client.
- `wheel?` (`boolean`): Lets the mouse wheel step the value while the input has focus.
- `disabled?` (`boolean`): Disables it like a native control: it can't be focused or changed, and isn't submitted.
- `readOnly?` (`boolean`): Keeps it focusable and submitted, but stops changes.
- `required?` (`boolean`): Blocks form submission while it's empty, with the browser's own message.
- `name?` (`string`): The name it submits under. The number is submitted as is, like `1234.5`, never formatted.
- `form?` (`string`): The id of a form to belong to, when it isn't inside that form.
- `controller?` (`object`): Steps it from anywhere. Create one with `createNumberInputController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### NumberInputScrubArea

- `orientation?` (`"horizontal" | "vertical"`): Which way to drag: right and up increase.
- `pixelsPerStep?` (`number`): How far the pointer moves for one step, in CSS pixels.
- `controller?` (`object`): Connects a scrub area outside the number input, like an icon in a toolbar, to the number input with this controller. Inside it, it connects on its own. Web components use `for="<number input id>"` instead.

### NumberInputIncrement and NumberInputDecrement

- `disabled?` (`boolean`): Turns off this button alone. Pressing, clicking or holding it doesn't step.

### State

What `@render={{true}}` yields as `state`. Every part gets the field's state.

- `value` (`number | null`): The value, or null when empty.
- `disabled` (`boolean`): Whether it's disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether it's read-only: it stays focusable and submitted, but typing, steps and scrubs don't change it.
- `required` (`boolean`): Whether a form won't submit while it's empty.
- `scrubbing` (`boolean`): Whether a scrub is moving the value.

The buttons' state, `NumberInputButtonState`, says whether that button can step, and whether the value is at its bound, apart from a disabled field:

- `value` (`number | null`): The value, or null when empty.
- `disabled` (`boolean`): Whether it's disabled, by itself or by a `<fieldset>`. Whether the button can't step, because it or the field is disabled, the field is read-only, or the value is at its bound.
- `readOnly` (`boolean`): Whether it's read-only: it stays focusable and submitted, but typing, steps and scrubs don't change it.
- `required` (`boolean`): Whether a form won't submit while it's empty.
- `scrubbing` (`boolean`): Whether a scrub is moving the value.
- `atBound` (`boolean`): Whether the value is at the bound this button steps toward, like the maximum for the increment.

### Reasons

`details.reason` says why the value changed.

- `input-change` (`Event`): Typing, pasting or dropping changed a text field's value; in a combobox it can also open or close it, or Enter keeps the typed text as the value.
- `input-commit` (`KeyboardEvent | FocusEvent`): Enter, or leaving a number input, committed what was typed: a number input parses, clamps and snaps it to the step, and an autocomplete closes its suggestions on it.
- `step-key` (`KeyboardEvent`): Arrow, Page Up, Page Down, Home or End stepped a slider or a number input.
- `increment-press` (`MouseEvent | PointerEvent`): A number input's increment button was pressed, or held.
- `decrement-press` (`MouseEvent | PointerEvent`): A number input's decrement button was pressed, or held.
- `wheel` (`WheelEvent`): The mouse wheel stepped a focused number input.
- `scrub` (`PointerEvent`): A drag on a number input's scrub area.
- `reset` (`none`): A form reset.
- `restore` (`none`): The browser restored state, like after going back, or a saved value was read back from storage.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createNumberInputController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

- `getValue()` (`() => number | null`): The value, or null when the field is empty.
- `setValue(value, options?)` (`(value: number | null, options?: NumberInputChangeOptions | undefined) => boolean`): Sets the value, as a user would. It's clamped and snapped to the step.
- `increment(options?)` (`(options?: (NumberInputChangeOptions & { large?: boolean | undefined; }) | undefined) => boolean`): Steps the value up, by `largeStep` with `{ large: true }`.
- `decrement(options?)` (`(options?: (NumberInputChangeOptions & { large?: boolean | undefined; }) | undefined) => boolean`): Steps the value down, by `largeStep` with `{ large: true }`.
- `focus()` (`() => void`): Moves focus to the input.

### Events

Callbacks get the new value first, then the details.

| Argument         | On            | Receives                                                                          |
| ---------------- | ------------- | --------------------------------------------------------------------------------- |
| `@onValueChange` | `NumberInput` | `(value, details)`: the new value, or null when empty, and the [reason](#reasons) |
| `@onValueCommit` | `NumberInput` | `(value, details)`: the value once the interaction ends, and its reason           |

## Accessibility

Follows the keyboard model of the [WAI-ARIA spinbutton pattern](https://www.w3.org/WAI/ARIA/apg/patterns/spinbutton/) on a native text input, so ordinary text editing works too. Give the input a field label or `aria-label`, and name both step buttons. Each button points to the input with `aria-controls`.

### Keyboard

| Input                                               | Increment                                          |
| --------------------------------------------------- | -------------------------------------------------- |
| ArrowUp, ArrowDown, or a step button                | `@step`, which defaults to 1.                      |
| Shift with an arrow or button; Page Up or Page Down | `@largeStep`, which defaults to ten steps.         |
| Alt (Option) with an arrow key                      | `@smallStep`, which defaults to a tenth of a step. |
| Home or End                                         | The minimum or maximum, when set.                  |

Enter commits typed text. The step buttons stay out of the Tab order, because the focused input gives the same steps through its arrow keys.

### Tested Behavior

Every line below is an automated test.

**Keyboard**

- Starts with its default value, formatted.
- ArrowUp and ArrowDown step the value.
- Shift with an arrow key steps by the large step.
- Home and End go to the minimum and the maximum.
- Stepping stops at the bounds.
- Steps keep cents exact.
- The buttons aren't in the tab order.

**Typing**

- Typing a number changes the value.
- A typed value above the maximum is lowered when focus leaves.
- Typed text in the format is read and formatted when focus leaves.
- Typing sends change only once the text is committed.
- Letters can't be typed.
- Arrow keys step from what's typed.
- Text that isn't a number goes back to the value when focus leaves.
- The value commits when focus leaves.

**Buttons**

- The increment and decrement buttons step the value.
- A button at its bound is disabled and marked data-at-bound.
- Holding a button repeats the step.
- A press commits when the button is released.
- A disabled button is marked disabled.
- A disabled button doesn't step when clicked or held, and the other still does.
- <button disabled> inside a step button element stays disabled past a bound. Web components only.
- A button disabled while it's held stops repeating.

**State and forms**

- Submits the number as is, not formatted.
- A disabled field can't be focused or changed.
- A read-only field can be focused, but not changed.
- A required empty field blocks the form.
- The mouse wheel does nothing unless turned on.
- The mouse wheel steps a focused field when turned on.
- A canceled change keeps the value.
- A controlled field follows its value.
- Reads and writes the locale's format.

Runs in React, Vue and web components.

Beyond the pattern:

- Page Up and Page Down step by the large step.
- A form reset returns every field to its default.
- A typed value snaps to the step when focus leaves.
- Enter commits and formats what's typed.
- Holding an arrow key commits once, when the key comes up.
- A field with cents asks for a decimal keypad.
- A scrub steps by distance, whatever the speed.
- A scrub that doesn't move commits nothing.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while moving to a number input with a keyboard.

Runs in React, Vue and web components.
