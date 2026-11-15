# Autocomplete

Suggest text while someone types, without limiting what they can enter.

Use Autocomplete for a text field with helpful suggestions. Choosing one fills in the field, but any text is a valid value. Use [Combobox](./combobox.md) when the value should be a selected option instead.

```glimmer-ts title="demo.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

<template>
  <Autocomplete as |c|>
    <div data-slot="stack">
      <c.Label>Favorite fruit</c.Label>
      <c.Input placeholder="e.g. Mango" />
    </div>
    <c.Content>
      <c.Empty>No fruits found.</c.Empty>
      <c.List>
        {{#each fruits key="@identity" as |fruit|}}
          <c.Item @value={{fruit}}>
            {{fruit}}
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

Type “man”, press Down Arrow, then Enter to fill in Mango. You can also leave text that is not in the list.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build an `Autocomplete`:

```text
Autocomplete as |c|
├── c.Label
├── c.Input
└── c.Content
    ├── c.Empty
    └── c.List
        ├── c.Item
        └── c.Item
```

Name the input, then put suggestions in a list inside the popup. Each suggestion needs a unique value.

## Usage

Import the root and use the parts it yields:

```gts
import { Autocomplete } from "ember-ui-sdk/autocomplete"

<template>
  <Autocomplete as |c|>
    <c.Label>Fruit</c.Label>
    <c.Input placeholder="Type a fruit…" />
    <c.Content>
      <c.List>
        <c.Item @value="Apple">Apple</c.Item>
        <c.Item @value="Banana">Banana</c.Item>
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

## Autocomplete vs Combobox

Both filter a list as you type. They differ in what the value is.

- **Autocomplete**: the value is the text. Suggestions help fill it in, and anything typed is valid. Use it for a search box, an address or a free-form field.
- **[Combobox](./combobox.md)**: the value is an option from the list, or several with `@multiple`. The text is only a query; closing without choosing restores the selected label, and a form submits the value, not the text. Use it for a country, an assignee or a set of labels.

## Disabled

A disabled field cannot be focused or changed and submits nothing. A read-only field stays focusable and submits its value, but does not open or accept changes. Disabled suggestions are skipped by keyboard navigation and cannot fill in the field.

```glimmer-ts title="disabled.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

const skipped = (index: number) => index % 3 === 0

<template>
  <div data-slot="stack">
    <Autocomplete @disabled={{true}} @defaultValue="Banana" as |c|>
      <div data-slot="stack">
        <c.Label>Disabled</c.Label>
        <c.Input />
      </div>
    </Autocomplete>
    <Autocomplete @readOnly={{true}} @defaultValue="Cherry" as |c|>
      <div data-slot="stack">
        <c.Label>Read-only</c.Label>
        <c.Input />
      </div>
    </Autocomplete>
    <Autocomplete as |c|>
      <div data-slot="stack">
        <c.Label>Some suggestions disabled</c.Label>
        <c.Input placeholder="Type “b”" />
      </div>
      <c.Content>
        <c.List>
          {{#each fruits key="@identity" as |fruit index|}}
            <c.Item @value={{fruit}} @disabled={{(skipped index)}}>
              {{fruit}}
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Autocomplete>
  </div>
</template>
```

Try the Disabled and Read-only fields. In Disabled suggestion, type “b”: arrow keys skip Banana and a press cannot choose it.

## Clear and Trigger

`c.Clear` empties the field and returns focus to it. `c.Trigger` lets someone open the suggestions without typing. Give the trigger a label that describes what it opens.

```glimmer-ts title="clear.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { ChevronDown, X } from "lucide"
import { icon } from "./icon"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

<template>
  <Autocomplete @defaultValue="Mango" as |c|>
    <div data-slot="stack">
      <c.Label>Fruit</c.Label>
      <div data-slot="row">
        <c.Input />
        <c.Clear aria-label="Clear">{{icon X}}</c.Clear>
        <c.Trigger aria-label="Show fruits">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No fruits found.</c.Empty>
      <c.List>
        {{#each fruits key="@identity" as |fruit|}}
          <c.Item @value={{fruit}}>
            {{fruit}}
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Clear Mango, then press Show fruits to open the suggestions. The clear button disappears while the field is empty.

## Open on Focus

Add `@openOnFocus={{true}}` to offer suggestions as soon as the input receives focus. This works well when there are useful choices before someone types.

```glimmer-ts title="open-on-focus.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const recent = ["react hooks", "tailwind grid", "web components", "vue v-model"]

