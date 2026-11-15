# Radio

Choose one option, move the selection with arrow keys, and submit it with a form.

Use radios for a short list of choices where only one can be picked, like a shipping speed or a plan. The group keeps one value and gives the whole list a single tab stop.

```glimmer-ts title="basic.gts"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const speeds = [
  { value: "standard", label: "Standard" },
  { value: "express", label: "Express" },
  { value: "overnight", label: "Overnight" },
]

<template>
  <Field as |f|>
    <f.Label>Shipping speed</f.Label>
    <RadioGroup @defaultValue="standard" @field={{f.field}} as |g|>
      {{#each speeds key="value" as |speed|}}
        <label data-slot="label">
          <g.Radio @value={{speed.value}} as |r|>
            <r.Indicator />
          </g.Radio>
          {{speed.label}}
        </label>
      {{/each}}
    </RadioGroup>
  </Field>
</template>
```

Choose Express, then use the arrow keys to move the selection between speeds.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `RadioGroup`:

```text
RadioGroup as |g|
├── g.Radio as |r|
│   └── r.Indicator
└── g.Radio as |r|
    └── r.Indicator
```

Give each radio a `@value` and wrap it with its text in a label. The group's value is the checked radio's value, and the indicator shows while its radio is checked.

## Usage

Import the group and use the parts it yields:

```gts
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

<template>
  <Field as |f|>
    <f.Label>Shipping speed</f.Label>
    <RadioGroup @defaultValue="standard" @field={{f.field}} as |g|>
      <label>
        <g.Radio @value="standard" as |r|>
          <r.Indicator />
        </g.Radio>
        Standard
      </label>
      <label>
        <g.Radio @value="express" as |r|>
          <r.Indicator />
        </g.Radio>
        Express
      </label>
    </RadioGroup>
  </Field>
</template>
```

The field's label names the group. Without a field, name it with `aria-label` or `aria-labelledby`. Without `@defaultValue`, nothing starts checked and Tab enters on the first enabled radio.

## Description

Put each radio in its own `Field` with a `f.Label` and `f.Description` when an option needs more explanation. That field connects both to its radio, while the outer field still names the group.

```glimmer-ts title="description.gts"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const frequencies = [
  { value: "instant", label: "Instantly", description: "An email right away." },
  {
    value: "daily",
    label: "Daily digest",
    description: "One email each morning.",
  },
  {
    value: "weekly",
    label: "Weekly digest",
    description: "A summary every Monday.",
  },
]

<template>
  <Field as |f|>
    <f.Label>Email notifications</f.Label>
    <RadioGroup @defaultValue="daily" @field={{f.field}} as |g|>
      {{#each frequencies key="value" as |frequency|}}
        <Field as |inner|>
          <g.Radio @value={{frequency.value}} @field={{inner.field}} as |r|>
            <r.Indicator />
          </g.Radio>
          <div data-slot="stack">
            <inner.Label>{{frequency.label}}</inner.Label>
            <inner.Description>{{frequency.description}}</inner.Description>
          </div>
        </Field>
      {{/each}}
    </RadioGroup>
  </Field>
</template>
```

Choose Weekly digest by its label. Each radio is also described by the line under it.

## Choice Card

Wrap an option's content in its label to make the whole card clickable. `:has([data-checked])` lets the card reflect the radio inside it.

```glimmer-ts title="choice-card.gts"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const plans = [
  {
    value: "hobby",
    label: "Hobby",
    description: "Free for personal projects.",
  },
  {
    value: "pro",
    label: "Pro",
    description: "$20 per month for growing teams.",
  },
  {
    value: "enterprise",
    label: "Enterprise",
    description: "Custom pricing and support.",
  },
]

<template>
  <Field as |f|>
    <f.Label>Plan</f.Label>
    <RadioGroup @defaultValue="hobby" @field={{f.field}} as |g|>
      {{#each plans key="value" as |plan|}}
        <label data-slot="card">
          <span data-slot="stack">
            <span>{{plan.label}}</span>
            <span data-slot="hint">{{plan.description}}</span>
          </span>
          <g.Radio @value={{plan.value}} as |r|>
            <r.Indicator />
          </g.Radio>
        </label>
      {{/each}}
    </RadioGroup>
  </Field>
</template>
```

Click anywhere on the Pro card to choose it. Arrow keys move the selection between cards too.

## Fieldset and Legend

Use a `fieldset` with a `legend` to describe a set of choices together. Connect the group to the legend with `aria-labelledby`, and to the description with `aria-describedby`.

