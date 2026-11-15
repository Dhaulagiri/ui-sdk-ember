# Checkbox

Choose one or more options, individually or as a group.

Use a checkbox for a choice someone can check or uncheck. Use a group when several choices belong to one value.

```glimmer-ts title="basic.gts"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "./icon"

<template>
  <label data-slot="label">
    <Checkbox as |c|>
      <c.Indicator>{{icon Check}}</c.Indicator>
    </Checkbox>
    Accept terms and conditions
  </label>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Click the checkbox or its label, or focus it and press Space, to accept the terms.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Checkbox`:

```text
Checkbox as |c|
└── c.Indicator
```

Wrap the checkbox and its text in a label. The indicator shows while the checkbox is checked or mixed.

## Usage

Import the root and use the parts it yields:

```gts
import { Checkbox } from "ember-ui-sdk/checkbox"

<template>
  <label>
    <Checkbox as |c|>
      <c.Indicator aria-hidden="true">✓</c.Indicator>
    </Checkbox>
    Accept terms and conditions
  </label>
</template>
```

## Description

Use `Field` with its `f.Label` and `f.Description` when a choice needs more explanation. The field connects both to the checkbox.

```glimmer-ts title="description.gts"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { Check } from "lucide"
import { icon } from "./icon"

<template>
  <Field as |f|>
    <Checkbox @field={{f.field}} as |c|>
      <c.Indicator>{{icon Check}}</c.Indicator>
    </Checkbox>
    <div data-slot="stack">
      <f.Label>Accept terms and conditions</f.Label>
      <f.Description>
        By clicking this checkbox, you agree to the terms and conditions.
      </f.Description>
    </div>
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

Click Accept terms and conditions. The field connects the label and description to the checkbox.

## Disabled

`@disabled={{true}}` prevents focus and changes, and leaves the checkbox out of form submissions. A disabled `fieldset` does the same.

```glimmer-ts title="disabled.gts"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "./icon"

<template>
  <div data-slot="stack">
    <label data-slot="label">
      <Checkbox @defaultChecked={{true}} as |c|>
        <c.Indicator>{{icon Check}}</c.Indicator>
      </Checkbox>
      Product updates
    </label>
    <label data-slot="label">
      <Checkbox @defaultChecked={{true}} @disabled={{true}} as |c|>
        <c.Indicator>{{icon Check}}</c.Indicator>
      </Checkbox>
      Security alerts
    </label>
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

Security alerts are always on, so that checkbox is disabled. Clicking its label leaves it checked.

## Read-Only

`@readOnly={{true}}` keeps the checkbox focusable and included in form submissions, while preventing the user from changing it.

```glimmer-ts title="read-only.gts"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { Check } from "lucide"
import { icon } from "./icon"

<template>
  <Field as |f|>
    <Checkbox @name="two-factor" @defaultChecked={{true}} @readOnly={{true}} @field={{f.field}} as |c|>
      <c.Indicator>{{icon Check}}</c.Indicator>
    </Checkbox>
    <div data-slot="stack">
      <f.Label>Require two-factor authentication</f.Label>
      <f.Description>Your organization requires this setting.</f.Description>
    </div>
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

Tab to the checked checkbox. Space and clicks leave the setting unchanged.

## Indeterminate

An indeterminate checkbox represents a partly checked set. It has `aria-checked="mixed"` and `data-indeterminate`. A press checks it; only your code puts it back into the mixed state.

Start with `@defaultChecked="indeterminate"`, or pass `"indeterminate"` as the controlled value. A [parent checkbox](#parent-checkbox) derives this state from a group for you.

```gts
<Checkbox @defaultChecked="indeterminate" as |c|>
  <c.Indicator>{{icon Minus}}</c.Indicator>
