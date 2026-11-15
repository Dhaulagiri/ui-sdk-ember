# Switch

Turn a setting on or off.

Use a switch for a setting that takes effect as soon as it changes, like Airplane mode or a notification preference. Keep its label the same in both states: the label says what the setting is, and the switch shows whether it's on.

```glimmer-ts title="basic.gts"
import { Switch } from "ember-ui-sdk/switch"

<template>
  <label data-slot="label">
    Airplane mode
    <Switch as |s|>
      <s.Thumb />
    </Switch>
  </label>
</template>
```

Click Airplane mode, or focus the switch and press Space, to turn it on and off.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Switch`:

```text
Switch as |s|
└── s.Thumb
```

Wrap the switch and its text in a label. The thumb stays mounted and gets the switch's state, so CSS can slide it from one end to the other.

## Usage

Import the root and use the parts it yields:

```gts
import { Switch } from "ember-ui-sdk/switch"

<template>
  <label>
    Airplane mode
    <Switch as |s|>
      <s.Thumb />
    </Switch>
  </label>
</template>
```

## Description

Use `Field` with its `f.Label` and `f.Description` when a setting needs more explanation. The field connects both to the switch.

```glimmer-ts title="description.gts"
import { Field } from "ember-ui-sdk/field"
import { Switch } from "ember-ui-sdk/switch"

<template>
  <Field as |f|>
    <div data-slot="stack">
      <f.Label>Weekly digest</f.Label>
      <f.Description>A summary of your week, every Monday.</f.Description>
    </div>
    <Switch @field={{f.field}} as |s|>
      <s.Thumb />
    </Switch>
  </Field>
</template>
```

Click Weekly digest. The field connects the label and description to the switch.

## Choice Card

A setting can fill a whole card. Here the label's `::after` covers the card, so a click anywhere on it toggles the switch, and `:has([data-checked])` marks the cards that are on.

```glimmer-ts title="choice-card.gts"
import { Field } from "ember-ui-sdk/field"
import { Switch } from "ember-ui-sdk/switch"

const settings = [
  {
    label: "Public profile",
    description: "Anyone can see your name and photo.",
    defaultChecked: false,
  },
  {
    label: "Show activity status",
    description: "Teammates can see when you're online.",
    defaultChecked: true,
  },
]

<template>
  <div data-slot="stack">
    {{#each settings key="label" as |setting|}}
      <Field data-variant="card" as |f|>
        <div data-slot="stack">
          <f.Label>{{setting.label}}</f.Label>
          <f.Description>{{setting.description}}</f.Description>
        </div>
        <Switch @defaultChecked={{setting.defaultChecked}} @field={{f.field}} as |s|>
          <s.Thumb />
        </Switch>
      </Field>
    {{/each}}
  </div>
</template>
```

Click anywhere on the Public profile card to turn it on. Each card's switch keeps its own value.

## Disabled

`@disabled={{true}}` prevents focus and changes, and leaves the switch out of form submissions. A disabled `fieldset` does the same.

```glimmer-ts title="disabled.gts"
import { Switch } from "ember-ui-sdk/switch"

<template>
  <div data-slot="stack">
    <label data-slot="label">
      Product updates
      <Switch as |s|>
        <s.Thumb />
      </Switch>
    </label>
    <label data-slot="label">
      Security alerts
      <Switch @defaultChecked={{true}} @disabled={{true}} as |s|>
        <s.Thumb />
      </Switch>
    </label>
  </div>
</template>
```

Security alerts are always on, so that switch is disabled. Clicking it leaves it on, and Tab skips it.

## Read-Only

`@readOnly={{true}}` keeps the switch focusable and included in form submissions, while preventing the user from changing it. Use it for a setting managed somewhere else.

```glimmer-ts title="read-only.gts"
import { Field } from "ember-ui-sdk/field"
import { Switch } from "ember-ui-sdk/switch"

<template>
  <Field as |f|>
    <div data-slot="stack">
      <f.Label>Encrypt backups</f.Label>
      <f.Description>Your organization manages this setting.</f.Description>
    </div>
    <Switch @name="encrypt" @defaultChecked={{true}} @readOnly={{true}} @field={{f.field}} as |s|>
      <s.Thumb />
    </Switch>
  </Field>
</template>
```

Tab to Encrypt backups. Space and clicks leave it on.

## Controlled

Pass `@checked` and update it in `@onCheckedChange` to own the value. A [controller](#controller), from `createSwitchController()` and passed as `@controller`, changes it from anywhere, like the Toggle button below.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Switch, createSwitchController } from "ember-ui-sdk/switch"
import { useLog } from "./log"

export default class Controlled extends Component {
  log = useLog(this)
  wifi = createSwitchController()
  @tracked checked = true

  toggle = () => this.wifi.toggle()

  onCheckedChange = (next: boolean, details: { reason: string }) => {
    this.checked = next
    this.log(`${next ? "On" : "Off"} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.toggle}}>Toggle</button>
      </div>
      <label data-slot="label">
        Wi-Fi
        <Switch
          @checked={{this.checked}}
          @onCheckedChange={{this.onCheckedChange}}
          @controller={{this.wifi}}
          as |s|
        >
          <s.Thumb />
        </Switch>
      </label>
    </div>
  </template>
}
```

Turn Wi-Fi off, or press Toggle. The console logs each change and its reason.

## Form

Set `@name` to include the switch in a native form. A switch that's on submits its `@value`, which defaults to `"on"`; a switch that's off submits nothing. Reset returns it to `@defaultChecked`. Set `@form` to a form's id to join it from elsewhere on the page.

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { FieldSet } from "ember-ui-sdk/field"
import { Switch } from "ember-ui-sdk/switch"
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
      <FieldSet as |s|>
        <s.Legend>Email notifications</s.Legend>
        <label data-slot="label">
          Product updates
          <Switch @name="updates" as |s|>
            <s.Thumb />
          </Switch>
        </label>
        <label data-slot="label">
          Security alerts
          <Switch @name="security" @defaultChecked={{true}} as |s|>
            <s.Thumb />
          </Switch>
        </label>
        <label data-slot="label">
          Weekly digest
          <Switch @name="digest" @value="weekly" @defaultChecked={{true}} as |s|>
            <s.Thumb />
          </Switch>
        </label>
      </FieldSet>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Save</button>
        <button type="reset">Reset</button>
      </div>
    </form>
  </template>
}
```