```glimmer-ts title="legend.gts"
import { FieldSet } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const periods = [
  { value: "monthly", label: "Monthly", price: "$12 per month" },
  { value: "yearly", label: "Yearly", price: "$120 per year" },
]

<template>
  <FieldSet as |s|>
    <s.Legend id="billing-legend">Billing period</s.Legend>
    <s.Description id="billing-description">Yearly billing gets you two months
      free.</s.Description>
    <RadioGroup
      @defaultValue="monthly"
      aria-labelledby="billing-legend"
      aria-describedby="billing-description"
      as |g|
    >
      {{#each periods key="value" as |period|}}
        <label data-slot="label">
          <g.Radio @value={{period.value}} as |r|>
            <r.Indicator />
          </g.Radio>
          {{period.label}}
          <span data-slot="hint">({{period.price}})</span>
        </label>
      {{/each}}
    </RadioGroup>
  </FieldSet>
</template>
```

Choose Yearly. The legend and the line under it describe both billing periods.

## Disabled

Set `@disabled={{true}}` on the group or on one radio. Disabled radios can't be focused or checked, and arrow keys skip them. A disabled fieldset disables the group too, and a disabled group submits nothing.

```glimmer-ts title="disabled.gts"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const themes = [
  { value: "light", label: "Light" },
  { value: "dark", label: "Dark" },
  { value: "system", label: "System" },
]

const backups = [
  { value: "hourly", label: "Hourly", disabled: true },
  { value: "daily", label: "Daily", disabled: false },
  { value: "weekly", label: "Weekly", disabled: false },
]

<template>
  <div data-slot="stack">
    <Field as |f|>
      <f.Label>Theme</f.Label>
      <f.Description>Set by your organization.</f.Description>
      <RadioGroup @defaultValue="light" @disabled={{true}} @field={{f.field}} as |g|>
        {{#each themes key="value" as |theme|}}
          <label data-slot="label">
            <g.Radio @value={{theme.value}} as |r|>
              <r.Indicator />
            </g.Radio>
            {{theme.label}}
          </label>
        {{/each}}
      </RadioGroup>
    </Field>
    <Field as |f|>
      <f.Label>Backups</f.Label>
      <f.Description>Hourly backups need the Pro plan.</f.Description>
      <RadioGroup @defaultValue="daily" @field={{f.field}} as |g|>
        {{#each backups key="value" as |backup|}}
          <label data-slot="label">
            <g.Radio @value={{backup.value}} @disabled={{backup.disabled}} as |r|>
              <r.Indicator />
            </g.Radio>
            {{backup.label}}
          </label>
        {{/each}}
      </RadioGroup>
    </Field>
  </div>
</template>
```

The Theme group is disabled. In Backups, Hourly is disabled, so the arrow keys move between Daily and Weekly.

## Read-Only

Set `@readOnly={{true}}` on the group to keep its value while still letting people focus and read the options. Arrow keys move focus without checking anything, and the value still submits with a form.

```glimmer-ts title="read-only.gts"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const plans = [
  { value: "free", label: "Free" },
  { value: "pro", label: "Pro" },
  { value: "team", label: "Team" },
]

<template>
  <Field as |f|>
    <f.Label>Your plan</f.Label>
    <f.Description>Ask an admin to change plans.</f.Description>
    <RadioGroup @defaultValue="pro" @readOnly={{true}} @field={{f.field}} as |g|>
      {{#each plans key="value" as |plan|}}
        <label data-slot="label">
          <g.Radio @value={{plan.value}} as |r|>
            <r.Indicator />
          </g.Radio>
          {{plan.label}}
        </label>
      {{/each}}
    </RadioGroup>
  </Field>
</template>
```

Click Team, or focus Pro and press the Down arrow. Pro stays checked.

## Controlled

Pass `@value` and update it in `@onValueChange` to own the value. Call `details.cancel()` in the callback to keep the current value. A controller from `createRadioGroupController()`, passed as `@controller`, checks a radio from anywhere, like the Choose Team button below. Create one controller per mounted group.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup, createRadioGroupController } from "ember-ui-sdk/radio"
import { useLog } from "./log"

const plans = [
  { value: "starter", label: "Starter" },
  { value: "pro", label: "Pro" },
  { value: "team", label: "Team" },
]

export default class Controlled extends Component {
  log = useLog(this)
  planGroup = createRadioGroupController()
  @tracked value: string | null = "pro"

