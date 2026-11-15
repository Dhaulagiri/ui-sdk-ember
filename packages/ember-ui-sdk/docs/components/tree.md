# Tree

Browse a hierarchy of files, pages, or choices with expandable branches.

Use a Tree when items have children, like files in folders or pages in a docs sidebar. Start with nested parts, then add selection, checkboxes, or children loaded from a server as you need them.

```glimmer-ts title="demo.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { ChevronRight, File, Folder, FolderOpen } from "lucide"
import { Tree } from "ember-ui-sdk/tree"
import { icon } from "./icon"

const files = [
  {
    value: "app",
    label: "app",
    children: [
      { value: "app/layout.tsx", label: "layout.tsx" },
      { value: "app/page.tsx", label: "page.tsx" },
      {
        value: "app/settings",
        label: "settings",
        children: [{ value: "app/settings/page.tsx", label: "page.tsx" }],
      },
    ],
  },
  {
    value: "components",
    label: "components",
    children: [
      { value: "components/button.tsx", label: "button.tsx" },
      { value: "components/card.tsx", label: "card.tsx" },
    ],
  },
  { value: "components.json", label: "components.json" },
  { value: "package.json", label: "package.json" },
  { value: "README.md", label: "README.md" },
]

type Node = {
  value: string
  label: string
  children?: Node[]
}

class Nodes extends Component<{
  Args: { parts: Record<string, unknown>; items: Node[] }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} as |i|>
        <i.Label>
          {{#if item.children}}
            <i.Indicator>{{icon ChevronRight}}</i.Indicator>
            {{icon Folder}}
            {{icon FolderOpen}}
          {{else}}
            {{icon File}}
          {{/if}}
          <span>{{item.label}}</span>
        </i.Label>
        {{#if item.children}}
          <i.Group as |g|>
            <Nodes @parts={{g}} @items={{item.children}} />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class Demo extends Component {
  files = files

  <template>
    <Tree
      aria-label="Files"
      @defaultExpanded={{array "app"}}
      @defaultValue="app/page.tsx"
      as |t|
    >
      <Nodes @parts={{t}} @items={{this.files}} />
    </Tree>
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

Expand components to see its files. Use the arrow keys to move between rows and open or close branches.

## Installation

```bash
npm install ember-ui-sdk @ui-sdk/core
```

## Composition

Use the following composition to build a `Tree`:

```text
Tree as |t|
├── t.Item
│   ├── t.Label
│   │   └── t.Indicator
│   └── t.Group
│       └── t.Item
│           └── t.Label
└── t.Item
    └── t.Label
```

Give the tree an accessible name and every item a unique `@value`. An item with a `t.Group` inside it is a branch. The group holds its children; the label names the item. The indicator and checkbox are optional, and they belong to the item around them, so put them inside its label to make them part of the row.

## Usage

Import the root and use the parts it yields:

```gts
import { Tree } from "ember-ui-sdk/tree"

<template>
  <Tree aria-label="Project files" as |t|>
    <t.Item @value="src">
      <t.Label>
        <t.Indicator>›</t.Indicator>
        src
      </t.Label>
      <t.Group>
        <t.Item @value="src/index.ts">
          <t.Label>index.ts</t.Label>
        </t.Item>
      </t.Group>
    </t.Item>
    <t.Item @value="package.json">
      <t.Label>package.json</t.Label>
    </t.Item>
  </Tree>
</template>
```

## Items as Data

Pass `@items` to give the tree its full hierarchy, including collapsed branches. Each `TreeItemData` has a `value`, a `label`, and optional `children`. With no children of its own, the tree renders bare parts from the data:

```gts
import { Tree } from "ember-ui-sdk/tree"

const items = [
  {
    value: "fruit",
    label: "Fruit",
    children: [
      { value: "apple", label: "Apple" },
      { value: "banana", label: "Banana" },
    ],
  },
  { value: "bread", label: "Bread" },
]

<template><Tree aria-label="Groceries" @items={{items}} /></template>
```

To render the rows yourself, keep `@items` on the tree and render them with a recursive component that receives the tree's parts, so keyboard navigation, item counts, and controllers still know the whole hierarchy. The tree example's `Nodes` component does this.

## File Paths

Pass `@paths` for a file explorer. Folders become branches and sort before files; a path ending in `/` represents an empty folder. `treeFromPaths()` returns the same data when you want to render the rows yourself.

Selection and activation are separate. This example uses `@activation="automatic"` so arrow keys select a file, then `@onAction` opens it. Return a promise from the action callback to show a pending state while it opens.

```glimmer-ts title="paths.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { ChevronRight, LoaderCircle } from "lucide"
import { Tree, treeFromPaths } from "ember-ui-sdk/tree"
import { icon } from "./icon"
import { useLog } from "./log"

const paths = [
  "src/index.ts",
  "src/lib/format.ts",
  "src/lib/parse.ts",
  "src/routes/home.tsx",
  "src/routes/about.tsx",
  "tests/",
  "package.json",
  "tsconfig.json",
]

type Node = {
  value: string
  label: string
  children?: Node[]
}

