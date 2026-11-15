# Command

Search commands, run actions, and open pages of more choices.

Command puts a search field over a list of actions. The list stays open while someone searches. You can use it on its own, or put it in a dialog to build a command palette.

```glimmer-ts title="demo.gts"
import {
  Calculator,
  Calendar,
  CreditCard,
  Search,
  Settings,
  Smile,
  User,
} from "lucide"
import { Command } from "ember-ui-sdk/command"
import { icon } from "./icon"

const suggestions = [
  { value: "calendar", label: "Calendar", icon: Calendar },
  { value: "emoji", label: "Search Emoji", icon: Smile },
  {
    value: "calculator",
    label: "Calculator",
    icon: Calculator,
    disabled: true,
  },
]

const settings = [
  { value: "profile", label: "Profile", icon: User, shortcut: "mod+p" },
  { value: "billing", label: "Billing", icon: CreditCard, shortcut: "mod+b" },
  { value: "settings", label: "Settings", icon: Settings, shortcut: "mod+s" },
]

<template>
  <Command as |c|>
    <div data-slot="row">
      {{icon Search}}
      <c.Input
        aria-label="Search commands"
        placeholder="Type a command or search…"
      />
    </div>
    <c.Empty>No results found.</c.Empty>
    <c.List>
      <c.Group as |g|>
        <g.Label>Suggestions</g.Label>
        {{#each suggestions key="value" as |suggestion|}}
          <g.Item
            @value={{suggestion.value}}
            @disabled={{suggestion.disabled}}
            as |item|
          >
            <item.Icon>{{icon suggestion.icon}}</item.Icon>
            <span>{{suggestion.label}}</span>
          </g.Item>
        {{/each}}
      </c.Group>
      <c.Separator />
      <c.Group as |g|>
        <g.Label>Settings</g.Label>
        {{#each settings key="value" as |setting|}}
          <g.Item
            @value={{setting.value}}
            @shortcut={{setting.shortcut}}
            as |item|
          >
            <item.Icon>{{icon setting.icon}}</item.Icon>
            <span>{{setting.label}}</span>
            <item.Shortcut />
          </g.Item>
        {{/each}}
      </c.Group>
    </c.List>
  </Command>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Type “bil” to find Billing. Arrow keys move the highlight; Escape clears the search.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Command`:

```text
Command as |c|
├── c.Input
├── c.Empty
└── c.List
    ├── c.Item
    └── c.Item
```

Give the input an accessible name and each command a unique value. Keep empty and status messages outside the list, which holds commands and groups. `@onAction` reports the value of the command that ran; use it to perform the action.

Use `c.Group` and `g.Label` to name related commands, with a `c.Separator` between groups. Groups and separators disappear when filtering leaves them empty.

## Usage

Import the root and use the parts it yields:

```gts
import { Command } from "ember-ui-sdk/command"

<template>
  <Command as |c|>
    <c.Input aria-label="Search commands" />
    <c.Empty>No commands found.</c.Empty>
    <c.List>
      <c.Item @value="new-file">New file</c.Item>
      <c.Item @value="new-folder">New folder</c.Item>
    </c.List>
  </Command>
</template>
```

## Dialog

Put Command inside a [Dialog](./dialog.md) for a command palette. Give the dialog a title, put `@shortcut="mod+k"` on its trigger, and close it when a command runs. The dialog handles dismissal and returns focus to the trigger.

```glimmer-ts title="dialog.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  Calculator,
  Calendar,
  CreditCard,
  Search,
  Settings,
  Smile,
  User,
} from "lucide"
import { Command } from "ember-ui-sdk/command"
import { Dialog } from "ember-ui-sdk/dialog"
import { icon } from "./icon"
import { useLog } from "./log"

const commands = [
  { value: "calendar", label: "Calendar", icon: Calendar },
  { value: "emoji", label: "Search Emoji", icon: Smile },
  {
    value: "calculator",
    label: "Calculator",
    icon: Calculator,
    disabled: true,
  },
  { value: "profile", label: "Profile", icon: User },
  { value: "billing", label: "Billing", icon: CreditCard },
  { value: "settings", label: "Settings", icon: Settings },
]

export default class DialogExample extends Component {
  log = useLog(this)
  commands = commands
  @tracked open = false

  onOpenChange = (next: boolean) => {
    this.open = next
  }

  onAction = (value: string) => {
    this.log(`Ran ${value}`)
    this.open = false
  }

  <template>
    <div data-slot="stack">
      <Dialog @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |d|>
        <d.Trigger @shortcut="mod+k" @render={{true}} as |t|>
          <button {{t.part}} type="button">
            Search…
            <d.Shortcut as |s|>{{s.state.text}}</d.Shortcut>
          </button>
        </d.Trigger>
        <d.Backdrop />
        <d.Content>
          <d.Title>Command palette</d.Title>
          <Command @onAction={{this.onAction}} as |c|>
            <div data-slot="row">
              {{icon Search}}
              <c.Input aria-label="Search commands" placeholder="Type a command or search…" />
            </div>
            <c.Empty>No results found.</c.Empty>
            <c.List>
              <c.Group as |g|>
                <g.Label>Suggestions</g.Label>
                {{#each this.commands key="value" as |command|}}
                  <g.Item @value={{command.value}} @disabled={{command.disabled}} as |item|>
                    <item.Icon>{{icon command.icon}}</item.Icon>
                    {{command.label}}
                  </g.Item>
                {{/each}}
              </c.Group>
            </c.List>
          </Command>
        </d.Content>
      </Dialog>
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

Press Search or use Cmd+K / Ctrl+K. Choose a command to run it and close the palette; the console logs what ran.

## Shortcuts

An item’s `@shortcut` can run it while the command list is mounted, even when the search or current page hides it. `item.Shortcut` displays the keys for the current platform, and the item gets `aria-keyshortcuts`. Shortcuts inside a dialog run while it is open.

```glimmer-ts title="shortcuts.gts"
import Component from "@glimmer/component"
import { CreditCard, Settings, User } from "lucide"
import { Command } from "ember-ui-sdk/command"
import { icon } from "./icon"
import { useLog } from "./log"

