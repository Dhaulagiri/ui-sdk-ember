# Combobox

Search a list of options and choose one or several values.

Use a Combobox when people need to find a choice by typing. Start with an input and a list, then add chips, server results, or the option to create something new as you need them.

```glimmer-ts title="demo.gts"
import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "sveltekit", label: "SvelteKit" },
  { value: "nuxt", label: "Nuxt" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "solidstart", label: "SolidStart" },
  { value: "qwik", label: "Qwik City" },
]

<template>
  <Combobox as |c|>
    <div data-slot="stack">
      <c.Label>Framework</c.Label>
      <div data-slot="row">
        <c.Input placeholder="Select a framework" />
        <c.Trigger aria-label="Show frameworks">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No frameworks found.</c.Empty>
      <c.List>
        {{#each frameworks key="value" as |framework|}}
          <c.Item
            @value={{framework.value}}
            @label={{framework.label}}
            as |item|
          >
            {{framework.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Type “sv” to find SvelteKit. Press Down Arrow to highlight it, then Enter to choose it.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Combobox`:

```text
Combobox as |c|
├── c.Label
├── c.Input
└── c.Content
    └── c.List
        ├── c.Item
        └── c.Item
```

Name the input, give each option a unique value, and put the options in a list inside the popup. The label names the input; choosing an option puts its label in the input.

## Usage

Import the root and use the parts it yields:

```gts
import { Combobox } from "ember-ui-sdk/combobox"

<template>
  <Combobox as |c|>
    <c.Label>Fruit</c.Label>
    <c.Input placeholder="Search fruits…" />
    <c.Content>
      <c.List>
        <c.Item @value="apple" @label="Apple">Apple</c.Item>
        <c.Item @value="banana" @label="Banana">Banana</c.Item>
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

## Autocomplete vs Combobox

Both filter a list as you type. They differ in what the value is.

- **Combobox**: the value is an option from the list, or several with `@multiple`. The text is only a query; closing without choosing restores the selected label, and a form submits the value, not the text. Use it for a country, an assignee or a set of labels.
- **[Autocomplete](./autocomplete.md)**: the value is the text. Suggestions help fill it in, and anything typed is valid. Use it for a search box, an address or a free-form field.

`@allowCustomValue` lets a combobox accept text that matches no option, like a datalist. Reach for it when choosing from the list is the main path; use an autocomplete when free text is.

## Disabled

A disabled combobox cannot be focused or changed and submits nothing. A read-only one remains focusable and submits its value, but does not open or accept changes. Keyboard navigation skips a disabled option, and it cannot be chosen.

```glimmer-ts title="disabled.gts"
import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const countries = [
  { value: "ar", label: "Argentina" },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria" },
  { value: "be", label: "Belgium" },
  { value: "br", label: "Brazil" },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark" },
  { value: "fi", label: "Finland" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "gr", label: "Greece" },
  { value: "jp", label: "Japan" },
  { value: "nl", label: "Netherlands" },
  { value: "es", label: "Spain" },
  { value: "se", label: "Sweden" },
  { value: "ch", label: "Switzerland" },
]

const countryLabel = (value: string) =>
  countries.find((country) => country.value === value)?.label ?? value

const variants = ["disabled", "readOnly", "item"]

const defaultValueOf = (variant: string) => (variant === "item" ? null : "fr")
const isDisabled = (variant: string) => variant === "disabled"
const isReadOnly = (variant: string) => variant === "readOnly"
const labelOf = (variant: string) =>
  variant === "disabled"
    ? "Billing country"
    : variant === "readOnly"
      ? "Shipping from"
      : "Shipping to"
const isUnavailable = (value: string) => value === "dk"