class Nodes extends Component<{
  Args: { parts: Record<string, unknown>; items: Node[] }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} as |i|>
        <i.Label as |l|>
          {{#if item.children}}
            <i.Indicator>{{icon ChevronRight}}</i.Indicator>
          {{/if}}
          <span>{{item.label}}</span>
          {{#if l.state.pending}}
            {{icon LoaderCircle}}
          {{/if}}
        </i.Label>
        {{#if item.children}}
          <i.Group as |g|>
            <Nodes @parts={{g}} @items={{item.children}} />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class Paths extends Component {
  log = useLog(this)
  items = treeFromPaths(paths)
  files = new Set(paths.filter((path) => !path.endsWith("/")))
  paths = paths

  onAction = async (value: string) => {
    if (!this.files.has(value)) {
      return
    }
    await new Promise((resolve) => setTimeout(resolve, 600))
    this.log(`Opened ${value}`)
  }

  <template>
    <Tree
      aria-label="Project"
      @paths={{this.paths}}
      @defaultExpanded={{array "src"}}
      @defaultValue="src/index.ts"
      @activation="automatic"
      @onAction={{this.onAction}}
      as |t|
    >
      <Nodes @parts={{t}} @items={{this.items}} />
    </Tree>
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

Arrow down to package.json, then press Enter. It shows a spinner while it opens, then the console logs Opened package.json.

## Selection

The default `@mode="single"` uses one string value or `null`. Use `"multiple"` for an array, or `"none"` when items should only navigate or perform actions.

`@activation="automatic"` selects while arrow keys move in single selection mode. Pressing a branch also expands or collapses it; set `@expandOnPress={{false}}` to leave expansion to the indicator and arrow keys.

## Multiple Selection

`@mode="multiple"` makes the value an array. Cmd-click or Ctrl-click toggles one item, Shift extends a range, and Cmd+A or Ctrl+A selects the visible items. This example sets `@expandOnPress={{false}}`, so clicking Inbox or Projects selects the folder without closing it.

```glimmer-ts title="multiple.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { ChevronRight } from "lucide"
import { Tree } from "ember-ui-sdk/tree"
import { icon } from "./icon"
import { useLog } from "./log"

const items = [
  {
    value: "inbox",
    label: "Inbox",
    children: [
      { value: "updates", label: "Updates" },
      { value: "forums", label: "Forums" },
      { value: "promotions", label: "Promotions" },
    ],
  },
  {
    value: "projects",
    label: "Projects",
    children: [
      { value: "website", label: "Website" },
      { value: "mobile", label: "Mobile app" },
    ],
  },
  { value: "archive", label: "Archive" },
  { value: "trash", label: "Trash" },
]

type Node = {
  value: string
  label: string
  children?: Node[]
}

class Nodes extends Component<{
  Args: { parts: Record<string, unknown>; items: Node[] }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} as |i|>
        <i.Label>
          {{#if item.children}}
            <i.Indicator>{{icon ChevronRight}}</i.Indicator>
          {{/if}}
          {{item.label}}
        </i.Label>
        {{#if item.children}}
          <i.Group as |g|>
            <Nodes @parts={{g}} @items={{item.children}} />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class Multiple extends Component {
  log = useLog(this)
  items = items

  onValueChange = (value: string[]) => {
    this.log(`${value.length} selected: ${value.join(", ")}`)
  }

  <template>
    <Tree
      aria-label="Folders"
      @items={{this.items}}
      @mode="multiple"
      @defaultValue={{array "updates" "website"}}
      @onValueChange={{this.onValueChange}}
      @expandOnPress={{false}}
      @defaultExpanded={{array "inbox" "projects"}}
      as |t|
    >
      <Nodes @parts={{t}} @items={{this.items}} />
    </Tree>
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

Cmd-click or Ctrl-click Archive to add it to the selection. Shift-click or Shift+Arrow extends a range, and the console logs what's selected.

## Checkboxes

Add `@checkable={{true}}` and `t.Checkbox` for a checked state separate from selection. Space checks the focused item. Checking a branch checks its descendants, and a partly checked branch reports a mixed state.

`@checkStrategy` chooses what the `checked` array reports:

| Strategy        | Reported Values                          |
| --------------- | ---------------------------------------- |
| `"leaf"`        | Checked leaves. This is the default.     |
| `"trunk"`       | The outermost fully checked items.       |
| `"branch"`      | Every fully checked item.                |
| `"independent"` | Each item on its own, without cascading. |

```glimmer-ts title="checkboxes.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { ChevronRight } from "lucide"
import { Tree } from "ember-ui-sdk/tree"
import { icon } from "./icon"
import { useLog } from "./log"

const items = [
  {
    value: "frontend",
    label: "Frontend",
    children: [
      { value: "react", label: "React" },
      { value: "vue", label: "Vue" },
      { value: "svelte", label: "Svelte" },
    ],
  },
  {
    value: "backend",
    label: "Backend",
    children: [
      { value: "node", label: "Node" },
      {
        value: "databases",
        label: "Databases",
        children: [
          { value: "postgres", label: "Postgres" },
          { value: "sqlite", label: "SQLite" },
        ],
      },
    ],
  },
]

type Node = {
  value: string
  label: string
  children?: Node[]
}

class Nodes extends Component<{
  Args: { parts: Record<string, unknown>; items: Node[] }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} as |i|>
        <i.Label>
          {{#if item.children}}
            <i.Indicator>{{icon ChevronRight}}</i.Indicator>
          {{/if}}
          <i.Checkbox />
          {{item.label}}
        </i.Label>
        {{#if item.children}}
          <i.Group as |g|>
            <Nodes @parts={{g}} @items={{item.children}} />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class Checkboxes extends Component {
  log = useLog(this)
  items = items

  onCheckedChange = (checked: string[]) => {
    this.log(`Checked ${checked.join(", ") || "nothing"}`)
  }

  <template>
    <Tree
      aria-label="Stack"
      @items={{this.items}}
      @checkable={{true}}
      @mode="none"
      @checkStrategy="trunk"
      @defaultChecked={{array "react" "postgres"}}
      @onCheckedChange={{this.onCheckedChange}}
      @defaultExpanded={{array "frontend" "backend" "databases"}}
      as |t|
    >
      <Nodes @parts={{t}} @items={{this.items}} />
    </Tree>
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

Press Space on Vue, then on Frontend. Frontend is mixed while only some of its items are checked, and the console logs the trunk strategy's values.

## Links

Set `@mode="none"` for a navigation tree, then render labels as links. `@current` identifies the current page with `aria-current="page"`, expands its ancestors, and gives it the initial Tab stop. Update it when your route changes.

```glimmer-ts title="links.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronRight } from "lucide"
import { Tree } from "ember-ui-sdk/tree"
import { icon } from "./icon"

const pages = [
  {
    value: "getting-started",
    label: "Getting started",
    children: [
      { value: "introduction", label: "Introduction", href: "#introduction" },
      { value: "installation", label: "Installation", href: "#installation" },
    ],
  },
  {
    value: "components",
    label: "Components",
    children: [
      { value: "accordion", label: "Accordion", href: "#accordion" },
      { value: "dialog", label: "Dialog", href: "#dialog" },
      { value: "tree", label: "Tree", href: "#tree" },
    ],
  },
  { value: "changelog", label: "Changelog", href: "#changelog" },
]

const links = new Set(
  pages
    .flatMap((page) => [page, ...(page.children ?? [])])
    .filter((page) => page.href)
    .map((page) => page.value)
)

type Node = {
  value: string
  label: string
  children?: Node[]
  href?: string
}

class Nodes extends Component<{
  Args: { parts: Record<string, unknown>; items: Node[] }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} as |i|>
        {{#if item.href}}
          <i.Label @render={{true}} as |l|>
            <a href={{item.href}} {{l.part}}>{{item.label}}</a>
          </i.Label>
        {{else}}
          <i.Label>
            {{#if item.children}}
              <i.Indicator>{{icon ChevronRight}}</i.Indicator>
            {{/if}}
            {{item.label}}
          </i.Label>
        {{/if}}
        {{#if item.children}}
          <i.Group as |g|>
            <Nodes @parts={{g}} @items={{item.children}} />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class Links extends Component {
  pages = pages
  @tracked current = "tree"

  onAction = (value: string, { event }: { event?: Event }) => {
    if (!links.has(value)) {
      return
    }
    event?.preventDefault()
    this.current = value
  }

  <template>
    <Tree
      aria-label="Docs"
      @items={{this.pages}}
      @mode="none"
      @current={{this.current}}
      @onAction={{this.onAction}}
      as |t|
    >
      <Nodes @parts={{t}} @items={{this.pages}} />
    </Tree>
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

Choose Dialog. The current-page marker moves to it, and you stay on this docs page.

## Disabled

Disabled items can't be selected, checked, expanded, or run. They stay focusable so screen readers can find them. Set `@focusableWhenDisabled={{false}}` to skip them, or `@disabled={{true}}` on the root to disable the whole tree. A disabled `<fieldset>` around the tree disables it too.

```glimmer-ts title="disabled.gts"
import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { tracked } from "@glimmer/tracking"
import { ChevronRight } from "lucide"
import { Switch } from "ember-ui-sdk/switch"
import { Tree } from "ember-ui-sdk/tree"
import { icon } from "./icon"

const items = [
  {
    value: "plans",
    label: "Plans",
    children: [
      { value: "free", label: "Free" },
      { value: "pro", label: "Pro" },
      { value: "enterprise", label: "Enterprise", disabled: true },
    ],
  },
  {
    value: "legacy",
    label: "Legacy plans",
    disabled: true,
    children: [{ value: "starter", label: "Starter" }],
  },
  { value: "custom", label: "Custom" },
]

type Node = {
  value: string
  label: string
  children?: Node[]
  disabled?: boolean
}

class Nodes extends Component<{
  Args: { parts: Record<string, unknown>; items: Node[] }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} @disabled={{item.disabled}} as |i|>
        <i.Label>
          {{#if item.children}}
            <i.Indicator>{{icon ChevronRight}}</i.Indicator>
          {{/if}}
          {{item.label}}
        </i.Label>
        {{#if item.children}}
          <i.Group as |g|>
            <Nodes @parts={{g}} @items={{item.children}} />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class Disabled extends Component {
  @tracked focusable = true
  items = items

  onFocusableChange = (next: boolean) => {
    this.focusable = next
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <label data-slot="label">
          <Switch @checked={{this.focusable}} @onCheckedChange={{this.onFocusableChange}} as |s|>
            <s.Thumb />
          </Switch>
          Focusable when disabled
        </label>
      </div>
      <Tree
        aria-label="Plans"
        @items={{this.items}}
        @defaultExpanded={{array "plans"}}
        @focusableWhenDisabled={{this.focusable}}
        as |t|
      >
        <Nodes @parts={{t}} @items={{this.items}} />
      </Tree>
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

Arrow through Enterprise while Focusable when disabled is on. Turn it off and the same arrow keys skip disabled items.

## Loading Children

Mark an item as a `@branch` before its children exist. `@loadChildren` runs the first time that branch expands while empty. Load and render its children, then let the promise resolve; the tree expands the branch once they are ready.

Use the supplied `signal` to cancel a request. Trying to expand the branch again while it loads aborts it. A rejection sets `data-failed`, and the next attempt retries. `@announcement` lets you customize loading and failure messages.

```glimmer-ts title="lazy.gts"
import Component from "@glimmer/component"
import { get } from "@ember/helper"
import { tracked } from "@glimmer/tracking"
import { ChevronRight, LoaderCircle, RotateCw } from "lucide"
import { Tree } from "ember-ui-sdk/tree"
import { icon } from "./icon"

const top = [
  { value: "users", label: "users", branch: true },
  { value: "orders", label: "orders", branch: true },
  { value: "archive", label: "archive", branch: true },
]

const announcement = ({ type, label }: { type: string; label: string }) =>
  (
    ({
      expanded: "Expanded",
      collapsed: "Collapsed",
      loading: `Loading ${label}`,
      "load-failed": `${label} didn't load. Try again.`,
    }) as Record<string, string>
  )[type]

type Node = { value: string; label: string; branch?: boolean }

class Nodes extends Component<{
  Args: {
    parts: Record<string, unknown>
    items: Node[]
    loaded: Record<string, Node[]>
  }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} @branch={{item.branch}} as |i|>
        <i.Label>
          {{#if item.branch}}
            <i.Indicator as |s|>
              {{#if s.state.loading}}
                {{icon LoaderCircle}}
              {{else if s.state.failed}}
                {{icon RotateCw}}
              {{else}}
                {{icon ChevronRight}}
              {{/if}}
            </i.Indicator>
          {{/if}}
          {{item.label}}
        </i.Label>
        {{#let (get @loaded item.value) as |children|}}
          {{#if children}}
            <i.Group as |g|>
              <Nodes @parts={{g}} @items={{children}} @loaded={{@loaded}} />
            </i.Group>
          {{/if}}
        {{/let}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class Lazy extends Component {
  archiveAsked = false
  top = top
  @tracked loaded: Record<string, Node[]> = {}

  fetchChildren = async (value: string, signal: AbortSignal) => {
    await new Promise((resolve, reject) => {
      const timer = setTimeout(resolve, 800)
      signal.addEventListener(
        "abort",
        () => (clearTimeout(timer), reject(signal.reason))
      )
    })
    if (value === "archive" && !this.archiveAsked) {
      this.archiveAsked = true
      throw new Error("Network error")
    }
    return Array.from({ length: 3 }, (_, index) => ({
      value: `${value}/${index + 1}`,
      label: `${value.slice(0, -1)}_${index + 1}.json`,
    }))
  }

  loadChildren = async (value: string, { signal }: { signal: AbortSignal }) => {
    const children = await this.fetchChildren(value, signal)
    this.loaded = { ...this.loaded, [value]: children }
  }

  announcement = announcement

  <template>
    <Tree
      aria-label="Database"
      @loadChildren={{this.loadChildren}}
      @announcement={{this.announcement}}
      as |t|
    >
      <Nodes @parts={{t}} @items={{this.top}} @loaded={{this.loaded}} />
    </Tree>
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

Expand users to load its files. Archive fails on its first attempt and shows a retry icon; expand it again to load it.

## Virtualized

Pass the full `@items` hierarchy and use `visibleTreeRows(items, expanded)` to flatten the open branches. Render the nearby rows with their position; the tree supplies the correct ARIA hierarchy even though the DOM is flat.

`@onHighlight` reports the focused item's index among visible rows. Use it to scroll before mounting a row that is outside the rendered range. Every item sets `--tree-level`, so the stylesheet indents the flat rows by their level.

```glimmer-ts title="virtualized.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { htmlSafe } from "@ember/template"
import { tracked } from "@glimmer/tracking"
import { ChevronRight } from "lucide"
import { Tree, visibleTreeRows } from "ember-ui-sdk/tree"
import { icon } from "./icon"

const items = Array.from({ length: 100 }, (_, folder) => ({
  value: `folder-${folder + 1}`,
  label: `Folder ${folder + 1}`,
  children: Array.from({ length: 100 }, (_, file) => ({
    value: `folder-${folder + 1}/file-${file + 1}`,
    label: `File ${file + 1}.txt`,
  })),
}))

const row = 32
const height = 288

export default class Virtualized extends Component {
  items = items
  @tracked scrollTop = 0
  @tracked expanded = ["folder-1"]

  get rows() {
    return visibleTreeRows(this.items, this.expanded)
  }

  get start() {
    return Math.max(0, Math.floor(this.scrollTop / row) - 4)
  }

  get end() {
    return Math.min(
      this.rows.length,
      Math.ceil((this.scrollTop + height) / row) + 4
    )
  }

  get visibleRows() {
    return this.rows.slice(this.start, this.end)
  }

  get treeStyle() {
    return htmlSafe(`height: ${this.rows.length * row}px`)
  }

  topOf = (index: number) => htmlSafe(`top: ${index * row}px`)

  scrolled = (event: Event) => {
    this.scrollTop = (event.currentTarget as HTMLDivElement).scrollTop
  }

  onExpandedChange = (next: string[]) => {
    this.expanded = next
  }

  onHighlight = (_value: string, { index }: { index: number }) => {
    const el = document.querySelector<HTMLDivElement>("#virtualized-scroller")
    if (!el) {
      return
    }
    const top = index * row
    if (top < el.scrollTop) {
      el.scrollTop = top
    } else if (top + row > el.scrollTop + el.clientHeight - 10) {
      el.scrollTop = top + row - el.clientHeight + 10
    }
    this.scrollTop = el.scrollTop
  }

  <template>
    <div id="virtualized-scroller" data-slot="scroll" {{on "scroll" this.scrolled}}>
      <Tree
        aria-label="Archive"
        @items={{this.items}}
        @expanded={{this.expanded}}
        @onExpandedChange={{this.onExpandedChange}}
        @onHighlight={{this.onHighlight}}
        style={{this.treeStyle}}
        as |t|
      >
        {{#each this.visibleRows key="item.value" as |entry|}}
          <t.Item @value={{entry.item.value}} style={{this.topOf entry.index}} as |i|>
            <i.Label>
              {{#if entry.item.children}}
                <i.Indicator>{{icon ChevronRight}}</i.Indicator>
              {{/if}}
              {{entry.item.label}}
            </i.Label>
          </t.Item>
        {{/each}}
      </Tree>
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

Expand folders or press End to focus Folder 100. The tree has 10,100 items, but only nearby rows render.

## Find in Page

`@hiddenUntilFound={{true}}` keeps collapsed groups in the DOM with `hidden="until-found"`. In browsers that support it, Find in Page can match a hidden item and open its ancestors. Use `@keepMounted={{true}}` when you only need collapsed content to stay mounted, without browser search.

```glimmer-ts title="find-in-page.gts"
import Component from "@glimmer/component"
import { ChevronRight } from "lucide"
import { Tree } from "ember-ui-sdk/tree"
import { icon } from "./icon"

const items = [
  {
    value: "planets",
    label: "Planets",
    children: [
      { value: "mercury", label: "Mercury" },
      { value: "venus", label: "Venus" },
      {
        value: "earth",
        label: "Earth",
        children: [{ value: "moon", label: "The Moon" }],
      },
      {
        value: "mars",
        label: "Mars",
        children: [
          { value: "phobos", label: "Phobos" },
          { value: "deimos", label: "Deimos" },
        ],
      },
    ],
  },
  {
    value: "dwarf-planets",
    label: "Dwarf planets",
    children: [
      { value: "ceres", label: "Ceres" },
      {
        value: "pluto",
        label: "Pluto",
        children: [{ value: "charon", label: "Charon" }],
      },
    ],
  },
]

type Node = {
  value: string
  label: string
  children?: Node[]
}

class Nodes extends Component<{
  Args: { parts: Record<string, unknown>; items: Node[] }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} as |i|>
        <i.Label>
          {{#if item.children}}
            <i.Indicator>{{icon ChevronRight}}</i.Indicator>
          {{/if}}
          {{item.label}}
        </i.Label>
        {{#if item.children}}
          <i.Group as |g|>
            <Nodes @parts={{g}} @items={{item.children}} />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class FindInPage extends Component {
  items = items

  <template>
    <Tree aria-label="Solar system" @items={{this.items}} @hiddenUntilFound={{true}} as |t|>
      <Nodes @parts={{t}} @items={{this.items}} />
    </Tree>
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

Use your browser's Find command to look for Phobos, a moon of Mars. The matching branches open to reveal it.

## Animation

A group exposes its measured height as `--tree-group-height`. Transition between that height and zero from `data-starting-style` and `data-ending-style`:

```css
[data-slot="tree-group"] {
  height: var(--tree-group-height);
  overflow: hidden;
  transition: height 150ms ease-out;

  &:is([data-starting-style], [data-ending-style]) {
    height: 0;
  }
}
```

The group stays mounted until its closing animation ends. Groups open on the first render, or revealed by Find in Page, don't animate.

## Controlled

Selection, expanded branches, and checkboxes are independent:

| Argument    | Shape                                          | Change callback     |
| ----------- | ---------------------------------------------- | ------------------- |
| `@value`    | A string or `null`; an array in multiple mode. | `@onValueChange`    |
| `@expanded` | An array of branch values.                     | `@onExpandedChange` |
| `@checked`  | An array shaped by the check strategy.         | `@onCheckedChange`  |

Pass each with its change callback to control it, or use `@defaultValue`, `@defaultExpanded`, and `@defaultChecked` for starting state. Call `details.cancel()` in a change callback to reject a change.

## Controller

A `createTreeController()` instance can expand or collapse branches, change selection and checkboxes, or focus an item. `reveal(value)` opens an item's ancestors, scrolls it into view, and focuses it. Supply the hierarchy through `@items`, as this example does, or keep collapsed groups mounted so their descendants are known.

```glimmer-ts title="controller.gts"
import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { ChevronRight } from "lucide"
import { createTreeController, Tree } from "ember-ui-sdk/tree"
import { icon } from "./icon"

const sections = [
  {
    value: "account",
    label: "Account",
    children: [
      { value: "profile", label: "Profile" },
      {
        value: "security",
        label: "Security",
        children: [
          { value: "password", label: "Password" },
          { value: "two-factor", label: "Two-factor authentication" },
        ],
      },
    ],
  },
  {
    value: "workspace",
    label: "Workspace",
    children: [
      { value: "members", label: "Members" },
      { value: "billing", label: "Billing" },
    ],
  },
]

type Node = {
  value: string
  label: string
  children?: Node[]
}

class Nodes extends Component<{
  Args: { parts: Record<string, unknown>; items: Node[] }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} as |i|>
        <i.Label>
          {{#if item.children}}
            <i.Indicator>{{icon ChevronRight}}</i.Indicator>
          {{/if}}
          {{item.label}}
        </i.Label>
        {{#if item.children}}
          <i.Group as |g|>
            <Nodes @parts={{g}} @items={{item.children}} />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class Controller extends Component {
  settings = createTreeController()
  sections = sections

  expandAll = () => {
    this.settings.expandAll()
  }

  collapseAll = () => {
    this.settings.collapseAll()
  }

  findTwoFactor = () => {
    this.settings.setValue("two-factor")
    this.settings.reveal("two-factor")
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.expandAll}}>Expand All</button>
        <button type="button" {{on "click" this.collapseAll}}>Collapse All</button>
        <button type="button" {{on "click" this.findTwoFactor}}>
          Find Two-Factor
        </button>
      </div>
      <Tree aria-label="Settings" @items={{this.sections}} @controller={{this.settings}} as |t|>
        <Nodes @parts={{t}} @items={{this.sections}} />
      </Tree>
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

Press Find Two-Factor to open Account and Security, then select and focus Two-factor authentication. Collapse All closes every branch.

## Custom Rendering

Pass `@render={{true}}` to any part to render it as your own element. The Links example renders `t.Label` as an anchor; a link in a label leaves the tab order to its item. The block of `t.Label` and `t.Indicator` also receives the item's state, which the File Paths and Loading Children examples use for their spinners. Parts and Composition covers prop merging and state-based rendering.

## Styling

Style each row through `t.Label`, which carries its item's `data-selected`, `data-expanded`, `data-branch`, `data-current`, `data-disabled`, `data-loading`, `data-failed` and `data-pending`. An item's own background would also cover its children. Focus stays on the item, so style a focused row as a label inside an item with `:focus-visible`. Turn the indicator with its `data-expanded`, and indent rows with `--tree-level` or padding on each group.

Each part has a `data-slot`, such as `tree-label`, and its state attributes are listed under [Data Attributes](#data-attributes).

### TreeItem
- `--tree-level`: The item's depth, 1 for a top-level item. Indent a flat tree with it.

### TreeGroup
- `--tree-group-height`: The group's content height in pixels while it animates, auto once expanded and 0px while collapsed.

## Data Attributes

### TreeItem
`[data-slot="tree-item"]`

- `data-level` (`1`, `2`): The item's depth, from 1 at the top level. Also in the `--tree-level` variable.
- `data-branch`: Present on a branch: an item with children, or with `branch` set.
- `data-expanded`: Present while a branch is expanded.
- `data-indeterminate`: Present while only some of a branch is checked, with `checkable`.
- `data-selected`: Present while the item is selected.
- `data-current`: Present on the item for the current page, from `current`.
- `data-checked`: Present while the item's checkbox is checked, with `checkable`.
- `data-disabled`: Present when the item, or the whole tree, is disabled.
- `data-unchecked`: Present while the item's checkbox is unchecked, with `checkable`.
- `data-loading`: Present while `loadChildren` loads the branch's children.
- `data-failed`: Present after the branch's children failed to load, until it loads again.
- `data-pending`: Present while the item's `onAction` Promise hasn't settled.

### TreeItemLabel
`[data-slot="tree-label"]`

- `data-level` (`1`, `2`): The item's depth, from 1 at the top level. Also in the `--tree-level` variable.
- `data-branch`: Present on a branch: an item with children, or with `branch` set.
- `data-expanded`: Present while a branch is expanded.
- `data-selected`: Present while the item is selected.
- `data-current`: Present on the item for the current page, from `current`.
- `data-disabled`: Present when the item, or the whole tree, is disabled.
- `data-loading`: Present while `loadChildren` loads the branch's children.
- `data-failed`: Present after the branch's children failed to load, until it loads again.
- `data-pending`: Present while the item's `onAction` Promise hasn't settled.

### TreeItemIndicator
`[data-slot="tree-indicator"]`

- `data-level` (`1`): The item's depth, from 1 at the top level. Also in the `--tree-level` variable.
- `data-branch`: Present on a branch: an item with children, or with `branch` set.
- `data-expanded`: Present while a branch is expanded.
- `data-loading`: Present while `loadChildren` loads the branch's children.
- `data-failed`: Present after the branch's children failed to load, until it loads again.
- `data-pending`: Present while the item's `onAction` Promise hasn't settled.

### TreeItemCheckbox
`[data-slot="tree-checkbox"]`

- `data-indeterminate`: Present while only some of a branch is checked, with `checkable`.
- `data-checked`: Present while the item's checkbox is checked, with `checkable`.
- `data-unchecked`: Present while the item's checkbox is unchecked, with `checkable`.

### TreeGroup
`[data-slot="tree-group"]`

- `data-open`: Present while the group's branch is expanded.
- `data-closed`: Present while the group's branch is collapsed, including while it animates out.

## API Reference

Pass the root's options as `@` arguments.

### Tree

- `items?` (`TreeItemData[]`): The items as data: each a `value`, a `label` and, for a branch, `children`. Renders them for you, and gives the tree its whole shape even where rows aren't rendered.
- `paths?` (`readonly string[]`): Items from file paths, like `["src/index.ts", "README.md"]`: each folder becomes a branch, folders first. A path ending in `/` is an empty folder.
- `mode?` (`Mode`): How many items can be selected.
- `value?` (`TreeValue<Mode>`): The selected value. Pass it to control the selection. `null` selects nothing, and with `mode: "multiple"` it's a list.
- `defaultValue?` (`TreeValue<Mode>`): The value selected at first, when uncontrolled.
- `onValueChange?` (`((value: TreeValue<Mode>, details: ChangeDetails<TreeValueChangeReason>) => void)`): Runs when the selection wants to change. `details.reason` says why, and `details.cancel()` stops it.
- `activation?` (`"automatic" | "manual"`): Whether moving focus with the keyboard selects, with one item selectable: `"automatic"` selects the focused item, `"manual"` waits for Enter, Space or a press.
- `expanded?` (`string[]`): The expanded branches' values. Pass it to control which branches are open.
- `defaultExpanded?` (`string[]`): The branches expanded at first, when uncontrolled. The ancestors of `current` are added.
- `onExpandedChange?` (`((expanded: string[], details: ChangeDetails<TreeExpandedChangeReason>) => void)`): Runs when branches want to expand or collapse. `details.reason` says why, and `details.cancel()` stops it.
- `expandOnPress?` (`boolean`): Whether pressing a branch's row expands or collapses it. Its indicator always does.
- `checkable?` (`boolean`): Gives every item a tri-state checkbox, kept apart from the selection. Checking a branch checks everything in it, and a branch shows mixed while only some of it is checked. Space checks the focused item.
- `checked?` (`string[]`): The checked items' values, as `checkStrategy` reports them. Pass it to control the checkboxes.
- `defaultChecked?` (`string[]`): The items checked at first, when uncontrolled. A branch stands for everything in it.
- `onCheckedChange?` (`((checked: string[], details: ChangeDetails<TreeCheckedChangeReason>) => void)`): Runs when checkboxes want to change. `details.reason` says why, and `details.cancel()` stops it.
- `checkStrategy?` (`TreeCheckStrategy`): Which items the checked value lists: `"leaf"` the checked leaves, `"trunk"` the outermost fully checked items, `"branch"` every fully checked item, and `"independent"` each item on its own, with no cascading.
- `onAction?` (`((value: string, details: TreeActionDetails) => unknown)`): Runs when an item is pressed or Enter is pressed on it, apart from selecting it, like opening a file. Return a Promise to mark the item pending until it settles.
- `pendingAnnouncement?` (`string`): What screen readers hear once an item's action has been pending for a second, so a slow action doesn't pass in silence. Set it in the page's language. An empty string says nothing.
- `loadChildren?` (`((value: string, details: { signal: AbortSignal; }) => void | Promise<unknown>)`): Loads a branch's children the first time it expands while it has none. The branch shows `data-loading` and expands once the Promise resolves; a rejection marks it `data-failed` and the next expand tries again. Expanding it again while loading cancels through `signal`.
- `current?` (`string | null`): The value of the item for the current page. It gets `aria-current="page"`, takes the tab stop first, and its ancestors expand, at first and whenever it changes.
- `onHighlight?` (`((value: string, details: ListHighlightDetails) => void)`): Runs when the keyboard moves focus to an item, with its row among the items that show, from 0. A virtualized list scrolls that row into view here, so an item it hasn't rendered can take focus once it does.
- `disabled?` (`boolean`): Disables every item. Items stay focusable unless `focusableWhenDisabled` is false.
- `focusableWhenDisabled?` (`boolean`): Whether disabled items take focus, so a screen reader still finds them.
- `keepMounted?` (`boolean`): Whether collapsed branches keep their groups in the page, hidden.
- `hiddenUntilFound?` (`boolean`): Keeps collapsed groups in the page as `hidden="until-found"`, so the browser's find in page can match their text and expand them.
- `announcement?` (`((change: TreeAnnouncement) => string | null | undefined)`): What screen readers hear when a branch expands, collapses, starts loading or fails to load. Return null for nothing. Expanding and collapsing are announced on Apple platforms only, where VoiceOver doesn't read the change.
- `controller?` (`object`): Drives the tree from anywhere. Create one with `createTreeController()`.
- `debug?` (`boolean`): Logs every state change with its reason to the console, in development builds.

### TreeItem

- `value` (`string`): Identifies the item, unique in the tree. Passed to `@onAction`, and listed by the value, `expanded` and `checked`.
- `branch?` (`boolean`): Whether it's a branch. Adapters set it when it has a group; set it yourself for a branch whose children load later.
- `disabled?` (`boolean`): Stops it from being selected, checked, expanded or run. It stays focusable unless `focusableWhenDisabled` is false.
- `label?` (`string`): The text typeahead matches, when its label isn't plain text.

### TreeGroup

- `keepMounted?` (`boolean`): Whether the group stays in the page, hidden, while collapsed. Overrides the tree's.
- `hiddenUntilFound?` (`boolean`): Whether the group stays findable with `hidden="until-found"` while collapsed. Overrides the tree's.

### Items as Data

Each item in `@items`:

- `value` (`string`): Identifies the item. Unique in the tree.
- `label` (`string`): What it shows, and what typeahead matches.
- `children?` (`TreeItemData[]`): Its children. Leave it out for a leaf. An empty array is a branch with no children, or one whose children load when it opens.
- `disabled?` (`boolean`): Whether it can't be selected, checked or activated. It can still take focus.
- `href?` (`string`): Makes the item a link to this address.

Each row `visibleTreeRows(items, expanded)` returns, for a flat list:

- `item` (`TreeItemData`): The object from your data this row shows, the same one you passed in, children included.
- `parent` (`string | null`): The value of the item it's nested in, or `null` at the top level.
- `level` (`number`): Its depth, 1 at the top level.
- `index` (`number`): Its place among the rows that show, from 0, for a virtualized list.

### State

What `@render` parts and their blocks receive, per part.

`Tree`:

- `mode` (`TreeMode`): How many items can be selected.
- `checkable` (`boolean`): Whether items have checkboxes.
- `disabled` (`boolean`): Whether the whole tree is disabled, by its `disabled` option or a disabled fieldset around it.

`TreeItem`, and its `TreeItemLabel`, `TreeItemIndicator` and `TreeItemCheckbox`:

- `expanded` (`boolean`): Whether it's a branch that's expanded.
- `selected` (`boolean`): Whether its value is in the tree's value. Separate from `checked`, which its checkbox sets.
- `checked` (`TreeCheckedState`): Its checkbox: checked, unchecked or `"indeterminate"`. False without `checkable`.
- `disabled` (`boolean`): Whether it can't be selected, checked, expanded or run.
- `branch` (`boolean`): Whether it has children, or can load them.
- `level` (`number`): Its depth, 1 at the top level.
- `current` (`boolean`): Whether it's the current page's item.
- `loading` (`boolean`): Whether its children are loading.
- `failed` (`boolean`): Whether loading its children failed.
- `pending` (`boolean`): Whether its `onAction` is still running.

`TreeGroup`:

- `expanded` (`boolean`): Whether its branch is expanded.
- `level` (`number`): The depth of the items in it.

### Reasons

Why branches expanded or collapsed:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `trigger-press` (`MouseEvent | KeyboardEvent | TouchEvent`): Click, tap, Enter or Space on the part that opens, closes or toggles. Arrow keys that open a menu or submenu count too. A tap on a combobox's input that opens a sheet reports its `touchend`.
- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `find-in-page` (`Event`): The browser's find in page matched hidden content.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

Why the selection changed:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `list-navigation` (`KeyboardEvent`): Arrow, Home or End keys moved the selection, typing picked an item, or Ctrl or ⌘ with A selected every item of a listbox.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

And why the checkboxes changed:

- `item-press` (`MouseEvent | KeyboardEvent`): A member of a collection was chosen: a menu item, a tab, a radio or a checkbox item.
- `imperative` (`none`): A controller or `api` call, or a property set on a web component.

### Controller

Create one with `createTreeController()` and pass it as `@controller`.

- `getExpanded()` (`() => string[]`): The values of the expanded branches.
- `setExpanded(expanded, options?)` (`(expanded: string[], options?: TreeChangeOptions<TreeExpandedChangeReason> | undefined) => boolean`): Expands exactly these branches. Returns false when canceled.
- `isExpanded(value)` (`(value: string) => boolean`): Whether a branch is expanded.
- `expand(value, options?)` (`(value: string, options?: TreeChangeOptions<TreeExpandedChangeReason> | undefined) => boolean`): Expands a branch, loading its children first with `loadChildren` when it has none.
- `collapse(value, options?)` (`(value: string, options?: TreeChangeOptions<TreeExpandedChangeReason> | undefined) => boolean`): Collapses a branch. Focus inside it moves to the branch.
- `toggle(value, options?)` (`(value: string, options?: TreeChangeOptions<TreeExpandedChangeReason> | undefined) => boolean`): Expands a collapsed branch, or collapses an expanded one.
- `expandAll(options?)` (`(options?: TreeChangeOptions<TreeExpandedChangeReason> | undefined) => boolean`): Expands every branch, and every branch that renders inside one later.
- `collapseAll(options?)` (`(options?: TreeChangeOptions<TreeExpandedChangeReason> | undefined) => boolean`): Collapses every branch.
- `getValue()` (`() => string | string[] | null`): The selected value: a value or `null`, or a list with `mode: "multiple"`.
- `setValue(value, options?)` (`(value: string | string[] | null, options?: TreeChangeOptions<TreeValueChangeReason> | undefined) => boolean`): Selects these items.
- `getChecked()` (`() => string[]`): The checked value, as `checkStrategy` reports it.
- `setChecked(checked, options?)` (`(checked: string[], options?: TreeChangeOptions<TreeCheckedChangeReason> | undefined) => boolean`): Sets the checked value.
- `checkedState(value)` (`(value: string) => TreeCheckedState`): Whether an item's checkbox is checked, unchecked or `"indeterminate"`.
- `reveal(value)` (`(value: string) => void`): Expands an item's ancestors, scrolls it into view and focuses it.
- `focus(value?)` (`(value?: string | undefined) => void`): Focuses an item, or the item with the tab stop.

## Accessibility

The tree follows the [WAI-ARIA tree view pattern](https://www.w3.org/WAI/ARIA/apg/patterns/treeview/). Items have the `treeitem` role with `aria-level`, `aria-expanded` on branches, and `aria-checked` when the tree is checkable.

### Keyboard

The tree has one tab stop. Tab enters at the current page, the selected item, or the first item, then returns to the item focused last.

| Key                         | Action                                                 |
| --------------------------- | ------------------------------------------------------ |
| Down / Up Arrow             | Focus the next or previous visible item.               |
| Right Arrow                 | Expand a branch, or enter its first child.             |
| Left Arrow                  | Collapse a branch, or focus its parent.                |
| Home / End                  | Focus the first or last visible item.                  |
| Alt+Right / Alt+Left Arrow  | Expand or collapse a branch and its descendants.       |
| `*`                         | Expand sibling branches.                               |
| Enter                       | Select and run the item's action, or follow its link.  |
| Space                       | Check the item when checkable, otherwise select it.    |
| Shift+Down / Shift+Up Arrow | Extend a multiple selection.                           |
| Cmd+A / Ctrl+A              | Select visible items in multiple selection mode.       |
| Typing                      | Focus the next item whose label starts with that text. |

Option is Alt on a Mac. In right-to-left text, Left and Right swap.

### Tested Behavior

Every line below is an automated test.

**Expanding and collapsing**

- Branches start collapsed, and only top-level items show.
- Clicking a branch expands it and shows its children.
- Clicking the indicator expands without selecting.
- A change can be canceled.
- A default can expand nested branches.
- A controller expands and collapses everything.
- Reveal expands an item's ancestors and focuses it.

**Keyboard**

- Tab reaches the tree once, on the first item.
- Down and Up move between the items that show.
- Right expands a branch, then moves to its first child.
- Right on a leaf does nothing.
- Left collapses a branch, then moves to its parent.
- Home and End move to the first and last items that show.
- * expands every branch beside the focused item.
- Alt+Right expands a branch and everything in it.
- Typing moves to the next item that starts with the text.
- Enter selects the item and runs its action.
- A key on a nested item acts on that item only.

**Selection**

- Clicking an item selects it alone.
- The selected item takes the tab stop.
- Disabled items take focus but can't be selected.
- With multiple selection, Shift+Down extends and Ctrl+A selects everything.
- With automatic activation, moving focus selects.
- Without selection, items have no aria-selected.

**Checkboxes**

- Checking a branch checks everything in it.
- Space checks the focused item, and a disabled item keeps its check.
- Checking a leaf leaves the selection and the branch alone.

**Positions**

- Every item says its level and place among its siblings.
- The current page's item is marked.

Runs in React, Vue and web components.

Screen readers hear the same thing in each tested framework, recorded by a virtual screen reader:

- Announcements while using the tree with a keyboard.
- Expanding the focused item is announced on Apple platforms.
- Nothing is announced elsewhere, where screen readers read the change.

Runs in React, Vue and web components.