  chooseTeam = () => this.planGroup.setValue("team")

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    const label = plans.find((plan) => plan.value === next)?.label ?? "None"
    this.log(`${label} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.chooseTeam}}>Choose Team</button>
      </div>
      <Field as |f|>
        <f.Label>Plan</f.Label>
        <RadioGroup
          @value={{this.value}}
          @onValueChange={{this.onValueChange}}
          @controller={{this.planGroup}}
          @field={{f.field}}
          as |g|
        >
          {{#each plans key="value" as |plan|}}
            <label data-slot="label">
              <g.Radio @value={{plan.value}} as |r|>
                <r.Indicator />
              </g.Radio>
              {{plan.label}}
            </label>
          {{/each}}
        </RadioGroup>
      </Field>
    </div>
  </template>
}
```

Choose Starter, then press Choose Team. The console logs each change and its reason.

## Form

Each radio renders a button with the `radio` role and a hidden native radio, so the group takes part in forms. Set `@name` to submit the checked value; the group submits nothing without a name or a checked radio. `@required={{true}}` blocks submission until there's a choice, and a reset returns to `@defaultValue`.

Set `@form` to a form's id to join it from elsewhere on the page, as this group does.

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"
import { useLog } from "./log"

const speeds = [
  { value: "standard", label: "Standard", detail: "Free, 5 to 7 days" },
  { value: "express", label: "Express", detail: "$9, 2 days" },
  { value: "overnight", label: "Overnight", detail: "$24, next day" },
]

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Submitted shipping=${new FormData(event.currentTarget as HTMLFormElement).get("shipping")}`
    )
  }

  <template>
    <div data-slot="stack">
      <Field as |f|>
        <f.Label>Shipping speed</f.Label>
        <RadioGroup
          @name="shipping"
          @form="checkout"
          @required={{true}}
          @defaultValue="standard"
          @field={{f.field}}
          as |g|
        >
          {{#each speeds key="value" as |speed|}}
            <label data-slot="label">
              <g.Radio @value={{speed.value}} as |r|>
                <r.Indicator />
              </g.Radio>
              {{speed.label}}
              <span data-slot="hint">({{speed.detail}})</span>
            </label>
          {{/each}}
        </RadioGroup>
      </Field>
      <form id="checkout" data-slot="row" {{on "submit" this.onSubmit}}>
        <button type="submit" data-variant="solid">Continue</button>
        <button type="reset">Reset</button>
      </form>
    </div>
  </template>
}
```

Choose Express and press Continue. The console logs the submitted value, and Reset returns the choice to Standard.

## Validation

Put a required group in a [Field](./field.md) with an `f.Error`. Submitting without a choice shows the error under the group and moves focus to it.

```glimmer-ts title="invalid.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"
import { useLog } from "./log"

const channels = [
  { value: "email", label: "Email only" },
  { value: "sms", label: "SMS only" },
  { value: "both", label: "Email and SMS" },
]

export default class Invalid extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Saved updates=${new FormData(event.currentTarget as HTMLFormElement).get("updates")}`
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <f.Label>Order updates</f.Label>
        <f.Description>Choose how we tell you about your orders.</f.Description>
        <RadioGroup @name="updates" @required={{true}} @field={{f.field}} as |g|>
          {{#each channels key="value" as |channel|}}
            <label data-slot="label">
              <g.Radio @value={{channel.value}} as |r|>
                <r.Indicator />
              </g.Radio>
              {{channel.label}}
            </label>
          {{/each}}
        </RadioGroup>
        <f.Error>Choose how to get order updates.</f.Error>
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Save</button>
      </div>
    </form>
  </template>
}
```

Press Save without a choice to see the error. Choose SMS only and save again; the console logs the saved value.

## Animation

The indicator has `data-starting-style` as it appears and `data-ending-style` while it leaves, and stays mounted until its exit finishes. Transition from those states:

```css
[data-slot="radio-indicator"] {
  transition:
    opacity 0.15s,
    scale 0.15s;

  &:is([data-starting-style], [data-ending-style]) {
    opacity: 0;
    scale: 0.5;
  }
}
```

`@keepMounted={{true}}` keeps the indicator in the page while unchecked, with `data-unchecked`. Here it lets a hovered option preview its dot.

```glimmer-ts title="indicator.gts"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"

const themes = [
  { value: "light", label: "Light" },
  { value: "dark", label: "Dark" },
  { value: "system", label: "System" },
]

<template>
  <Field as |f|>
    <f.Label>Theme</f.Label>
    <RadioGroup @defaultValue="system" @field={{f.field}} as |g|>
      {{#each themes key="value" as |theme|}}
        <label data-slot="label">
          <g.Radio @value={{theme.value}} as |r|>
            <r.Indicator @keepMounted={{true}} />
          </g.Radio>
          {{theme.label}}
        </label>
      {{/each}}
    </RadioGroup>
  </Field>
</template>
```

Hover Light to preview its dot, then choose it. The dot scales in on Light and out of System.

## Loop

Arrow keys wrap from the last radio to the first. Set `@loop={{false}}` to stop at the ends.

```gts
<RadioGroup @defaultValue="low" @loop={{false}} as |g|>…</RadioGroup>
```

## Custom Rendering

Pass `@render={{true}}` to a radio or its indicator to render your own element. The part yields `{ part, state }`: bind `part` to the interactive element so its role, label and keyboard behavior stay connected, and read `state` to change its content.

```glimmer-ts title="render.gts"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"
import { Check } from "lucide"
import { icon } from "./icon"

const options = [
  {
    value: "all",
    label: "Everything",
    description: "Every message and update.",
  },
  {
    value: "mentions",
    label: "Mentions",
    description: "Only when someone mentions you.",
  },
  { value: "none", label: "Nothing", description: "Turn notifications off." },
]

<template>
  <Field as |f|>
    <f.Label>Notify me about</f.Label>
    <RadioGroup @defaultValue="mentions" @field={{f.field}} as |g|>
      {{#each options key="value" as |option|}}
        <g.Radio
          @value={{option.value}}
          aria-labelledby="render-{{option.value}}-label"
          aria-describedby="render-{{option.value}}-description"
          @render={{true}}
          as |r|
        >
          <button {{r.part}}>
            <span data-slot="stack">
              <span id="render-{{option.value}}-label">{{option.label}}</span>
              <span
                data-slot="hint"
                id="render-{{option.value}}-description"
              >{{option.description}}</span>
            </span>
            <span data-checked={{if r.state.checked ""}}>{{icon Check}}</span>
          </button>
        </g.Radio>
      {{/each}}
    </RadioGroup>
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

Choose Nothing. Each radio renders a full-width button that shows a check from its state.

## Styling

Use `data-checked` and `data-unchecked` for the checked state, and `data-disabled`, `data-readonly` and `data-required` for the rest. The indicator gets the same state attributes as its radio, and the group gets `data-disabled`, `data-readonly` and `data-required`.

Each part has a `data-slot`, such as `radio`, and its state attributes are listed under [Data Attributes](#data-attributes).

## Data Attributes

### RadioGroup
`[data-slot="radio-group"]`

- `data-readonly`: Present when the group is read-only.
- `data-required`: Present when the group is required.
- `data-disabled`: Present when disabled, by its own prop, the group or a `<fieldset>`.

### Radio
`[data-slot="radio"]`

- `data-checked`: Present on the checked radio.
- `data-readonly`: Present when the group is read-only.
- `data-required`: Present when the group is required.
- `data-unchecked`: Present on radios that aren't checked.
- `data-disabled`: Present when disabled, by its own prop, the group or a `<fieldset>`.

### RadioIndicator
`[data-slot="radio-indicator"]`

- `data-checked`: Present on the checked radio.
- `data-readonly`: Present when the group is read-only.
- `data-required`: Present when the group is required.
- `data-unchecked`: Present on radios that aren't checked.
- `data-disabled`: Present when disabled, by its own prop, the group or a `<fieldset>`.
- `data-starting-style`: Present for the indicator's first frame. Style the state you animate from.
- `data-ending-style`: Present while the indicator animates out. Style the state you animate to.

## API Reference

Options and callbacks are the same as below, as arguments: `@value`, `@onValueChange`. Every part also takes `@render`.

### RadioGroup

- `value?` (`T | null`): The checked radio's value. Pass it to control the group. `null` checks nothing.
- `defaultValue?` (`T | null`): The radio checked at first, when uncontrolled. A form reset returns to it.
- `onValueChange?` (`((value: T | null, details: ChangeDetails<RadioGroupValueChangeReason>) => void)`): Runs when a user or a form reset wants to change the value. `details.reason` says why, and `details.cancel()` stops it.
- `disabled?` (`boolean`): Disables every radio like native ones: they can't be focused or changed, and the value isn't submitted.
- `readOnly?` (`boolean`): Keeps the items focusable and the value submitted, but stops changes.
- `required?` (`boolean`): Blocks form submission until an item is checked, with the browser's own message.
- `name?` (`string`): The name the value submits under. Without one, the group submits nothing.
- `form?` (`string`): The id of a form to belong to, when the group isn't inside that form.
- `loop?` (`boolean`): Whether arrow keys wrap from the last item to the first.
- `controller?` (`{ getValue: () => T | null; setValue: (value: T | null, details?: Details) => boolean; focus: () => void; }`): Checks radios from anywhere. Create one with `createRadioGroupController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### Radio

- `value` (`string`): What the group's value becomes when this item is checked.
- `disabled?` (`boolean`): Skips the item, like a disabled native radio: arrow keys pass it and it can't be focused or checked.

### RadioIndicator

- `keepMounted?` (`boolean`): Whether the indicator stays in the page while its item is unchecked.

### State

What `@render={{true}}` yields as `state`, per part.

- `value` (`string | null`): The checked item's value.
- `disabled` (`boolean`): Whether the group is disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether the group is read-only: arrow keys still move focus, but nothing changes the checked item.
- `required` (`boolean`): Whether a form won't submit until an item is checked.

- `checked` (`boolean`): Whether this item is checked.
- `disabled` (`boolean`): Whether this item is disabled, by itself, its group or a `<fieldset>`.
- `readOnly` (`boolean`): Whether the group is read-only.
- `required` (`boolean`): Whether the group is required.

- `checked` (`boolean`): Whether this item is checked.
- `disabled` (`boolean`): Whether this item is disabled, by itself, its group or a `<fieldset>`.
- `readOnly` (`boolean`): Whether the group is read-only.
- `required` (`boolean`): Whether the group is required.

### Reasons

`details.reason` says why the checked value changed.

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `reset` (`none`): A form reset.
- `restore` (`none`): The browser restored state, like after going back, or a saved value was read back from storage.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createRadioGroupController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

- `getValue()` (`() => T | null`): The checked radio's value.
- `setValue(value, details?)` (`(value: T | null, details?: RadioGroupChangeOptions | undefined) => boolean`): Checks a radio, as a user would. Disabled radios and read-only groups ignore it.
- `focus()` (`() => void`): Moves focus to the checked radio, or the first one.

### Events

Callbacks get the new value first, then the details.

| Argument         | On           | Receives                                                          |
| ---------------- | ------------ | ----------------------------------------------------------------- |
| `@onValueChange` | `RadioGroup` | `(value, details)`: the checked value, and the [reason](#reasons) |

## Accessibility

Radio groups follow the [WAI-ARIA radio group pattern](https://www.w3.org/WAI/ARIA/apg/patterns/radio/), and behave like native radios that share a name. `Radio` renders a button with the `radio` role, and a hidden native radio that takes part in forms.

### Keyboard

| Key        | Does                                                                    |
| ---------- | ----------------------------------------------------------------------- |
| Tab        | Moves into the group, onto the checked radio or the first enabled one   |
| Arrow keys | Move to the next or previous radio and check it, skipping disabled ones |
| Space      | Checks the focused radio                                                |
| Enter      | Submits its form                                                        |

### Tested Behavior

Every line below is an automated test.

**Selection**

- Nothing is checked at first without a default value.
- Clicking an item checks it and unchecks the others.
- Clicking an item's label checks it.
- Clicking a disabled item does nothing.
- A change can be cancelled.

**Keyboard**

- Tab lands on the first item when nothing is checked.
- Tab lands on the checked item.
- Tab leaves the group after one stop.
- Space checks the focused item.
- ArrowDown and ArrowRight move to the next item and check it.
- ArrowUp and ArrowLeft move to the previous item and check it.
- Arrow keys skip disabled items.
- Arrow keys wrap at both ends.
- Enter never checks an item.
- Keys pressed in quick succession are never lost.
- Enter on an item submits the form.

**Read-only and disabled**

- A read-only group moves focus with arrow keys but checks nothing.
- A disabled group can't be focused or changed.
- Clicking a radio in a disabled group doesn't focus it.
- Clicking the label of a radio in a disabled group neither focuses nor checks it.

**Animation**

- The indicator animates in from its starting style.

Runs in React, Vue and web components.

In a field:

**With every radio enabled**

- Each radio is named by the label of its own field.
- The field around the group still names the group.
- Clicking a radio's label checks it and unchecks the others.
- The group keeps one tab stop.
- Arrow keys move between the radios and check them.

**A disabled radio**

- A disabled field around the first radio moves the tab stop to the next.
- Disabling the first radio after it renders moves the tab stop to the next.
- Enabling the first radio again gives it back the tab stop.

Runs in React, Vue and web components.

In right-to-left pages:

- ArrowLeft moves to the next radio and ArrowRight to the previous one.
- ArrowDown and ArrowUp keep their direction.

Runs in React, Vue and web components.