</Checkbox>
```

## Controlled

Pass `@checked` and update it in `@onCheckedChange` to own the value. A controller from `createCheckboxController()`, passed as `@controller`, changes it from anywhere, like the Toggle button below.

```glimmer-ts title="controlled.gts"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  Checkbox,
  createCheckboxController,
  type CheckedState,
} from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Controlled extends Component {
  log = useLog(this)
  updates = createCheckboxController()
  @tracked checked: CheckedState = false

  toggle = () => this.updates.toggle()

  onCheckedChange = (next: CheckedState, details: { reason: string }) => {
    this.checked = next
    const state =
      next === "indeterminate" ? "Mixed" : next ? "Checked" : "Unchecked"
    this.log(`${state} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.toggle}}>Toggle</button>
      </div>
      <label data-slot="label">
        <Checkbox
          @checked={{this.checked}}
          @controller={{this.updates}}
          @onCheckedChange={{this.onCheckedChange}}
          as |c|
        >
          <c.Indicator>{{icon Check}}</c.Indicator>
        </Checkbox>
        Email me about product updates
      </label>
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

Change the checkbox, or press Toggle. The console logs each change and its reason.

## Forms

Set `@name` and `@value` to include a checked checkbox in a native form. Unchecked and mixed checkboxes submit nothing. The default value is `"on"`. Independent checkboxes can share a name to submit several values; use a [group](#group) when your app also needs one list of checked values.

`@required={{true}}` blocks submission until the checkbox is checked. Reset returns it to `@defaultChecked`. Set `@form` to a form's id to join it from elsewhere on the page.

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { Check } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const entries = [
      ...new FormData(event.currentTarget as HTMLFormElement),
    ].map(([name, value]) => `${name}=${value}`)
    this.log(
      entries.length ? `Submitted ${entries.join("&")}` : "Submitted nothing"
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <Checkbox @name="terms" @value="yes" @required={{true}} @field={{f.field}} as |c|>
          <c.Indicator>{{icon Check}}</c.Indicator>
        </Checkbox>
        <div data-slot="stack">
          <f.Label>Accept terms and conditions</f.Label>
          <f.Description>You agree to our Terms of Service and Privacy Policy.</f.Description>
        </div>
      </Field>
      <Field as |f|>
        <Checkbox @name="newsletter" @value="weekly" @defaultChecked={{true}} @field={{f.field}} as |c|>
          <c.Indicator>{{icon Check}}</c.Indicator>
        </Checkbox>
        <div data-slot="stack">
          <f.Label>Send me the weekly newsletter</f.Label>
          <f.Description>Product news and tips, once a week. Unsubscribe
            anytime.</f.Description>
        </div>
      </Field>
      <div data-slot="row">
        <button type="submit">Create Account</button>
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

Create the account with the terms unchecked to see native validation, then accept them and try again. The console logs what was submitted, and Reset restores the defaults.

## Group

`CheckboxGroup` keeps one list of checked values. Each checkbox supplies its `@value`; the group returns selected values in the order the checkboxes appear. Name the group with `aria-label`, `aria-labelledby`, or a [Field](#group-in-a-form).

```glimmer-ts title="group.gts"
import { array } from "@ember/helper"
import { CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "./icon"

const toppings = [
  { value: "cheese", label: "Cheese" },
  { value: "mushrooms", label: "Mushrooms" },
  { value: "olives", label: "Olives" },
  { value: "peppers", label: "Peppers" },
]

<template>
  <div data-slot="stack">
    <h3 id="basic-toppings">Toppings</h3>
    <CheckboxGroup @defaultValue={{array "cheese"}} aria-labelledby="basic-toppings" as |g|>
      {{#each toppings key="value" as |topping|}}
        <label data-slot="label">
          <g.Checkbox @value={{topping.value}} as |c|>
            <c.Indicator>{{icon Check}}</c.Indicator>
          </g.Checkbox>
          {{topping.label}}
        </label>
      {{/each}}
    </CheckboxGroup>
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

Choose several toppings. The group keeps one list of checked values.

## Parent Checkbox

Add a checkbox with `@parent={{true}}` to check or uncheck the group. It is checked when every value is selected, unchecked when none are, and mixed in between. It points to its children with `aria-controls` and submits nothing itself.

Pass `@allValues` to the group so the parent has the right state on the first render, including on the server. Otherwise it discovers the values after the checkboxes mount.

```glimmer-ts title="group-parent.gts"
import { array } from "@ember/helper"
import { CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Check, Minus } from "lucide"
import { icon } from "./icon"

const toppings = [
  { value: "cheese", label: "Cheese" },
  { value: "mushrooms", label: "Mushrooms" },
  { value: "olives", label: "Olives" },
  { value: "peppers", label: "Peppers" },
]

const toppingValues = toppings.map((topping) => topping.value)

<template>
  <div data-slot="stack">
    <h3 id="parent-toppings">Toppings</h3>
    <CheckboxGroup
      @defaultValue={{array "cheese" "olives"}}
      @allValues={{toppingValues}}
      aria-labelledby="parent-toppings"
      as |g|
    >
      <label data-slot="label">
        <g.Checkbox @parent={{true}} as |c|>
          <c.Indicator>
            {{icon Check}}
            {{icon Minus}}
          </c.Indicator>
        </g.Checkbox>
        Select all
      </label>
      <div data-slot="stack">
        {{#each toppings key="value" as |topping|}}
          <label data-slot="label">
            <g.Checkbox @value={{topping.value}} as |c|>
              <c.Indicator>{{icon Check}}</c.Indicator>
            </g.Checkbox>
            {{topping.label}}
          </label>
        {{/each}}
      </div>
    </CheckboxGroup>
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

Select all checks every topping. Uncheck one topping to put Select all into its mixed state.

## Disabled Group

Disable the group to lock every checkbox, or disable one child to keep just that value fixed. A parent changes only enabled children.

```glimmer-ts title="group-disabled.gts"
import { array } from "@ember/helper"
import { CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Check, Minus } from "lucide"
import { icon } from "./icon"

const backups = [
  { value: "photos", label: "Photos" },
  { value: "documents", label: "Documents" },
  { value: "messages", label: "Messages" },
]

const folders = [
  { value: "desktop", label: "Desktop", disabled: true },
  { value: "projects", label: "Projects", disabled: false },
  { value: "downloads", label: "Downloads", disabled: false },
]

const folderValues = folders.map((item) => item.value)

<template>
  <div data-slot="stack">
    <div data-slot="stack">
      <h3 id="disabled-backups">Backups</h3>
      <p data-slot="hint">Managed by your organization.</p>
      <CheckboxGroup
        @defaultValue={{array "photos" "documents"}}
        @disabled={{true}}
        aria-labelledby="disabled-backups"
        as |g|
      >
        {{#each backups key="value" as |item|}}
          <label data-slot="label">
            <g.Checkbox @value={{item.value}} as |c|>
              <c.Indicator>{{icon Check}}</c.Indicator>
            </g.Checkbox>
            {{item.label}}
          </label>
        {{/each}}
      </CheckboxGroup>
    </div>
    <div data-slot="stack">
      <h3 id="disabled-folders">Sync folders</h3>
      <CheckboxGroup
        @defaultValue={{array "desktop"}}
        @allValues={{folderValues}}
        aria-labelledby="disabled-folders"
        as |g|
      >
        <label data-slot="label">
          <g.Checkbox @parent={{true}} as |c|>
            <c.Indicator>
              {{icon Check}}
              {{icon Minus}}
            </c.Indicator>
          </g.Checkbox>
          Select all
        </label>
        <div data-slot="stack">
          {{#each folders key="value" as |item|}}
            <label data-slot="label">
              <g.Checkbox @value={{item.value}} @disabled={{item.disabled}} as |c|>
                <c.Indicator>{{icon Check}}</c.Indicator>
              </g.Checkbox>
              {{item.label}}
            </label>
          {{/each}}
        </div>
      </CheckboxGroup>
    </div>
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

The Backups group is disabled. In Sync folders, Select all changes the enabled folders while Desktop stays checked.

## Controlled Group

Pass `@value` and update it in `@onValueChange` to own the selected values. A controller from `createCheckboxGroupController()`, passed as `@controller`, can replace that list, as Select Weekdays and Clear do below.

```glimmer-ts title="group-controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import {
  CheckboxGroup,
  createCheckboxGroupController,
} from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const days = [
  { value: "mon", label: "Monday" },
  { value: "tue", label: "Tuesday" },
  { value: "wed", label: "Wednesday" },
  { value: "thu", label: "Thursday" },
  { value: "fri", label: "Friday" },
  { value: "sat", label: "Saturday" },
  { value: "sun", label: "Sunday" },
]

const weekdays = ["mon", "tue", "wed", "thu", "fri"]

export default class GroupControlled extends Component {
  log = useLog(this)
  schedule = createCheckboxGroupController()
  @tracked value: string[] = ["mon", "tue"]

  selectWeekdays = () => this.schedule.setValue(weekdays)
  clear = () => this.schedule.setValue([])

  onValueChange = (next: string[], details: { reason: string }) => {
    this.value = next
    const names = days
      .filter((day) => next.includes(day.value))
      .map((day) => day.label)
    this.log(`${names.join(", ") || "No days"} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.selectWeekdays}}>Select Weekdays</button>
        <button type="button" {{on "click" this.clear}}>Clear</button>
      </div>
      <h3 id="controlled-days">Working days</h3>
      <CheckboxGroup
        @value={{this.value}}
        @controller={{this.schedule}}
        @onValueChange={{this.onValueChange}}
        aria-labelledby="controlled-days"
        as |g|
      >
        {{#each days key="value" as |day|}}
          <label data-slot="label">
            <g.Checkbox @value={{day.value}} as |c|>
              <c.Indicator>{{icon Check}}</c.Indicator>
            </g.Checkbox>
            {{day.label}}
          </label>
        {{/each}}
      </CheckboxGroup>
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

Choose working days, or press Select Weekdays or Clear. The console logs the group's value and the reason it changed.

## Group in a Form

Set `@name` on the group to submit every checked value under that name. `@required={{true}}` requires at least one selection, and Reset restores `@defaultValue`. Pass `@field={{f.field}}` to connect the group to a `Field`, which supplies its label and description, and `f.Error` shows the validation message inline until a selection makes the group valid.

```glimmer-ts title="group-field.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { Check } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const channels = [
  { value: "email", label: "Email" },
  { value: "sms", label: "SMS" },
  { value: "push", label: "Push notifications" },
]

export default class GroupField extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const entries = [
      ...new FormData(event.currentTarget as HTMLFormElement),
    ].map(([name, value]) => `${name}=${value}`)
    this.log(`Saved ${entries.join("&")}`)
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <f.Label>Notifications</f.Label>
        <f.Description>Choose how we tell you about your orders.</f.Description>
        <CheckboxGroup @name="notifications" @required={{true}} @field={{f.field}} as |g|>
          {{#each channels key="value" as |channel|}}
            <label data-slot="label">
              <g.Checkbox @value={{channel.value}} as |c|>
                <c.Indicator>{{icon Check}}</c.Indicator>
              </g.Checkbox>
              {{channel.label}}
            </label>
          {{/each}}
        </CheckboxGroup>
        <div>
          <f.Error>Choose at least one way to be notified.</f.Error>
        </div>
      </Field>
      <button type="submit">Save</button>
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

Save with nothing checked to see the inline error. Choose a notification method and save; the console logs the submitted values.

## Table

The same parent checkbox can select rows from a table header. Each row supplies its value and accessible name.

```glimmer-ts title="table.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Check, Minus } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const people = [
  {
    id: "hollis",
    name: "Hollis Grant",
    email: "hollis@example.com",
    role: "Owner",
  },
  {
    id: "ines",
    name: "Inès Moreau",
    email: "ines@example.com",
    role: "Editor",
  },
  {
    id: "kofi",
    name: "Kofi Mensah",
    email: "kofi@example.com",
    role: "Viewer",
  },
  {
    id: "wren",
    name: "Wren Takahashi",
    email: "wren@example.com",
    role: "Editor",
  },
]

const ids = people.map((person) => person.id)

export default class Table extends Component {
  log = useLog(this)
  @tracked selected: string[] = ["hollis"]

  onValueChange = (next: string[]) => {
    this.selected = next
    this.log(`${next.length} of ${people.length} selected`)
  }

  <template>
    <CheckboxGroup
      @value={{this.selected}}
      @onValueChange={{this.onValueChange}}
      @allValues={{ids}}
      aria-label="Team members"
      as |g|
    >
      <table>
        <caption data-slot="visually-hidden">Team members</caption>
        <thead>
          <tr>
            <th>
              <g.Checkbox @parent={{true}} aria-label="Select all" as |c|>
                <c.Indicator>
                  {{icon Check}}
                  {{icon Minus}}
                </c.Indicator>
              </g.Checkbox>
            </th>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
          </tr>
        </thead>
        <tbody>
          {{#each people key="id" as |person|}}
            <tr>
              <td>
                <g.Checkbox @value={{person.id}} aria-label="Select {{person.name}}" as |c|>
                  <c.Indicator>{{icon Check}}</c.Indicator>
                </g.Checkbox>
              </td>
              <td>{{person.name}}</td>
              <td>{{person.email}}</td>
              <td>{{person.role}}</td>
            </tr>
          {{/each}}
        </tbody>
      </table>
    </CheckboxGroup>
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

Select rows individually, or use Select all in the header. The console logs how many are selected.

## Animation

The indicator has `data-starting-style` as it appears and `data-ending-style` while it leaves, and stays mounted until its exit finishes. Transition from those states:

```css
[data-slot="checkbox-indicator"] {
  transition:
    opacity 0.15s,
    scale 0.15s;

  &:is([data-starting-style], [data-ending-style]) {
    opacity: 0;
    scale: 0.5;
  }
}
```

`@keepMounted={{true}}` keeps the indicator in the page while unchecked, with `data-unchecked`, for styles that show both states.

```glimmer-ts title="indicator.gts"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Check } from "lucide"
import { icon } from "./icon"

const tasks = [
  { label: "Write the release notes", done: false },
  { label: "Update the changelog", done: true },
  { label: "Tag the release", done: false },
]

<template>
  <div data-slot="stack">
    {{#each tasks key="label" as |task|}}
      <label data-slot="label">
        <Checkbox @defaultChecked={{task.done}} as |c|>
          <c.Indicator>{{icon Check}}</c.Indicator>
        </Checkbox>
        {{task.label}}
      </label>
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

Check and uncheck a task. The check scales and fades in, and out before it unmounts.

## Custom Rendering

Pass `@render={{true}}` to a checkbox, indicator, or group to render your own element. The part yields `{ part, state }`: bind `part` to the interactive element so its role, label, and keyboard behavior stay connected, and read `state` to change its content.

```glimmer-ts title="render.gts"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Check, Plus } from "lucide"
import { icon } from "./icon"

const topics = [
  { value: "design", label: "Design", checked: true },
  { value: "engineering", label: "Engineering", checked: false },
  { value: "marketing", label: "Marketing", checked: false },
  { value: "sales", label: "Sales", checked: false },
]

<template>
  <fieldset>
    <legend>Topics you follow</legend>
    <div data-slot="row">
      {{#each topics key="value" as |topic|}}
        <Checkbox
          @name="topics"
          @value={{topic.value}}
          @defaultChecked={{topic.checked}}
          @render={{true}}
          as |c|
        >
          <button {{c.part}}>
            {{#if c.state.checked}}
              {{icon Check}}
            {{else}}
              {{icon Plus}}
            {{/if}}
            {{topic.label}}
          </button>
        </Checkbox>
      {{/each}}
    </div>
  </fieldset>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose topics. Each checkbox renders a button that shows a check or a plus from its state.

## Styling

Use `data-checked`, `data-unchecked` and `data-indeterminate` for the checked state, and `data-disabled`, `data-readonly` and `data-required` for the rest. The indicator gets the same state attributes as its checkbox.

Each part has a `data-slot`, such as `checkbox`, and its state attributes are listed under [Data Attributes](#data-attributes).

## Data Attributes

### Checkbox
`[data-slot="checkbox"]`

- `data-checked`: Present while checked.
- `data-disabled`: Present when disabled, by its own prop, a group or a `<fieldset>`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-unchecked`: Present while unchecked.
- `data-indeterminate`: Present while indeterminate.

### CheckboxIndicator
`[data-slot="checkbox-indicator"]`

- `data-checked`: Present while checked.
- `data-disabled`: Present when disabled, by its own prop, a group or a `<fieldset>`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-unchecked`: Present while unchecked.
- `data-indeterminate`: Present while indeterminate.
- `data-starting-style`: Present for the indicator's first frame. Style the state you animate from.
- `data-ending-style`: Present while the indicator animates out. Style the state you animate to.

### CheckboxGroup
`[data-slot="checkbox-group"]`

- `data-disabled`: Present when the group is disabled, by its own prop or a `<fieldset>`.
- `data-required`: Present when at least one checkbox must be checked.

## API Reference

Options and callbacks are the same as below, as arguments: `@checked`, `@onCheckedChange`. Every part also takes `@render`.

### Checkbox

- `checked?` (`CheckedState`): Whether it's checked. Pass it to control the checkbox.
- `defaultChecked?` (`CheckedState`): Whether it's checked at first, when uncontrolled. A form reset returns to it.
- `onCheckedChange?` (`((checked: CheckedState, details: ChangeDetails<CheckboxCheckedChangeReason>) => void)`): Runs when a user or a form reset wants to change it. `details.reason` says why, and `details.cancel()` stops it.
- `disabled?` (`boolean`): Disables it like a native control: it can't be focused or changed, and isn't submitted.
- `readOnly?` (`boolean`): Keeps it focusable and submitted, but stops changes.
- `required?` (`boolean`): Blocks form submission until it's checked, with the browser's own message.
- `name?` (`string`): The name it submits under. Without one, it submits nothing.
- `value?` (`string`): What it submits while checked.
- `form?` (`string`): The id of a form to belong to, when it isn't inside that form.
- `controller?` (`{ toggle: (details?: Details) => boolean; getChecked: () => CheckedState; setChecked: (checked: CheckedState, details?: Details) => boolean; focus: () => void; }`): Toggles it from anywhere. Create one with `createCheckboxController()`.
- `parent?` (`boolean`): Makes it the parent of its group: it checks or unchecks every checkbox in the group, and shows checked, unchecked or indeterminate from them.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### CheckboxIndicator

- `keepMounted?` (`boolean`): Whether the indicator stays in the page while unchecked, so it can be styled or animated in both states.

### CheckboxGroup

- `value?` (`T[]`): The checked checkboxes' values. Pass it to control the group.
- `defaultValue?` (`T[]`): The values checked at first, when uncontrolled. A form reset returns to them.
- `onValueChange?` (`((value: T[], details: ChangeDetails<CheckboxGroupValueChangeReason>) => void)`): Runs when a user or a form reset wants to change the value. `details.reason` says why, and `details.cancel()` stops it.
- `allValues?` (`T[]`): Every value a parent checkbox checks. Without it, the parent checks the checkboxes in the group. Pass it to render the parent right on the server.
- `disabled?` (`boolean`): Disables every checkbox in the group, and leaves them out of the form.
- `readOnly?` (`boolean`): Makes every checkbox in the group read-only: focusable and submitted, but presses don't change it.
- `required?` (`boolean`): Blocks form submission until at least one checkbox is checked, with the browser's own message.
- `name?` (`string`): The name every checkbox in the group submits under.
- `form?` (`string`): The id of a form to belong to, when the group isn't inside that form.
- `controller?` (`{ getValue: () => T[]; setValue: (value: T[], details?: Details) => boolean; focus: () => void; }`): Checks values from anywhere. Create one with `createCheckboxGroupController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### State

What `@render={{true}}` yields as `state`.

- `checked` (`boolean`): Whether it's checked. False while indeterminate.
- `indeterminate` (`boolean`): Whether it's `"indeterminate"`, for a partly checked group. A press makes it checked.
- `disabled` (`boolean`): Whether it's disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether it's read-only: it stays focusable and submitted, but presses don't change it.
- `required` (`boolean`): Whether a form won't submit until it's checked. Indeterminate doesn't count.

The indicator receives the same state.

- `checked` (`boolean`): Whether it's checked. False while indeterminate.
- `indeterminate` (`boolean`): Whether it's `"indeterminate"`, for a partly checked group. A press makes it checked.
- `disabled` (`boolean`): Whether it's disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether it's read-only: it stays focusable and submitted, but presses don't change it.
- `required` (`boolean`): Whether a form won't submit until it's checked. Indeterminate doesn't count.

The group:

- `value` (`string[]`): The checked values.
- `disabled` (`boolean`): Whether the group is disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether the group is read-only: its checkboxes stay focusable and submitted, but presses don't change them.
- `required` (`boolean`): Whether a form won't submit until at least one of its checkboxes is checked.

### Reasons

`details.reason` says why the checked state changed.

- `press` (`MouseEvent | KeyboardEvent`): A single-element control was pressed: a checkbox, a switch or a toggle.
- `reset` (`none`): A form reset.
- `restore` (`none`): The browser restored state, like after going back, or a saved value was read back from storage.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

For a group, it says why the checked values changed.

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `reset` (`none`): A form reset.
- `restore` (`none`): The browser restored state, like after going back, or a saved value was read back from storage.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Checkbox Controller

Create one with `createCheckboxController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

- `toggle(details?)` (`(details?: CheckboxChangeOptions | undefined) => boolean`): Checks it, or unchecks it. An indeterminate checkbox becomes checked.
- `getChecked()` (`() => CheckedState`): Whether it's checked: `true`, `false` or `"indeterminate"`.
- `setChecked(checked, details?)` (`(checked: CheckedState, details?: CheckboxChangeOptions | undefined) => boolean`): Sets whether it's checked, as a user would.
- `focus()` (`() => void`): Moves focus to it.

### CheckboxGroup Controller

Create one with `createCheckboxGroupController()` and pass it as `@controller`.

Its write methods work like the checkbox controller's.

- `getValue()` (`() => T[]`): The checked values.
- `setValue(value, details?)` (`(value: T[], details?: CheckboxGroupChangeOptions | undefined) => boolean`): Sets the checked values, as a user would. A disabled group ignores it.
- `focus()` (`() => void`): Moves focus to the first enabled checkbox.

### Events

Callbacks get the new state or value first, then the details.

| Argument           | On              | Receives                                                                               |
| ------------------ | --------------- | -------------------------------------------------------------------------------------- |
| `@onCheckedChange` | `Checkbox`      | `(checked, details)`: `true`, `false` or `"indeterminate"`, and the [reason](#reasons) |
| `@onValueChange`   | `CheckboxGroup` | `(value, details)`: the checked values, and the [reason](#reasons)                     |

## Accessibility

The checkbox follows the [WAI-ARIA checkbox pattern](https://www.w3.org/WAI/ARIA/apg/patterns/checkbox/), and a group's parent checkbox follows its [mixed checkbox example](https://www.w3.org/WAI/ARIA/apg/patterns/checkbox/examples/checkbox-mixed/). `Checkbox` renders a button with the `checkbox` role, and a hidden native checkbox that takes part in forms. Every line below is an automated test.

### Keyboard

| Key   | Does                                         |
| ----- | -------------------------------------------- |
| Tab   | Moves to the next checkbox                   |
| Space | Checks or unchecks it, or checks a mixed one |
| Enter | Submits its form                             |

### Tested Behavior

**Checkbox**

- Clicking toggles it.
- Clicking its label toggles it.
- Clicking a label around it toggles it once.
- Space toggles it.
- Enter submits the form and never toggles it.
- Tab moves through checkboxes in order.
- The indicator shows only while checked.
- A change can be cancelled.
- A controlled checkbox follows its value.
- A read-only checkbox can be focused but not changed.
- Exit keyframes keyed on data-unchecked play before the indicator unmounts.
- An infinite exit animation still unmounts the indicator.

Runs in React, Vue and web components.

Groups and parent checkboxes:

- The group is named by its label.
- Starts on its default value.
- Checking a checkbox adds its value to the group.
- Every checked value submits under the group's name, in order.
- A reset returns to the default value.
- A required group blocks submission until one is checked.

**Parent checkbox**

- Is mixed while some checkboxes are checked.
- Checks every checkbox from mixed, then unchecks them all.
- Is checked once every checkbox is.
- Submits nothing itself.

Runs in React, Vue and web components.

In forms:

- The form submits every checked control's name and value.
- Unchecked controls submit nothing.
- A checkbox outside the form joins it with the form attribute.
- Required controls block submission.
- A form reset returns every control to its default.
- A reset returns to the default value, not to nothing.
- A disabled fieldset disables the controls inside it.
- A read-only control still submits.
- A user's change fires native input and change events on the form.

Runs in React, Vue and web components.

Beyond the pattern's baseline:

**Enhancements**

- The first invalid control takes focus in document order.
- A later required field without an error part doesn't take focus from the first.

**Form-associated custom elements**

- Take part in the form with no hidden input. Web components only.
- Report validity like native controls. Web components only.
- Have live checked and value properties. Web components only.
- Are named by their labels. Web components only.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while checking boxes with a keyboard.
- Announcements while choosing a radio with a keyboard.

Runs in React, Vue and web components.