Turn on Product updates and press Save. The console logs the submitted values, and Reset restores the defaults.

## Validation

`@required={{true}}` blocks submission until the switch is on. In a `Field`, `f.Error` shows the message under the switch and connects it to the switch.

```glimmer-ts title="invalid.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { Switch } from "ember-ui-sdk/switch"
import { useLog } from "./log"

export default class Invalid extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Submitted two-factor=${new FormData(event.currentTarget as HTMLFormElement).get("two-factor")}`
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <div data-slot="row">
          <div data-slot="stack">
            <f.Label>Two-factor authentication</f.Label>
            <f.Description>Required for admins of this workspace.</f.Description>
          </div>
          <Switch @name="two-factor" @required={{true}} @field={{f.field}} as |s|>
            <s.Thumb />
          </Switch>
        </div>
        <f.Error @match="valueMissing">Turn this on to continue.</f.Error>
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Continue</button>
      </div>
    </form>
  </template>
}
```

Press Continue with the switch off to see the error. Turn on Two-factor authentication and continue; the console logs the submitted value.

## Saving on Toggle

To save a change before it shows, call `details.cancel()` in `@onCheckedChange` to keep the current value while the save runs. When it finishes, call `controller.setChecked(next, { reason: "imperative" })`, and let that reason through in the callback so the saved value commits.

The example ignores presses while a save is running, and shows a spinner in the thumb. `aria-busy` tells assistive technology the switch is busy; the callback is what blocks another change.

```glimmer-ts title="async.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Switch, createSwitchController } from "ember-ui-sdk/switch"
import { LoaderCircle } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const save = (_checked: boolean) =>
  new Promise((resolve) => setTimeout(resolve, 800))

export default class Async extends Component {
  log = useLog(this)
  backups = createSwitchController()
  @tracked saving = false

  onCheckedChange = (
    next: boolean,
    details: { reason: string; cancel: () => void }
  ) => {
    if (details.reason === "imperative") {
      return
    }
    details.cancel()
    if (this.saving) {
      return
    }
    this.saving = true
    this.log("Saving…")
    save(next).then(() => {
      this.backups.setChecked(next, { reason: "imperative" })
      this.saving = false
      this.log(`Saved: ${next ? "on" : "off"}`)
    })
  }