<template>
  <Autocomplete @openOnFocus={{true}} as |c|>
    <c.Input aria-label="Search" placeholder="Search…" />
    <c.Content>
      <c.Empty>No results.</c.Empty>
      <c.List>
        <c.Group as |g|>
          <g.Label>Recent searches</g.Label>
          {{#each recent key="@identity" as |search|}}
            <g.Item @value={{search}}>
              {{search}}
            </g.Item>
          {{/each}}
        </c.Group>
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

Focus Search docs to see recent searches before typing. Escape closes them; pressing the field opens them again.

## Auto Highlight

`@autoHighlight={{true}}` highlights the first match while typing, so Enter can choose it immediately. Set `@loop={{false}}` to stop arrow keys at either end of the list.

```glimmer-ts title="auto-highlight.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

<template>
  <Autocomplete @autoHighlight={{true}} @loop={{false}} as |c|>
    <div data-slot="stack">
      <c.Label>Fruit</c.Label>
      <c.Input placeholder="Type, then Enter" />
    </div>
    <c.Content>
      <c.Empty>No fruits found.</c.Empty>
      <c.List>
        {{#each fruits key="@identity" as |fruit|}}
          <c.Item @value={{fruit}}>
            {{fruit}}
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

Type “pe” and press Enter to choose the first match. Arrow keys stop at the ends because this example disables looping.

## Inline Completion

`@inlineComplete={{true}}` fills in the rest of the first suggestion that starts with the typed text, with the added text selected. Arrow keys fill in the suggestion they highlight. End or Right Arrow accepts the completion; Backspace or Escape takes it back out.

```glimmer-ts title="inline.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

<template>
  <Autocomplete @inlineComplete={{true}} as |c|>
    <div data-slot="stack">
      <c.Label>Fruit</c.Label>
      <c.Input placeholder="Type “bl”" />
    </div>
    <c.Content>
      <c.Empty>No fruits found.</c.Empty>
      <c.List>
        {{#each fruits key="@identity" as |fruit|}}
          <c.Item @value={{fruit}}>
            {{fruit}}
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

Type “bl” to complete blackberry inline. Backspace removes the completion; Down Arrow fills in Blueberry. Press End to accept the text.

## Highlight Matches

`c.ItemText` marks the matching text, ignoring case and accents using the current locale. Its state exposes the matching segments when you want to render them yourself, as this example does in bold.

```glimmer-ts title="highlight.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

<template>
  <Autocomplete as |c|>
    <div data-slot="stack">
      <c.Label>Favorite fruit</c.Label>
      <c.Input placeholder="e.g. berry" />
    </div>
    <c.Content>
      <c.Empty>No fruits found.</c.Empty>
      <c.List>
        {{#each fruits key="@identity" as |fruit|}}
          <c.Item @value={{fruit}} as |item|>
            <item.Text />
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

Type “berry”. The matching letters are bold while each suggestion keeps its original spelling.

## Filter and Keywords

The default filter matches text anywhere in a suggestion. Use `@filter="startsWith"` or `@filter="fuzzy"` for a different match, a function for your own filter, or `@filter={{false}}` for results already filtered by a server. `@keywords` adds searchable text without changing what goes in the field.

```glimmer-ts title="filter.gts"
import { get } from "@ember/helper"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const tags = [
  {
    value: "feature",
    label: "feature",
    keywords: ["enhancement", "request"],
  },
  { value: "fix", label: "fix", keywords: ["bug", "patch"] },
  { value: "docs", label: "docs", keywords: ["documentation", "readme"] },
  { value: "performance", label: "performance", keywords: ["speed", "slow"] },
  { value: "security", label: "security", keywords: ["vulnerability"] },
  { value: "refactor", label: "refactor", keywords: ["cleanup"] },
]

<template>
  <Autocomplete @filter="startsWith" as |c|>
    <div data-slot="stack">
      <c.Label>Tag</c.Label>
      <c.Input placeholder="Try “bug”" />
    </div>
    <c.Content>
      <c.Empty>No tags found.</c.Empty>
      <c.List>
        {{#each tags key="value" as |tag|}}
          <c.Item @value={{tag.value}} @label={{tag.label}} @keywords={{tag.keywords}}>
            {{tag.label}}
            <span data-slot="hint">{{get tag.keywords 0}}</span>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

Type “bug” to find fix through its keywords. Type “re” to find labels or keywords that start with those letters.

## Groups

Use `c.Group` and `c.GroupLabel` to name related suggestions. Filtering hides empty groups and separators.

```glimmer-ts title="groups.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const fruitGroups = [
  {
    label: "Tree fruits",
    items: ["Apple", "Apricot", "Cherry", "Lemon", "Peach", "Pear"],
  },
  {
    label: "Berries",
    items: ["Blackberry", "Blueberry", "Grape", "Strawberry"],
  },
  { label: "Tropical", items: ["Avocado", "Banana", "Mango", "Pineapple"] },
]

const isFirst = (index: number) => index === 0

<template>
  <Autocomplete as |c|>
    <div data-slot="stack">
      <c.Label>Fruit</c.Label>
      <c.Input placeholder="e.g. Pear" />
    </div>
    <c.Content>
      <c.Empty>No fruits found.</c.Empty>
      <c.List>
        {{#each fruitGroups key="label" as |group index|}}
          {{#unless (isFirst index)}}
            <c.Separator />
          {{/unless}}
          <c.Group as |g|>
            <g.Label>{{group.label}}</g.Label>
            {{#each group.items key="@identity" as |fruit|}}
              <g.Item @value={{fruit}}>
                {{fruit}}
              </g.Item>
            {{/each}}
          </c.Group>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

Type “an”. Banana and Mango remain in Tropical; groups with no matches disappear.

## Icons

`c.ItemIcon` keeps decorative icons out of accessible names, filtering, and the text put in the field. Add `@mirror={{true}}` for directional icons. An icon-only suggestion still needs an `aria-label`.

```glimmer-ts title="icons.gts"
import { Archive, Clock, File, Pencil, Reply, Star } from "lucide"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { icon } from "./icon"

const mailSearches = [
  { value: "Starred", icon: Star },
  { value: "Drafts", icon: Pencil },
  { value: "Replies", icon: Reply, mirror: true },
  { value: "Attachments", icon: File },
  { value: "Archived", icon: Archive },
  { value: "Scheduled", icon: Clock },
]

<template>
  <Autocomplete as |c|>
    <c.Input type="search" aria-label="Search mail" placeholder="Search mail…" />
    <c.Content>
      <c.Empty>No searches found.</c.Empty>
      <c.List>
        {{#each mailSearches key="value" as |search|}}
          <c.Item @value={{search.value}} as |item|>
            <item.Icon @mirror={{search.mirror}}>{{icon
                search.icon
              }}</item.Icon>
            {{search.value}}
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Type “rep” and choose Replies. The icon stays out of the text put in the field.

## Items as Data

Map an array into parts when you want to write the markup yourself. This example maps fruit groups and adds a separator between them.

```glimmer-ts title="data.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const fruitGroups = [
  {
    label: "Tree fruits",
    fruits: ["Apple", "Apricot", "Cherry", "Lemon", "Peach", "Pear"],
  },
  {
    label: "Berries",
    fruits: ["Blackberry", "Blueberry", "Grape", "Strawberry"],
  },
  { label: "Tropical", fruits: ["Avocado", "Banana", "Mango", "Pineapple"] },
]

const isFirst = (index: number) => index === 0

<template>
  <Autocomplete as |c|>
    <div data-slot="stack">
      <c.Label>Fruit</c.Label>
      <c.Input placeholder="e.g. Peach" />
    </div>
    <c.Content>
      <c.Empty>No fruits found.</c.Empty>
      <c.List>
        {{#each fruitGroups key="label" as |group index|}}
          {{#unless (isFirst index)}}
            <c.Separator />
          {{/unless}}
          <c.Group as |g|>
            <g.Label>{{group.label}}</g.Label>
            {{#each group.fruits key="@identity" as |fruit|}}
              <g.Item @value={{fruit}}>{{fruit}}</g.Item>
            {{/each}}
          </c.Group>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

Open the list to see three fruit groups. Type “an” to narrow them to Banana and Mango.

Pass `@items` when the autocomplete needs the whole collection, such as server results or recent searches. It can render bare parts for you. Lists and Menus covers the `ListData` format.

Suggestions can change while the list is open. The highlight stays with its suggestion, and the typed text stays unchanged. Removing the highlighted suggestion clears the highlight.

## Controlled

The value is always a string. Control it with `@value` and `@onValueChange`, or start uncontrolled with `@defaultValue`. Suggestions have a separate `@open` state and `@onOpenChange`. Callbacks receive the proposed value first, then change details. Call `details.cancel()` to reject a text or open change.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { useLog } from "./log"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

export default class Controlled extends Component {
  log = useLog(this)
  @tracked value = ""
  @tracked open = false

  changeValue = (
    next: string,
    details: { reason: string; cancel: () => void }
  ) => {
    if (next.length > 12) {
      return details.cancel()
    }
    this.value = next
    this.log(`text: ${details.reason}`)
  }

  onOpenChange = (next: boolean, details: { reason: string }) => {
    this.open = next
    this.log(`${next ? "opened" : "closed"}: ${details.reason}`)
  }

  onOpenChangeComplete = (next: boolean) => {
    this.log(`${next ? "opened" : "closed"} and settled`)
  }

  onHighlight = (highlighted: string | null) => {
    if (highlighted) this.log(`highlighted ${highlighted}`)
  }

  <template>
    <div data-slot="stack">
      <Autocomplete
        @value={{this.value}}
        @open={{this.open}}
        @debug={{true}}
        @onValueChange={{this.changeValue}}
        @onOpenChange={{this.onOpenChange}}
        @onOpenChangeComplete={{this.onOpenChangeComplete}}
        @onHighlight={{this.onHighlight}}
        as |c|
      >
        <c.Label>Fruit (12 characters at most)</c.Label>
        <c.Input />
        <c.Content>
          <c.Empty>No fruits found.</c.Empty>
          <c.List>
            {{#each fruits key="@identity" as |fruit|}}
              <c.Item @value={{fruit}}>
                {{fruit}}
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Autocomplete>
    </div>
  </template>
}
```

Type more than 12 characters and the extra text is refused. The console shows each change and its reason.

## Controller

Create a `createAutocompleteController()` for one instance and pass it as `@controller`. It can `setValue()`, `clear()`, `focus()`, `setOpen()`, or read `getValue()` and `isOpen()`. `open()` returns a promise that resolves when the popup closes, including abort and unmount; `close()` closes it.

```glimmer-ts title="controller.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import {
  Autocomplete,
  createAutocompleteController,
} from "ember-ui-sdk/autocomplete"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

export default class Controller extends Component {
  fruit = createAutocompleteController()

  openList = () => {
    this.fruit.open()
  }

  typePea = () => {
    this.fruit.setValue("Pea")
  }

  clearFruit = () => {
    this.fruit.clear()
  }

  focusFruit = () => {
    this.fruit.focus()
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" data-size="sm" {{on "click" this.openList}}>
          Open
        </button>
        <button type="button" data-size="sm" {{on "click" this.typePea}}>
          Type “Pea”
        </button>
        <button type="button" data-size="sm" {{on "click" this.clearFruit}}>
          Clear
        </button>
        <button type="button" data-size="sm" {{on "click" this.focusFruit}}>
          Focus
        </button>
      </div>
      <Autocomplete @controller={{this.fruit}} as |c|>
        <c.Label>Fruit</c.Label>
        <c.Input />
        <c.Content>
          <c.Empty>No fruits found.</c.Empty>
          <c.List>
            {{#each fruits key="@identity" as |item|}}
              <c.Item @value={{item}}>
                {{item}}
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Autocomplete>
    </div>
  </template>
}
```

Use the buttons to open the suggestions, type Pea, clear the field or focus it from outside.

## Positioning

Use `@side`, `@align`, offsets, or a custom `@anchor` to position the suggestions. `@container` chooses where they render, and `@keepMounted` keeps closed content in the DOM.

```glimmer-ts title="positioning.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { attach } from "ember-ui-sdk/primitive"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
]

export default class Positioning extends Component {
  fruits = fruits
  @tracked box: HTMLElement | null = null

  setBox = (element: HTMLElement) => {
    this.box = element
  }

  <template>
    <div {{attach this.setBox}} data-slot="card">
      <Autocomplete @modal="pointer" @container={{this.box}} as |c|>
        <div data-slot="stack">
          <c.Label>Fruit</c.Label>
          <c.Input />
        </div>
        <c.Content
          @side="top"
          @align="end"
          @sideOffset={{10}}
          @alignOffset={{-4}}
          @collisionPadding={{8}}
          @anchor={{this.box}}
          @keepMounted={{true}}
        >
          <c.Empty>No fruits found.</c.Empty>
          <c.List>
            {{#each this.fruits key="@identity" as |fruit|}}
              <c.Item @value={{fruit}}>{{fruit}}</c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Autocomplete>
    </div>
  </template>
}
```

Open the suggestions. They appear above the card, aligned to its end.

## Animation

The content has `data-starting-style` while it opens and `data-ending-style` while it closes. Transition from those states, and the popup stays mounted until the exit finishes:

```css
[data-slot="autocomplete-content"] {
  transition:
    opacity 0.15s,
    translate 0.2s cubic-bezier(0.22, 1, 0.36, 1);

  &:is([data-starting-style], [data-ending-style]) {
    opacity: 0;
    translate: 0 -6px;
  }
}
```

```glimmer-ts title="animation.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

<template>
  <Autocomplete as |c|>
    <div data-slot="stack">
      <c.Label>Favorite fruit</c.Label>
      <c.Input placeholder="e.g. Mango" />
    </div>
    <c.Content>
      <c.Empty>No fruits found.</c.Empty>
      <c.List>
        {{#each fruits key="@identity" as |fruit|}}
          <c.Item @value={{fruit}}>
            {{fruit}}
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

Type to open the suggestions. They slide and fade in, and fade out before they unmount.

## Presentation

`@presentation="sheet"` opens suggestions in a sheet. `"auto"` chooses a sheet on small touch screens and a popover elsewhere, each time the list opens. The server starts with the popover.

The same input moves into the sheet’s header. Opening by touch leaves the keyboard closed; tapping the input opens it and expands the sheet. Choosing a suggestion or swiping down closes it. Keyboard and mouse opening preserve input focus.

A sheet is modal unless `@modal` is `false`. Give it a height, keep suggestions inside `c.List`, and leave the content’s `translate` alone so dragging can move it. Use `data-presentation` to style both presentations and `--sheet-backdrop` to set the dimmed background.

```glimmer-ts title="presentation.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

<template>
  <Autocomplete @presentation="sheet" as |c|>
    <div data-slot="stack">
      <c.Label>Favorite fruit</c.Label>
      <c.Input placeholder="e.g. Mango" />
    </div>
    <c.Content>
      <c.Empty>No fruits found.</c.Empty>
      <c.List>
        {{#each fruits key="@identity" as |fruit|}}
          <c.Item @value={{fruit}}>
            {{fruit}}
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

Open the field to see a sheet. On touch, tap the field in its header to show the keyboard, or swipe down to close it.

## Forms

The native input is the form control: `@name` gives its submitted key, `@required={{true}}` rejects empty text, and reset restores `@defaultValue`. Text does not have to match a suggestion. Use `@form` to associate the field with a form elsewhere in the page.

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { Field } from "ember-ui-sdk/field"
import { useLog } from "./log"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

export default class Form extends Component {
  log = useLog(this)

  submit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = [...new FormData(event.currentTarget as HTMLFormElement)].map(
      ([name, value]) => `${name}=${value}`
    )
    this.log(`Submitted ${data.join("&")}`)
  }

  <template>
    <form id="order" data-slot="stack" {{on "submit" this.submit}}>
      <Field as |f|>
        <f.Label>Fruit</f.Label>
        <Autocomplete
          @name="fruit"
          @form="order"
          @required={{true}}
          @defaultValue="Apple"
          @field={{f.field}}
          as |c|
        >
          <c.Input />
          <c.Content>
            <c.Empty>No fruits found.</c.Empty>
            <c.List>
              {{#each fruits key="@identity" as |fruit|}}
                <c.Item @value={{fruit}}>
                  {{fruit}}
                </c.Item>
              {{/each}}
            </c.List>
          </c.Content>
        </Autocomplete>
        <f.Description>Any fruit, listed or not.</f.Description>
        <div><f.Error /></div>
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid"> Submit </button>
        <button type="reset"> Reset </button>
      </div>
    </form>
  </template>
}
```

Submit Apple, then choose Mango. Choosing it fills the field without submitting. Reset restores Apple.

## Search

Enter with no suggestion highlighted runs the `@onSubmit` callback with the text, then allows the surrounding form to submit. Call `preventDefault()` on `details.event` if your handler already performs the search.

Choosing a suggestion normally only fills in the field. Add `@submitOnSelect={{true}}` to search as soon as someone chooses one.

```glimmer-ts title="search.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { useLog } from "./log"

const recent = ["react hooks", "tailwind grid", "web components", "vue v-model"]

export default class Search extends Component {
  log = useLog(this)

  preventSubmit = (event: SubmitEvent) => {
    event.preventDefault()
  }

  submitted = (value: string) => {
    this.log(`Searched “${value}”`)
  }

  <template>
    <form role="search" data-slot="stack" {{on "submit" this.preventSubmit}}>
      <Autocomplete @submitOnSelect={{true}} @name="q" @onSubmit={{this.submitted}} as |c|>
        <c.Input type="search" aria-label="Search" placeholder="Search…" />
        <c.Content>
          <c.Empty>No results.</c.Empty>
          <c.List>
            {{#each recent key="@identity" as |search|}}
              <c.Item @value={{search}}>
                {{search}}
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Autocomplete>
    </form>
  </template>
}
```

Type “kotlin” and press Enter to search. Choose a suggestion to search for that text instead.

## Recent Searches

Pair `@emptyItems` with `@items` to show one collection while the field is empty and search the full collection once someone types. Add `@openOnFocus={{true}}` to show the recent searches on focus.

```glimmer-ts title="recent.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const recent = ["react hooks", "tailwind grid", "web components", "vue v-model"]
const topics = [
  ...recent,
  "react server components",
  "tailwind colors",
  "vue router",
]
const recentSearches = [
  { type: "group", label: "Recent searches", items: recent },
]

const announcement = (change: { type: string; count?: number }) =>
  change.type === "results"
    ? `${change.count} ${change.count === 1 ? "topic" : "topics"}`
    : null

<template>
  <Autocomplete
    @items={{topics}}
    @emptyItems={{recentSearches}}
    @openOnFocus={{true}}
    @announcement={{announcement}}
    as |c|
  >
    <c.Input type="search" aria-label="Search docs" placeholder="Search docs…" />
    <c.Content>
      <c.Empty>No topics found.</c.Empty>
      <c.List as |list|>
        {{#each list.state.items key="@identity" as |entry|}}
          {{#if entry.items}}
            <c.Group as |g|>
              <g.Label>{{entry.label}}</g.Label>
              {{#each entry.items key="@identity" as |topic|}}
                <g.Item @value={{topic}} as |item|>
                  <item.Text />
                </g.Item>
              {{/each}}
            </c.Group>
          {{else}}
            <c.Item @value={{entry}} as |item|>
              <item.Text />
            </c.Item>
          {{/if}}
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

Focus the empty field to see Recent searches. Type “react” to search all topics, then clear the text to return to recent searches.

## Async Suggestions

Use `useAsyncOptions` from `ember-ui-sdk/async-options` to wait for typing to pause and discard stale results. Pass its `items` and `status`, set `@filter={{false}}`, and send text changes to its `setQuery()` method.

`c.Status` and `c.Empty` provide loading, error, and empty messages. Without a status part, `@announcement` controls what screen readers hear when typing pauses. `@onLoadMore` can request another page when scrolling or highlighting reaches the last suggestion.

```glimmer-ts title="async.gts"
import Component from "@glimmer/component"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

function searchCities(query: string, { signal }: { signal: AbortSignal }) {
  const cities = [
    "Amsterdam",
    "Athens",
    "Barcelona",
    "Berlin",
    "Boston",
    "Brussels",
    "Buenos Aires",
    "Cairo",
    "Chicago",
    "Copenhagen",
    "Dublin",
    "Lisbon",
    "London",
    "Los Angeles",
    "Madrid",
    "Paris",
    "Prague",
    "Rome",
    "Seoul",
    "Tokyo",
  ]
  return new Promise<string[]>((resolve, reject) => {
    const timer = setTimeout(() => {
      const needle = query.trim().toLowerCase()
      resolve(cities.filter((city) => city.toLowerCase().startsWith(needle)))
    }, 300)
    signal.addEventListener("abort", () => {
      clearTimeout(timer)
      reject(new DOMException("Aborted", "AbortError"))
    })
  })
}

export default class Async extends Component {
  results = useAsyncOptions(this, searchCities, { debounce: 200 })

  onValueChange = (value: string) => {
    this.results.setQuery(value)
  }

  statusText = (state: { loading: boolean; count: number }) =>
    state.loading
      ? "Searching…"
      : state.count
        ? `${state.count} ${state.count === 1 ? "city" : "cities"}`
        : ""

  <template>
    <Autocomplete
      @items={{this.results.state.items}}
      @filter={{false}}
      @status={{this.results.state.status}}
      @onValueChange={{this.onValueChange}}
      @onLoadMore={{this.results.loadMore}}
      as |c|
    >
      <div data-slot="stack">
        <c.Label>City</c.Label>
        <c.Input placeholder="e.g. Paris" />
      </div>
      <c.Content>
        <c.Status as |s|>{{this.statusText s.state}}</c.Status>
        <c.Empty as |e|>
          {{#unless e.state.loading}}No cities start with “{{e.state.query}}”.{{/unless}}
        </c.Empty>
        <c.List as |list|>
          {{#each list.state.items key="@identity" as |city|}}
            <c.Item @value={{city}}>
              {{city}}
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Autocomplete>
  </template>
}
```

Type “b” and wait for the city suggestions. Keep typing to replace the search; the status describes the latest results.

## Custom Rendering

Pass `@render={{true}}` to a suggestion to give it a different element. Here each suggestion is a link, so the autocomplete works as a jump-to menu: Enter or a click follows the highlighted link, and the text after the title is a hint that doesn't affect filtering.

```glimmer-ts title="custom-rendering.gts"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

const pages = [
  { title: "Installation", section: "Get Started", href: "#installation" },
  { title: "Composition", section: "Concepts", href: "#composition" },
  { title: "Build Your Own", section: "Concepts", href: "#build-your-own" },
  { title: "Styling", section: "Guides", href: "#styling" },
  { title: "API Reference", section: "Reference", href: "#api-reference" },
  { title: "Accessibility", section: "Reference", href: "#accessibility" },
]

<template>
  <Autocomplete as |c|>
    <div data-slot="stack">
      <c.Label>Jump to</c.Label>
      <c.Input placeholder="e.g. Styling" />
    </div>
    <c.Content>
      <c.Empty>No sections found.</c.Empty>
      <c.List>
        {{#each pages key="href" as |page|}}
          <c.Item @value={{page.title}} @label={{page.title}} @render={{true}} as |p|>
            <a {{p.part}} href={{page.href}}>
              {{page.title}}
              <span data-slot="hint">{{page.section}}</span>
            </a>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Autocomplete>
</template>
```

Type “sty” and press Enter to jump to the Styling section of this page.

## Styling

Each part has a `data-slot`, such as `autocomplete-content`, and shows its state through the attributes listed under [Data Attributes](#data-attributes).

The popup exposes sizing and animation variables. `--anchor-width` is the input’s width; use `--available-height` on the content to keep a long list in the viewport.

While focus stays in the input, use the content’s `data-modality="keyboard"` with an item’s `data-highlighted` to show a keyboard focus indicator on the highlighted suggestion.

### AutocompleteContent
- `--anchor-width`: Width of the anchor, usually the trigger. Use it to match widths.
- `--anchor-height`: Height of the anchor.
- `--available-width`: Space beside the popup, up to the viewport edge. Not inherited either.
- `--available-height`: Space between the anchor and the viewport edge. Use it for max-height. Not inherited, so a child that needs it copies it on the popup, like `[--list-height:var(--available-height)]`, and reads `max-h-(--list-height)`. The first popup registers both names for the whole page with `CSS.registerProperty`, so they don't inherit anywhere. A page that needs them to inherit calls it first, with `inherits: true`. An `@property` rule can't, since a registration in script wins.
- `--transform-origin`: The point on the anchor the popup opens from. Use it to scale from the right place.
- `--arrow-offset`: Where the anchor's center falls along the popup's edge, kept `arrowPadding` from the corners. Position a ::before arrow with it.
- `--drawer-progress`: While it presents as a sheet: how far open the sheet is, from 0 closed to 1 at its largest snap point. Never past 1.
- `--drawer-dim`: While it presents as a sheet: how dim the page behind is, from 0 to 1. The backdrop's opacity follows it.
- `--drawer-expand`: While it presents as a sheet: 0 at the second-largest snap point and below, 1 at the largest. With one snap point, the whole travel.
- `--drawer-stack`: While it presents as a sheet: how many sheets opened from inside this one are open above it, rising smoothly as each one opens. Push it back with it.
- `--sheet-backdrop`: Set it yourself: the color the page dims to while it presents as a sheet. Black at 0.2 by default.

### Viewport
- `--keyboard-inset`: While it presents as a sheet: how many pixels of the page the on-screen keyboard covers, 0 without one.
- `--visual-viewport-width`: While it presents as a sheet: the width of the part of the page you can see.
- `--visual-viewport-height`: While it presents as a sheet: the height of the part of the page you can see, above the keyboard.
- `--visual-viewport-top`: While it presents as a sheet: how far the part of the page you can see is scrolled from the top of the layout, as when the keyboard pushes it up.

## Data Attributes

### AutocompleteLabel
`[data-slot="autocomplete-label"]`

- `data-disabled`: Present when the field is disabled, by its own prop, a field or a `<fieldset>`.
- `data-readonly`: Present when the field is read-only.
- `data-required`: Present when the field is required.

### AutocompleteInput
`[data-slot="autocomplete-input"]`

- `data-closed`: Present while the suggestions are closed, including while they animate out.
- `data-open`: Present while the suggestions are open.
- `data-disabled`: Present when the field is disabled, by its own prop, a field or a `<fieldset>`.
- `data-readonly`: Present when the field is read-only.
- `data-required`: Present when the field is required.

### AutocompleteTrigger
`[data-slot="autocomplete-trigger"]`

- `data-closed`: Present while the suggestions are closed, including while they animate out.
- `data-open`: Present while the suggestions are open.
- `data-disabled`: Present when the field is disabled, by its own prop, a field or a `<fieldset>`.
- `data-readonly`: Present when the field is read-only.
- `data-required`: Present when the field is required.

### AutocompleteClear
`[data-slot="autocomplete-clear"]`

- `data-disabled`: Present when the field is disabled or read-only.

### AutocompleteContent
`[data-slot="autocomplete-content"]`

- `data-closed`: Present while the suggestions are closed, including while they animate out.
- `data-presentation` (`popover`, `sheet`): How the suggestions present this time they're open.
- `data-open`: Present while the suggestions are open.
- `data-starting-style`: Present for the first frame. Style the state you animate from.
- `data-ending-style`: Present while the list animates out. Style the state you animate to.
- `data-modality` (`keyboard`, `pointer`): Whether the keyboard or a pointer moves the highlight. Style a focus ring for the keyboard only.
- `data-has-icons`: Present while any suggestion inside holds an icon part, so items without one can line up.

### AutocompleteItem
`[data-slot="autocomplete-item"]`

- `data-disabled`: Present when the suggestion can't be chosen. Arrow keys skip it.
- `data-highlighted`: Present on the highlighted suggestion, which Enter fills in. Focus stays in the field.
- `data-has-icon`: Present on a suggestion while it holds an icon part.

### AutocompleteItemText
`[data-slot="autocomplete-item-text"]`

- `data-matched`: Present on a suggestion's text while the field's text matched part of it, which is marked.

### AutocompleteEmpty
`[data-slot="autocomplete-empty"]`

- `data-loading`: Present while results load, with `status="loading"`.
- `data-empty`: Present while no suggestion matches.

### AutocompleteStatus
`[data-slot="autocomplete-status"]`

- `data-loading`: Present while results load, with `status="loading"`.

### AutocompleteArrow
`[data-slot="autocomplete-arrow"]`

- `data-closed`: Present while the suggestions are closed, including while they animate out.
- `data-open`: Present while the suggestions are open.

### AutocompleteItemIcon
`[data-slot="autocomplete-item-icon"]`

- `data-mirror`: Present on an icon that flips in right-to-left text, with `mirror`.

## API Reference

Pass the root's options as `@` arguments. `@value` and `@open` are controlled with their `@on…Change` callbacks.

### Autocomplete

- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `value?` (`string`): The text. Pass it to control it.
- `defaultValue?` (`string`): The text at first, when uncontrolled. A form reset returns to it.
- `onValueChange?` (`((value: string, details: ChangeDetails<AutocompleteValueChangeReason>) => void)`): Runs when the text wants to change: typing, choosing a suggestion, a Clear part, a form reset or a controller. `details.cancel()` keeps it as it was.
- `open?` (`boolean`): Whether the suggestions are open. Pass it to control them.
- `defaultOpen?` (`boolean`): Whether the suggestions start open, when uncontrolled.
- `onOpenChange?` (`((open: boolean, details: ChangeDetails<AutocompleteOpenChangeReason>) => void)`): Runs when the suggestions want to open or close. `details.reason` says why, and `details.cancel()` stops it.
- `onOpenChangeComplete?` (`((open: boolean) => void)`): Runs once the suggestions have finished opening or closing, after any animation.
- `onSubmit?` (`((value: string, details: AutocompleteSubmitDetails) => void)`): Runs with the text when Enter is pressed with no suggestion highlighted, or after choosing one with `submitOnSelect`. The surrounding form submits next, unless the event's `preventDefault()` is called.
- `items?` (`ListData<string>`): The suggestions as data. Renders them for you, and filters them without rendering every one.
- `emptyItems?` (`ListData<string>`): Suggestions shown instead of `items` while the field is empty, like recent searches, with `openOnFocus`. Groups work, like `{ type: "group", label: "Recent", items }`. Needs `items`.
- `filter?` (`SearchFilter<string>`): How typing narrows the suggestions: `"contains"`, `"startsWith"`, `"fuzzy"`, a function of the item and the text, or `false` to keep every one, for results a server already filtered.
- `inlineComplete?` (`boolean`): Whether typing completes the text with the first suggestion that starts with it, with the rest selected after the caret: ArrowRight or End accepts it, Backspace and Escape take it back out, and arrow keys fill in the suggestion they highlight.
- `autoHighlight?` (`boolean`): Whether the first suggestion is highlighted while typing, so Enter chooses it.
- `openOnFocus?` (`boolean`): Whether the suggestions open when the field gets focus, like recent searches, even before anything is typed.
- `submitOnSelect?` (`boolean`): Whether choosing a suggestion submits, like a search box: `@onSubmit` runs, then the form submits.
- `status?` (`AsyncOptionsStatus`): Whether results are loading or failed, for the empty and status parts. Sets `aria-busy` on the list while loading.
- `onHighlight?` (`((value: string | null, details: ListHighlightDetails) => void)`): Runs when the highlight moves, with the suggestion's index among the visible ones, so a virtualized list can scroll to it.
- `onLoadMore?` (`(() => void)`): Runs when the highlight or scrolling reaches the last suggestion, so the next page can load, like `createAsyncOptions`'s `loadMore`. Not again for the same suggestions, unless the last load failed.
- `announcement?` (`((change: ListAnnouncement) => string | null | undefined)`): What screen readers hear after typing pauses, when no `AutocompleteStatus` is rendered. Return null for nothing.
- `loop?` (`boolean`): Whether arrow keys wrap from the last suggestion to the first.
- `modal?` (`"pointer" | boolean`): `false`: the page stays usable while the suggestions are open. `"pointer"`: an outside press only closes them. `true`: also locks scroll and makes the rest of the page inert.
- `presentation?` (`PresentationSetting<"popover">`): How the suggestions present. `"sheet"` slides them up from the bottom of the screen with the field in its header, where they can be swiped away, and `"auto"` does that on small touch screens. A tap that opens a sheet leaves the keyboard closed until the field in the header is tapped. Decided each time they open; the server renders `"popover"` for `"auto"`.
- `disabled?` (`boolean`): Disables the field like a native input: it can't be focused or changed, and its text isn't submitted.
- `readOnly?` (`boolean`): Keeps the field focusable and its text submitted, but stops changes.
- `required?` (`boolean`): Blocks form submission while the field is empty, with the browser's own message.
- `name?` (`string`): The name the text submits under.
- `form?` (`string`): The id of a form to belong to, when the field isn't inside that form.
- `controller?` (`object`): Opens, closes, reads and sets the autocomplete from anywhere. Create one with `createAutocompleteController()`.
- `dismissible?` (`boolean`): Whether Escape, an outside press, focus or the window leaving, Android's back gesture and a sheet's swipe can close it. Triggers, Close parts and the controller always can. Pass `false` while it holds unsaved work, and ask in `@onDismissAttempt`.
- `onDismissAttempt?` (`function`): Runs when `dismissible` refused a dismissal made on purpose: Escape, an outside press, back or a swipe. Focus or the window leaving is refused without it. Ask "Discard changes?" here.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### AutocompleteLabel

Names the input. Renders a `label` tied to the input, so you don't need a `Field`.

### AutocompleteInput

The text field. Renders an `input` with the combobox role, and accepts its attributes.

### AutocompleteTrigger

An optional button that opens and closes the suggestions. Renders a `button`.

### AutocompleteClear

- `keepMounted?` (`boolean`): Whether the clear button stays in the page while the field is empty.

### AutocompleteContent

- `side?` (`Side`): Which side of the anchor the popup opens on. Flips to the other side when there isn't room. Which side of the field the suggestions open on.
- `align?` (`Align`): How the popup lines up with the anchor along that side. `start` and `end` follow the reading direction. How the suggestions line up with the field along that side.
- `sideOffset?` (`number`): Gap between the anchor and the popup, in pixels. Gap between the field and the suggestions, in pixels.
- `alignOffset?` (`number`): Shift along the anchor, in pixels. Shift along the field, in pixels.
- `collisionPadding?` (`number`): Space to keep from the viewport edges, in pixels.
- `arrowPadding?` (`number`): Space to keep between the arrow and the popup's corners, in pixels.
- `anchor?` (`string | Anchor | null`): Positions the popup against this instead of its trigger: an element, a CSS selector, a point like `{ x, y }`, or anything with `getBoundingClientRect()`. It's read on every check, so it can move. A controller's `open({ anchor })` wins for that open.
- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `keepMounted?` (`boolean`): Whether the suggestions stay in the page, hidden, while closed.

### AutocompleteArrow

An optional arrow pointing at the input. Renders a `div` positioned on the content's edge.

### AutocompleteStatus

Announces loading and result counts to screen readers.

### AutocompleteEmpty

Shows when no suggestion matches.

### AutocompleteList

Holds the suggestions. Renders the listbox, and renders `@items` when you pass no block.

### AutocompleteGroup

Groups related suggestions. Renders a `div` with the group role.

### AutocompleteGroupLabel

Names its group. Renders a `div` the group is labelled by.

### AutocompleteItem

- `value` (`string`): Identifies the suggestion. Choosing it fills the field with its `label`, or with this when there's none.
- `label?` (`string`): The text the field gets and filtering matches, when the content isn't plain text. Not the accessible name: use `aria-label` for that.
- `keywords?` (`string[]`): More words filtering matches.
- `disabled?` (`boolean`): Keeps the suggestion from being chosen. Sets `data-disabled` and `aria-disabled`.
- `index?` (`number`): The suggestion's position among all visible ones, for virtualized lists that render only some. Sets `aria-posinset` and `aria-setsize`.

### AutocompleteItemIcon

- `mirror?` (`boolean`): Flips the icon horizontally in right-to-left text, for icons that point a way, like arrows and chevrons. Icons that picture a thing, like a clock or a check, stay as they are.

### AutocompleteItemText

The suggestion's text, with the matched part marked. Its state includes the matched `segments`.

### AutocompleteSeparator

A divider between suggestions or groups. Renders a `div` with the separator role.

### Items as Data

Each suggestion in `@items`, or a plain string. Groups are `{ type: "group", label, items }` and separators `{ type: "separator" }`.

- `value` (`T`): Identifies the item, and is what choosing it reports. A string, or any value with `itemToValue`.
- `label` (`string`): The text shown and matched by typeahead and filtering. A select's trigger shows it once chosen.
- `keywords?` (`string[]`): More words filtering matches, like `["team"]` for a plan called Pro.
- `disabled?` (`boolean`): Keeps the item from being chosen. The keyboard skips it, like in a native select.

### State

What `@render` parts and their blocks receive, per part.

`AutocompleteInput` and `AutocompleteTrigger`:

- `open` (`boolean`): Whether the suggestions are open.
- `disabled` (`boolean`): Whether the field is disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether the field is read-only.
- `required` (`boolean`): Whether the field is required.

`AutocompleteContent` and `AutocompleteList`:

- `open` (`boolean`): Whether the suggestions are open. False while they animate out.
- `presentation` (`"popover" | "sheet"`): How they present this time they're open.
- `status` (`AsyncOptionsStatus`): Whether results are loading or failed.
- `items` (`ListData<string>`): The visible suggestions, for rendering a virtualized list yourself.

`AutocompleteItem`:

- `highlighted` (`boolean`): Whether the suggestion is highlighted, by the keyboard or the pointer.
- `disabled` (`boolean`): Whether the suggestion can't be chosen.

`AutocompleteEmpty`:

- `loading` (`boolean`): Whether results are loading.
- `empty` (`boolean`): Whether no item matches.
- `query` (`string`): The text the list is filtered by.

`AutocompleteStatus`:

- `status` (`"idle" | "loading" | "error"`): Whether results are loading or failed.
- `loading` (`boolean`): Whether results are loading.
- `count` (`number`): How many items are visible.

`AutocompleteClear`:

- `disabled` (`boolean`): Whether the field is disabled or read-only.

`AutocompleteArrow`:

- `open` (`boolean`): Whether the suggestions are open.

`AutocompleteItemText`, which takes no arguments of its own:

- `segments` (`MatchSegment[]`): The text in pieces, each marked when it matched. Joined, they're the whole text.
- `matched` (`boolean`): Whether any piece matched.

`AutocompleteItemIcon`:

- `mirror` (`boolean`): Whether it flips in right-to-left text.

### Reasons

Why the text changed:

- `input-change` (`Event`): Typing, pasting or dropping changed a text field's value; in a combobox it can also open or close it, or Enter keeps the typed text as the value.
- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `clear-press` (`MouseEvent | KeyboardEvent`): A Clear part was pressed, like on an input, a select or a combobox.
- `reset` (`none`): A form reset.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

And why the suggestions opened or closed:

- `input-change` (`Event`): Typing, pasting or dropping changed a text field's value; in a combobox it can also open or close it, or Enter keeps the typed text as the value.
- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.
- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `trigger-focus` (`FocusEvent`): Keyboard focus reached a trigger that opens on focus, like a tooltip's.
- `input-commit` (`KeyboardEvent | FocusEvent`): Enter, or leaving a number input, committed what was typed: a number input parses, clamps and snaps it to the step, and an autocomplete closes its suggestions on it.
- `outside-press` (`MouseEvent`): A press outside the layer.
- `close-press` (`MouseEvent | KeyboardEvent | SubmitEvent`): A Close part was pressed, or a form with `method="dialog"` was submitted.
- `focus-out` (`KeyboardEvent | FocusEvent`): Focus left the layer, or Tab moved it out.
- `window-blur` (`FocusEvent`): The window lost focus.
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `swipe` (`TouchEvent | PointerEvent`): A swipe gesture: a finger, mouse or pen dragged it.

With `@dismissible={{false}}`, the refused dismissals `@onDismissAttempt` reports:

- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `outside-press` (`MouseEvent`): A press outside the layer.
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `swipe` (`TouchEvent | PointerEvent`): A swipe gesture: a finger, mouse or pen dragged it.

### Controller

Create one with `createAutocompleteController()` and pass it as `@controller`.

- `isOpen()` (`() => boolean`): Whether the suggestions are open.
- `setOpen(open, options?)` (`(open: boolean, options?: AutocompleteChangeOptions<AutocompleteOpenChangeReason> | undefined) => boolean`): Opens or closes the suggestions. Returns false when the change was canceled or it was already open or closed.
- `open(options?)` (`(options?: (AutocompleteChangeOptions<AutocompleteOpenChangeReason> & { signal?: AbortSignal | undefined; }) | undefined) => Promise<...>`): Opens the suggestions, and resolves once they close, with why and how. Resolves exactly once and never rejects: on the next close, when `signal` aborts, or with reason `"unmount"`.
- `close(options?)` (`(options?: AutocompleteChangeOptions<AutocompleteOpenChangeReason> | undefined) => boolean`): Closes the suggestions. Returns false when the close was canceled or it was already closed.
- `toggle(options?)` (`(options?: AutocompleteChangeOptions<AutocompleteOpenChangeReason> | undefined) => boolean`): Opens the suggestions when they're closed, and closes them when they're open. Returns false when the change was canceled.
- `getValue()` (`() => string`): The text.
- `setValue(value, options?)` (`(value: string, options?: AutocompleteChangeOptions<AutocompleteValueChangeReason> | undefined) => boolean`): Changes the text, which filters the suggestions. Returns false when the change was canceled or nothing changed.
- `clear(options?)` (`(options?: AutocompleteChangeOptions<AutocompleteValueChangeReason> | undefined) => boolean`): Empties the field. Returns false when the change was canceled or nothing changed.
- `focus()` (`() => void`): Moves focus to the field.

### Events

Callbacks get the new state first, then the details. A controlled value only updates when the change callback wasn't canceled.

| Argument                | On             | Receives                                                     |
| ----------------------- | -------------- | ------------------------------------------------------------ |
| `@onValueChange`        | `Autocomplete` | `(value, details)`: the new text, and the [reason](#reasons) |
| `@onOpenChange`         | `Autocomplete` | `(open, details)`: the new state, and the [reason](#reasons) |
| `@onOpenChangeComplete` | `Autocomplete` | `(open)`, after the animation                                |
| `@onSubmit`             | `Autocomplete` | `(value, { event })`: the text, when Enter submits           |
| `@onHighlight`          | `Autocomplete` | `(value, { index, event })`: the highlighted suggestion      |
| `@onLoadMore`           | `Autocomplete` | `()`, when the last suggestion is reached                    |
| `@onDismissAttempt`     | `Autocomplete` | `({ reason, event })`, when a dismissal was refused          |

## Accessibility

The autocomplete follows the [WAI-ARIA combobox pattern with list autocomplete](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-autocomplete-list/), and [list and inline](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-autocomplete-both/) with `@inlineComplete`.

Typing filters the suggestions. Arrow keys move the highlight; Enter fills in the highlighted text and Escape closes the list. Focus usually stays in the input while `aria-activedescendant` identifies the highlighted suggestion. A touch screen-reader trigger can move focus into the list, and a sheet has its own [focus behavior](#presentation).

Every line below is an automated test.

**Field**

- Is a combobox named by its label, with list autocomplete.
- Typing opens the suggestions that match, and the text stays what was typed.
- Text that matches nothing stays, with the empty message.
- Typing in the middle of the text keeps the caret where it was.

**Choosing**

- Arrow keys move the highlight while focus stays in the field.
- Enter fills in the highlighted suggestion and closes, without submitting.
- Clicking a suggestion fills it in and keeps focus in the field.
- A disabled suggestion can't be chosen.
- Escape takes an inline completion back out.
- Escape closes the suggestions and keeps the text.

**Forms**

- Enter with nothing highlighted submits the text as typed.
- The field submits a chosen suggestion's text under its name.
- Required blocks submitting an empty field.
- A disabled field can't be focused or changed.

**Clear**

- The clear button empties the field and keeps focus in it.

Runs in React, Vue and web components.

Also tested:

**Enhancements**

- Inline completion fills in the first match with the rest selected after the caret.
- Backspace takes an inline completion out and doesn't complete again.
- ArrowRight accepts an inline completion.
- With inline completion, arrow keys fill in the suggestion they highlight.
- The suggestions open when the field gets focus.
- Enter with nothing highlighted runs onSubmit with the text.
- Filtering matches a suggestion's keywords.
- A form reset puts the default text back.
- The list is named by the field's label.
- An immediate search runs once when the autocomplete mounts.
- A newer search aborts the older one, and only its results land.
- Arrow keys keep the highlighted item in view when the … scrolls.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while typing and choosing with a keyboard.

Runs in React, Vue and web components.