<template>
  <div data-slot="stack">
    {{#each variants key="@identity" as |variant|}}
      <Combobox
        @defaultValue={{defaultValueOf variant}}
        @itemToLabel={{countryLabel}}
        @disabled={{isDisabled variant}}
        @readOnly={{isReadOnly variant}}
        as |c|
      >
        <div data-slot="stack">
          <c.Label>{{labelOf variant}}</c.Label>
          <div data-slot="row">
            <c.Input placeholder="Search countries…" />
            <c.Trigger aria-label="Show countries">{{icon
                ChevronDown
              }}</c.Trigger>
          </div>
        </div>
        <c.Content>
          <c.Empty>No countries found.</c.Empty>
          <c.List>
            {{#each countries key="value" as |country|}}
              <c.Item
                @value={{country.value}}
                @label={{country.label}}
                @disabled={{isUnavailable country.value}}
                as |item|
              >
                {{country.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Combobox>
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

Billing country is disabled and Shipping from is read-only. Open Shipping to: arrow keys skip Denmark, which can't be chosen.

## Clear and Trigger

`c.Clear` clears both the selection and the query, then keeps focus in the input. It appears while either has a value. When someone deletes all the text, a single selection clears right away instead of when the list closes. Escape brings the selection back while the list is still open; closing it any other way leaves it cleared.

```glimmer-ts title="clear.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"
import { useLog } from "./log"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "sveltekit", label: "SvelteKit" },
  { value: "nuxt", label: "Nuxt" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "solidstart", label: "SolidStart" },
  { value: "qwik", label: "Qwik City" },
]

const frameworkLabel = (value: string) =>
  frameworks.find((framework) => framework.value === value)?.label ?? value

export default class Clear extends Component {
  log = useLog(this)
  frameworkLabel = frameworkLabel
  @tracked value: string | null = "sveltekit"

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    this.log(`${next ? frameworkLabel(next) : "Cleared"} (${details.reason})`)
  }

  <template>
    <Combobox
      @value={{this.value}}
      @onValueChange={{this.onValueChange}}
      @itemToLabel={{this.frameworkLabel}}
      as |c|
    >
      <div data-slot="stack">
        <c.Label>Framework</c.Label>
        <div data-slot="row">
          <c.Input placeholder="Select a framework" />
          <c.Clear aria-label="Clear framework">{{icon X}}</c.Clear>
          <c.Trigger aria-label="Show frameworks">{{icon
              ChevronDown
            }}</c.Trigger>
        </div>
      </div>
      <c.Content>
        <c.Empty>No frameworks found.</c.Empty>
        <c.List>
          {{#each frameworks key="value" as |framework|}}
            <c.Item @value={{framework.value}} @label={{framework.label}} as |item|>
              {{framework.label}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Combobox>
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

Choose a framework, then press the clear button. The selection and text clear, focus stays in the input, and the console logs each change.

## Auto Highlight

Add `@autoHighlight={{true}}` to highlight the first match while typing, so Enter can choose it immediately. With `@autoHighlight="always"`, opening the list also highlights the selected item, or the first, so the arrow keys move from there. A highlight it placed follows the list as items arrive, and one the user moved stays while its item is there.

```glimmer-ts title="auto-highlight.gts"
import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const countries = [
  { value: "ar", label: "Argentina" },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria" },
  { value: "be", label: "Belgium" },
  { value: "br", label: "Brazil" },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark" },
  { value: "fi", label: "Finland" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "gr", label: "Greece" },
  { value: "jp", label: "Japan" },
  { value: "nl", label: "Netherlands" },
  { value: "es", label: "Spain" },
  { value: "se", label: "Sweden" },
  { value: "ch", label: "Switzerland" },
]

<template>
  <Combobox @autoHighlight={{true}} as |c|>
    <div data-slot="stack">
      <c.Label>Country</c.Label>
      <div data-slot="row">
        <c.Input placeholder="Type “sw” and press Enter" />
        <c.Trigger aria-label="Show countries">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No countries found.</c.Empty>
      <c.List>
        {{#each countries key="value" as |country|}}
          <c.Item @value={{country.value}} @label={{country.label}} as |item|>
            {{country.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Type “sw” and press Enter. The first matching country is already highlighted.

## Highlight Matches

`c.ItemText` marks the matching text. Matching ignores case and accents using the current locale, while the label keeps its original spelling. Its state also exposes segments if you want to render the marks yourself.

```glimmer-ts title="highlight.gts"
import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const countries = [
  { value: "ar", label: "Argentina", keywords: ["república argentina"] },
  { value: "au", label: "Australia", keywords: ["oz"] },
  { value: "at", label: "Austria", keywords: ["österreich"] },
  { value: "be", label: "Belgium", keywords: ["belgië", "belgique"] },
  { value: "br", label: "Brazil", keywords: ["brasil"] },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark", keywords: ["danmark"] },
  { value: "fi", label: "Finland", keywords: ["suomi"] },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany", keywords: ["deutschland"] },
  { value: "gr", label: "Greece", keywords: ["hellas", "ελλάδα"] },
  { value: "jp", label: "Japan", keywords: ["nippon", "日本"] },
  { value: "nl", label: "Netherlands", keywords: ["holland", "nederland"] },
  { value: "es", label: "Spain", keywords: ["españa"] },
  { value: "se", label: "Sweden", keywords: ["sverige"] },
  {
    value: "ch",
    label: "Switzerland",
    keywords: ["schweiz", "suisse", "svizzera"],
  },
]

<template>
  <Combobox as |c|>
    <div data-slot="stack">
      <c.Label>Country</c.Label>
      <div data-slot="row">
        <c.Input placeholder="Search countries…" />
        <c.Trigger aria-label="Show countries">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No countries found.</c.Empty>
      <c.List>
        {{#each countries key="value" as |country|}}
          <c.Item @value={{country.value}} @label={{country.label}} @keywords={{country.keywords}} as |item|>
            <item.Text @render={{true}} as |t|>
              <span {{t.part}}>
                {{#each t.state.segments key="@index" as |segment|}}
                  {{#if segment.match}}
                    <mark>{{segment.text}}</mark>
                  {{else}}
                    {{segment.text}}
                  {{/if}}
                {{/each}}
              </span>
            </item.Text>
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Type “an”. Matching letters are marked while each country keeps its original spelling.

## Filter and Keywords

`@filter` accepts `"contains"` (the default), `"startsWith"`, a function of the item and query, or `false` for results already filtered by a server. A function can return a score instead of `true` or `false`, and items you pass as `@items` then sort by it, best first. `fuzzyScore` from `@ui-sdk/core/text-match` scores an exact match above a prefix, and a prefix above a match inside the label.

Use `keywords` for text that should match without appearing in the label, such as a username or a country’s local name.

```glimmer-ts title="filter.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { Select } from "ember-ui-sdk/select"
import { icon } from "./icon"

const countries = [
  { value: "ar", label: "Argentina", keywords: ["república argentina"] },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria", keywords: ["österreich"] },
  { value: "be", label: "Belgium", keywords: ["belgië", "belgique"] },
  { value: "br", label: "Brazil", keywords: ["brasil"] },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark", keywords: ["danmark"] },
  { value: "fi", label: "Finland", keywords: ["suomi"] },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany", keywords: ["deutschland"] },
  { value: "gr", label: "Greece", keywords: ["hellas", "ελλάδα"] },
  { value: "jp", label: "Japan", keywords: ["nippon", "日本"] },
  { value: "nl", label: "Netherlands", keywords: ["holland", "nederland"] },
  { value: "es", label: "Spain", keywords: ["españa"] },
  { value: "se", label: "Sweden", keywords: ["sverige"] },
  {
    value: "ch",
    label: "Switzerland",
    keywords: ["schweiz", "suisse", "svizzera"],
  },
]

function fuzzy(item: { label: string }, query: string) {
  let at = 0
  for (const char of item.label.toLowerCase()) {
    if (char === query[at]?.toLowerCase()) {
      at++
    }
  }
  return at === query.length
}

const filters = {
  contains: "contains",
  startsWith: "startsWith",
  fuzzy,
}

const modes = [
  { value: "contains", label: "Contains" },
  { value: "startsWith", label: "Starts with" },
  { value: "fuzzy", label: "Fuzzy" },
]

export default class Filter extends Component {
  @tracked mode = "contains"

  modes = modes

  get filter() {
    return filters[this.mode as keyof typeof filters]
  }

  onModeChange = (next: string | null) => {
    if (next) this.mode = next
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select @items={{this.modes}} @value={{this.mode}} @onValueChange={{this.onModeChange}} as |s|>
          <s.Label>Filter</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.modes key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <Combobox @filter={{this.filter}} as |c|>
        <div data-slot="stack">
          <c.Label>Country</c.Label>
          <div data-slot="row">
            <c.Input placeholder="Try “an”, “swd” or “deutschland”" />
            <c.Trigger aria-label="Show countries">{{icon
                ChevronDown
              }}</c.Trigger>
          </div>
        </div>
        <c.Content>
          <c.Empty>No countries found.</c.Empty>
          <c.List>
            {{#each countries key="value" as |country|}}
              <c.Item
                @value={{country.value}}
                @label={{country.label}}
                @keywords={{country.keywords}}
                as |item|
              >
                {{country.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Combobox>
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

Type “an” and switch Filter between Contains and Starts with. Choose Fuzzy and type “swd” for Sweden, or type “deutschland” to find Germany through a keyword.

## Groups

Use `c.Group` and `c.GroupLabel` to name groups. Filtering hides empty groups and separators as their items disappear.

```glimmer-ts title="groups.gts"
import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const timezones = [
  {
    label: "Americas",
    items: [
      { value: "America/New_York", label: "New York" },
      { value: "America/Chicago", label: "Chicago" },
      { value: "America/Denver", label: "Denver" },
      { value: "America/Los_Angeles", label: "Los Angeles" },
      { value: "America/Sao_Paulo", label: "São Paulo" },
    ],
  },
  {
    label: "Europe",
    items: [
      { value: "Europe/London", label: "London" },
      { value: "Europe/Paris", label: "Paris" },
      { value: "Europe/Berlin", label: "Berlin" },
      { value: "Europe/Madrid", label: "Madrid" },
    ],
  },
  {
    label: "Asia & Pacific",
    items: [
      { value: "Asia/Tokyo", label: "Tokyo" },
      { value: "Asia/Singapore", label: "Singapore" },
      { value: "Asia/Kolkata", label: "Kolkata" },
      { value: "Australia/Sydney", label: "Sydney" },
    ],
  },
]

const isFirst = (index: number) => index === 0

<template>
  <Combobox as |c|>
    <div data-slot="stack">
      <c.Label>Timezone</c.Label>
      <div data-slot="row">
        <c.Input placeholder="Search cities…" />
        <c.Trigger aria-label="Show timezones">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No cities found.</c.Empty>
      <c.List>
        {{#each timezones key="label" as |group index|}}
          {{#unless (isFirst index)}}
            <c.Separator />
          {{/unless}}
          <c.Group as |g|>
            <g.Label>
              {{group.label}}
            </g.Label>
            {{#each group.items key="value" as |item|}}
              <g.Item @value={{item.value}} @label={{item.label}} as |entry|>
                {{item.label}}
                <entry.Indicator>{{icon Check}}</entry.Indicator>
              </g.Item>
            {{/each}}
          </c.Group>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Type “chic”. Chicago remains in Americas; groups with no matches disappear.

## Icons

`c.ItemIcon` keeps decorative icons out of accessible names, filtering, and match marks. `c.ValueIcon` projects the selected item’s icon next to the input; it takes no children and is only for a single selection.

Wrap the input and icon together, then use that wrapper as the popup’s `@anchor`. Add `@mirror={{true}}` for directional icons. An icon-only option still needs an `aria-label`.

```glimmer-ts title="icons.gts"
import {
  ArrowRight,
  ChevronDown,
  Check,
  Circle,
  CircleCheck,
  CircleX,
} from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

<template>
  <Combobox as |c|>
    <div data-slot="stack">
      <c.Label>Status</c.Label>
      <div id="status-field" data-slot="row">
        <c.ValueIcon />
        <c.Input placeholder="Select a status" />
        <c.Trigger aria-label="Show statuses">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content @anchor="#status-field">
      <c.Empty>No statuses found.</c.Empty>
      <c.List>
        <c.Item @value="backlog" @label="Backlog" as |item|>
          <item.Icon>{{icon Circle}}</item.Icon>
          <item.Text />
          <item.Indicator>{{icon Check}}</item.Indicator>
        </c.Item>
        <c.Item @value="in-progress" @label="In progress" as |item|>
          <item.Icon @mirror={{true}}>{{icon ArrowRight}}</item.Icon>
          <item.Text />
          <item.Indicator>{{icon Check}}</item.Indicator>
        </c.Item>
        <c.Item @value="done" @label="Done" as |item|>
          <item.Icon>{{icon CircleCheck}}</item.Icon>
          <item.Text />
          <item.Indicator>{{icon Check}}</item.Indicator>
        </c.Item>
        <c.Item @value="canceled" @label="Canceled" as |item|>
          <item.Icon>{{icon CircleX}}</item.Icon>
          <item.Text />
          <item.Indicator>{{icon Check}}</item.Indicator>
        </c.Item>
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose Done. Its icon appears next to the input as well as in the list.

## Custom Items

Show useful context beside a label, such as a username or role. Set `@label` explicitly so filtering and the input use the intended text, and put extra search terms in `keywords`.

```glimmer-ts title="custom-items.gts"
import { array } from "@ember/helper"
import { ChevronDown, Check } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const users = [
  { id: 1, name: "Hollis Grant", username: "hollis", role: "Owner" },
  { id: 2, name: "Inès Moreau", username: "ines", role: "Admin" },
  { id: 3, name: "Kofi Mensah", username: "kofi", role: "Member" },
  { id: 4, name: "Wren Takahashi", username: "wren", role: "Member" },
  { id: 5, name: "Tomasz Wójcik", username: "tomasz", role: "Guest" },
]

const initial = (name: string) => name.slice(0, 1)

<template>
  <Combobox as |c|>
    <div data-slot="stack">
      <c.Label>Owner</c.Label>
      <div data-slot="row">
        <c.Input placeholder="Search people…" />
        <c.Trigger aria-label="Show people">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No people found.</c.Empty>
      <c.List>
        {{#each users key="id" as |user|}}
          <c.Item @value={{user.username}} @label={{user.name}} @keywords={{array user.username}} as |item|>
            <span data-slot="badge">
              {{initial user.name}}
            </span>
            <span data-slot="stack">
              <span>{{user.name}}</span>
              <span data-slot="hint">@{{user.username}}</span>
            </span>
            <span data-slot="hint">
              {{user.role}}
            </span>
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Search for a person’s name or username. Choose a result to put that person’s name in the input.

## Items as Data

Pass `@items` when the combobox needs the whole collection, such as recent items or server results. It can render bare parts for you, or you can render the parts yourself from the list's `state.items`. Each item's `label` supplies the text for filtering and the input; `keywords` and `disabled` work the same as with items you render yourself. Lists and Menus covers the `ListData` format.

```gts
import { Combobox } from "ember-ui-sdk/combobox"

const fruits = [
  { value: "apple", label: "Apple" },
  { value: "cherry", label: "Cherry", keywords: ["red"] },
  {
    type: "group",
    label: "Citrus",
    items: [{ value: "lemon", label: "Lemon" }],
  },
]

<template>
  <Combobox @items={{fruits}} as |c|>
    <c.Input aria-label="Fruit" />
  </Combobox>
</template>
```

Items can change while the list is open. Selection and highlight stay on their items; removing the highlighted item clears the highlight.

## Recent Items

`@emptyItems` supplies suggestions while the query is empty. Pair it with `@items` for the full searchable collection. Render the list from `state.items` so it follows the active collection.

```glimmer-ts title="recent.gts"
import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const countries = [
  { value: "ar", label: "Argentina", keywords: ["república argentina"] },
  { value: "au", label: "Australia", keywords: ["oz"] },
  { value: "at", label: "Austria", keywords: ["österreich"] },
  { value: "be", label: "Belgium", keywords: ["belgië", "belgique"] },
  { value: "br", label: "Brazil", keywords: ["brasil"] },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark", keywords: ["danmark"] },
  { value: "fi", label: "Finland", keywords: ["suomi"] },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany", keywords: ["deutschland"] },
  { value: "gr", label: "Greece", keywords: ["hellas", "ελλάδα"] },
  { value: "jp", label: "Japan", keywords: ["nippon", "日本"] },
  { value: "nl", label: "Netherlands", keywords: ["holland", "nederland"] },
  { value: "es", label: "Spain", keywords: ["españa"] },
  { value: "se", label: "Sweden", keywords: ["sverige"] },
  {
    value: "ch",
    label: "Switzerland",
    keywords: ["schweiz", "suisse", "svizzera"],
  },
]

const recentCountries = [
  {
    type: "group",
    label: "Recent",
    items: [countries[9], countries[12], countries[15]],
  },
]

const announcement = (change: { type: string; count?: number }) =>
  change.type === "results" ? `${change.count} countries match` : null

<template>
  <Combobox @items={{countries}} @emptyItems={{recentCountries}} @announcement={{announcement}} as |c|>
    <div data-slot="stack">
      <c.Label>Country</c.Label>
      <div data-slot="row">
        <c.Input placeholder="Search countries…" />
        <c.Trigger aria-label="Show countries">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No countries found.</c.Empty>
      <c.List as |list|>
        {{#each list.state.items key="@identity" as |entry|}}
          {{#if entry.items}}
            <c.Group as |g|>
              <g.Label>{{entry.label}}</g.Label>
              {{#each entry.items key="value" as |country|}}
                <g.Item @value={{country.value}} @label={{country.label}} as |item|>
                  <item.Text />
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </g.Item>
              {{/each}}
            </c.Group>
          {{else}}
            <c.Item @value={{entry.value}} @label={{entry.label}} as |item|>
              <item.Text />
              <item.Indicator>{{icon Check}}</item.Indicator>
            </c.Item>
          {{/if}}
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Open the empty input to see Recent. Start typing to search all countries; clear the text to return to Recent.

## Object Values

Use `@itemToValue` for an object’s string identity and form value, `@itemToLabel` for its displayed text, and `@isItemEqualToValue` when two different objects can represent the same option.

```gts
<Combobox
  @name="reviewer"
  @itemToValue={{this.personId}}
  @itemToLabel={{this.personName}}
  @isItemEqualToValue={{this.samePerson}}
  as |c|
>…</Combobox>
```

## Multiple

Add `@multiple={{true}}` to make the value an array. Choosing an option toggles it, keeps the list open, and clears the query. Put `c.Value` and the input inside `c.Chips`, then render each value as a chip with a removal button.

Backspace in an empty input removes the last chip in one press. Unlike [Token Input](./token-input.md#deleting-tokens), there is no `tokenDeletion` option to select it first. Arrow keys move between chips. Supply `@itemToLabel` when starting with values whose labels are not yet known from rendered items.

Add `@keepQuery={{true}}` to choose several matches without retyping the query.

```glimmer-ts title="multiple.gts"
import { array, get } from "@ember/helper"
import { Check, ChevronDown, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "sveltekit", label: "SvelteKit" },
  { value: "nuxt", label: "Nuxt" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "solidstart", label: "SolidStart" },
  { value: "qwik", label: "Qwik City" },
]

const frameworkLabel = (value: string) =>
  frameworks.find((framework) => framework.value === value)?.label ?? value

<template>
  <Combobox @multiple={{true}} @defaultValue={{array "next" "astro"}} @itemToLabel={{frameworkLabel}} as |c|>
    <div data-slot="stack">
      <c.Label>Frameworks</c.Label>
      <div data-slot="row">
        <c.Chips>
          <c.Value as |state|>
            {{#each state.value key="@identity" as |value index|}}
              <c.Chip @value={{value}} as |chip|>
                {{get state.labels index}}
                <chip.Remove
                  aria-label="Remove {{get state.labels index}}"
                >{{icon X}}</chip.Remove>
              </c.Chip>
            {{/each}}
          </c.Value>
          <c.Input placeholder="Add a framework…" />
        </c.Chips>
        <c.Trigger aria-label="Show frameworks">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No frameworks found.</c.Empty>
      <c.List>
        {{#each frameworks key="value" as |framework|}}
          <c.Item @value={{framework.value}} @label={{framework.label}} as |item|>
            {{framework.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose several frameworks. Remove one with its chip button, or press Backspace in the empty input to remove the last chip.

## Select All

`c.SelectAll` toggles every matching, enabled option. Inside a group, it affects only that group. It joins keyboard navigation and reports a mixed state while some of its options are selected.

```glimmer-ts title="select-all.gts"
import { array, get } from "@ember/helper"
import { Check, Minus, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const timezones = [
  {
    label: "Americas",
    items: [
      { value: "America/New_York", label: "New York" },
      { value: "America/Chicago", label: "Chicago" },
      { value: "America/Denver", label: "Denver" },
      { value: "America/Los_Angeles", label: "Los Angeles" },
      { value: "America/Sao_Paulo", label: "São Paulo" },
    ],
  },
  {
    label: "Europe",
    items: [
      { value: "Europe/London", label: "London" },
      { value: "Europe/Paris", label: "Paris" },
      { value: "Europe/Berlin", label: "Berlin" },
      { value: "Europe/Madrid", label: "Madrid" },
    ],
  },
  {
    label: "Asia & Pacific",
    items: [
      { value: "Asia/Tokyo", label: "Tokyo" },
      { value: "Asia/Singapore", label: "Singapore" },
      { value: "Asia/Kolkata", label: "Kolkata" },
      { value: "Australia/Sydney", label: "Sydney" },
    ],
  },
]

const groupSelectAllLabel = (checked: boolean, label: string) =>
  checked ? `Clear ${label}` : `Select all in ${label}`

<template>
  <Combobox @multiple={{true}} @defaultValue={{array "Europe/Paris"}} as |c|>
    <div data-slot="stack">
      <c.Label>Timezones</c.Label>
      <c.Chips>
        <c.Value as |state|>
          {{#each state.value key="@identity" as |value index|}}
            <c.Chip @value={{value}} as |chip|>
              {{get state.labels index}}
              <chip.Remove aria-label="Remove {{get state.labels index}}">{{icon
                  X
                }}</chip.Remove>
            </c.Chip>
          {{/each}}
        </c.Value>
        <c.Input placeholder="Add timezones…" />
      </c.Chips>
    </div>
    <c.Content>
      <c.Empty>No timezones found.</c.Empty>
      <c.List>
        <c.SelectAll>
          <span>
            {{icon Check}}
            {{icon Minus}}
          </span>
          Select all
        </c.SelectAll>
        {{#each timezones key="label" as |group|}}
          <c.Group as |g|>
            <g.Label>
              {{group.label}}
            </g.Label>
            <g.SelectAll as |sa|>
              {{groupSelectAllLabel sa.state.checked group.label}}
            </g.SelectAll>
            {{#each group.items key="value" as |zone|}}
              <g.Item @value={{zone.value}} @label={{zone.label}} as |item|>
                <span>
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </span>
                {{zone.label}}
              </g.Item>
            {{/each}}
          </c.Group>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Open the list and choose a group’s select-all option. Type to narrow the matches, then use the main select-all option on those results.

## Chips That Collapse

Add `c.ChipsOverflow` to keep chips on one line. It measures which chips fit, hides the rest, and exposes their count and labels. Separately, `c.Value` can use `@max` to show a short text summary of the selection.

```glimmer-ts title="chips-overflow.gts"
import { array, concat, get } from "@ember/helper"
import { Check, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const countries = [
  { value: "ar", label: "Argentina" },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria" },
  { value: "be", label: "Belgium" },
  { value: "br", label: "Brazil" },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark" },
  { value: "fi", label: "Finland" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "gr", label: "Greece" },
  { value: "jp", label: "Japan" },
  { value: "nl", label: "Netherlands" },
  { value: "es", label: "Spain" },
  { value: "se", label: "Sweden" },
  { value: "ch", label: "Switzerland" },
]

const countryLabel = (value: string) =>
  countries.find((country) => country.value === value)?.label ?? value

const joinLabels = (labels: string[]) => labels.join(", ")

<template>
  <Combobox
    @multiple={{true}}
    @defaultValue={{array "fr" "jp" "se" "de" "ch"}}
    @itemToLabel={{countryLabel}}
    as |c|
  >
    <div data-slot="stack">
      <c.Label>Countries</c.Label>
      <c.Chips>
        <c.Value as |state|>
          {{#each state.value key="@identity" as |value index|}}
            <c.Chip @value={{value}} as |chip|>
              {{get state.labels index}}
              <chip.Remove
                aria-label={{concat "Remove " (get state.labels index)}}
              >{{icon X}}</chip.Remove>
            </c.Chip>
          {{/each}}
        </c.Value>
        <c.ChipsOverflow @render={{true}} as |o|>
          <span {{o.part}} title={{joinLabels o.state.labels}} data-slot="hint">
            +{{o.state.count}}
          </span>
        </c.ChipsOverflow>
        <c.Input placeholder="Add…" />
      </c.Chips>
      <p data-slot="hint">
        <c.Value @maxLabels={{2}} />
      </p>
    </div>
    <c.Content>
      <c.Empty>No countries found.</c.Empty>
      <c.List>
        {{#each countries key="value" as |country|}}
          <c.Item @value={{country.value}} @label={{country.label}} as |item|>
            {{country.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Add or remove countries. Chips that no longer fit are replaced by an overflow count; the summary below lists the first two.

## Max Selected

`@maxSelected` limits a multiple selection. Once the limit is reached, other options become disabled; their `maxReached` state explains why.

```glimmer-ts title="max-selected.gts"
import { array } from "@ember/helper"
import { Check, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const labels = [
  "Bug",
  "Feature",
  "Documentation",
  "Design",
  "Performance",
  "Security",
  "Testing",
]

<template>
  <Combobox @multiple={{true}} @maxSelected={{3}} @defaultValue={{array "Bug" "Design"}} as |c|>
    <div data-slot="stack">
      <c.Label>Labels (up to 3)</c.Label>
      <c.Chips>
        <c.Value as |state|>
          {{#each state.value key="@identity" as |label|}}
            <c.Chip @value={{label}} as |chip|>
              {{label}}
              <chip.Remove aria-label="Remove {{label}}">{{icon
                  X
                }}</chip.Remove>
            </c.Chip>
          {{/each}}
        </c.Value>
        <c.Input placeholder="Add labels…" />
      </c.Chips>
    </div>
    <c.Content>
      <c.List>
        {{#each labels key="@identity" as |label|}}
          <c.Item @value={{label}} as |item|>
            {{label}}
            {{#if item.state.maxReached}}
              <span data-slot="hint">Limit reached</span>
            {{/if}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Choose a third label. Other unselected labels become unavailable until you remove one.

## Create Option

`c.Create` offers the query when no label matches it exactly and it meets `@minLength`. Use `@onCreate` to save it; return a promise for asynchronous work. Creation does not change the selection itself: add the new item and select it after saving.

While saving, the option reports `data-pending`, `aria-busy` and `aria-disabled`. A rejected promise is available through its error state.

```glimmer-ts title="create.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, LoaderCircle, Plus, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

function saveLabel(name: string) {
  return new Promise<void>((resolve, reject) =>
    setTimeout(
      () =>
        name.length > 20
          ? reject(new Error("Labels are 20 characters at most."))
          : resolve(),
      800
    )
  )
}

export default class Create extends Component {
  @tracked labels = [
    "Bug",
    "Feature",
    "Documentation",
    "Design",
    "Performance",
    "Security",
    "Testing",
  ]
  @tracked value: string[] = ["Bug"]

  create = async (query: string) => {
    await saveLabel(query)
    this.labels = [...this.labels, query]
    this.value = [...this.value, query]
  }

  onValueChange = (next: string[]) => {
    this.value = next
  }

  <template>
    <Combobox @value={{this.value}} @onValueChange={{this.onValueChange}} @multiple={{true}} as |c|>
      <div data-slot="stack">
        <c.Label>Labels</c.Label>
        <c.Chips>
          <c.Value as |state|>
            {{#each state.value key="@identity" as |label|}}
              <c.Chip @value={{label}} as |chip|>
                {{label}}
                <chip.Remove aria-label="Remove {{label}}">{{icon
                    X
                  }}</chip.Remove>
              </c.Chip>
            {{/each}}
          </c.Value>
          <c.Input placeholder="Add or create a label…" />
        </c.Chips>
      </div>
      <c.Content>
        <c.List>
          {{#each this.labels key="@identity" as |label|}}
            <c.Item @value={{label}} as |item|>
              {{label}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </c.Item>
          {{/each}}
          <c.Create @minLength={{2}} @onCreate={{this.create}} as |cr|>
            {{#if cr.state.pending}}
              <span data-slot="spinner">{{icon LoaderCircle}}</span>
              Creating “{{cr.state.query}}”…
            {{else}}
              {{icon Plus}}
              <span data-slot="stack">
                Create “{{cr.state.query}}”
                {{#if cr.state.error}}<span
                    data-slot="hint"
                  >{{cr.state.error.message}}</span>{{/if}}
              </span>
            {{/if}}
          </c.Create>
        </c.List>
      </c.Content>
    </Combobox>
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

Type a new label and choose Create. It becomes a selected chip after saving; a label longer than 20 characters shows an error.

## Custom Value

Use `@allowCustomValue={{true}}` when suggestions are optional, like a datalist. Unmatched text becomes the value on Enter with nothing highlighted, or when the list closes. This does not create a new item in the collection.

```glimmer-ts title="custom-value.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"
import { useLog } from "./log"

const titles = [
  "Designer",
  "Engineer",
  "Engineering manager",
  "Product manager",
  "Researcher",
]

export default class CustomValue extends Component {
  log = useLog(this)
  @tracked value: string | null = null

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    this.log(`${next ? `“${next}”` : "No title"} (${details.reason})`)
  }

  <template>
    <Combobox @allowCustomValue={{true}} @value={{this.value}} @onValueChange={{this.onValueChange}} as |c|>
      <div data-slot="stack">
        <c.Label>Job title</c.Label>
        <c.Input placeholder="Type any title…" />
      </div>
      <c.Content>
        <c.Empty as |e|>
          Press Enter to use “{{e.state.query}}”.
        </c.Empty>
        <c.List>
          {{#each titles key="@identity" as |title|}}
            <c.Item @value={{title}} as |item|>
              {{title}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Combobox>
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

Type a job title that isn't suggested, then press Enter without a highlighted option or leave the field. The text becomes the value, and the console logs it.

## Input in the Popup

The input can live inside the popup, opened by a button showing the current value. The button then stays in the tab order. Anchor the content to it, clear the query when opening, and return focus to it after closing, as this example does.

```glimmer-ts title="popup.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown, Search } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const countries = [
  { value: "ar", label: "Argentina" },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria" },
  { value: "be", label: "Belgium" },
  { value: "br", label: "Brazil" },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark" },
  { value: "fi", label: "Finland" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "gr", label: "Greece" },
  { value: "jp", label: "Japan" },
  { value: "nl", label: "Netherlands" },
  { value: "es", label: "Spain" },
  { value: "se", label: "Sweden" },
  { value: "ch", label: "Switzerland" },
]

const countryLabel = (value: string) =>
  countries.find((country) => country.value === value)?.label ?? value

export default class Popup extends Component {
  @tracked query = ""

  onQueryChange = (next: string) => {
    this.query = next
  }

  onOpenChange = (open: boolean) => {
    if (open) {
      this.query = ""
    }
  }

  onOpenChangeComplete = (open: boolean) => {
    if (!open) {
      document.querySelector<HTMLElement>("#country-trigger")?.focus()
    }
  }

  <template>
    <Combobox
      @query={{this.query}}
      @onQueryChange={{this.onQueryChange}}
      @defaultValue="jp"
      @itemToLabel={{countryLabel}}
      @onOpenChange={{this.onOpenChange}}
      @onOpenChangeComplete={{this.onOpenChangeComplete}}
      as |c|
    >
      <c.Trigger @render={{true}} as |t|>
        <button {{t.part}} id="country-trigger" aria-label="Country" type="button">
          <span>
            <c.Value as |state|>
              {{#if state.label}}{{state.label}}{{else}}Select a country{{/if}}
            </c.Value>
          </span>
          {{icon ChevronDown}}
        </button>
      </c.Trigger>
      <c.Content @anchor="#country-trigger">
        <div data-slot="row">
          {{icon Search}}
          <c.Input autofocus aria-label="Search countries" placeholder="Search…" />
        </div>
        <c.Empty>No countries found.</c.Empty>
        <c.List>
          {{#each countries key="value" as |country|}}
            <c.Item @value={{country.value}} @label={{country.label}} as |item|>
              {{country.label}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Combobox>
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

Press Country to open the search field inside the popup. Choose a country; closing the popup returns focus to the button.

## Async Search

Use `useAsyncOptions` from `ember-ui-sdk/async-options` to debounce a search and discard stale results. Pass its `items` and `status` to the combobox, set `@filter` to `false`, and send query changes to the loader.

`c.Status` and `c.Empty` provide loading, error, and empty messages. Without a custom status, the combobox announces the result count once typing pauses.

```glimmer-ts title="async.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const movieTitles = [
  "The Shawshank Redemption",
  "The Godfather",
  "The Dark Knight",
  "Pulp Fiction",
  "Schindler's List",
  "The Lord of the Rings",
  "Fight Club",
  "Forrest Gump",
  "Inception",
  "The Matrix",
  "Goodfellas",
  "Interstellar",
  "Parasite",
  "Spirited Away",
  "Whiplash",
  "The Prestige",
  "The Departed",
  "Gladiator",
  "Alien",
  "Casablanca",
  "Amélie",
  "Arrival",
]

function searchMovies(query: string, { signal }: { signal: AbortSignal }) {
  return new Promise<{ value: string; label: string }[]>((resolve, reject) => {
    const timer = setTimeout(() => {
      const needle = query.trim().toLowerCase()
      resolve(
        movieTitles
          .filter((title) => title.toLowerCase().includes(needle))
          .map((title) => ({
            value: title.toLowerCase().replace(/\W+/g, "-"),
            label: title,
          }))
      )
    }, 500)
    signal.addEventListener("abort", () => {
      clearTimeout(timer)
      reject(signal.reason)
    })
  })
}

const statusText = (state: {
  status: string
  loading: boolean
  count: number
}) =>
  state.status === "error"
    ? "Couldn't load movies."
    : state.loading
      ? "Searching…"
      : `${state.count} ${state.count === 1 ? "movie" : "movies"}`

export default class Async extends Component {
  movies = useAsyncOptions(this, searchMovies, {
    debounce: 300,
    query: "the",
    immediate: true,
  })

  statusText = statusText

  onQueryChange = (query: string) => {
    this.movies.setQuery(query)
  }

  <template>
    <Combobox
      @items={{this.movies.state.items}}
      @defaultQuery="the"
      @filter={{false}}
      @status={{this.movies.state.status}}
      @onQueryChange={{this.onQueryChange}}
      as |c|
    >
      <div data-slot="stack">
        <c.Label>Movie</c.Label>
        <div data-slot="row">
          <c.Input placeholder="Search movies…" />
          <c.Trigger aria-label="Show movies">{{icon ChevronDown}}</c.Trigger>
        </div>
      </div>
      <c.Content>
        <c.Status as |s|>{{this.statusText s.state}}</c.Status>
        <c.Empty as |e|>
          {{#unless e.state.loading}}No movies match “{{e.state.query}}”.{{/unless}}
        </c.Empty>
        <c.List as |list|>
          {{#each list.state.items key="value" as |item|}}
            <c.Item @value={{item.value}} @label={{item.label}} @disabled={{item.disabled}} as |i|>
              {{item.label}}
              <i.Indicator>{{icon Check}}</i.Indicator>
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Combobox>
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

Replace “the” with another movie title. The status shows the pending search, then the latest results.

## Load More

`@onLoadMore` runs when scrolling or highlighting reaches the last option, once per page and not while a page loads. Connect it to the async loader’s `loadMore()`; return `{ items, hasMore }` from each page.

```glimmer-ts title="infinite.gts"
import Component from "@glimmer/component"
import { Check, ChevronDown } from "lucide"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const movieTitles = [
  "The Shawshank Redemption",
  "The Godfather",
  "The Dark Knight",
  "Pulp Fiction",
  "Schindler's List",
  "The Lord of the Rings",
  "Fight Club",
  "Forrest Gump",
  "Inception",
  "The Matrix",
  "Goodfellas",
  "Interstellar",
  "Parasite",
  "Spirited Away",
  "Whiplash",
  "The Prestige",
  "The Departed",
  "Gladiator",
  "Alien",
  "Casablanca",
  "Amélie",
  "Arrival",
]

function searchMoviePages(
  query: string,
  { signal, page }: { signal: AbortSignal; page: number }
) {
  return new Promise<{
    items: { value: string; label: string }[]
    hasMore: boolean
  }>((resolve, reject) => {
    const timer = setTimeout(() => {
      const needle = query.trim().toLowerCase()
      const found = movieTitles
        .filter((title) => title.toLowerCase().includes(needle))
        .map((title) => ({
          value: title.toLowerCase().replace(/\W+/g, "-"),
          label: title,
        }))
      resolve({
        items: found.slice(page * 5, page * 5 + 5),
        hasMore: found.length > page * 5 + 5,
      })
    }, 500)
    signal.addEventListener("abort", () => {
      clearTimeout(timer)
      reject(signal.reason)
    })
  })
}

export default class Infinite extends Component {
  movies = useAsyncOptions(this, searchMoviePages, { immediate: true })

  onQueryChange = (query: string) => {
    this.movies.setQuery(query)
  }

  onLoadMore = () => {
    this.movies.loadMore()
  }

  statusText = (state: { loading: boolean; count: number }) =>
    state.loading
      ? "Loading more…"
      : this.movies.state.hasMore
        ? `${state.count} loaded`
        : `All ${state.count}`

  <template>
    <Combobox
      @items={{this.movies.state.items}}
      @filter={{false}}
      @status={{this.movies.state.status}}
      @onQueryChange={{this.onQueryChange}}
      @onLoadMore={{this.onLoadMore}}
      as |c|
    >
      <div data-slot="stack">
        <c.Label>Movie</c.Label>
        <div data-slot="row">
          <c.Input placeholder="Search movies…" />
          <c.Trigger aria-label="Show movies">{{icon ChevronDown}}</c.Trigger>
        </div>
      </div>
      <c.Content>
        <c.Empty as |e|>
          {{#unless e.state.loading}}No movies found.{{/unless}}
        </c.Empty>
        <c.List as |list|>
          {{#each list.state.items key="value" as |item|}}
            <c.Item @value={{item.value}} @label={{item.label}} @disabled={{item.disabled}} as |i|>
              {{item.label}}
              <i.Indicator>{{icon Check}}</i.Indicator>
            </c.Item>
          {{/each}}
        </c.List>
        <c.Status as |s|>{{this.statusText s.state}}</c.Status>
      </c.Content>
    </Combobox>
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

Open the movies and scroll or arrow to the last result. Another page loads while the existing results stay available.

## Virtualized

Supply `@items` so filtering and keyboard navigation know about every option, even when only a few rows render. The list’s `state.items` contains matches, `@onHighlight` reports the row to reveal, and each rendered item’s `@index` gives its position in the full list to screen readers.

This example windows 10,000 items. Keep the actual row height aligned with your virtualizer’s measurement, and use the scroller’s visible height when revealing a row.

```glimmer-ts title="virtualized.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { htmlSafe } from "@ember/template"
import { tracked } from "@glimmer/tracking"
import { Combobox } from "ember-ui-sdk/combobox"
import { ChevronDown } from "lucide"
import { attach } from "ember-ui-sdk/primitive"
import { icon } from "./icon"

const manyItems = Array.from({ length: 10_000 }, (_, index) => ({
  value: `item-${index + 1}`,
  label: `Item ${index + 1}`,
}))

const row = 32
const height = 288

function scrollForRow(
  index: number,
  scrollTop: number,
  viewport: number,
  size: number
) {
  const top = index * size
  if (top < scrollTop) {
    return top
  }
  if (top + size > scrollTop + viewport) {
    return top + size - viewport
  }
  return scrollTop
}

export default class Virtualized extends Component {
  items = manyItems
  scroller: HTMLElement | null = null
  @tracked scrollTop = 0

  setScroller = (element: HTMLElement) => {
    this.scroller = element
  }

  onHighlight = (_value: unknown, { index }: { index: number }) => {
    const el = this.scroller
    if (el && index >= 0) {
      el.scrollTop = scrollForRow(index, el.scrollTop, el.clientHeight, row)
    }
  }

  onScroll = (event: Event) => {
    this.scrollTop = (event.currentTarget as HTMLElement).scrollTop
  }

  visible = (items: typeof manyItems) => {
    const start = Math.max(0, Math.floor(this.scrollTop / row) - 4)
    const end = Math.min(
      items.length,
      Math.ceil((this.scrollTop + height) / row) + 4
    )
    return items
      .slice(start, end)
      .map((item, offset) => ({ item, index: start + offset }))
  }

  heightOf = (count: number) => htmlSafe(`height: ${count * row}px`)

  rowStyle = (index: number) =>
    htmlSafe(`top: ${index * row}px; height: ${row}px`)

  <template>
    <Combobox @items={{this.items}} @onHighlight={{this.onHighlight}} as |c|>
      <div data-slot="stack">
        <c.Label>Item</c.Label>
        <div data-slot="row">
          <c.Input placeholder="Search 10,000 items…" />
          <c.Trigger aria-label="Show items">
            {{icon ChevronDown}}
          </c.Trigger>
        </div>
      </div>
      <c.Content>
        <c.Empty>No items found.</c.Empty>
        <div {{attach this.setScroller}} {{on "scroll" this.onScroll}}>
          <c.List as |list|>
            <div style={{this.heightOf list.state.items.length}}>
              {{#each
                (this.visible list.state.items) key="item.value"
                as |entry|
              }}
                <c.Item
                  @value={{entry.item.value}}
                  @label={{entry.item.label}}
                  @index={{entry.index}}
                  style={{this.rowStyle entry.index}}
                >
                  {{entry.item.label}}
                </c.Item>
              {{/each}}
            </div>
          </c.List>
        </div>
      </c.Content>
    </Combobox>
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

Search 10,000 items or move through them with the arrow keys. Only the nearby rows render.

## Controlled

The selection, text, and popup have separate values:

| Argument | Change callback  | Meaning                                         |
| -------- | ---------------- | ----------------------------------------------- |
| `@value` | `@onValueChange` | One value or `null`; an array with `@multiple`. |
| `@query` | `@onQueryChange` | The input’s text.                               |
| `@open`  | `@onOpenChange`  | Whether the popup is open.                      |

Control only the values you need. Change callbacks include a reason and `details.cancel()` to reject the request. Choosing an item writes its label into the input, and a canceled choice keeps the current one. Closing without choosing restores the value’s label unless custom values are allowed.

Focus leaving the input closes the popup with the reason `focus-out`, even when code moves it, like a notice that takes focus. To keep the popup open, cancel that close in `@onOpenChange`.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"
import { useLog } from "./log"

const countries = [
  { value: "ar", label: "Argentina" },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria" },
  { value: "be", label: "Belgium" },
  { value: "br", label: "Brazil" },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark" },
  { value: "fi", label: "Finland" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "gr", label: "Greece" },
  { value: "jp", label: "Japan" },
  { value: "nl", label: "Netherlands" },
  { value: "es", label: "Spain" },
  { value: "se", label: "Sweden" },
  { value: "ch", label: "Switzerland" },
]

const countryLabel = (value: string) =>
  countries.find((country) => country.value === value)?.label ?? value

export default class Controlled extends Component {
  log = useLog(this)
  itemToLabel = countryLabel
  @tracked value: string | null = "fr"
  @tracked query = "France"
  @tracked open = false

  chooseJapan = () => {
    this.value = "jp"
  }

  showOpen = () => {
    this.open = true
  }

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    this.log(`value: ${next} (${details.reason})`)
  }

  onQueryChange = (next: string, details: { reason: string }) => {
    this.query = next
    this.log(`query: “${next}” (${details.reason})`)
  }

  onOpenChange = (next: boolean, details: { reason: string }) => {
    this.open = next
    this.log(`open: ${next} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.chooseJapan}}>Choose Japan</button>
        <button type="button" {{on "click" this.showOpen}}>Open</button>
      </div>
      <Combobox
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @query={{this.query}}
        @onQueryChange={{this.onQueryChange}}
        @open={{this.open}}
        @onOpenChange={{this.onOpenChange}}
        @itemToLabel={{this.itemToLabel}}
        as |c|
      >
        <div data-slot="stack">
          <c.Label>Country</c.Label>
          <div data-slot="row">
            <c.Input placeholder="Search countries…" />
            <c.Trigger aria-label="Show countries">{{icon
                ChevronDown
              }}</c.Trigger>
          </div>
        </div>
        <c.Content>
          <c.Empty>No countries found.</c.Empty>
          <c.List>
            {{#each countries key="value" as |country|}}
              <c.Item @value={{country.value}} @label={{country.label}} as |item|>
                {{country.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Combobox>
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

Type, choose, or use the buttons. The console logs each value, query and open change with its reason.

## Controller

Pass a controller from `createComboboxController()`. It can read or set the value and query, open or close the list, and focus the input. `open()` resolves when the list closes with its reason and source, including `unmount`; pass an abort signal to close it on cancellation.

```glimmer-ts title="controller.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Check, ChevronDown } from "lucide"
import { Combobox, createComboboxController } from "ember-ui-sdk/combobox"
import { icon } from "./icon"
import { useLog } from "./log"

const countries = [
  { value: "ar", label: "Argentina" },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria" },
  { value: "be", label: "Belgium" },
  { value: "br", label: "Brazil" },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark" },
  { value: "fi", label: "Finland" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "gr", label: "Greece" },
  { value: "jp", label: "Japan" },
  { value: "nl", label: "Netherlands" },
  { value: "es", label: "Spain" },
  { value: "se", label: "Sweden" },
  { value: "ch", label: "Switzerland" },
]

const countryLabel = (value: string) =>
  countries.find((country) => country.value === value)?.label ?? value

export default class Controller extends Component {
  log = useLog(this)
  country = createComboboxController<string>()
  itemToLabel = countryLabel

  openAndWait = async () => {
    const { reason } = await this.country.open()
    this.log(
      `Closed by ${reason}, with ${this.country.getValue() ?? "nothing"}`
    )
  }

  search = () => {
    this.country.focus()
    this.country.setQuery("sw")
    this.country.open()
  }

  chooseGermany = () => {
    this.country.setValue("de")
  }

  clear = () => {
    this.country.clear()
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.openAndWait}}>Open and Wait</button>
        <button type="button" {{on "click" this.search}}>Search “sw”</button>
        <button type="button" {{on "click" this.chooseGermany}}>Choose Germany</button>
        <button type="button" {{on "click" this.clear}}>Clear</button>
      </div>
      <Combobox @controller={{this.country}} @itemToLabel={{this.itemToLabel}} as |c|>
        <div data-slot="stack">
          <c.Label>Country</c.Label>
          <div data-slot="row">
            <c.Input placeholder="Search countries…" />
            <c.Trigger aria-label="Show countries">{{icon
                ChevronDown
              }}</c.Trigger>
          </div>
        </div>
        <c.Content>
          <c.Empty>No countries found.</c.Empty>
          <c.List>
            {{#each countries key="value" as |item|}}
              <c.Item @value={{item.value}} @label={{item.label}} as |entry|>
                {{item.label}}
                <entry.Indicator>{{icon Check}}</entry.Indicator>
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Combobox>
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

Use the buttons to drive the combobox from outside. Open and Wait logs how the list closed and what was chosen.

## Positioning

`@side` and `@align` place the popup around the input or chips. `@anchor` can use a different element, and `c.Arrow` follows the side chosen after collision handling. Popups covers offsets and available space.

The page stays usable by default. `@modal="pointer"` makes an outside press only dismiss the list; `@modal={{true}}` also locks scrolling and makes the rest of the page inert. The popup uses the top layer and renders in place; use `@container` when its DOM belongs elsewhere, such as a shadow root.

```glimmer-ts title="positioning.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check, ChevronDown } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Combobox } from "ember-ui-sdk/combobox"
import { Select } from "ember-ui-sdk/select"
import { icon } from "./icon"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "sveltekit", label: "SvelteKit" },
  { value: "nuxt", label: "Nuxt" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "solidstart", label: "SolidStart" },
  { value: "qwik", label: "Qwik City" },
]

const sides = [
  { value: "top", label: "Top" },
  { value: "right", label: "Right" },
  { value: "bottom", label: "Bottom" },
  { value: "left", label: "Left" },
]

const aligns = [
  { value: "start", label: "Start" },
  { value: "center", label: "Center" },
  { value: "end", label: "End" },
]

export default class Positioning extends Component {
  @tracked side = "bottom"
  @tracked align = "start"
  @tracked anchored = false

  sides = sides
  aligns = aligns
  frameworks = frameworks

  get anchor() {
    return this.anchored ? "#positioning-box" : null
  }

  onSideChange = (next: string | null) => {
    if (next) this.side = next
  }

  onAlignChange = (next: string | null) => {
    if (next) this.align = next
  }

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.anchored = next === true
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select @items={{this.sides}} @value={{this.side}} @onValueChange={{this.onSideChange}} as |s|>
          <s.Label>Side</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.sides key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <Select @items={{this.aligns}} @value={{this.align}} @onValueChange={{this.onAlignChange}} as |s|>
          <s.Label>Align</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.aligns key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <label data-slot="label">
          <Checkbox @checked={{this.anchored}} @onCheckedChange={{this.onCheckedChange}} as |c|>
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Anchor to the box
        </label>
      </div>
      <div id="positioning-box" data-slot="card">
        <Combobox as |c|>
          <c.Input aria-label="Framework" placeholder="Framework" />
          <c.Content
            @side={{this.side}}
            @align={{this.align}}
            @sideOffset={{10}}
            @alignOffset={{0}}
            @collisionPadding={{16}}
            @anchor={{this.anchor}}
          >
            <c.Empty>No frameworks found.</c.Empty>
            <c.List>
              {{#each this.frameworks key="value" as |framework|}}
                <c.Item @value={{framework.value}} @label={{framework.label}} as |item|>
                  {{framework.label}}
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </c.Item>
              {{/each}}
            </c.List>
          </c.Content>
        </Combobox>
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

Pick a side and an alignment, then open the list. Check Anchor to the Box to place it against the box instead of the input.

## Animation

The content has `data-starting-style` while it opens and `data-ending-style` while it closes. Transition from those states, and the popup stays mounted until the exit finishes. `@onOpenChangeComplete` runs after opening or closing finishes, and `@keepMounted={{true}}` on an item indicator keeps it in the page for a selection animation.

```css
[data-slot="combobox-content"] {
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
import Component from "@glimmer/component"
import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"
import { useLog } from "./log"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "sveltekit", label: "SvelteKit" },
  { value: "nuxt", label: "Nuxt" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "solidstart", label: "SolidStart" },
  { value: "qwik", label: "Qwik City" },
]

export default class Animation extends Component {
  log = useLog(this)

  onOpenChangeComplete = (open: boolean) => {
    this.log(open ? "Finished opening" : "Finished closing")
  }

  <template>
    <Combobox @onOpenChangeComplete={{this.onOpenChangeComplete}} as |c|>
      <div data-slot="stack">
        <c.Label>Framework</c.Label>
        <div data-slot="row">
          <c.Input placeholder="Select a framework" />
          <c.Trigger aria-label="Show frameworks">{{icon
              ChevronDown
            }}</c.Trigger>
        </div>
      </div>
      <c.Content>
        <c.Empty>No frameworks found.</c.Empty>
        <c.List>
          {{#each frameworks key="value" as |framework|}}
            <c.Item @value={{framework.value}} @label={{framework.label}} as |item|>
              {{framework.label}}
              <item.Indicator @keepMounted={{true}}>{{icon
                  Check
                }}</item.Indicator>
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Combobox>
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

Open and close the list. The console logs when each animation finishes.

## Presentation

Use `@presentation="sheet"` for a sheet, or `"auto"` to choose a sheet on small touch screens each time the list opens. The input moves into the sheet’s header; there is still one input and one query.

A touch opening leaves the keyboard closed. Tapping the header input opens the keyboard and grows the sheet; closing the keyboard keeps the query. Choosing an item closes the sheet unless `@multiple` is set. Swiping down closes it with the reason `swipe`.

Keep the options inside `c.List` so the header stays outside the listbox. Give sheet content a height, style it with `data-presentation`, and leave its `translate` for the sheet behavior. `--sheet-backdrop` controls the backdrop. The sheet is modal unless you set `@modal` to `false`; mouse and keyboard openings keep input focus as it moves.

```glimmer-ts title="presentation.gts"
import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const frameworks = [
  { value: "next", label: "Next.js" },
  { value: "sveltekit", label: "SvelteKit" },
  { value: "nuxt", label: "Nuxt" },
  { value: "remix", label: "Remix" },
  { value: "astro", label: "Astro" },
  { value: "solidstart", label: "SolidStart" },
  { value: "qwik", label: "Qwik City" },
]

<template>
  <Combobox @presentation="sheet" as |c|>
    <div data-slot="stack">
      <c.Label>Framework</c.Label>
      <div data-slot="row">
        <c.Input placeholder="Select a framework" />
        <c.Trigger aria-label="Show frameworks">{{icon ChevronDown}}</c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No frameworks found.</c.Empty>
      <c.List>
        {{#each frameworks key="value" as |framework|}}
          <c.Item @value={{framework.value}} @label={{framework.label}} as |item|>
            {{framework.label}}
            <item.Indicator>{{icon Check}}</item.Indicator>
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Open the field to see a sheet. On touch, tap the search field in its header to bring up the keyboard, or swipe down to close it.

## Forms

A combobox submits the selected value under `@name`, rather than the query text. Multiple values submit as separate entries. `@required={{true}}` prevents empty submissions, reset restores the default selection and its label, and `@form` joins a form from elsewhere on the page.

In a [Field](./field.md), the field supplies the input's accessible name, description and error. Submitting a required field without a selection sets `aria-invalid` and `data-invalid`.

```glimmer-ts title="form.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { on } from "@ember/modifier"
import { Check, ChevronDown, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { Field } from "ember-ui-sdk/field"
import { icon } from "./icon"
import { useLog } from "./log"

const countries = [
  { value: "ar", label: "Argentina" },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria" },
  { value: "be", label: "Belgium" },
  { value: "br", label: "Brazil" },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark" },
  { value: "fi", label: "Finland" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "gr", label: "Greece" },
  { value: "jp", label: "Japan" },
  { value: "nl", label: "Netherlands" },
  { value: "es", label: "Spain" },
  { value: "se", label: "Sweden" },
  { value: "ch", label: "Switzerland" },
]

const countryLabel = (value: string) =>
  countries.find((country) => country.value === value)?.label ?? value

const interests = ["Design", "Engineering", "Marketing", "Research", "Sales"]

export default class Form extends Component {
  log = useLog(this)

  submit = (event: SubmitEvent) => {
    event.preventDefault()
    const entries = [
      ...new FormData(event.currentTarget as HTMLFormElement),
    ].map(([name, value]) => `${name}=${value}`)
    this.log(`Submitted ${entries.join("&")}`)
  }

  <template>
    <form data-slot="stack" {{on "submit" this.submit}}>
      <Field @name="country" as |f|>
        <f.Label>Country</f.Label>
        <Combobox @required={{true}} @itemToLabel={{countryLabel}} @field={{f.field}} as |c|>
          <div data-slot="row">
            <c.Input placeholder="Search countries…" />
            <c.Trigger aria-label="Show countries">{{icon
                ChevronDown
              }}</c.Trigger>
          </div>
          <c.Content>
            <c.Empty>No countries found.</c.Empty>
            <c.List>
              {{#each countries key="value" as |country|}}
                <c.Item @value={{country.value}} @label={{country.label}} as |item|>
                  {{country.label}}
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </c.Item>
              {{/each}}
            </c.List>
          </c.Content>
        </Combobox>
        <f.Description>Where we ship your order.</f.Description>
        <div>
          <f.Error @match="valueMissing">Choose a country.</f.Error>
        </div>
      </Field>
      <Field @name="interests" as |f|>
        <f.Label>Interests</f.Label>
        <Combobox @multiple={{true}} @defaultValue={{array "Design"}} @field={{f.field}} as |c|>
          <c.Chips>
            <c.Value as |state|>
              {{#each state.value key="@identity" as |interest|}}
                <c.Chip @value={{interest}} as |chip|>
                  {{interest}}
                  <chip.Remove aria-label="Remove {{interest}}">{{icon
                      X
                    }}</chip.Remove>
                </c.Chip>
              {{/each}}
            </c.Value>
            <c.Input placeholder="Add interests…" />
          </c.Chips>
          <c.Content>
            <c.List>
              {{#each interests key="@identity" as |interest|}}
                <c.Item @value={{interest}} as |item|>
                  {{interest}}
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </c.Item>
              {{/each}}
            </c.List>
          </c.Content>
        </Combobox>
      </Field>
      <div data-slot="row">
        <button type="submit">Submit</button>
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

Submit without a country to see the inline error. Choose one and submit; the console logs the values, and Reset restores the defaults.

## Custom Rendering

Pass `@render={{true}}` to render a part as your own element: it yields `{ part, state }`, and you bind `part` to your element as a modifier. A part's block also receives its state. Each part's state is listed [below](#state).

```glimmer-ts title="custom-rendering.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { ChevronDown, ChevronUp, Check, Search } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

const users = [
  { id: 1, name: "Hollis Grant", username: "hollis", role: "Owner" },
  { id: 2, name: "Inès Moreau", username: "ines", role: "Admin" },
  { id: 3, name: "Kofi Mensah", username: "kofi", role: "Member" },
  { id: 4, name: "Wren Takahashi", username: "wren", role: "Member" },
  { id: 5, name: "Tomasz Wójcik", username: "tomasz", role: "Guest" },
]

const initial = (name: string) => name.slice(0, 1)

<template>
  <Combobox as |c|>
    <div data-slot="stack">
      <c.Label>Assignee</c.Label>
      <div data-slot="row">
        <c.Input @render={{true}} as |i|>
          <div data-slot="row">
            {{icon Search}}
            <input {{i.part}} placeholder="Search people…" />
          </div>
        </c.Input>
        <c.Trigger aria-label="Show people" as |t|>
          {{#if t.state.open}}
            {{icon ChevronUp}}
          {{else}}
            {{icon ChevronDown}}
          {{/if}}
        </c.Trigger>
      </div>
    </div>
    <c.Content>
      <c.Empty>No one by that name.</c.Empty>
      <c.List>
        {{#each users key="id" as |user|}}
          <c.Item @value={{user.username}} @label={{user.name}} @keywords={{array user.username}} as |item|>
            <span data-slot="badge">{{initial user.name}}</span>
            <span data-slot="stack">
              {{user.name}}
              <span data-slot="hint">@{{user.username}}</span>
            </span>
            {{#if item.state.selected}}
              {{icon Check}}
            {{else if item.state.highlighted}}
              <kbd data-slot="kbd">Enter</kbd>
            {{/if}}
          </c.Item>
        {{/each}}
      </c.List>
    </c.Content>
  </Combobox>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Open the list and move through it. The chevron flips while it's open, the highlighted person shows Enter, and the chosen one shows a check.

## Styling

Each part has a `data-slot`, such as `combobox-content`, and shows its state through the attributes listed under [Data Attributes](#data-attributes).

Use `data-highlighted` for the active option and `data-selected` for chosen values. Because the keyboard highlight usually moves without focus leaving the input, use the content's `data-modality="keyboard"` to style it. Real focus can move into the list for touch screen readers or into the sheet.

`--anchor-width` follows the input or chips. `--available-height` doesn't inherit: when a nested scroller needs it, copy it to a custom property on the content, such as `--list-height: var(--available-height)`, then use that property on the scroller.

### ComboboxContent
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

### ComboboxLabel
`[data-slot="combobox-label"]`

- `data-disabled`: Present when the combobox is disabled, by its own prop, a field or a `<fieldset>`.
- `data-readonly`: Present when the combobox is read-only.
- `data-required`: Present when the combobox is required.

### ComboboxInput
`[data-slot="combobox-input"]`

- `data-closed`: Present while the list is closed, including while it animates out.
- `data-open`: Present while the list is open.
- `data-disabled`: Present when the combobox is disabled, by its own prop, a field or a `<fieldset>`.
- `data-readonly`: Present when the combobox is read-only.
- `data-required`: Present when the combobox is required.

### ComboboxTrigger
`[data-slot="combobox-trigger"]`

- `data-closed`: Present while the list is closed, including while it animates out.
- `data-open`: Present while the list is open.
- `data-disabled`: Present when the combobox is disabled, by its own prop, a field or a `<fieldset>`.
- `data-readonly`: Present when the combobox is read-only.
- `data-required`: Present when the combobox is required.

### ComboboxClear
`[data-slot="combobox-clear"]`

- `data-disabled`: Present when the combobox is disabled or read-only.

### ComboboxChips
`[data-slot="combobox-chips"]`

- `data-disabled`: Present when the combobox is disabled, by its own prop, a field or a `<fieldset>`.
- `data-readonly`: Present when the combobox is read-only.
- `data-required`: Present when the combobox is required.

### ComboboxContent
`[data-slot="combobox-content"]`

- `data-closed`: Present while the list is closed, including while it animates out.
- `data-presentation` (`popover`, `sheet`): How the list presents this time it's open.
- `data-open`: Present while the list is open.
- `data-starting-style`: Present for the first frame. Style the state you animate from.
- `data-ending-style`: Present while the list animates out. Style the state you animate to.
- `data-modality` (`keyboard`, `pointer`): Whether the keyboard or a pointer moves the highlight. Style a focus ring for the keyboard only.
- `data-has-icons`: Present while any item inside holds an icon part, so items without one can line up.

### ComboboxItem
`[data-slot="combobox-item"]`

- `data-selected`: Present on selected items, and on the check inside them.
- `data-disabled`: Present when the item can't be chosen, or `maxSelected` is reached.
- `data-highlighted`: Present on the highlighted item. Focus stays in the input.
- `data-has-icon`: Present on an item while it holds an icon part.

### ComboboxItemText
`[data-slot="combobox-item-text"]`

- `data-matched`: Present on an item's text while the input's text matched part of it, which is marked.

### ComboboxItemIndicator
`[data-slot="combobox-item-indicator"]`

- `data-selected`: Present on selected items, and on the check inside them.

### ComboboxEmpty
`[data-slot="combobox-empty"]`

- `data-loading`: Present while results load, with `status="loading"`.
- `data-empty`: Present while no item matches.

### ComboboxStatus
`[data-slot="combobox-status"]`

- `data-loading`: Present while results load, with `status="loading"`.

### ComboboxArrow
`[data-slot="combobox-arrow"]`

- `data-closed`: Present while the list is closed, including while it animates out.
- `data-open`: Present while the list is open.

### ComboboxItemIcon
`[data-slot="combobox-item-icon"]`

- `data-mirror`: Present on an icon that flips in right-to-left text, with `mirror`.

### ComboboxChip
`[data-slot="combobox-chip"]`

- `data-value` (`a`): The chip's value, as the string it submits as.
- `data-disabled`: Present when the combobox is disabled or read-only, so the chip can't be removed.

### ComboboxChipRemove
`[data-slot="combobox-chip-remove"]`

- `data-disabled`: Present when the combobox is disabled or read-only.

### ComboboxSelectAll
`[data-slot="combobox-select-all"]`

- `data-disabled`: Present when nothing the select-all option covers can be chosen, or choosing them all would pass `maxSelected`.
- `data-unchecked`: Present on a select-all option while none of its items is selected.
- `data-highlighted`: Present on the highlighted item. Focus stays in the input.

### ComboboxCreate
`[data-slot="combobox-create"]`

- `data-highlighted`: Present while the create option is highlighted.
- `data-pending`: Present while the Promise `onCreate` returned is running.

## API Reference

Pass the root's options as `@` arguments on `Combobox`. `@value`, `@query` and `@open` are controlled with their `@on…Change` callbacks.

### Combobox

- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `query?` (`string`): The input's text, which filters the list. Pass it to control it. Choosing an item sets it to the item's label, or empties it with `multiple`.
- `defaultQuery?` (`string`): The input's text at first, when uncontrolled. Defaults to the selected item's label.
- `onQueryChange?` (`((query: string, details: ChangeDetails<ComboboxQueryChangeReason>) => void)`): Runs when the input's text wants to change: typing, choosing an item, or closing with text that wasn't chosen.
- `open?` (`boolean`): Whether the list is open. Pass it to control it.
- `defaultOpen?` (`boolean`): Whether the list starts open, when uncontrolled.
- `onOpenChange?` (`((open: boolean, details: ChangeDetails<ComboboxOpenChangeReason>) => void)`): Runs when the list wants to open or close. `details.reason` says why, and `details.cancel()` stops it.
- `onOpenChangeComplete?` (`((open: boolean) => void)`): Runs once the list has finished opening or closing, after any animation.
- `maxSelected?` (`number`): With `multiple`, how many items can be selected. Once reached, the other items are disabled.
- `items?` (`ListData<T>`): The items as data. Renders the list for you, and filters it without rendering every item.
- `emptyItems?` (`ListData<T>`): Items shown instead of `items` while the input is empty, like recent choices or suggestions. Groups work, like `{ type: "group", label: "Recent", items }`. Needs `items`.
- `filter?` (`ListFilter<T>`): How typing narrows the list: `"contains"`, `"startsWith"`, a function of the item and the text, whose numeric result also sorts data items, or `false` to keep every item, for results a server already filtered.
- `itemToValue?` (`((value: T) => string)`): The string an item's value submits as and is identified by, for object values. Strings pass through, and objects use their `value` or `id`.
- `itemToLabel?` (`((value: T) => string)`): The text a value shows, for values whose item isn't rendered, like async results.
- `isItemEqualToValue?` (`((itemValue: T, value: T) => boolean)`): Whether an item's value is the selected value, for object values that aren't the same object.
- `autoHighlight?` (`"always" | boolean`): Whether the first matching item is highlighted while typing, so Enter chooses it. `"always"` also highlights the selected item, or the first, when the list opens, so arrows move from there.
- `keepQuery?` (`boolean`): With `multiple`, whether the input keeps its text after an item is chosen.
- `pendingAnnouncement?` (`string`): What screen readers hear once the Create part's `@onCreate` has been pending for a second, so a slow action doesn't pass in silence. Set it in the page's language. An empty string says nothing.
- `allowCustomValue?` (`boolean`): Whether text that matches no item becomes the value, when Enter is pressed with nothing highlighted, or, without `multiple`, when the list closes. The value is the text itself.
- `status?` (`AsyncOptionsStatus`): Whether results are loading or failed, for the status and empty parts. Sets `aria-busy` on the list while loading.
- `onHighlight?` (`((value: T | null, details: ListHighlightDetails) => void)`): Runs when the highlight moves, with the item's index among the visible items, so a virtualized list can scroll to it.
- `onLoadMore?` (`(() => void)`): Runs when the highlight or scrolling reaches the last item, so the next page can load, like `createAsyncOptions`'s `loadMore`. Not again for the same items, unless the last load failed.
- `announcement?` (`((change: ListAnnouncement) => string | null | undefined)`): What screen readers hear after typing pauses, when no `ComboboxStatus` is rendered, and when a chip is removed. Return null for nothing.
- `loop?` (`boolean`): Whether arrow keys wrap from the last item to the first.
- `modal?` (`"pointer" | boolean`): `false`: the page stays usable while the list is open. `"pointer"`: an outside press only closes the list. `true`: also locks scroll and makes the rest of the page inert.
- `presentation?` (`PresentationSetting<"popover">`): How the list presents. `"sheet"` slides it up from the bottom of the screen with the input in its header, where it can be swiped away, and `"auto"` does that on small touch screens. A tap that opens a sheet leaves the keyboard closed until the input in the header is tapped. Decided each time it opens; the server renders `"popover"` for `"auto"`.
- `disabled?` (`boolean`): Disables the combobox like a native input: it can't be focused or changed, and the value isn't submitted.
- `readOnly?` (`boolean`): Keeps the combobox focusable and its value submitted, but stops changes.
- `required?` (`boolean`): Blocks form submission until a value is selected, with the browser's own message.
- `name?` (`string`): The name the value submits under. Without one, the combobox submits nothing.
- `form?` (`string`): The id of a form to belong to, when the combobox isn't inside that form.
- `controller?` (`object`): Opens, closes, reads and sets the combobox from anywhere. Create one with `createComboboxController()`.
- `dismissible?` (`boolean`): Whether Escape, an outside press, focus or the window leaving, Android's back gesture and a sheet's swipe can close it. Triggers, Close parts and the controller always can. Pass `false` while it holds unsaved work, and ask in `@onDismissAttempt`.
- `onDismissAttempt?` (`function`): Runs when `dismissible` refused a dismissal made on purpose: Escape, an outside press, back or a swipe. Focus or the window leaving is refused without it. Ask "Discard changes?" here.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.
- `multiple?` (`boolean`): Whether several items can be selected. The value is then a list, the list stays open as items toggle, and the input empties after each choice. Whether several items can be selected.
- `value?` (`T | T[] | null`): The selected value. Pass it to control the combobox. `null` selects nothing. The selected values. Pass it to control the combobox. The selected value, or values with `multiple`. Pass it to control the combobox.
- `defaultValue?` (`T | T[] | null`): The value selected at first, when uncontrolled. A form reset returns to it. The values selected at first, when uncontrolled. A form reset returns to them. The value or values selected at first, when uncontrolled. A form reset returns to it.
- `onValueChange?` (`union`): Runs when a user, a form reset or a controller wants to change the value. `details.reason` says why, and `details.cancel()` stops it.

`announcement` receives `{ type: "results", count, query, loading }` or `{ type: "removed", label }` and returns the words, or `null` for silence. The default is English: "3 results", "No results", "Loading" or "France removed".

### ComboboxLabel

The input's visible label. Renders a `label`.

### ComboboxInput

The text field that filters the list and shows the chosen label. Renders an `input`.

### ComboboxTrigger

Opens and closes the list. Renders a `button`, kept out of the tab order while the input sits beside it.

### ComboboxClear

- `keepMounted?` (`boolean`): Whether the clear button stays in the page while there's nothing to clear.

### ComboboxChips

Holds the chips and the input for a multiple selection. Renders a `div`.

### ComboboxValue

- `maxLabels?` (`number`): With `multiple`, how many labels the `label` in its state shows before the rest are counted, as in "France, Chile and 2 more", joined the way the page's language joins lists.
- `getMoreLabel?` (`((count: number) => string)`): The words for the labels past `maxLabels`.

### ComboboxChip

- `value` (`T`): The selected value this chip shows.

### ComboboxChipRemove

Removes its chip's value. Renders a `button`. Takes the same arguments as `ComboboxChip`.

### ComboboxChipsOverflow

Turns collapsing on for the chips around it, and shows how many are hidden. Renders a `span`.

### ComboboxValueIcon

Shows the selected item's icon beside the input. It takes no arguments of its own, and no children.

### ComboboxContent

- `side?` (`Side`): Which side of the anchor the popup opens on. Flips to the other side when there isn't room. Which side of the input the list opens on.
- `align?` (`Align`): How the popup lines up with the anchor along that side. `start` and `end` follow the reading direction. How the list lines up with the input along that side.
- `sideOffset?` (`number`): Gap between the anchor and the popup, in pixels. Gap between the input and the list, in pixels.
- `alignOffset?` (`number`): Shift along the anchor, in pixels. Shift along the input, in pixels.
- `collisionPadding?` (`number`): Space to keep from the viewport edges, in pixels.
- `arrowPadding?` (`number`): Space to keep between the arrow and the popup's corners, in pixels.
- `anchor?` (`string | Anchor | null`): Positions the popup against this instead of its trigger: an element, a CSS selector, a point like `{ x, y }`, or anything with `getBoundingClientRect()`. It's read on every check, so it can move. A controller's `open({ anchor })` wins for that open.
- `container?` (`DocumentFragment | Element | null`): Renders the popup into this element instead of in place, like a container inside a shadow root or an iframe. On web components, a CSS selector. Nested popups stay inside their parent.
- `keepMounted?` (`boolean`): Whether the list stays in the page, hidden, while closed.

### ComboboxArrow

Points from the popup to its anchor, following the side chosen after collision handling. Renders a `div`.

### ComboboxStatus

Announces loading, errors and result counts. Renders a `div` with the status role.

### ComboboxEmpty

Shows while no option matches. Renders a `div`.

### ComboboxList

Holds the options. Renders a `div` with the listbox role.

### ComboboxSelectAll

Toggles every matching, enabled option in its group, or outside a group. Renders a `div` with the option role.

### ComboboxGroup

Groups options under a label. Renders a `div` with the group role.

### ComboboxGroupLabel

Names its group. Renders a `div`.

### ComboboxItem

- `label?` (`string`): The text the input shows once chosen, and filtering matches, when the content isn't plain text. Not the accessible name: use `aria-label` for that.
- `keywords?` (`string[]`): More words filtering matches.
- `disabled?` (`boolean`): Keeps the item from being chosen. The keyboard and the pointer skip it. Sets `data-disabled` and `aria-disabled`.
- `index?` (`number`): The item's position among all visible items, for virtualized lists that render only some. Sets `aria-posinset` and `aria-setsize`.
- `value` (`T`): What the value becomes when the item is chosen. A string, or any value with `itemToValue`.

### ComboboxItemIcon

- `mirror?` (`boolean`): Flips the icon horizontally in right-to-left text, for icons that point a way, like arrows and chevrons. Icons that picture a thing, like a clock or a check, stay as they are.

### ComboboxItemText

Shows its item's label, and marks what matched the query. Renders a `span`.

### ComboboxItemIndicator

- `keepMounted?` (`boolean`): Whether the indicator stays in the page while its item isn't selected.

### ComboboxSeparator

Separates options or groups. Renders a `div` with the separator role.

### ComboboxCreate

- `onCreate?` (`((query: string) => unknown)`): Runs with the input's text when the create option is chosen. It doesn't change the value by itself. Return a Promise to mark the option pending until it settles; the list closes (or the input empties, with `multiple`) once it resolves.
- `minLength?` (`number`): How many characters the text needs before the option shows.

### Items as Data

Each item in `@items`. Groups are `{ type: "group", label, items }` and separators `{ type: "separator" }`.

- `value` (`T`): Identifies the item, and is what choosing it reports. A string, or any value with `itemToValue`.
- `label` (`string`): The text shown and matched by typeahead and filtering. A select's trigger shows it once chosen.
- `keywords?` (`string[]`): More words filtering matches, like `["team"]` for a plan called Pro.
- `disabled?` (`boolean`): Keeps the item from being chosen. The keyboard skips it, like in a native select.

### Async Options

Async Options, in `ember-ui-sdk/async-options`, covers loading, paging, and retries.

### State

What `@render` parts and their blocks receive, per part.

`ComboboxInput`:

- `open` (`boolean`): Whether the list is open.
- `disabled` (`boolean`): Whether the combobox is disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether the combobox keeps its value but refuses changes, from its `readOnly` option.
- `required` (`boolean`): Whether a value must be selected before the form submits, from its `required` option.

`ComboboxTrigger`:

- `open` (`boolean`): Whether the list is open.
- `disabled` (`boolean`): Whether the combobox is disabled, by itself or by a `<fieldset>`.
- `readOnly` (`boolean`): Whether the combobox keeps its value but refuses changes, from its `readOnly` option.
- `required` (`boolean`): Whether a value must be selected before the form submits, from its `required` option.

`ComboboxContent` and `ComboboxList`:

- `open` (`boolean`): Whether the list is open. False while it animates out.
- `presentation` (`"popover" | "sheet"`): How it presents this time it's open.
- `multiple` (`boolean | undefined`): Whether several items can be selected.
- `status` (`AsyncOptionsStatus`): Whether results are loading or failed.
- `items` (`ListData<unknown>`): The visible items, for rendering a virtualized list yourself.

`ComboboxItem`:

- `highlighted` (`boolean`): Whether the item is highlighted, by the keyboard or the pointer.
- `selected` (`boolean`): Whether its value is in the combobox's value, compared with `isItemEqualToValue` when you pass one.
- `disabled` (`boolean`): Whether the item can't be chosen, by itself or because `maxSelected` is reached.
- `maxReached` (`boolean`): Whether `maxSelected` is reached and the item isn't selected, which is why it's disabled.

`ComboboxItemIndicator`:

- `selected` (`boolean`): Whether its item is selected. While false, the indicator isn't shown unless `keepMounted` is set.

`ComboboxItemIcon`:

- `mirror` (`boolean`): Whether it flips in right-to-left text.

`ComboboxCreate`:

- `query` (`string`): The text the option would create.
- `highlighted` (`boolean`): Whether the option is highlighted.
- `pending` (`boolean`): Whether `onCreate`'s Promise is running.
- `error` (`unknown`): Why the last `onCreate` failed, until the next try.

`ComboboxEmpty`:

- `loading` (`boolean`): Whether results are loading.
- `empty` (`boolean`): Whether no item matches.
- `query` (`string`): The text the list is filtered by.

`ComboboxStatus`:

- `status` (`"idle" | "loading" | "error"`): Whether results are loading or failed.
- `loading` (`boolean`): Whether results are loading.
- `count` (`number`): How many items are visible.

`ComboboxValue`:

- `value` (`unknown`): The selected value: one, `null`, or a list with `multiple`.
- `labels` (`string[]`): Each selected item's label, in the order they were selected.
- `label` (`string`): The labels joined with commas, or with `maxLabels`, as a list in the page's language, like "France, Chile and 2 more". An empty string for none.

`ComboboxChip`:

- `value` (`unknown`): The selected value the chip stands for, from its `value` prop.
- `label` (`string`): The text for the value: from `itemToLabel`, its item's label, or the value itself.
- `disabled` (`boolean`): Whether the combobox is disabled or read-only, so the chip can't be removed.

`ComboboxClear` and `ComboboxChipRemove`:

- `disabled` (`boolean`): Whether the combobox is disabled or read-only.

`ComboboxArrow`:

- `open` (`boolean`): Whether the list is open.

`ComboboxItemText`:

- `segments` (`MatchSegment[]`): The text in pieces, each marked when it matched. Joined, they're the whole text.
- `matched` (`boolean`): Whether any piece matched.

`ComboboxSelectAll`:

- `checked` (`boolean`): Whether every item it covers is selected.
- `indeterminate` (`boolean`): Whether some of its items are selected, but not all.
- `highlighted` (`boolean`): Whether it's highlighted, by the keyboard or the pointer.
- `disabled` (`boolean`): Whether it can't be used: nothing it covers can be chosen, or choosing them all would pass `maxSelected`.

`ComboboxChipsOverflow`:

- `count` (`number`): How many chips don't fit and are hidden.
- `labels` (`string[]`): The labels of the hidden chips.

### Reasons

`details.reason` says why the value changed:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `input-change` (`Event`): Typing, pasting or dropping changed a text field's value; in a combobox it can also open or close it, or Enter keeps the typed text as the value.
- `clear-press` (`MouseEvent | KeyboardEvent`): A Clear part was pressed, like on an input, a select or a combobox.
- `remove-press` (`MouseEvent | KeyboardEvent`): A chip's remove part was pressed, or Backspace or Delete removed a chip or a span.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `reset` (`none`): A form reset.
- `restore` (`none`): The browser restored state, like after going back, or a saved value was read back from storage.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

Why the text changed:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `input-change` (`Event`): Typing, pasting or dropping changed a text field's value; in a combobox it can also open or close it, or Enter keeps the typed text as the value.
- `clear-press` (`MouseEvent | KeyboardEvent`): A Clear part was pressed, like on an input, a select or a combobox.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `reset` (`none`): A form reset.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.
- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `close-press` (`MouseEvent | KeyboardEvent | SubmitEvent`): A Close part was pressed, or a form with `method="dialog"` was submitted.
- `outside-press` (`MouseEvent`): A press outside the layer.
- `focus-out` (`KeyboardEvent | FocusEvent`): Focus left the layer, or Tab moved it out.
- `window-blur` (`FocusEvent`): The window lost focus.
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `swipe` (`TouchEvent | PointerEvent`): A swipe gesture: a finger, mouse or pen dragged it.

And why the list opened or closed:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `input-change` (`Event`): Typing, pasting or dropping changed a text field's value; in a combobox it can also open or close it, or Enter keeps the typed text as the value.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.
- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `close-press` (`MouseEvent | KeyboardEvent | SubmitEvent`): A Close part was pressed, or a form with `method="dialog"` was submitted.
- `outside-press` (`MouseEvent`): A press outside the layer.
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

Create one with `createComboboxController<Value, Multiple>()` and pass it as `@controller`.

Every write method takes an optional `{ reason, event }`, passed to the change callback.

- `isOpen()` (`() => boolean`): Whether the list is open.
- `setOpen(open, options?)` (`(open: boolean, options?: ComboboxChangeOptions<ComboboxOpenChangeReason> | undefined) => boolean`): Opens or closes the list. Returns false when the change was canceled or it was already open or closed.
- `open(options?)` (`(options?: (ComboboxChangeOptions<ComboboxOpenChangeReason> & { signal?: AbortSignal | undefined; }) | undefined) => Promise<...>`): Opens the list, and resolves once it closes, with why and how. Resolves exactly once and never rejects: on the next close from any source, when `signal` aborts, or with reason `"unmount"` when the combobox leaves the page.
- `close(options?)` (`(options?: ComboboxChangeOptions<ComboboxOpenChangeReason> | undefined) => boolean`): Closes the list. Returns false when the close was canceled or it was already closed.
- `toggle(options?)` (`(options?: ComboboxChangeOptions<ComboboxOpenChangeReason> | undefined) => boolean`): Opens the list when it's closed, and closes it when it's open. Returns false when the change was canceled.
- `getValue()` (`() => ComboboxValue<T, Multiple>`): The selected value.
- `setValue(value, options?)` (`(value: ComboboxValue<T, Multiple>, options?: ComboboxChangeOptions<ComboboxValueChangeReason> | undefined) => boolean`): Selects a value, as a user would. A disabled or read-only combobox ignores it. Returns false when the change was canceled or nothing changed.
- `clear(options?)` (`(options?: ComboboxChangeOptions<ComboboxValueChangeReason> | undefined) => boolean`): Selects nothing and empties the input. Returns false when the change was canceled or nothing changed.
- `getQuery()` (`() => string`): The input's text.
- `setQuery(query, options?)` (`(query: string, options?: ComboboxChangeOptions<ComboboxQueryChangeReason> | undefined) => boolean`): Changes the input's text, which filters the list. Returns false when the change was canceled or nothing changed.
- `focus()` (`() => void`): Moves focus to the input.

### Events

Callbacks get the new state first, then the details. A controlled value only updates when the change callback wasn't canceled.

| Argument                | On               | Receives                                                      |
| ----------------------- | ---------------- | ------------------------------------------------------------- |
| `@onValueChange`        | `Combobox`       | `(value, details)`: the new value, and the [reason](#reasons) |
| `@onQueryChange`        | `Combobox`       | `(query, details)`: the new text, and the [reason](#reasons)  |
| `@onOpenChange`         | `Combobox`       | `(open, details)`: the new state, and the [reason](#reasons)  |
| `@onOpenChangeComplete` | `Combobox`       | `(open)`, after the animation                                 |
| `@onHighlight`          | `Combobox`       | `(value, { index, event })`: the highlighted item and its row |
| `@onLoadMore`           | `Combobox`       | `()`, when the last item is reached                           |
| `@onDismissAttempt`     | `Combobox`       | `({ reason, event })`, when a dismissal was refused           |
| `@onCreate`             | `ComboboxCreate` | `(query)`: the text. Return a Promise to mark it pending      |

## Accessibility

The combobox follows the [WAI-ARIA combobox pattern with list autocomplete](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-autocomplete-list/). Focus usually stays in the input while `aria-activedescendant` identifies the highlighted option. A touch screen-reader trigger can move real focus into the list, and a sheet has its own [focus behavior](#presentation). Every line below is an automated test.

### Keyboard

| Key                   | Does                                                                     |
| --------------------- | ------------------------------------------------------------------------ |
| Typing                | Filters the options and opens the list                                   |
| ArrowDown, ArrowUp    | Opens the list, then moves the highlight. Wraps unless `@loop={{false}}` |
| Enter                 | Chooses the highlighted option                                           |
| Escape                | Closes the list, then restores the selection's label                     |
| Backspace             | In an empty input with chips, removes the last chip                      |
| ArrowLeft, ArrowRight | Moves between chips, reversed in right-to-left text                      |

### Tested Behavior

**Input**

- Is a combobox named by its label, with list autocomplete.
- Typing opens the list with the items that match.
- Matching ignores case and accents.
- ArrowDown opens the list.
- Choosing with the keyboard leaves the caret after the text.
- Points to the list it controls while open.

**Highlight**

- Arrow keys move the highlight while focus stays in the input.
- Arrow keys skip disabled items.
- Moving over a disabled item leaves the highlight where it was.
- The highlighted option has the id aria-activedescendant names.

**AutoHighlight**

- The first match is highlighted from the first keystroke, so Enter chooses it.
- A disabled match is passed over.

**Choosing**

- Enter chooses the highlighted item, puts its label in the input and closes.
- Clicking an item chooses it and keeps focus in the input.
- A disabled item can't be chosen.
- After choosing, opening again shows every item with the chosen one selected.
- A canceled choice closes the list and keeps the value's label in the input.
- Text that matches nothing shows the empty message.

**Closing**

- Escape closes the list and keeps focus in the input.
- Escape after deleting the text brings back the value and its label.
- Leaving after deleting the text keeps the value empty.
- Clicking outside closes the list.
- Tab closes the list and moves on.

**Trigger and clear**

- The trigger button opens and closes the list.
- Clear empties the input and the value.

**Default value**

- Shows its label in the input.

**Multiple**

- Choosing adds a chip and empties the input.
- A canceled choice adds no chip and keeps the text.
- Backspace in an empty input removes the last chip.
- A chip's remove button removes its value.

**Groups**

- Items sit in groups named by their labels, and empty groups hide while filtering.

**Forms**

- The form submits the value under the combobox's name.
- Several values submit under one name.
- A required combobox blocks submission until a value is chosen.
- A disabled combobox can't be focused.
- A disabled fieldset disables the combobox and leaves it out of the form.

**Async**

- Results load for the text, with the list kept while loading.
- The chosen item's label survives results that don't include it.

Runs in React, Vue and web components.

Long lists stay fast and announce their size:

**Virtualized**

- Renders only the rows in view, each with its place in the whole list.
- Arrow keys reach items that weren't rendered, and the active descendant follows.
- Filtering covers every item, rendered or not.

Runs in React.

Also tested:

**Enhancements**

- The list is named by the combobox's label.
- Filtering matches an item's keywords as well as its label.
- A create option offers the text, and hides when an item's label matches it exactly.
- Enter on the create option calls onCreate with the text.
- A create option is pending while onCreate's Promise runs.
- With multiple, the list stays open after choosing.
- MaxSelected disables the other items once reached.
- Arrow keys move between chips, and Backspace on one removes it.
- The chips are a toolbar named by the combobox's label.
- Web chips follow a label that changes after they rendered. Web components only.
- Enter on the trigger opens the list as the keyboard did.
- ArrowDown on the trigger opens the list at its first item.
- The content says whether the keyboard or a pointer is in use, while focus stays in the input.
- A form reset returns the combobox to its default value and label.
- Arrow keys keep the highlighted item in view when the … scrolls.

Runs in React, Vue and web components.

Rows people rebuild, here and in Select:

**Items shown while nothing is typed**

- A combobox shows its recent items, as a group, until the user types.
- An autocomplete shows recent searches while the field is empty.

**Select all**

- Selects every item that can be chosen, then clears them, and says which with aria-checked.
- Is mixed while some are selected.
- Covers only the items the text matches.
- Is reached with the arrow keys and chosen with Enter.
- In a group, it covers that group.
- A select's works the same, with real focus.

**Chips that collapse**

- Chips past the line hide, and a count says how many.
- Removing chips brings the hidden ones back, and the count goes.
- A value text lists two labels and counts the rest, in the page's language. React and Vue only.
- A select's value lists two labels and counts the rest.
- A web select value takes getMoreLabel as a property. Web components only.

**Loading more**

- Reaching the last item with the keyboard loads the next page.
- Scrolling to the end loads the next page, with a status while it does.
- The last page loads no more.

**Rows**

- A recent item is chosen like any other.
- Typing on a select never lands on it.

Runs in React, Vue and web components.

Match highlighting, here and in Autocomplete and Command:

**Combobox**

- Marks the part of each label the text matched.
- Marks keep the label's own case and accents while matching without them.
- An item matched by a keyword has nothing to mark.
- Marks go away when the text is cleared, and the label reads whole.

**Autocomplete**

- Marks the part of each suggestion the text matched.

**Command**

- Marks each letter a fuzzy match found, joining neighbours.
- Marks a whole match at a word start.

**Highlighting**

- The chosen label in the input shows every item unmarked.

Runs in React, Vue and web components.

Touch screen readers and announcements:

**A screen reader's tap moves real focus into the list**

- Autocomplete: tapping the trigger focuses the first suggestion, and Escape returns.
- Searchable select: tapping the trigger focuses the selected item, not the search field.

**Combobox**

- Tapping the trigger focuses the selected item, with no aria-activedescendant.
- Arrow keys move real focus, and choosing returns focus to the input.
- Escape closes the list and focus returns to the input.

**Announcements**

- How many items match is announced once typing pauses.
- Autocomplete and searchable select announce counts too.
- Removing a chip announces which.

**Touch screen readers and announcements**

- A tap on the input is for typing: focus stays there.
- A status part says it instead, so nothing is announced twice.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while filtering and choosing with a keyboard.

Runs in React, Vue and web components.