  <template>
    <label data-slot="label">
      Automatic backups
      <Switch
        @controller={{this.backups}}
        aria-busy={{if this.saving "true" "false"}}
        @onCheckedChange={{this.onCheckedChange}}
        as |s|
      >
        <s.Thumb>
          {{#if this.saving}}
            <span data-slot="spinner">{{icon LoaderCircle}}</span>
          {{/if}}
        </s.Thumb>
      </Switch>
    </label>
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

Turn on Automatic backups. The thumb shows a spinner while it saves, then the switch turns on.

## Custom Rendering

Pass `@render={{true}}` to the switch or its thumb to render your own element. The part yields `{ part, state }`: bind `part` to the element so its role, label and keyboard behavior stay connected, and read `state` to change its content. See [Parts and Composition](#custom-rendering) for the rendering contract.

```glimmer-ts title="render.gts"
import { Switch } from "ember-ui-sdk/switch"
import { Moon, Sun } from "lucide"
import { icon } from "./icon"

<template>
  <label data-slot="label">
    Dark mode
    <Switch as |s|>
      <s.Thumb @render={{true}} as |t|>
        <span {{t.part}}>
          {{#if t.state.checked}}{{icon Moon}}{{else}}{{icon Sun}}{{/if}}
        </span>
      </s.Thumb>
    </Switch>
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

Turn on Dark mode. The thumb renders a sun or a moon from its state.

## Styling

Style the switch and its thumb with `data-checked` and `data-unchecked`, and use `data-disabled`, `data-readonly` and `data-required` for the rest. In an invalid field, the switch also gets `data-invalid` and `aria-invalid`; the thumb doesn't. Slide the thumb with `translate` on `data-checked`, and reverse it under `dir="rtl"`.

Each part has a `data-slot`, such as `switch`, and its state attributes are listed under [Data Attributes](#data-attributes).

## Data Attributes

### Switch
`[data-slot="switch"]`

- `data-checked`: Present while on.
- `data-disabled`: Present when disabled, by its own prop or a `<fieldset>`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-unchecked`: Present while off.
- `data-invalid`: Present while a `Field` around it shows as invalid. The thumb doesn't get it.

### SwitchThumb
`[data-slot="switch-thumb"]`

- `data-checked`: Present while on.
- `data-disabled`: Present when disabled, by its own prop or a `<fieldset>`.
- `data-readonly`: Present when read-only.
- `data-required`: Present when required.
- `data-unchecked`: Present while off.

## API Reference

Options and callbacks are the same as below, as arguments: `@checked`, `@onCheckedChange`. Every part also takes `@render`.

### Switch

- `checked?` (`boolean`): Whether it's checked. Pass it to control the checkbox.
- `defaultChecked?` (`boolean`): Whether it's checked at first, when uncontrolled. A form reset returns to it.
- `onCheckedChange?` (`((checked: boolean, details: ChangeDetails<CheckboxCheckedChangeReason>) => void)`): Runs when a user or a form reset wants to change it. `details.reason` says why, and `details.cancel()` stops it.
- `disabled?` (`boolean`): Disables it like a native control: it can't be focused or changed, and isn't submitted.
- `readOnly?` (`boolean`): Keeps it focusable and submitted, but stops changes.
- `required?` (`boolean`): Blocks form submission until it's checked, with the browser's own message.
- `name?` (`string`): The name it submits under. Without one, it submits nothing.
- `value?` (`string`): What it submits while checked.
- `form?` (`string`): The id of a form to belong to, when it isn't inside that form.
- `controller?` (`{ toggle: (details?: Details) => boolean; getChecked: () => boolean; setChecked: (checked: boolean, details?: Details) => boolean; focus: () => void; }`): Toggles it from anywhere. Create one with `createSwitchController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### State

What `@render={{true}}` yields as `state`. The thumb's state, `SwitchThumbState`, is the same.

- `checked` (`boolean`): Whether it's checked. False while indeterminate.
- `disabled` (`boolean`): Whether it's disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether it's read-only: it stays focusable and submitted, but presses don't change it.
- `required` (`boolean`): Whether a form won't submit until it's checked. Indeterminate doesn't count.

### Reasons

`details.reason` says why the switch turned on or off.

- `press` (`MouseEvent | KeyboardEvent`): A single-element control was pressed: a checkbox, a switch or a toggle.
- `reset` (`none`): A form reset.
- `restore` (`none`): The browser restored state, like after going back, or a saved value was read back from storage.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createSwitchController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, runs the change callback like a press, and returns `false` when the change is canceled.

- `toggle(details?)` (`(details?: CheckboxChangeOptions | undefined) => boolean`): Turns it on, or off.
- `getChecked()` (`() => boolean`): Whether it's on.
- `setChecked(checked, details?)` (`(checked: boolean, details?: CheckboxChangeOptions | undefined) => boolean`): Turns it on or off, as a user would.
- `focus()` (`() => void`): Moves focus to it.

### Events

Callbacks get the new state first, then the details.

| Argument           | On       | Receives                                                        |
| ------------------ | -------- | --------------------------------------------------------------- |
| `@onCheckedChange` | `Switch` | `(checked, details)`: the new state, and the [reason](#reasons) |

## Accessibility

The switch follows the [WAI-ARIA switch pattern](https://www.w3.org/WAI/ARIA/apg/patterns/switch/). `Switch` renders a button with the `switch` role, and a hidden native checkbox that takes part in forms.

### Keyboard

| Key   | Does                                   |
| ----- | -------------------------------------- |
| Tab   | Moves to the next switch               |
| Space | Turns it on or off                     |
| Enter | Submits its form, and never toggles it |

### Tested Behavior

Every line below is an automated test.

- Starts in its default state.
- Clicking toggles it.
- Clicking its label toggles it.
- Space toggles it.
- Enter submits the form and never toggles it.
- The thumb follows the state.

**The first input on a page**

- The first Space reports keyboard.

**On a touch screen**

- The first tap reports touch.

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
