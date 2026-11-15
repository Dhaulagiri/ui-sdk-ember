# Listbox

Choose one or several options from an always-visible list.

Use a Listbox when the choices should stay in view. It works like a native select with several visible rows, with keyboard navigation, typeahead, and optional range selection.

```glimmer-ts title="basic.gts"
import { array } from "@ember/helper"
import { Field } from "ember-ui-sdk/field"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "./icon"

const topics = [
  { value: "comments", label: "Comments" },
  { value: "mentions", label: "Mentions" },
  { value: "reactions", label: "Reactions" },
  { value: "sign-ins", label: "New sign-ins" },
  { value: "billing", label: "Billing" },
]

<template>
  <Field as |f|>
    <f.Label>Email me about</f.Label>
    <Listbox
      @multiple={{true}}
      @activation="automatic"
      @defaultValue={{array "mentions"}}
      @field={{f.field}}
      as |l|
    >
      {{#each topics key="value" as |topic|}}
        <l.Item @value={{topic.value}} as |i|>
          {{topic.label}}
          <i.Indicator>{{icon Check}}</i.Indicator>
        </l.Item>
      {{/each}}
    </Listbox>
    <f.Description>Hold Shift to select a range, or Ctrl or ⌘ to add one.</f.Description>
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

Choose Comments, then hold Shift and choose New sign-ins to select the range. A click replaces the selection; Ctrl or ⌘ adds one option.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Listbox`:

```text
Listbox as |l|
├── l.Item as |i|
│   └── i.Indicator
└── l.Item as |i|
    └── i.Indicator
```

Give the list an accessible name and each option a unique `@value`. `i.Indicator` shows its content when that option is selected.

You can also name the list with a [Field label](./field.md) or `aria-labelledby`. Keep buttons, search fields, and empty messages outside the list: its contents should be options, groups, and separators.

## Usage

Import the root and use the parts it yields:

```gts
import { Listbox } from "ember-ui-sdk/listbox"

<template>
  <Listbox aria-label="Toppings" @defaultValue="basil" as |l|>
    <l.Item @value="basil" as |i|>
      Basil
      <i.Indicator>✓</i.Indicator>
    </l.Item>
    <l.Item @value="olive" as |i|>
      Olive
      <i.Indicator>✓</i.Indicator>
    </l.Item>
  </Listbox>
</template>
```

`ember-ui-sdk/listbox` also exports each part by name, such as `ListboxItem` and `ListboxItemIndicator`.

## Multiple

Add `@multiple={{true}}` to select several options. The value becomes an array; a single list uses one value or `null`. By default, arrow keys move focus without changing a multiple selection.

| Action                             | Result                                                 |
| ---------------------------------- | ------------------------------------------------------ |
| Press an option or Space           | Toggle that option.                                    |
| Shift + press, arrow key, or Space | Select a range from the last chosen option.            |
| Ctrl/Cmd + Shift + Home or End     | Extend the range to the first or last option.          |
| Ctrl/Cmd + A                       | Select every enabled option, then clear the selection. |

Changing a Shift range preserves the options selected before that range began.

```glimmer-ts title="multiple.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const toppings = [
  { value: "basil", label: "Basil" },
  { value: "cheese", label: "Extra cheese" },
  { value: "mushroom", label: "Mushroom" },
  { value: "olive", label: "Olive" },
  { value: "onion", label: "Onion" },
  { value: "pepper", label: "Pepper" },
]

export default class Multiple extends Component {
  log = useLog(this)

  onValueChange = (value: string[], details: { reason: string }) => {
    this.log(`${value.join(", ") || "Nothing"} (${details.reason})`)
  }

  <template>
    <Listbox
      @multiple={{true}}
      @defaultValue={{array "cheese" "onion"}}
      @onValueChange={{this.onValueChange}}
      aria-label="Toppings"
      as |l|
    >
      {{#each toppings key="value" as |topping|}}
        <l.Item @value={{topping.value}} as |i|>
          {{topping.label}}
          <i.Indicator>{{icon Check}}</i.Indicator>
        </l.Item>
      {{/each}}
    </Listbox>
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

Choose Basil, then hold Shift and choose Pepper to select a range. Use Ctrl+A or ⌘A to select every option, then again to clear. The console logs each change.

## Selection That Follows Focus

A single list selects as arrow keys, Home, End, or typing move focus. A multiple list can do the same with `@activation="automatic"`, like a file list: a press or arrow replaces the selection, Ctrl or Cmd adds to it, and Ctrl or Cmd with an arrow moves focus without selecting.

Taps and screen-reader presses toggle an option instead, since they do not have modifier keys.

```gts
<Listbox @multiple={{true}} @activation="automatic" aria-label="Files" as |l|>…</Listbox>
```

```glimmer-ts title="activation.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { Listbox } from "ember-ui-sdk/listbox"
import { File } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const files = [
  { value: "readme", label: "README.md" },
  { value: "package", label: "package.json" },
  { value: "tsconfig", label: "tsconfig.json" },
  { value: "index", label: "index.ts" },
  { value: "styles", label: "styles.css" },
  { value: "logo", label: "logo.svg" },
]