const settings = [
  { value: "profile", label: "Profile", icon: User, shortcut: "mod+p" },
  { value: "billing", label: "Billing", icon: CreditCard, shortcut: "mod+b" },
  { value: "settings", label: "Settings", icon: Settings, shortcut: "mod+s" },
]

export default class Shortcuts extends Component {
  log = useLog(this)
  settings = settings

  onAction = (value: string) => {
    this.log(`Ran ${value}`)
  }

  <template>
    <div data-slot="stack">
      <Command @onAction={{this.onAction}} as |c|>
        <c.Input aria-label="Search settings" placeholder="Search settings…" />
        <c.List>
          <c.Group as |g|>
            <g.Label>Settings</g.Label>
            {{#each this.settings key="value" as |setting|}}
              <g.Item @value={{setting.value}} @shortcut={{setting.shortcut}} as |item|>
                <item.Icon>{{icon setting.icon}}</item.Icon>
                <span>{{setting.label}}</span>
                <item.Shortcut as |s|>{{s.state.text}}</item.Shortcut>
              </g.Item>
            {{/each}}
          </c.Group>
        </c.List>
      </Command>
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

Press Cmd+P / Ctrl+P to run Profile, even when the search hides it. The console logs each command that runs.

## Highlight Matches

`item.Text` marks the matched text. The default fuzzy filter can match letters that are apart, so one command may have several marked segments.

```glimmer-ts title="highlight.gts"
import {
  Calculator,
  Calendar,
  CreditCard,
  Search,
  Settings,
  Smile,
  User,
} from "lucide"
import { Command } from "ember-ui-sdk/command"
import { icon } from "./icon"

const commands = [
  { value: "calendar", label: "Calendar", icon: Calendar },
  { value: "emoji", label: "Search Emoji", icon: Smile },
  {
    value: "calculator",
    label: "Calculator",
    icon: Calculator,
    disabled: true,
  },
  { value: "profile", label: "Profile", icon: User },
  { value: "billing", label: "Billing", icon: CreditCard },
  { value: "settings", label: "Settings", icon: Settings },
]

<template>
  <Command as |c|>
    <div data-slot="row">
      {{icon Search}}
      <c.Input aria-label="Search commands" placeholder="Try “prf” or “emo”…" />
    </div>
    <c.Empty>No results found.</c.Empty>
    <c.List>
      {{#each commands key="value" as |command|}}
        <c.Item @value={{command.value}} @label={{command.label}} @disabled={{command.disabled}} as |item|>
          <item.Icon>{{icon command.icon}}</item.Icon>
          <item.Text />
        </c.Item>
      {{/each}}
    </c.List>
  </Command>
</template>
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Type “prf” to find Profile. Matching letters are marked even when they are not next to each other.

## Filter and Keywords

`"fuzzy"` is the default: `nf` matches New file. `"contains"` and `"startsWith"` match the text itself. A custom function returns a boolean or a score; zero hides a command and higher scores rank first.

Data commands are sorted by score. Commands written directly in markup keep their order, even though the best match can be highlighted.

`@keywords` adds search terms without changing the command's label. Use it for synonyms or names someone might type instead.

```glimmer-ts title="filter.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Command } from "ember-ui-sdk/command"
import { Select } from "ember-ui-sdk/select"
import { icon } from "./icon"

const commands = [
  { label: "Home" },
  { label: "Inbox", keywords: ["mail", "messages"] },
  { label: "Documents" },
  { label: "Downloads" },
  { label: "New file" },
  { label: "New folder" },
  { label: "Copy" },
  { label: "Paste" },
  { label: "Delete", keywords: ["remove", "trash"] },
  { label: "Zoom in" },
  { label: "Zoom out" },
  { label: "Search emoji", keywords: ["smiley", "face"] },
  { label: "Keyboard shortcuts", keywords: ["hotkeys"] },
  { label: "Settings", keywords: ["preferences"] },
]

const modes = [
  { value: "fuzzy", label: "Fuzzy" },
  { value: "contains", label: "Contains" },
  { value: "startsWith", label: "Starts with" },
  { value: "words", label: "Words" },
]

function words(item: { label: string }, query: string) {
  return query
    .toLowerCase()
    .split(/\s+/)
    .every((word) =>
      item.label
        .toLowerCase()
        .split(" ")
        .some((part) => part.startsWith(word))
    )
}

export default class Filter extends Component {
  commands = commands
  modes = modes
  @tracked mode = "fuzzy"

  get filter() {
    return this.mode === "words" ? words : this.mode
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
      <Command @filter={{this.filter}} as |c|>
        <c.Input aria-label="Search commands" placeholder="Try “nf”, “zo in” or “smiley”" />
        <c.Empty>No results found.</c.Empty>
        <c.List>
          {{#each this.commands key="label" as |command|}}
            <c.Item @value={{command.label}} @keywords={{command.keywords}}>
              {{command.label}}
            </c.Item>
          {{/each}}
        </c.List>
      </Command>
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

Type “nf” with Fuzzy to find New file. Choose Words and type “zo in” for Zoom in, or type “smiley” to find Search emoji through a keyword.

## Pages

Set an item’s `@page` to the value of a `c.Page` to open it. An unnamed page holds the first set of commands. The `@pages` array records the stack of pages that have been opened.

Backspace in an empty search goes back and restores the previous page’s query. Escape clears the query first, then goes back. A Go back command can call `pop()` on a controller.

```glimmer-ts title="pages.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ArrowLeft, Moon, Users } from "lucide"
import { Command, createCommandController } from "ember-ui-sdk/command"
import { icon } from "./icon"

const themes = [
  { value: "light", label: "Light" },
  { value: "dark", label: "Dark" },
  { value: "system", label: "System" },
]

const teams = [
  { value: "design", label: "Design" },
  { value: "engineering", label: "Engineering" },
  { value: "marketing", label: "Marketing" },
]

export default class Pages extends Component {
  command = createCommandController()
  themes = themes
  teams = teams
  @tracked pages: string[] = []

  get hasPages() {
    return this.pages.length > 0
  }

  get placeholder() {
    return this.pages.length
      ? "Search… (Backspace to go back)"
      : "What do you need?"
  }

  onPagesChange = (next: string[]) => {
    this.pages = next
  }

  onAction = (value: string) => {
    if (value === "back") {
      this.command.pop()
    }
  }

  <template>
    <Command
      @pages={{this.pages}}
      @onPagesChange={{this.onPagesChange}}
      @controller={{this.command}}
      @onAction={{this.onAction}}
      as |c|
    >
      <div data-slot="row">
        {{#each this.pages key="@identity" as |page|}}
          <span data-slot="badge">{{page}}</span>
        {{/each}}
      </div>
      <c.Input aria-label="Search commands" placeholder={{this.placeholder}} />
      <c.Empty>No results found.</c.Empty>
      <c.List>
        <c.Page as |p|>
          <p.Group as |g|>
            <g.Label>Workspace</g.Label>
            <g.Item @value="theme" @page="theme" as |item|>
              <item.Icon>{{icon Moon}}</item.Icon>
              Change theme…
            </g.Item>
            <g.Item @value="teams" @page="teams" as |item|>
              <item.Icon>{{icon Users}}</item.Icon>
              Switch team…
            </g.Item>
          </p.Group>
        </c.Page>
        <c.Page @value="theme" as |p|>
          {{#each this.themes key="value" as |theme|}}
            <p.Item @value={{theme.value}}>
              {{theme.label}}
            </p.Item>
          {{/each}}
        </c.Page>
        <c.Page @value="teams" as |p|>
          {{#each this.teams key="value" as |team|}}
            <p.Item @value={{team.value}}>
              {{team.label}}
            </p.Item>
          {{/each}}
        </c.Page>
        {{#if this.hasPages}}
          <c.Item @value="back" as |item|>
            <item.Icon @mirror={{true}}>{{icon ArrowLeft}}</item.Icon>
            Go back
          </c.Item>
        {{/if}}
      </c.List>
    </Command>
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

Choose Change theme or Switch team. Use Go back, or press Backspace in an empty search field, to return.

## Items as Data

Pass `@items` to provide commands, groups, separators, and pages as `CommandData`. A data command with its own `items` opens a page. Its shortcut still works when another page or filter hides it.

The data can render bare parts for you. For styled commands, render from the list’s `state.items`, which follows the current page and ranked results. The example handles groups and separators as well as commands. Lists and Menus covers the shared data format.

Pass `@emptyItems` alongside `@items` to show suggested or recent commands while the first page's search is empty. Once someone types, the full collection is searched.

```gts
const suggested = [{ type: "group", label: "Suggested", items: recent }]

<template>
  <Command @items={{commands}} @emptyItems={{suggested}} as |c|>…</Command>
</template>
```

```glimmer-ts title="data.gts"
import Component from "@glimmer/component"
import { Command } from "ember-ui-sdk/command"
import { useLog } from "./log"

const commands = [
  {
    type: "group",
    label: "Navigation",
    items: [
      { value: "home", label: "Go home", keywords: ["start"] },
      { value: "inbox", label: "Open inbox", shortcut: "mod+i" },
    ],
  },
  { type: "separator" },
  {
    type: "group",
    label: "Preferences",
    items: [
      {
        value: "theme",
        label: "Change theme…",
        items: [
          { value: "light", label: "Light" },
          { value: "dark", label: "Dark" },
          { value: "system", label: "System" },
        ],
      },
      {
        value: "language",
        label: "Change language…",
        items: ["English", "Français", "Deutsch", "日本語"],
      },
      { value: "sign-out", label: "Sign out", shortcut: "mod+shift+q" },
    ],
  },
]

export default class Data extends Component {
  log = useLog(this)
  commands = commands

  onAction = (value: string) => {
    this.log(`Ran ${value}`)
  }

  <template>
    <div data-slot="stack">
      <Command @items={{this.commands}} @onAction={{this.onAction}} as |c|>
        <c.Input aria-label="Search commands" placeholder="Type a command…" />
        <c.Empty>No results found.</c.Empty>
        <c.List as |list|>
          {{#each list.state.items key="@identity" as |entry|}}
            {{#if entry.items}}
              <c.Group as |g|>
                <g.Label>{{entry.label}}</g.Label>
                {{#each entry.items key="@identity" as |command|}}
                  <g.Item
                    @value={{command.value}}
                    @label={{command.label}}
                    @disabled={{command.disabled}}
                    @shortcut={{command.shortcut}}
                    as |item|
                  >
                    {{command.label}}
                    {{#if command.shortcut}}<item.Shortcut />{{/if}}
                  </g.Item>
                {{/each}}
              </c.Group>
            {{else}}
              <c.Separator />
            {{/if}}
          {{/each}}
        </c.List>
      </Command>
    </div>
  </template>
}
```

Choose Change theme to open its commands. Press Cmd+I / Ctrl+I to run Open inbox from any page; the console logs what ran.

## Async Results

Use `useAsyncOptions` from `ember-ui-sdk/async-options` to wait for typing to pause and discard stale results. Send query changes to its `setQuery()`, render the returned items, and pass `@status`. Set `@filter={{false}}` to keep the server’s order.

`c.Status` describes loading and failures, and the list gets `aria-busy` while loading. `@onLoadMore` can request another page when scrolling or highlighting reaches the last command. Without a status part, `@announcement` controls the result-count message after typing pauses.

```glimmer-ts title="async.gts"
import Component from "@glimmer/component"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Command } from "ember-ui-sdk/command"

function searchIssues(query: string, { signal }: { signal: AbortSignal }) {
  const issues = [
    "Fix login redirect",
    "Dark mode flicker",
    "Add billing page",
    "Search is slow",
    "Update dependencies",
    "Crash on upload",
    "Export to CSV",
    "Keyboard shortcuts help",
  ]
  return new Promise<{ value: string; label: string }[]>((resolve, reject) => {
    const timer = setTimeout(() => {
      const needle = query.trim().toLowerCase()
      resolve(
        issues
          .filter((issue) => issue.toLowerCase().includes(needle))
          .map((issue) => ({
            value: issue.toLowerCase().replaceAll(" ", "-"),
            label: issue,
          }))
      )
    }, 400)
    signal.addEventListener("abort", () => {
      clearTimeout(timer)
      reject(new DOMException("Aborted", "AbortError"))
    })
  })
}

export default class Async extends Component {
  issues = useAsyncOptions(this, searchIssues, {
    debounce: 250,
    immediate: true,
  })

  onQueryChange = (query: string) => {
    this.issues.setQuery(query)
  }

  statusText = (state: { loading: boolean; count: number }) =>
    state.loading
      ? "Searching…"
      : `${state.count} ${state.count === 1 ? "issue" : "issues"}`

  <template>
    <Command
      @filter={{false}}
      @status={{this.issues.state.status}}
      @onQueryChange={{this.onQueryChange}}
      @onLoadMore={{this.issues.loadMore}}
      as |c|
    >
      <c.Input aria-label="Search issues" placeholder="Search issues…" />
      <c.Status as |s|>{{this.statusText s.state}}</c.Status>
      <c.Empty as |e|>
        {{#unless e.state.loading}}No issues match “{{e.state.query}}”.{{/unless}}
      </c.Empty>
      <c.List>
        {{#each this.issues.state.items key="value" as |issue|}}
          <c.Item @value={{issue.value}} @label={{issue.label}}>
            {{issue.label}}
          </c.Item>
        {{/each}}
      </c.List>
    </Command>
  </template>
}
```

Type “login” and wait for matching issues. Replace the text to start a new search; only the latest results appear.

## Pending Actions

Return a promise from `@onAction` or an item’s `@onSelect`. The command gets `data-pending`, `aria-busy` and `aria-disabled` until it settles; further presses do not start another run. A rejection becomes the command’s `error` state, which clears when it runs again.

An item’s `@onSelect` runs before `@onAction`. Call `preventDefault()` on its event to stop the action.

```glimmer-ts title="pending.gts"
import Component from "@glimmer/component"
import { LoaderCircle } from "lucide"
import { Command } from "ember-ui-sdk/command"
import { icon } from "./icon"
import { useLog } from "./log"

const wait = (ms: number) =>
  new Promise<void>((resolve) => setTimeout(resolve, ms))

export default class Pending extends Component {
  log = useLog(this)

  deploy = async () => {
    await wait(1200)
    this.log("Deployed to production")
  }

  sync = async () => {
    await wait(600)
    this.log("Couldn't sync: offline")
    throw new Error("Offline")
  }

  <template>
    <div data-slot="stack">
      <Command as |c|>
        <c.Input aria-label="Search actions" placeholder="Search actions…" />
        <c.List>
          <c.Item @value="deploy" @onSelect={{this.deploy}} as |item|>
            Deploy to production
            {{#if item.state.pending}}
              <span data-slot="spinner">{{icon LoaderCircle}}</span>
            {{/if}}
          </c.Item>
          <c.Item @value="sync" @onSelect={{this.sync}} as |item|>
            Sync with server
            {{#if item.state.pending}}
              <span data-slot="spinner">{{icon LoaderCircle}}</span>
            {{else if item.state.error}}
              <span data-slot="hint">Failed, try again</span>
            {{/if}}
          </c.Item>
        </c.List>
      </Command>
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

Run Deploy to production and try it again while it's pending. Sync with server fails and can be retried; the console logs each outcome.

## Virtualized

Pass the full `@items` collection so filtering and keyboard navigation include commands that are not mounted. Render only visible rows, giving each its index in the current results. `@onValueChange` includes that index so you can scroll a newly highlighted row into view.

```glimmer-ts title="virtualized.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { htmlSafe } from "@ember/template"
import { tracked } from "@glimmer/tracking"
import { Command } from "ember-ui-sdk/command"

const commands = Array.from({ length: 10_000 }, (_, index) => ({
  value: `command-${index + 1}`,
  label: `Command ${index + 1}`,
}))

const row = 32
const height = 256

export default class Virtualized extends Component {
  commands = commands
  @tracked scrollTop = 0

  onValueChange = (_value: string | null, { index }: { index: number }) => {
    const el = document.querySelector<HTMLDivElement>("#virtualized-scroller")
    if (!el || index < 0) {
      return
    }
    const top = index * row
    if (top < el.scrollTop) {
      el.scrollTop = top
    } else if (top + row > el.scrollTop + el.clientHeight) {
      el.scrollTop = top + row - el.clientHeight
    }
  }

  scrolled = (event: Event) => {
    this.scrollTop = (event.currentTarget as HTMLDivElement).scrollTop
  }

  visible = (items: typeof commands) => {
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

  topOf = (index: number) => htmlSafe(`top: ${index * row}px`)

  <template>
    <Command @items={{this.commands}} @onValueChange={{this.onValueChange}} as |c|>
      <c.Input aria-label="Search 10,000 commands" placeholder="Search 10,000 commands…" />
      <div id="virtualized-scroller" {{on "scroll" this.scrolled}}>
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
                style={{this.topOf entry.index}}
              >
                {{entry.item.label}}
              </c.Item>
            {{/each}}
          </div>
        </c.List>
      </div>
    </Command>
  </template>
}
```

Search 10,000 commands or move through them with the arrow keys. Only the rows near the viewport render.

## Controlled

The highlighted command, search text, and page stack are separate:

| Argument | Shape                               | Change callback  |
| -------- | ----------------------------------- | ---------------- |
| `@value` | A command’s string value or `null`. | `@onValueChange` |
| `@query` | The search text.                    | `@onQueryChange` |
| `@pages` | An array of page values.            | `@onPagesChange` |

Pass them with their change callbacks, or use `@defaultValue`, `@defaultQuery`, and `@defaultPages` for starting state. Change callbacks receive details; call `details.cancel()` to reject a change. `@value` is the highlighted command, not a chosen one, and it changes as the highlight moves. `@onAction` reports activation, so moving the highlight alone does not run a command.

```glimmer-ts title="controlled.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Command } from "ember-ui-sdk/command"
import { useLog } from "./log"

const themes = [
  { value: "light", label: "Light" },
  { value: "dark", label: "Dark" },
  { value: "system", label: "System" },
]

export default class Controlled extends Component {
  log = useLog(this)
  themes = themes
  @tracked value: string | null = "dark"
  @tracked query = ""
  @tracked pages = ["theme"]

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    this.log(`Highlighted ${next ?? "nothing"} (${details.reason})`)
  }

  onQueryChange = (next: string, details: { reason: string }) => {
    this.query = next
    this.log(`Query “${next}” (${details.reason})`)
  }

  onPagesChange = (next: string[], details: { reason: string }) => {
    this.pages = next
    this.log(`Pages [${next.join(", ")}] (${details.reason})`)
  }

  onAction = (next: string) => {
    this.log(`Ran ${next}`)
  }

  <template>
    <Command
      @value={{this.value}}
      @onValueChange={{this.onValueChange}}
      @query={{this.query}}
      @onQueryChange={{this.onQueryChange}}
      @pages={{this.pages}}
      @onPagesChange={{this.onPagesChange}}
      @onAction={{this.onAction}}
      as |c|
    >
      <c.Input aria-label="Search themes" placeholder="Search themes…" />
      <c.List>
        <c.Page as |p|>
          <p.Item @value="theme" @page="theme">Change theme…</p.Item>
        </c.Page>
        <c.Page @value="theme" as |p|>
          {{#each this.themes key="value" as |theme|}}
            <p.Item @value={{theme.value}}>
              {{theme.label}}
            </p.Item>
          {{/each}}
        </c.Page>
      </c.List>
    </Command>
  </template>
}
```

Open Change theme, search and move the highlight. The console logs each highlight, query and page change with its reason.

## Controller

Create a `createCommandController()` for one instance and pass it as `@controller`. It can read and set the highlight, query, and page stack. Use `push()` and `pop()` to navigate pages, `run()` to run the highlighted command or a named one, and `focus()` to focus the search.

```glimmer-ts title="controller.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Command, createCommandController } from "ember-ui-sdk/command"
import { useLog } from "./log"

const themes = [
  { value: "light", label: "Light" },
  { value: "dark", label: "Dark" },
  { value: "system", label: "System" },
]

export default class Controller extends Component {
  log = useLog(this)
  palette = createCommandController()
  themes = themes

  openThemes = () => {
    this.palette.push("theme")
  }

  back = () => {
    this.palette.pop()
  }

  highlightDark = () => {
    this.palette.setValue("dark")
  }

  searchLi = () => {
    this.palette.setQuery("li")
  }

  runHighlighted = () => {
    this.palette.run()
  }

  focus = () => {
    this.palette.focus()
  }

  onAction = (value: string) => {
    this.log(`Ran ${value}`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.openThemes}}>
          Open Themes
        </button>
        <button type="button" {{on "click" this.back}}> Back </button>
        <button type="button" {{on "click" this.highlightDark}}>
          Highlight Dark
        </button>
        <button type="button" {{on "click" this.searchLi}}>
          Search “li”
        </button>
        <button type="button" {{on "click" this.runHighlighted}}>
          Run Highlighted
        </button>
        <button type="button" {{on "click" this.focus}}> Focus </button>
      </div>
      <Command @controller={{this.palette}} @onAction={{this.onAction}} as |c|>
        <c.Input aria-label="Search commands" />
        <c.List>
          <c.Page as |p|>
            <p.Item @value="theme" @page="theme">Change theme…</p.Item>
          </c.Page>
          <c.Page @value="theme" as |p|>
            {{#each this.themes key="value" as |theme|}}
              <p.Item @value={{theme.value}}>
                {{theme.label}}
              </p.Item>
            {{/each}}
          </c.Page>
        </c.List>
      </Command>
    </div>
  </template>
}
```

Use the buttons to open pages, search, move the highlight and run it from outside. The console logs each command that runs.

## Custom Rendering

Pass `@render={{true}}` to an item to render it as an anchor when it should navigate. Enter follows the highlighted link; modified clicks keep their usual browser behavior.

```glimmer-ts title="custom-rendering.gts"
import Component from "@glimmer/component"
import { CornerDownLeft } from "lucide"
import { Command } from "ember-ui-sdk/command"
import { icon } from "./icon"

const pages = ["Composition", "Installation", "Styling"]

export default class CustomRendering extends Component {
  pages = pages

  hashOf = (page: string) => `#${page.toLowerCase()}`

  <template>
    <Command as |c|>
      <c.Input aria-label="Search docs" placeholder="Search docs…" />
      <c.List>
        {{#each this.pages key="@identity" as |page|}}
          <c.Item @value={{page}} @render={{true}} as |item|>
            <a {{item.part}} href={{this.hashOf page}}>
              <item.Text />
              {{#if item.state.highlighted}}{{icon CornerDownLeft}}{{/if}}
            </a>
          </c.Item>
        {{/each}}
      </c.List>
    </Command>
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

Search for Installation and press Enter. The command follows the link to that section on this page.

## Styling

Each part has a `data-slot`, such as `command-item`, and shows its state through the attributes listed under [Data Attributes](#data-attributes).

Use `data-highlighted` for the active command and `data-pending` for an action in progress. Give the list a height limit and `overflow-y: auto` for long lists; keyboard navigation scrolls the highlighted command into view. When mixing commands with and without icons, `data-has-icons` on the list and `data-has-icon` on each item let you reserve matching space with logical padding.

## Data Attributes

### Command
`[data-slot="command"]`

- `data-loading`: Present while results load, with `status="loading"`.

### CommandInput
### CommandList
`[data-slot="command-list"]`

- `data-has-icons`: Present while any command inside holds an icon part, so items without one can line up.

### CommandItem
`[data-slot="command-item"]`

- `data-disabled`: Present when the command can't run. Arrow keys skip it.
- `data-highlighted`: Present on the highlighted command, which Enter runs. Focus stays in the field.
- `data-pending`: Present while the Promise the command's `onSelect` or `onAction` returned is running.
- `data-has-icon`: Present on a command while it holds an icon part.

### CommandItemText
`[data-slot="command-item-text"]`

- `data-matched`: Present on a command's text while the search matched part of it, which is marked.

### CommandItemIcon
`[data-slot="command-item-icon"]`

- `data-mirror`: Present on an icon that flips in right-to-left text, with `mirror`.

### CommandEmpty
`[data-slot="command-empty"]`

- `data-loading`: Present while results load, with `status="loading"`.
- `data-empty`: Present while no command matches.

### CommandStatus
`[data-slot="command-status"]`

- `data-loading`: Present while results load, with `status="loading"`.

## API Reference

Pass the root's options as `@` arguments.

### Command

- `value?` (`string | null`): The highlighted command's value. Pass it to control the highlight. `null` highlights nothing.
- `defaultValue?` (`string | null`): The command highlighted at first, when uncontrolled. Without it, the first command is, with `autoHighlight`.
- `onValueChange?` (`((value: string | null, details: CommandValueChangeDetails) => void)`): Runs when the highlight moves: arrow keys, the pointer, typing, a page change or a controller. `details.index` says where the command is, for virtualized lists.
- `query?` (`string`): The search text, which filters the commands. Pass it to control it.
- `defaultQuery?` (`string`): The search text at first, when uncontrolled.
- `onQueryChange?` (`((query: string, details: ChangeDetails<CommandQueryChangeReason>) => void)`): Runs when the search text wants to change: typing, opening a page, going back, or a controller.
- `pages?` (`string[]`): The stack of open pages, from the first page opened to the current one. Pass it to control it.
- `defaultPages?` (`string[]`): The pages open at first, when uncontrolled.
- `onPagesChange?` (`((pages: string[], details: ChangeDetails<CommandPagesChangeReason>) => void)`): Runs when a page opens or Backspace or Escape goes back.
- `onAction?` (`((value: string, details: CommandActionDetails) => unknown)`): Runs when a command runs, with its value: Enter, a click, or its shortcut. Return a Promise to mark the command pending until it settles: it gets `data-pending`, `aria-busy` and `aria-disabled`, and running it again waits. A rejection puts the reason in its `error` state until the next run.
- `pendingAnnouncement?` (`string`): What screen readers hear once a command has been pending for a second, so a slow action doesn't pass in silence. Set it in the page's language. An empty string says nothing.
- `items?` (`CommandData`): The commands as data. Renders them for you, ranked as the user types, with pages for commands that have `items`.
- `emptyItems?` (`CommandData`): Commands shown instead of `items` on the first page while the search is empty, like recent or suggested ones. Groups work, like `{ type: "group", label: "Suggestions", items }`. Needs `items`.
- `filter?` (`SearchFilter<string>`): How typing narrows the list: `"fuzzy"` keeps commands with the text's letters in order, best matches first; `"contains"` and `"startsWith"` match the text itself. A function returns a score (0 hides) or a boolean. `false` keeps every command, for results a server already filtered. Composed commands keep their order, and data commands are ranked by score.
- `autoHighlight?` (`boolean`): Whether the first command is highlighted while nothing else is, and the best match as the user types, so Enter runs it.
- `loop?` (`boolean`): Whether arrow keys wrap from the last command to the first.
- `status?` (`AsyncOptionsStatus`): Whether results are loading or failed, for the empty and status parts. Sets `aria-busy` on the list while loading.
- `onLoadMore?` (`(() => void)`): Runs when the highlight or scrolling reaches the last command, so the next page can load, like `createAsyncOptions`'s `loadMore`. Not again for the same commands, unless the last load failed.
- `announcement?` (`((change: ListAnnouncement) => string | null | undefined)`): What screen readers hear after typing pauses, when no `CommandStatus` is rendered. Return null for nothing.
- `controller?` (`object`): Reads and drives the list from anywhere. Create one with `createCommandController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### CommandInput

The search field. Renders an `input` with the combobox role.

### CommandStatus

Describes loading and failures. Renders a `div` with the status role.

### CommandEmpty

Shows while no command matches. Renders a `div`.

### CommandList

Holds the commands. Renders a `div` with the listbox role, always shown.

### CommandPage

- `value?` (`string`): The page's name, which a command's `page` opens. Leave it out for the first page.

### CommandGroup

Groups commands under a label. Renders a `div` with the group role.

### CommandGroupLabel

Names its group. Renders a `div`.

### CommandItem

- `value?` (`string`): Passed to `@onAction` and `@onValueChange`, and identifies the command. Without it, one is generated.
- `label?` (`string`): The text the search matches, when the content isn't plain text. Not the accessible name: use `aria-label` for that.
- `keywords?` (`string[]`): More words the search matches.
- `disabled?` (`boolean`): Keeps the command from running. Arrow keys and the pointer skip it. Sets `data-disabled` and `aria-disabled`.
- `shortcut?` (`string`): A keyboard shortcut that runs the command while it's in the page, like `"mod+p"`. Sets `aria-keyshortcuts`, and a `CommandShortcut` inside shows it.
- `page?` (`string`): The page choosing this command opens, by the `value` of a `CommandPage`.
- `index?` (`number`): The command's position among all visible commands, for virtualized lists that render only some. Sets `aria-posinset` and `aria-setsize`.
- `onSelect?` (`((event: Event) => unknown)`): Runs when the command runs, before `@onAction`, with the click or key press that ran it, or a new `select` Event for a shortcut or a controller's `run()`. Call `event.preventDefault()` to skip `@onAction` and the page. Return a Promise to mark the command pending until it settles, like `@onAction`.

### CommandItemIcon

- `mirror?` (`boolean`): Flips the icon horizontally in right-to-left text, for icons that point a way, like arrows and chevrons. Icons that picture a thing, like a clock or a check, stay as they are.

### CommandItemText

Shows its command's label, and marks what matched the search. Renders a `span`.

### CommandShortcut

- `shortcut?` (`string`): The keys to show, like `"mod+p"`. Inside a command, its `shortcut`.

### CommandSeparator

Separates commands or groups. Renders a `div` with the separator role.

### Items as Data

Each command in `@items`. Groups are `{ type: "group", label, items }` and separators `{ type: "separator" }`.

- `value` (`string`): Identifies the item, and is what choosing it reports. A string, or any value with `itemToValue`.
- `label` (`string`): The text shown and matched by typeahead and filtering. A select's trigger shows it once chosen.
- `keywords?` (`string[]`): More words filtering matches, like `["team"]` for a plan called Pro.
- `disabled?` (`boolean`): Keeps the item from being chosen. The keyboard skips it, like in a native select.
- `shortcut?` (`string`): A keyboard shortcut that runs the command, like `"mod+p"`, while the list is in the page, whatever page it's on. Shows `⌘P` on Apple platforms and `Ctrl+P` elsewhere.
- `items?` (`CommandData`): Commands on a page of their own. Choosing this command opens the page, and Backspace in the empty field goes back.

### State

What `@render` parts and their blocks receive, per part.

`Command`:

- `page` (`string | null`): The current page, or `null` on the first page.
- `loading` (`boolean`): Whether results are loading.

`CommandInput`:

- `page` (`string | null`): The current page, or `null` on the first page.

`CommandList`:

- `status` (`AsyncOptionsStatus`): Whether results are loading or failed.
- `items` (`CommandData`): The visible data commands, ranked, for rendering a virtualized list yourself.

`CommandItem`:

- `highlighted` (`boolean`): Whether the command is highlighted, by the keyboard, the pointer or typing.
- `disabled` (`boolean`): Whether the command can't run.
- `pending` (`boolean`): Whether its action's Promise is running.
- `error` (`unknown`): Why its last action failed, until it runs again.

`CommandEmpty`:

- `loading` (`boolean`): Whether results are loading.
- `empty` (`boolean`): Whether no item matches.
- `query` (`string`): The text the list is filtered by.

`CommandStatus`:

- `status` (`"idle" | "loading" | "error"`): Whether results are loading or failed.
- `loading` (`boolean`): Whether results are loading.
- `count` (`number`): How many items are visible.

`CommandShortcut`:

- `text` (`string`): The shortcut formatted for this platform: `⌘P` on Apple platforms and `Ctrl+P` elsewhere. Empty without one.

`CommandItemText`, which takes no arguments of its own:

- `segments` (`MatchSegment[]`): The text in pieces, each marked when it matched. Joined, they're the whole text.
- `matched` (`boolean`): Whether any piece matched.

`CommandItemIcon`:

- `mirror` (`boolean`): Whether it flips in right-to-left text.

### Reasons

Why the highlighted command changed:

- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `item-hover` (`PointerEvent`): The pointer moved onto an item, which highlighted it, like in a command list.
- `input-change` (`Event`): Typing, pasting or dropping changed a text field's value; in a combobox it can also open or close it, or Enter keeps the typed text as the value.
- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `shortcut` (`KeyboardEvent`): A keyboard shortcut, like a trigger's `shortcut`.
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `item-removed` (`none`): The selected item left the page, and another was picked.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

Why the search text changed:

- `input-change` (`Event`): Typing, pasting or dropping changed a text field's value; in a combobox it can also open or close it, or Enter keeps the typed text as the value.
- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `shortcut` (`KeyboardEvent`): A keyboard shortcut, like a trigger's `shortcut`.
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

And why the stack of pages changed:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `shortcut` (`KeyboardEvent`): A keyboard shortcut, like a trigger's `shortcut`.
- `back` (`Event`): Going back: the Android back button or gesture, or Backspace in an empty command input, which returns to the previous page.
- `escape-key` (`KeyboardEvent`): Escape, or a submenu's close key (ArrowLeft in left-to-right layouts).
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createCommandController()` and pass it as `@controller`.

- `getValue()` (`() => string | null`): The highlighted command's value, or `null`.
- `setValue(value, options?)` (`(value: string | null, options?: CommandChangeOptions<CommandValueChangeReason> | undefined) => boolean`): Highlights a command, and scrolls it into view. Returns false when the change was canceled or nothing changed.
- `getQuery()` (`() => string`): The search text.
- `setQuery(query, options?)` (`(query: string, options?: CommandChangeOptions<CommandQueryChangeReason> | undefined) => boolean`): Changes the search text, which filters the commands. Returns false when the change was canceled or nothing changed.
- `getPages()` (`() => string[]`): The stack of open pages, from the first page opened to the current one. Empty on the first page.
- `setPages(pages, options?)` (`(pages: string[], options?: CommandChangeOptions<CommandPagesChangeReason> | undefined) => boolean`): Replaces the stack of pages. Returns false when the change was canceled or nothing changed.
- `push(page, options?)` (`(page: string, options?: CommandChangeOptions<CommandPagesChangeReason> | undefined) => boolean`): Opens a page on top of the current one, by the `value` of a `CommandPage` or a data command. Returns false when the change was canceled or nothing changed.
- `pop(options?)` (`(options?: CommandChangeOptions<CommandPagesChangeReason> | undefined) => boolean`): Goes back to the previous page, and puts back the search text typed there. Returns false when the change was canceled or nothing changed.
- `run(value?)` (`(value?: string | undefined) => void`): Runs a command, as Enter would: the highlighted one, or the one with this value.
- `focus()` (`() => void`): Moves focus to the search field.

### Events

Callbacks get the new state first, then the details. A controlled `@value`, `@query` or `@pages` only updates when its callback wasn't canceled.

| Argument         | On            | Receives                                                                               |
| ---------------- | ------------- | -------------------------------------------------------------------------------------- |
| `@onValueChange` | `Command`     | `(value, details)`: the highlighted command, the [reason](#reasons) and its `index`    |
| `@onQueryChange` | `Command`     | `(query, details)`: the new text, and the [reason](#reasons)                           |
| `@onPagesChange` | `Command`     | `(pages, details)`: the new stack, and the [reason](#reasons)                          |
| `@onAction`      | `Command`     | `(value, { event })`: the command that ran. Return a Promise to mark it pending        |
| `@onLoadMore`    | `Command`     | `()`, when the last command is reached                                                 |
| `@onSelect`      | `CommandItem` | `(event)`: before `@onAction`. `preventDefault()` skips it. A Promise marks it pending |

## Accessibility

The command list follows the [WAI-ARIA combobox pattern](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/) with a listbox that's always shown. Focus stays in the input, which points to the highlighted command with `aria-activedescendant`. Every line below is an automated test.

### Keyboard

| Key                | Does                                                                  |
| ------------------ | --------------------------------------------------------------------- |
| Typing             | Filters the commands and highlights the best match                    |
| ArrowDown, ArrowUp | Moves the highlight. Wraps unless `@loop={{false}}`                   |
| Enter              | Runs the highlighted command, or follows it when it renders as a link |
| Escape             | Clears the search, then goes back a page                              |
| Backspace          | In an empty search, goes back a page and restores its query           |
| An item's shortcut | Runs it while the list is mounted, even when hidden by the search     |

The first available command is highlighted by default. Set `@autoHighlight={{false}}` to wait for an arrow key or pointer movement.

### Tested Behavior

**Field**

- Is a combobox that controls an always-expanded listbox.
- The first command is highlighted from the start.

**Filtering**

- Typing keeps the commands that match, ignoring case and accents.
- Groups without a match hide, and the rest keep their labels.
- The first match is highlighted as the text changes, so Enter runs it.
- Deleting text brings back the commands the shorter text matches.
- Commands without a value that mount while the field has text show when they match.
- Going back a page reports the new highlight as back, not as a removal.
- Nothing matching shows the empty message.

**Keyboard**

- Arrow keys move the highlight while focus stays in the field.
- Home and End stay in the field for the caret.
- The highlighted option has the id aria-activedescendant names.
- Enter runs the highlighted command.

**Pointer**

- Clicking a command runs it.
- A disabled command doesn't run.

**AutoHighlight**

- Without autoHighlight, nothing is highlighted until an arrow key.

Runs in React, Vue and web components.

Long lists stay fast and announce their size:

**Virtualized**

- Renders only the rows in view, each with its place in the whole list.
- Arrow keys reach commands that weren't rendered, and the active descendant follows.
- Typing ranks every command, rendered or not, best match first.

Runs in React.

Also tested:

**Enhancements**

- The highlighted command is the selected option, as the APG's list autocomplete marks it.
- Keywords match as well as labels.
- Fuzzy matching finds the letters in order, across words.
- Arrow keys skip disabled commands.
- A command's shortcut runs it and sets aria-keyshortcuts.
- A shortcut runs its command while the search hides it.
- A command is pending while its action's Promise runs, and runs only once.
- A command opens its page, and Backspace in the empty field goes back with the text.
- Escape clears the text, then goes back a page.
- Results that still hold the highlighted command keep the highlight.
- The list is busy while results load.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while searching with a keyboard.

Runs in React, Vue and web components.