export default class Activation extends Component {
  log = useLog(this)

  onValueChange = (value: string[], details: { reason: string }) => {
    this.log(`${value.length} selected (${details.reason})`)
  }

  <template>
    <Listbox
      @multiple={{true}}
      @activation="automatic"
      @defaultValue={{array "readme"}}
      @onValueChange={{this.onValueChange}}
      aria-label="Files"
      as |l|
    >
      {{#each files key="value" as |file|}}
        <l.Item @value={{file.value}} as |i|>
          <i.Icon>{{icon File}}</i.Icon>
          {{file.label}}
        </l.Item>
      {{/each}}
    </Listbox>
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

Choose index.ts to replace the selection. Hold Ctrl or Cmd while choosing another file to add it; Shift selects a range.

## Manual Activation

Set `@activation="manual"` on a single list to browse without selecting. Space, Enter, or a press chooses the focused option.

```glimmer-ts title="manual.gts"
import Component from "@glimmer/component"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "nuxt", label: "Nuxt" },
  { value: "sveltekit", label: "SvelteKit" },
]

export default class Manual extends Component {
  log = useLog(this)

  onValueChange = (value: string | null, details: { reason: string }) => {
    this.log(`${value ?? "Nothing"} (${details.reason})`)
  }

  <template>
    <Listbox @activation="manual" @onValueChange={{this.onValueChange}} aria-label="Framework" as |l|>
      {{#each frameworks key="value" as |framework|}}
        <l.Item @value={{framework.value}} as |i|>
          {{framework.label}}
          <i.Indicator>{{icon Check}}</i.Indicator>
        </l.Item>
      {{/each}}
    </Listbox>
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

Move through the options with the arrow keys. Nothing is selected until you press Space or Enter, and the console logs the choice.

## Deselectable

Add `@deselectable={{true}}` to let pressing the selected option clear a single selection. Without it, the selection stays as it is.

```glimmer-ts title="deselectable.gts"
import Component from "@glimmer/component"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "nuxt", label: "Nuxt" },
  { value: "sveltekit", label: "SvelteKit" },
]

export default class Deselectable extends Component {
  log = useLog(this)

  onValueChange = (value: string | null, details: { reason: string }) => {
    this.log(`${value ?? "Nothing"} (${details.reason})`)
  }

  <template>
    <Listbox
      @deselectable={{true}}
      @defaultValue="astro"
      @onValueChange={{this.onValueChange}}
      aria-label="Framework"
      as |l|
    >
      {{#each frameworks key="value" as |framework|}}
        <l.Item @value={{framework.value}} as |i|>
          {{framework.label}}
          <i.Indicator>{{icon Check}}</i.Indicator>
        </l.Item>
      {{/each}}
    </Listbox>
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

Press Astro again to clear the selection, or choose another framework. The console logs each change.

## Groups

Use `l.Group` with `g.Label` to name a group. Arrow keys and ranges continue across groups. Separators stay out of the accessibility tree.

```glimmer-ts title="groups.gts"
import { array } from "@ember/helper"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "./icon"

const produce = [
  {
    label: "Fruits",
    items: [
      { value: "apple", label: "Apple" },
      { value: "banana", label: "Banana" },
      { value: "orange", label: "Orange" },
    ],
  },
  {
    label: "Vegetables",
    items: [
      { value: "carrot", label: "Carrot" },
      { value: "broccoli", label: "Broccoli" },
      { value: "spinach", label: "Spinach" },
    ],
  },
]

<template>
  <Listbox @multiple={{true}} @defaultValue={{array "banana"}} aria-label="Produce" as |l|>
    {{#each produce key="label" as |group index|}}
      {{#if index}}
        <l.Separator />
      {{/if}}
      <l.Group as |g|>
        <g.Label>{{group.label}}</g.Label>
        {{#each group.items key="value" as |item|}}
          <g.Item @value={{item.value}} as |i|>
            {{item.label}}
            <i.Indicator>{{icon Check}}</i.Indicator>
          </g.Item>
        {{/each}}
      </l.Group>
    {{/each}}
  </Listbox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Move from Apple through the list with Down Arrow. Navigation continues into the Vegetables group.

## Icons

Wrap an icon in `i.Icon` so screen readers and typeahead skip it. Add `@mirror={{true}}` to a directional icon to flip it in right-to-left text.

```glimmer-ts title="icons.gts"
import { Listbox } from "ember-ui-sdk/listbox"
import { Archive, ArrowRight, Mail, Pencil, Star } from "lucide"
import { icon } from "./icon"

const views = [
  { value: "inbox", label: "Inbox", icon: Mail, mirror: false },
  { value: "starred", label: "Starred", icon: Star, mirror: false },
  { value: "drafts", label: "Drafts", icon: Pencil, mirror: false },
  { value: "archive", label: "Archive", icon: Archive, mirror: false },
  { value: "next", label: "Next page", icon: ArrowRight, mirror: true },
]

<template>
  <Listbox @defaultValue="inbox" aria-label="Mailbox" as |l|>
    {{#each views key="value" as |view|}}
      <l.Item @value={{view.value}} as |i|>
        <i.Icon @mirror={{view.mirror}}>{{icon view.icon}}</i.Icon>
        {{view.label}}
      </l.Item>
    {{/each}}
  </Listbox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose Drafts. The icon stays out of the option’s accessible name and the text used for typeahead.

## Horizontal

Set `@orientation="horizontal"` to move with Left and Right Arrow. Arrow keys normally wrap; set `@loop={{false}}` to stop at the ends, as this example does. Shift ranges never wrap.

The list reads `dir="rtl"` from the page or an ancestor, so Left Arrow moves to the next option in right-to-left text.

```glimmer-ts title="horizontal.gts"
import { Listbox } from "ember-ui-sdk/listbox"

const sizes = [
  { value: "xs", label: "XS" },
  { value: "s", label: "S" },
  { value: "m", label: "M" },
  { value: "l", label: "L" },
  { value: "xl", label: "XL", disabled: true },
]

<template>
  <Listbox @orientation="horizontal" @loop={{false}} @defaultValue="m" aria-label="Size" as |l|>
    {{#each sizes key="value" as |size|}}
      <l.Item @value={{size.value}} @disabled={{size.disabled}}>
        {{size.label}}
      </l.Item>
    {{/each}}
  </Listbox>
</template>
```

Focus M, then use Left and Right Arrow to choose a size. The list stops at its ends; XL cannot be selected.

## Disabled

A disabled option cannot be selected. Arrow keys, typeahead and ranges skip it. Disabling the whole list removes its tab stop, prevents changes, and excludes its value from the form.

```glimmer-ts title="disabled.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "./icon"

const toppings = [
  { value: "basil", label: "Basil" },
  { value: "cheese", label: "Extra cheese" },
  { value: "mushroom", label: "Mushroom" },
  { value: "olive", label: "Olive" },
  { value: "onion", label: "Onion" },
  { value: "pepper", label: "Pepper" },
]

export default class Disabled extends Component {
  @tracked disabled = false

  toggle = () => {
    this.disabled = !this.disabled
  }

  isOlive = (value: string) => value === "olive"

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.toggle}}>
          {{if this.disabled "Enable the List" "Disable the List"}}
        </button>
      </div>
      <Listbox
        @multiple={{true}}
        @disabled={{this.disabled}}
        @defaultValue={{array "basil"}}
        aria-label="Toppings"
        as |l|
      >
        {{#each toppings key="value" as |topping|}}
          <l.Item @value={{topping.value}} @disabled={{this.isOlive topping.value}} as |i|>
            {{topping.label}}
            <i.Indicator>{{icon Check}}</i.Indicator>
          </l.Item>
        {{/each}}
      </Listbox>
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

Try choosing Olive. Then press Disable the List to make every option unavailable until you enable it again.

## Read-Only

Use `@readOnly={{true}}` when people should be able to browse the list without changing its value. The list remains focusable and its value still submits.

```glimmer-ts title="read-only.gts"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "./icon"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "nuxt", label: "Nuxt" },
  { value: "sveltekit", label: "SvelteKit" },
]

<template>
  <Listbox @readOnly={{true}} @defaultValue="nuxt" aria-label="Framework" as |l|>
    {{#each frameworks key="value" as |framework|}}
      <l.Item @value={{framework.value}} as |i|>
        {{framework.label}}
        <i.Indicator>{{icon Check}}</i.Indicator>
      </l.Item>
    {{/each}}
  </Listbox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Move focus through the frameworks. Nuxt stays selected because the list is read-only.

## Form

Add `@name` to submit the selection. Multiple selections submit one entry per value. Reset restores `@defaultValue`, and `@required={{true}}` prevents submission when nothing is selected.

The server HTML includes the hidden inputs for the current selection, so those values can submit before hydration.

The list can live outside its form: set `@form` to the form’s ID, as this example does. A disabled fieldset also disables the list.

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { on } from "@ember/modifier"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const toppings = [
  { value: "basil", label: "Basil" },
  { value: "cheese", label: "Extra cheese" },
  { value: "mushroom", label: "Mushroom" },
  { value: "olive", label: "Olive" },
  { value: "onion", label: "Onion" },
  { value: "pepper", label: "Pepper" },
]

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Ordered ${new FormData(event.currentTarget as HTMLFormElement).getAll("toppings").join(", ")}`
    )
  }

  <template>
    <div data-slot="stack">
      <Listbox
        @multiple={{true}}
        @name="toppings"
        @form="pizza-order"
        @required={{true}}
        @defaultValue={{array "cheese"}}
        aria-label="Toppings"
        as |l|
      >
        {{#each toppings key="value" as |topping|}}
          <l.Item @value={{topping.value}} as |i|>
            {{topping.label}}
            <i.Indicator>{{icon Check}}</i.Indicator>
          </l.Item>
        {{/each}}
      </Listbox>
      <form id="pizza-order" data-slot="row" {{on "submit" this.onSubmit}}>
        <button type="reset">Reset</button>
        <button data-variant="solid">Order</button>
      </form>
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

Choose Basil and press Order: the console logs both toppings. Reset restores Extra cheese; clearing every option makes the required list block the order.

## Object Values

Pass objects as item values when the selection should carry more than an ID. `@itemToValue` provides the string used for identity and form submission; `@isItemEqualToValue` matches objects that represent the same option but are different instances.

```glimmer-ts title="data.gts"
import Component from "@glimmer/component"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const plans = [
  { value: { id: "hobby", price: 0 }, label: "Hobby" },
  { value: { id: "pro", price: 20 }, label: "Pro" },
  { value: { id: "team", price: 50 }, label: "Team" },
  {
    value: { id: "enterprise", price: 200 },
    label: "Enterprise",
    disabled: true,
  },
]

const defaultPlan = plans[1].value

export default class Data extends Component {
  log = useLog(this)
  plans = plans
  defaultPlan = defaultPlan

  onValueChange = (plan: { id: string; price: number } | null) => {
    this.log(plan ? `${plan.id}, $${plan.price} a month` : "No plan")
  }

  itemToValue = (plan: { id: string }) => plan.id

  isItemEqualToValue = (plan: { id: string }, selected: { id: string }) =>
    plan.id === selected.id

  <template>
    <Listbox
      @items={{this.plans}}
      @defaultValue={{this.defaultPlan}}
      @onValueChange={{this.onValueChange}}
      @itemToValue={{this.itemToValue}}
      @isItemEqualToValue={{this.isItemEqualToValue}}
      aria-label="Plan"
      as |l|
    >
      {{#each this.plans key="value.id" as |plan|}}
        <l.Item @value={{plan.value}} @disabled={{plan.disabled}} as |i|>
          {{plan.label}}
          <i.Indicator>{{icon Check}}</i.Indicator>
        </l.Item>
      {{/each}}
    </Listbox>
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

Choose Team. The console logs the price from the selected object, not from its string ID.

To keep markup and classes explicit, map the data into parts, as the example does.

## Controller

A controller can select all options, clear the selection, or focus the list from another control. Create one with `createListboxController()` and pass it as `@controller`.

```glimmer-ts title="controller.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Listbox, createListboxController } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const toppings = [
  { value: "basil", label: "Basil" },
  { value: "cheese", label: "Extra cheese" },
  { value: "mushroom", label: "Mushroom" },
  { value: "olive", label: "Olive" },
  { value: "onion", label: "Onion" },
  { value: "pepper", label: "Pepper" },
]

export default class Controller extends Component {
  log = useLog(this)
  controller = createListboxController<string, true>()

  selectAll = () => this.controller.selectAll()
  clear = () => this.controller.clear()
  focus = () => this.controller.focus()

  onValueChange = (value: string[], details: { reason: string }) => {
    this.log(`${value.length} selected (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.selectAll}}>Select All</button>
        <button type="button" {{on "click" this.clear}}>Clear</button>
        <button type="button" {{on "click" this.focus}}>Focus</button>
      </div>
      <Listbox
        @multiple={{true}}
        @controller={{this.controller}}
        @onValueChange={{this.onValueChange}}
        aria-label="Toppings"
        as |l|
      >
        {{#each toppings key="value" as |topping|}}
          <l.Item @value={{topping.value}} as |i|>
            {{topping.label}}
            <i.Indicator>{{icon Check}}</i.Indicator>
          </l.Item>
        {{/each}}
      </Listbox>
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

Press Select All, Clear and Focus. Each button drives the same list through its controller, and the console logs the change.

## Scrollable

Give a long list a maximum height and `overflow-y: auto`. It starts scrolled to the selected option without taking focus. Keyboard navigation reveals the focused option without scrolling the page.

```glimmer-ts title="scrollable.gts"
import Component from "@glimmer/component"
import { Listbox } from "ember-ui-sdk/listbox"
import { Check } from "lucide"
import { icon } from "./icon"
import { useLog } from "./log"

const timezones = Array.from({ length: 27 }, (_, index) => {
  const offset = index - 12
  const label = `UTC${offset < 0 ? "−" : "+"}${String(Math.abs(offset)).padStart(2, "0")}:00`
  return { value: `utc${offset}`, label }
})

export default class Scrollable extends Component {
  log = useLog(this)

  onHighlight = (value: string | null, details: { index: number }) => {
    if (value) {
      this.log(
        `Focused ${timezones[details.index].label} (${details.index + 1} of ${timezones.length})`
      )
    }
  }

  <template>
    <Listbox @defaultValue="utc9" @onHighlight={{this.onHighlight}} aria-label="Time zone" as |l|>
      {{#each timezones key="value" as |zone index|}}
        <l.Item @value={{zone.value}} @index={{index}} as |i|>
          {{zone.label}}
          <i.Indicator>{{icon Check}}</i.Indicator>
        </l.Item>
      {{/each}}
    </Listbox>
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

Focus the list and use the arrow keys. Options scroll into view, and the console logs the focused time zone.

For a virtualized list, supply `@items` so typeahead knows about unmounted options. `@onHighlight` reports the focused value and index; each rendered item's `index` places it in the full collection for screen readers.

Set `@keepInView={{false}}` when something else scrolls the list, like a wheel that picks the option at its center. The list then leaves its scroll position alone as keys move focus.

## Custom Rendering

Render an option as a link when choosing it should navigate. Pass `@render={{true}}` to the item and bind its `part` to the link. A press or Enter follows the link and selects the option. This example uses manual activation so arrow keys only browse.

```gts
<l.Item @value="remix" @render={{true}} as |i|>
  <a {{i.part}} href="#remix">Remix</a>
</l.Item>
```

```glimmer-ts title="render.gts"
import Component from "@glimmer/component"
import { Listbox } from "ember-ui-sdk/listbox"
import { ExternalLink } from "lucide"
import { icon } from "./icon"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "nuxt", label: "Nuxt" },
  { value: "sveltekit", label: "SvelteKit" },
]

export default class Render extends Component {
  <template>
    <Listbox @defaultValue="next" @activation="manual" aria-label="Framework docs" as |l|>
      {{#each frameworks key="value" as |framework|}}
        <l.Item @value={{framework.value}} @label={{framework.label}} @render={{true}} as |i|>
          <a {{i.part}} href="#{{framework.value}}">
            <span>{{framework.label}}</span>
            {{#if i.state.selected}}
              {{icon ExternalLink}}
            {{/if}}
          </a>
        </l.Item>
      {{/each}}
    </Listbox>
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

Focus Remix and press Enter, or choose it with the pointer. The option is selected and its link updates the URL hash.

Each part's state is listed [below](#state).

## Styling

Use `data-selected` for the selection and `data-highlighted` for focus. They can describe different options when selection does not follow focus. Disabled and read-only states have their own attributes.

Each part has a `data-slot`, such as `listbox-item`, and its state attributes are listed under [Data Attributes](#data-attributes).

## Data Attributes

`ListboxGroup`, `ListboxGroupLabel` and `ListboxSeparator` have no state attributes.

### Listbox
`[data-slot="listbox"]`

- `data-orientation` (`vertical`, `horizontal`): Which arrow keys move between items.
- `data-disabled`: Present when the listbox is disabled, by its own prop, a Field or a `<fieldset>`.
- `data-readonly`: Present when the listbox is read-only.
- `data-required`: Present when the listbox is required.
- `data-has-icons`: Present while any item inside holds an icon part, so items without one can line up.

### ListboxItem
`[data-slot="listbox-item"]`

- `data-selected`: Present on selected items, and on the check inside them.
- `data-disabled`: Present when the item can't be chosen. It can still be focused.
- `data-highlighted`: Present on the item that has focus.
- `data-has-icon`: Present on an item while it holds an icon part.

### ListboxItemIndicator
`[data-slot="listbox-item-indicator"]`

- `data-selected`: Present on selected items, and on the check inside them.

### ListboxItemIcon
`[data-slot="listbox-item-icon"]`

- `data-mirror`: Present on an icon that flips in right-to-left text, with `mirror`.

## API Reference

Options and callbacks are the same as below, as arguments, such as `@value` and `@onValueChange`. Every part also takes `@render`.

### Listbox

- `activation?` (`"automatic" | "manual"`): Whether the selection follows focus. `"automatic"`: arrow keys, Home, End and typing select the option they move to, and with `multiple` a press replaces the selection while Ctrl or ⌘ adds to it, like a native multiple select. `"manual"`: keys only move focus, and Space, Enter or a press selects, or toggles with `multiple`.
- `deselectable?` (`boolean`): Whether pressing the selected item of a single listbox unselects it, so nothing is selected.
- `orientation?` (`"horizontal" | "vertical"`): Which arrow keys move between items. Horizontal lists use Left and Right, swapped in right-to-left text.
- `loop?` (`boolean`): Whether arrow keys wrap from the last item to the first. Shift with an arrow never wraps.
- `keepInView?` (`boolean`): Whether the list scrolls the option keys move to into view, and the selected option when it first shows. Turn it off when something else scrolls the list, like `bindScrollPicker`.
- `items?` (`ListData<T>`): The items as data. Renders them for you, and lets typing find items a virtualized list hasn't rendered.
- `itemToValue?` (`((value: T) => string)`): The string an item's value submits as and is identified by, for object values. Strings pass through, and objects use their `value` or `id`.
- `isItemEqualToValue?` (`((itemValue: T, value: T) => boolean)`): Whether an item's value is the selected value, for object values that aren't the same object.
- `onHighlight?` (`((value: T | null, details: ListHighlightDetails) => void)`): Runs when focus moves to another item, with its index among the items, so a virtualized list can scroll to it.
- `disabled?` (`boolean`): Disables the listbox like a native control: its items can't be focused or chosen, and the value isn't submitted.
- `readOnly?` (`boolean`): Keeps the listbox focusable and its value submitted, but stops changes.
- `required?` (`boolean`): Blocks form submission until a value is selected, with the browser's own message.
- `name?` (`string`): The name the value submits under. Without one, the listbox submits nothing.
- `form?` (`string`): The id of a form to belong to, when the listbox isn't inside that form.
- `controller?` (`object`): Reads and sets the listbox from anywhere. Create one with `createListboxController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.
- `multiple?` (`boolean`): Whether several items can be selected. The value is then a list, Shift selects ranges, and Ctrl or ⌘ with A selects every item. Whether several items can be selected.
- `value?` (`T | T[] | null`): The selected value. Pass it to control the listbox. `null` selects nothing. The selected values. Pass it to control the listbox. The selected value, or values with `multiple`. Pass it to control the listbox.
- `defaultValue?` (`T | T[] | null`): The value selected at first, when uncontrolled. A form reset returns to it. The values selected at first, when uncontrolled. A form reset returns to them. The value or values selected at first, when uncontrolled. A form reset returns to it.
- `onValueChange?` (`union`): Runs when a user, a form reset or a controller wants to change the value. `details.reason` says why, and `details.cancel()` stops it.

### ListboxItem

- `value` (`T`): What the value becomes when the item is chosen. A string, or any value with `itemToValue`.
- `label?` (`string`): The text typing finds, when the content isn't plain text. Not the accessible name: use `aria-label` for that.
- `disabled?` (`boolean`): Keeps the item from being chosen. Arrow keys, typing and ranges skip it. Sets `data-disabled` and `aria-disabled`.
- `index?` (`number`): The item's position among all items, for virtualized lists that render only some. Sets `aria-posinset` and `aria-setsize`.

### ListboxItemIndicator

- `keepMounted?` (`boolean`): Whether the indicator stays in the page while its item isn't selected, so it can be styled or animated in both states.

### ListboxItemIcon

- `mirror?` (`boolean`): Flips the icon horizontally in right-to-left text, for icons that point a way, like arrows and chevrons. Icons that picture a thing, like a clock or a check, stay as they are.

`ListboxGroup`, `ListboxGroupLabel` and `ListboxSeparator` take no options of their own.

### State

What `@render={{true}}` yields as `state`, per part.

`Listbox`:

- `multiple` (`boolean | undefined`): Whether several items can be selected.
- `orientation` (`"horizontal" | "vertical"`): Which arrow keys move between items.
- `disabled` (`boolean`): Whether the listbox is disabled, by itself, a Field or a `<fieldset>`.
- `readOnly` (`boolean`): Whether the listbox keeps its value but refuses changes, from its `readOnly` option. A form reset still restores it.
- `required` (`boolean`): Whether a value is required.
- `items` (`ListData<unknown>`): The data items, for rendering a virtualized list yourself. Empty without `items`.

`ListboxItem`:

- `highlighted` (`boolean`): Whether the item has focus.
- `selected` (`boolean`): Whether its value is in the listbox's value, compared with `isItemEqualToValue` when you pass one.
- `disabled` (`boolean`): Whether the item can't be chosen, by itself or a disabled listbox.

`ListboxItemIndicator`:

- `selected` (`boolean`): Whether its item is selected. While false, the indicator isn't shown unless `keepMounted` is set.

### Reasons

`details.reason` says why the value changed: `item-press` for a press, Space or Enter, `list-navigation` for keys that select as they move, Shift ranges with arrows and Ctrl or ⌘ with A, `reset` and `restore` from the form, and `imperative` from a controller.

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `reset` (`none`): A form reset.
- `restore` (`none`): The browser restored state, like after going back, or a saved value was read back from storage.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createListboxController()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, passed to `@onValueChange`.

- `getValue()` (`() => ListboxValue<T, Multiple>`): The selected value.
- `setValue(value, options?)` (`(value: ListboxValue<T, Multiple>, options?: ListboxChangeOptions | undefined) => boolean`): Selects a value, as a user would. A disabled or read-only listbox ignores it. Returns false when the change was canceled or nothing changed.
- `clear(options?)` (`(options?: ListboxChangeOptions | undefined) => boolean`): Selects nothing: `null`, or an empty list with `multiple`. Returns false when the change was canceled or nothing changed.
- `selectAll(options?)` (`(options?: ListboxChangeOptions | undefined) => boolean`): Selects every enabled item, with `multiple`. Returns false when the change was canceled or nothing changed.
- `focus()` (`() => void`): Moves focus into the list, onto the option that holds its tab stop.

### Events

Callbacks get the new value first, then the details.

| Argument         | On        | Receives                                                      |
| ---------------- | --------- | ------------------------------------------------------------- |
| `@onValueChange` | `Listbox` | `(value, details)`: the new value, and the [reason](#reasons) |
| `@onHighlight`   | `Listbox` | `(value, details)`: the focused option's value, and its index |

## Accessibility

Follows the [WAI-ARIA listbox pattern](https://www.w3.org/WAI/ARIA/apg/patterns/listbox/), with both of its keyboard models for several options. Options take real focus with one roving tab stop. Every option says whether it's selected.

### Focus

The list is one tab stop. Tab returns to the last focused option, then falls back to the first selected or enabled option. Options receive real DOM focus, so `focus-visible` works directly.

The root forwards focus into the options, including when you press a field label or the list's padding. Escape stays available to an enclosing dialog.

### Tested Behavior

Every line below is an automated test.

**Focus**

- Tab lands on the first option when nothing is selected.
- Tab lands on the selected option.
- Tab lands on the first selected option with multiple.
- The list is one tab stop: Tab leaves it from any option.
- Shift+Tab back into the list returns to the option focused last.
- A press focuses the option.
- Arrow keys skip disabled options.
- A disabled option can't be chosen.
- Arrow keys from a pressed disabled option move to the enabled ones around it.
- Tab lands on the first enabled option when the selected one is disabled.

**Single selection**

- Arrow keys move focus and the selection follows.
- Home and End move to the first and last option.
- Arrow keys wrap from the last option to the first.
- With loop off, arrow keys stop at the ends.
- A press selects the option.
- Pressing the selected option keeps it selected.
- With deselectable, pressing the selected option unselects it.
- With manual activation, arrows only move focus and Space selects.
- Typing moves focus to the next option that starts with it, and selects it.
- Typing several letters finds the option that starts with them.
- Escape leaves the selection alone.

**Multiple selection**

- Presses and Space toggle options.
- Arrow keys move focus without changing the selection.
- Shift with a press selects the range from the last option chosen.
- Shift with an arrow passes over a disabled option.
- A range skips disabled options.
- A second Shift press changes the range, keeping what was selected before it.
- Shift with an arrow key moves focus and extends the selection.
- Shift with Space selects from the last option chosen to the focused one.
- Ctrl+Shift+End selects from the focused option to the last.
- Ctrl+Shift+Home selects from the focused option to the first.
- Ctrl+A selects every enabled option, and again unselects them.
- Ctrl+A does nothing in a single listbox.
- Typing moves focus without selecting.

**Multiple selection with automatic activation**

- A press replaces the selection.
- Ctrl or Cmd with a press adds an option, and removes it again.
- Shift with a press replaces the selection with a range.
- Arrow keys select the option they move to.
- Ctrl or Cmd with an arrow moves focus only, and with Space toggles.
- Shift with an arrow key extends the selection.

**Horizontal**

- Left and Right move between options, and Up and Down don't.

**Groups**

- Arrow keys move across groups, skipping their labels.
- A range crosses groups.

**Form**

- Submits the selected value under its name.
- Submits each value with multiple.
- A reset returns to the default value.
- Required blocks submission until a value is selected.
- A disabled listbox can't be focused or changed, and submits nothing.
- A disabled fieldset disables the listbox.
- A read-only listbox can be browsed but not changed, and submits.

**Changes**

- A canceled change keeps the selection.
- A controlled listbox shows the value it's given.
- The controller clears and selects everything.

Runs in React, Vue and web components.

Beyond the pattern:

- Keys pressed with no waits between them all land.
- Escape leaves the selection alone and reaches a dialog around the list.
- A Shift press after the selection was cleared starts a new range there.
- Shift with an arrow never wraps past the end.
- A Shift press doesn't select the page's text.
- The selected option scrolls into view without taking focus.
- Arrow keys keep the focused option clear of the list's scroll padding at both ends.
- The selected option scrolls into view clear of the list's scroll padding.
- A focused option that leaves the list hands focus back to it, so keys keep working.
- Options that all leave take the tab stop with them, and options that come back hold it again.
- Options the app reorders keep their place in the keys.
- A press on the list's padding gives focus to the option that holds the tab stop.

**Touch**

- Taps toggle where clicks replace, since touch has no modifier keys.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while choosing one option with a keyboard.
- Announcements while choosing several options with a keyboard.

Runs in React, Vue and web components.
