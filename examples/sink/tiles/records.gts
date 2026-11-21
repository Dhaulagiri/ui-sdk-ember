import { capabilities, on, setModifierManager } from "@ember/modifier"
import { array, fn } from "@ember/helper"
import { guidFor } from "@ember/object/internals"
import { htmlSafe } from "@ember/template"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ModifierLike } from "@glint/template"
import { createInputHistory, isComposing } from "@ui-sdk/core"
import {
  createHistory,
  describeEntry,
  stageChanges,
  type HistoryEntry,
} from "@ui-sdk/core/history"
import {
  ChevronLeft,
  ChevronRight,
  RotateCcw,
  RotateCw,
  Sparkles,
} from "lucide"
import { createAgent } from "ember-ui-sdk/agent"
import { elementOf, observe, type ObservedChange } from "ember-ui-sdk/observe"
import { Pagination, paginationRange } from "ember-ui-sdk/pagination"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"
import { Slider } from "ember-ui-sdk/slider"
import { Switch } from "ember-ui-sdk/switch"
import {
  createTimelineController,
  Timeline,
  type TimelineStatus,
} from "ember-ui-sdk/timeline"
import {
  visibleWaterfallRows,
  Waterfall,
  type WaterfallData,
} from "ember-ui-sdk/waterfall"
import "../../../vendor/ui/apps/docs/app/sink/tiles/records.css"
import { icon } from "../icon.ts"
import type { Tile } from "../types.ts"

/** Runs `callback(el)` once the element is in the page, and its returned function when it leaves. */
const onInsert = setModifierManager(
  () => ({
    capabilities: capabilities("3.22", { disableAutoTracking: true }),
    createModifier: () => ({ cleanup: undefined as void | (() => void) }),
    installModifier: (
      modifier: { cleanup: void | (() => void) },
      el: Element,
      { positional }: { positional: unknown[] }
    ) => {
      // Tracked state the callback sets would otherwise change mid-render.
      void Promise.resolve().then(() => {
        modifier.cleanup = (
          positional[0] as (el: Element) => void | (() => void)
        )(el)
      })
    },
    updateModifier: () => {},
    destroyModifier: (modifier: { cleanup: void | (() => void) }) =>
      modifier.cleanup?.(),
  }),
  function () {} as unknown as ModifierLike<{
    Element: Element
    Args: { Positional: [(el: any) => void | (() => void)] }
  }>
)

const is = (a: unknown, b: unknown) => a === b
const flag = (value: unknown) => (value ? "" : undefined)

/* Release history */

const releases: {
  version: string
  dateTime: string
  date: string
  name: string
  summary: string
  commits: number
  status: TimelineStatus
}[] = [
  {
    version: "3.0",
    dateTime: "2026-03-04",
    date: "Mar 4",
    name: "The rewrite",
    summary: "A new sync engine and a sidebar you can collapse.",
    commits: 1204,
    status: "complete",
  },
  {
    version: "3.1",
    dateTime: "2026-04-15",
    date: "Apr 15",
    name: "Shared links",
    summary: "Links remember the folder they were opened from.",
    commits: 318,
    status: "complete",
  },
  {
    version: "3.2",
    dateTime: "2026-06-02",
    date: "Jun 2",
    name: "Search in files",
    summary: "Search matches what's inside a file, not only its name.",
    commits: 402,
    status: "complete",
  },
  {
    version: "3.3",
    dateTime: "2026-07-21",
    date: "Jul 21",
    name: "Resumable uploads",
    summary: "Uploads pick up where they stopped after the network drops.",
    commits: 276,
    status: "complete",
  },
  {
    version: "3.4",
    dateTime: "2026-09-08",
    date: "Sep 8",
    name: "Dark mode",
    summary: "Follows your system, with sharper avatars and icons.",
    commits: 189,
    status: "complete",
  },
  {
    version: "3.5",
    dateTime: "2026-11-12",
    date: "Nov 12",
    name: "Offline drafts",
    summary: "Write without a connection. Drafts sync when you're back.",
    commits: 441,
    status: "current",
  },
  {
    version: "3.6",
    dateTime: "2027-01-20",
    date: "Jan 20",
    name: "Comments",
    summary: "Threads on any line, with mentions and email replies.",
    commits: 97,
    status: "upcoming",
  },
]

const latestRelease = "3.5"

const statusLabel = (status: TimelineStatus) =>
  status === "current"
    ? "Latest"
    : status === "upcoming"
      ? "Planned"
      : "Shipped"

const commitCount = (commits: number) => commits.toLocaleString("en-US")

class ReleaseHistory extends Component {
  controller = createTimelineController()
  latest = latestRelease
  releases = releases
  @tracked selected = latestRelease

  get release() {
    return (
      releases.find((candidate) => candidate.version === this.selected) ??
      releases[0]
    )
  }

  get current() {
    return [this.release]
  }

  get atLatest() {
    return this.selected === latestRelease
  }

  jumpToLatest = () => this.controller.focus(latestRelease)

  select = (version: string) => {
    this.selected = version
  }

  scrub = (event: PointerEvent) => {
    if (!event.buttons) {
      return
    }
    const item = document
      .elementFromPoint(event.clientX, event.clientY)
      ?.closest<HTMLElement>('[data-slot="timeline-item"]')
    if (item && item !== document.activeElement) {
      item.focus({ preventScroll: true })
    }
  }

  <template>
    <div class="rc-releases">
      {{#each this.current key="version" as |release|}}
        <div class="rc-release" data-status={{release.status}}>
          <div class="rc-release-head">
            <span class="rc-release-version">v{{release.version}}</span>
            <span class="rc-release-status">{{statusLabel
                release.status
              }}</span>
            <button
              type="button"
              class="b-btn rc-release-latest"
              data-variant="ghost"
              hidden={{this.atLatest}}
              {{on "click" this.jumpToLatest}}
            >
              Jump to latest
            </button>
          </div>
          <p class="rc-release-name">{{release.name}}</p>
          <p class="rc-release-summary">{{release.summary}}</p>
          <p class="rc-release-meta">
            {{release.date}}
            ·
            {{commitCount release.commits}}
            commits
          </p>
        </div>
      {{/each}}
      <Timeline
        @orientation="horizontal"
        @loop={{false}}
        @controller={{this.controller}}
        aria-label="Releases"
        class="rc-timeline"
        {{on "pointerdown" this.scrub}}
        {{on "pointermove" this.scrub}}
        as |t|
      >
        {{#each this.releases key="version" as |item|}}
          <t.Item
            @value={{item.version}}
            @status={{item.status}}
            class="rc-tl-item"
            data-selected={{flag (is item.version this.selected)}}
            {{on "focus" (fn this.select item.version)}}
            as |i|
          >
            <i.Marker class="rc-tl-marker" />
            <i.Connector class="rc-tl-connector" />
            <i.Title class="rc-tl-title">{{item.version}}</i.Title>
            <i.Time datetime={{item.dateTime}} class="rc-tl-time">{{item.date}}
            </i.Time>
          </t.Item>
        {{/each}}
      </Timeline>
    </div>
  </template>
}

/* Request waterfall */

const requests: WaterfallData = [
  { value: "document", label: "dashboard", start: 0, duration: 168 },
  { value: "styles", label: "app.css", start: 176, duration: 92 },
  {
    value: "script",
    label: "app.js",
    start: 180,
    duration: 386,
    children: [
      { value: "charts", label: "charts.js", start: 590, duration: 174 },
      { value: "table", label: "table.js", start: 598, duration: 122 },
    ],
  },
  { value: "font", label: "geist.woff2", start: 284, duration: 196 },
  {
    value: "projects",
    label: "api/projects",
    start: 612,
    duration: 248,
    children: [
      { value: "avatar-1", label: "ada.webp", start: 872, duration: 96 },
      { value: "avatar-2", label: "linus.webp", start: 878, duration: 132 },
    ],
  },
  { value: "usage", label: "api/usage", start: 620, duration: 412 },
  { value: "analytics", label: "insights.js", start: 1046, duration: 150 },
]

const requestInfo: Record<
  string,
  { type: string; size: string; status: number; initiator: string }
> = {
  document: { type: "doc", size: "14 kB", status: 200, initiator: "Other" },
  styles: { type: "css", size: "9 kB", status: 200, initiator: "dashboard" },
  script: { type: "js", size: "212 kB", status: 200, initiator: "dashboard" },
  charts: { type: "js", size: "88 kB", status: 200, initiator: "app.js" },
  table: { type: "js", size: "41 kB", status: 200, initiator: "app.js" },
  font: { type: "font", size: "48 kB", status: 200, initiator: "app.css" },
  projects: { type: "api", size: "3 kB", status: 200, initiator: "app.js" },
  "avatar-1": { type: "img", size: "6 kB", status: 200, initiator: "app.js" },
  "avatar-2": { type: "img", size: "7 kB", status: 304, initiator: "app.js" },
  usage: { type: "api", size: "1 kB", status: 200, initiator: "app.js" },
  analytics: { type: "js", size: "22 kB", status: 200, initiator: "app.js" },
}

const milliseconds = {
  style: "unit",
  unit: "millisecond",
  unitDisplay: "narrow",
} as const

const requestFilters = [
  { value: "all", label: "All" },
  { value: "js", label: "JS" },
  { value: "api", label: "Fetch" },
  { value: "img", label: "Img" },
]

const requestsOfType = (type: string) =>
  type === "all"
    ? requests
    : requests.flatMap((item) => {
        const children = item.children?.filter(
          (child) => requestInfo[child.value].type === type
        )
        const kept = requestInfo[item.value].type === type || children?.length
        return kept
          ? [{ ...item, children: children?.length ? children : undefined }]
          : []
      })

const labelOf = (value: string) =>
  requests
    .flatMap((item) => [item, ...(item.children ?? [])])
    .find((item) => item.value === value)?.label
const hasChildren = (value: string) =>
  !!requests.find((item) => item.value === value)?.children
const typeOf = (value: string) => requestInfo[value].type
const sizeOf = (value: string) => requestInfo[value].size

const barLabel = (
  request: { value: string },
  { start, duration }: { start: string; duration: string }
) => `${requestInfo[request.value].size}, starts at ${start}, takes ${duration}`

class RequestWaterfall extends Component {
  filters = requestFilters
  milliseconds = milliseconds
  barLabel = barLabel
  @tracked filter = "all"
  @tracked expanded: string[] = ["script", "projects"]
  @tracked selected: string | null = "usage"

  get shown() {
    return requestsOfType(this.filter)
  }

  get rows() {
    return visibleWaterfallRows(this.shown, this.expanded)
  }

  get values() {
    return this.rows.map((row) => row.item.value)
  }

  get chosen() {
    return this.rows.find((row) => row.item.value === this.selected)?.item
  }

  get info() {
    const chosen = this.chosen
    return chosen && requestInfo[chosen.value]
  }

  get count() {
    return this.shown.flatMap((item) => [item, ...(item.children ?? [])]).length
  }

  setFilter = (value: string | null) => {
    if (value) {
      this.filter = value
    }
  }
  setExpanded = (value: string[]) => {
    this.expanded = value
  }
  setSelected = (value: string | null) => {
    this.selected = value
  }

  <template>
    <div class="rc-network">
      <div class="rc-wf-toolbar">
        <span class="rc-wf-title">Network</span>
        <SegmentedControl
          aria-label="Request type"
          @value={{this.filter}}
          @onValueChange={{this.setFilter}}
          class="rc-seg"
          as |s|
        >
          <s.Indicator class="rc-seg-indicator" />
          {{#each this.filters key="value" as |option|}}
            <s.Item @value={{option.value}} class="rc-seg-item">
              {{option.label}}
            </s.Item>
          {{/each}}
        </SegmentedControl>
      </div>
      <Waterfall
        aria-label="Network requests"
        @items={{this.shown}}
        @range={{array 0 1200}}
        @expanded={{this.expanded}}
        @onExpandedChange={{this.setExpanded}}
        @value={{this.selected}}
        @onValueChange={{this.setSelected}}
        @format={{this.milliseconds}}
        @locale="en-US"
        @getBarLabel={{this.barLabel}}
        class="rc-wf"
        as |w|
      >
        <w.HeaderRow class="rc-wf-head">
          <w.ColumnHeader class="rc-wf-name">Name</w.ColumnHeader>
          <w.ColumnHeader class="rc-wf-size">Size</w.ColumnHeader>
          <w.ColumnHeader aria-label="Timeline" class="rc-wf-axis">
            <w.Axis @maxTicks={{5}} class="rc-wf-ticks" />
            <w.Mark
              @time={{572}}
              class="rc-wf-mark"
              data-kind="dcl"
            >DCL</w.Mark>
            <w.Mark
              @time={{1032}}
              class="rc-wf-mark"
              data-kind="load"
            >Load</w.Mark>
          </w.ColumnHeader>
        </w.HeaderRow>
        {{#each this.values key="@identity" as |value|}}
          <w.Row
            @value={{value}}
            class="rc-wf-row"
            data-type={{typeOf value}}
            as |r|
          >
            <r.Header class="rc-wf-name">
              {{#if (hasChildren value)}}
                <r.Indicator class="rc-wf-caret">{{icon ChevronRight 11}}
                </r.Indicator>
              {{/if}}
              <span class="rc-wf-type" aria-hidden="true"></span>
              <span class="rc-wf-label">{{labelOf value}}</span>
            </r.Header>
            <r.Cell class="rc-wf-size">{{sizeOf value}}</r.Cell>
            <r.Bar class="rc-wf-bar" />
          </w.Row>
        {{/each}}
      </Waterfall>
      <p class="rc-wf-detail" aria-live="polite">
        {{#if this.info}}
          <span class="rc-wf-detail-name">{{this.chosen.label}}</span>
          <span data-status={{this.info.status}}>{{this.info.status}}</span>
          <span>{{this.info.type}}</span>
          <span>{{this.chosen.duration}} ms</span>
          <span class="rc-wf-detail-from">from {{this.info.initiator}}</span>
        {{else}}
          <span>Select a request.</span>
        {{/if}}
      </p>
      <p class="rc-wf-summary">
        <span>{{this.count}} requests</span>
        <span data-kind="dcl">DOMContentLoaded 572 ms</span>
        <span data-kind="load">Load 1.03 s</span>
      </p>
    </div>
  </template>
}

/* Invoices */

const INVOICES = 1269
const PER_PAGE = 6
const PAGE_COUNT = Math.ceil(INVOICES / PER_PAGE)

const customers = [
  "Northwind",
  "Acme Corp",
  "Globex",
  "Initech",
  "Umbrella",
  "Hooli",
  "Stark & Co",
  "Wayne Ent.",
  "Soylent",
  "Tyrell",
  "Cyberdyne",
]

const invoiceStatuses = ["Paid", "Paid", "Paid", "Due", "Overdue"] as const

function invoicesOn(page: number) {
  const first = (page - 1) * PER_PAGE
  return Array.from(
    { length: Math.min(PER_PAGE, INVOICES - first) },
    (_, offset) => {
      const index = first + offset
      return {
        number: `INV-${String(24180 - index).padStart(5, "0")}`,
        customer: customers[(index * 7) % customers.length],
        amount: 120 + ((index * 937) % 4800),
        status: invoiceStatuses[(index * 3 + page) % invoiceStatuses.length],
      }
    }
  )
}

const currency = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
  maximumFractionDigits: 0,
})

const money = (amount: number) => currency.format(amount)
const isNumber = (item: unknown) => typeof item === "number"

class Invoices extends Component {
  pageCount = PAGE_COUNT
  total = INVOICES.toLocaleString("en-US")
  @tracked page = 4

  get range() {
    return paginationRange({
      page: this.page,
      pageCount: PAGE_COUNT,
      siblings: 0,
    })
  }

  get first() {
    return (this.page - 1) * PER_PAGE + 1
  }

  get last() {
    return Math.min(this.first + PER_PAGE - 1, INVOICES)
  }

  get keyed() {
    return [this.page]
  }

  get invoices() {
    return invoicesOn(this.page)
  }

  setPage = (page: number) => {
    this.page = page
  }

  <template>
    <div class="rc-invoices">
      <div class="rc-inv-head">
        <span class="rc-inv-title">Invoices</span>
        <span class="rc-inv-count">{{this.first}}–{{this.last}}
          of
          {{this.total}}</span>
      </div>
      {{#each this.keyed key="@identity" as |page|}}
        <ul class="rc-inv-list" aria-label="Invoices, page {{page}}">
          {{#each this.invoices key="number" as |invoice|}}
            <li class="rc-inv-row">
              <span class="rc-inv-who">
                <span class="rc-inv-customer">{{invoice.customer}}</span>
                <span class="rc-inv-number">{{invoice.number}}</span>
              </span>
              <span class="rc-inv-right">
                <span class="rc-inv-amount">{{money invoice.amount}}</span>
                <span class="rc-inv-status" data-status={{invoice.status}}>
                  {{invoice.status}}
                </span>
              </span>
            </li>
          {{/each}}
        </ul>
      {{/each}}
      <p class="rc-inv-page" aria-hidden="true">
        Page
        {{this.page}}
        of
        {{this.pageCount}}
      </p>
      <Pagination
        aria-label="Invoice pages"
        @pageCount={{this.pageCount}}
        @page={{this.page}}
        @onPageChange={{this.setPage}}
        @siblings={{0}}
        class="rc-pages"
        as |p|
      >
        <p.List class="rc-pages-list">
          <p.Item>
            <p.Previous aria-label="Previous page" class="rc-page">{{icon
                ChevronLeft
                13
              }}</p.Previous>
          </p.Item>
          {{#each this.range key="@identity" as |item|}}
            <p.Item>
              {{#if (isNumber item)}}
                <p.Link @page={{item}} class="rc-page" />
              {{else}}
                <p.Ellipsis class="rc-page-gap">…</p.Ellipsis>
              {{/if}}
            </p.Item>
          {{/each}}
          <p.Item>
            <p.Next aria-label="Next page" class="rc-page">{{icon
                ChevronRight
                13
              }}</p.Next>
          </p.Item>
        </p.List>
      </Pagination>
    </div>
  </template>
}

/* Board history */

let sharedAgent: ReturnType<typeof createAgent> | undefined
const agentOf = () => (sharedAgent ??= createAgent())

const columns = ["To do", "Doing", "Done"] as const
const priorities = ["Low", "Medium", "High"] as const

const otherCards: Record<(typeof columns)[number], string> = {
  "To do": "Empty states",
  Doing: "Keyboard map",
  Done: "Dark mode",
}

const otherCard = (column: (typeof columns)[number]) => otherCards[column]
const describe = (entry: HistoryEntry) => describeEntry(entry)
const applied = (index: number, position: number) => index < position
const agentMade = (entry: HistoryEntry) => entry.source === "agent"
const atIndex = (index: number, position: number) => index + 1 === position
const next = (index: number) => index + 1

class BoardHistory extends Component {
  columns = columns
  priorities = priorities
  otherCard = otherCard
  history: ReturnType<typeof createHistory> | undefined
  undoKeys = /Mac|iPhone|iPad/.test(navigator.platform) ? "⌘Z" : "Ctrl+Z"
  @tracked status: string = "Doing"
  @tracked priority: string = "Medium"
  @tracked blocked = false
  @tracked entries: readonly HistoryEntry[] = []
  @tracked position = 0
  @tracked stagedAt: number | undefined

  mount = (root: Element) => {
    const history = createHistory(agentOf(), { within: () => root })
    this.history = history
    const stop = history.subscribe(() => {
      this.entries = history.entries()
      this.position = history.position()
    })
    return () => {
      stop()
      history.destroy()
    }
  }

  get isStaged() {
    return this.stagedAt !== undefined && this.position > this.stagedAt
  }

  get noEntries() {
    return !this.entries.length
  }

  get atStart() {
    return this.position === 0
  }

  get atEnd() {
    return this.position === this.entries.length
  }

  get previewDisabled() {
    return this.status === "Done" && this.priority === "High"
  }

  seek = (to: number) => this.history?.seek(to)
  undo = () => this.seek(this.position - 1)
  redo = () => this.seek(this.position + 1)

  setStatus = (value: string | null) => {
    if (value) {
      this.status = value
    }
  }
  setPriority = (value: string | null) => {
    if (value) {
      this.priority = value
    }
  }
  setBlocked = (value: boolean) => {
    this.blocked = value
  }

  suggest = async () => {
    const before = this.position
    const { applied } = await stageChanges(agentOf(), [
      { ref: "Card status", value: "Done" },
      { ref: "Card priority", value: "High" },
    ])
    if (applied.length) {
      this.stagedAt = before
    }
  }

  discard = () => {
    if (this.stagedAt !== undefined) {
      this.seek(this.stagedAt)
    }
    this.stagedAt = undefined
  }

  keep = () => {
    this.stagedAt = undefined
  }

  onKeyDown = (event: KeyboardEvent) => {
    if (
      event.key.toLowerCase() !== "z" ||
      !(event.metaKey || event.ctrlKey) ||
      event.altKey
    ) {
      return
    }
    event.preventDefault()
    this.seek(event.shiftKey ? this.position + 1 : this.position - 1)
  }

  <template>
    <div
      class="rc-board"
      {{onInsert this.mount}}
      {{on "keydown" this.onKeyDown}}
    >
      <div class="rc-columns" aria-hidden="true">
        {{#each this.columns as |column|}}
          <div class="rc-column" data-current={{flag (is column this.status)}}>
            <span class="rc-column-name">{{column}}</span>
            <span class="rc-card rc-card-quiet">{{otherCard column}}</span>
            {{#if (is column this.status)}}
              <span
                class="rc-card"
                data-priority={{this.priority}}
                data-blocked={{flag this.blocked}}
              >
                <span class="rc-card-title">Offline drafts</span>
                <span class="rc-card-meta">
                  <span class="rc-card-priority">{{this.priority}}</span>
                  {{#if this.blocked}}<span
                      class="rc-card-blocked"
                    >Blocked</span>{{/if}}
                </span>
              </span>
            {{/if}}
          </div>
        {{/each}}
      </div>

      <div class="rc-controls">
        <SegmentedControl
          aria-label="Card status"
          @defaultValue="Doing"
          @onValueChange={{this.setStatus}}
          class="rc-seg"
          as |s|
        >
          <s.Indicator class="rc-seg-indicator" />
          {{#each this.columns as |column|}}
            <s.Item @value={{column}} class="rc-seg-item">{{column}}</s.Item>
          {{/each}}
        </SegmentedControl>
        <SegmentedControl
          aria-label="Card priority"
          @defaultValue="Medium"
          @onValueChange={{this.setPriority}}
          class="rc-seg"
          as |s|
        >
          <s.Indicator class="rc-seg-indicator" />
          {{#each this.priorities as |level|}}
            <s.Item @value={{level}} class="rc-seg-item">{{level}}</s.Item>
          {{/each}}
        </SegmentedControl>
        <label class="rc-switch-row">
          <Switch
            aria-label="Blocked"
            @onCheckedChange={{this.setBlocked}}
            class="rc-switch"
            as |s|
          >
            <s.Thumb class="rc-switch-thumb" />
          </Switch>
          <span aria-hidden="true">Blocked</span>
        </label>
      </div>

      <div class="rc-history">
        <div class="rc-history-bar">
          <span class="rc-history-title">History</span>
          <kbd class="rc-kbd">{{this.undoKeys}}</kbd>
          <button
            type="button"
            class="b-btn rc-icon-btn"
            aria-label="Undo"
            disabled={{this.atStart}}
            {{on "click" this.undo}}
          >{{icon RotateCcw 15}}</button>
          <button
            type="button"
            class="b-btn rc-icon-btn"
            aria-label="Redo"
            disabled={{this.atEnd}}
            {{on "click" this.redo}}
          >{{icon RotateCw 15}}</button>
        </div>
        <ol class="rc-entries" aria-label="Changes">
          {{#if this.noEntries}}
            <li class="rc-entries-hint">Change the card, then press
              {{this.undoKeys}}.</li>
          {{/if}}
          <li>
            <button
              type="button"
              class="rc-entry"
              data-applied=""
              aria-current={{if this.atStart "true"}}
              {{on "click" (fn this.seek 0)}}
            >
              Opened the card
            </button>
          </li>
          {{#each this.entries key="id" as |entry index|}}
            <li>
              <button
                type="button"
                class="rc-entry"
                data-applied={{flag (applied index this.position)}}
                data-agent={{flag (agentMade entry)}}
                aria-current={{if (atIndex index this.position) "true"}}
                {{on "click" (fn this.seek (next index))}}
              >
                {{describe entry}}
              </button>
            </li>
          {{/each}}
        </ol>
        <div class="rc-suggest" data-staged={{flag this.isStaged}}>
          {{icon Sparkles 14}}
          {{#if this.isStaged}}
            <span class="rc-suggest-text">Agent moved it to Done.</span>
            <button
              type="button"
              class="b-btn"
              data-variant="ghost"
              {{on "click" this.discard}}
            >
              Discard
            </button>
            <button
              type="button"
              class="b-btn"
              data-variant="primary"
              {{on "click" this.keep}}
            >
              Keep
            </button>
          {{else}}
            <span class="rc-suggest-text">Looks shipped. Close it out?</span>
            <button
              type="button"
              class="b-btn"
              disabled={{this.previewDisabled}}
              {{on "click" this.suggest}}
            >
              Preview
            </button>
          {{/if}}
        </div>
      </div>
    </div>
  </template>
}

/* Command line */

const seededCommands = [
  "git status",
  "pnpm test --filter core",
  "deploy --env preview",
]

function respond(command: string) {
  const [name] = command.split(/\s+/)
  if (name === "git") {
    return "On branch main. Nothing to commit."
  }
  if (name === "pnpm") {
    return "✓ 312 tests passed in 4.1s"
  }
  if (name === "deploy") {
    return command.includes("prod")
      ? "Queued build #483 → production"
      : "Queued build #483 → preview"
  }
  if (name === "help") {
    return "Try git, pnpm, deploy or clear."
  }
  return `command not found: ${name}`
}

class CommandLine extends Component {
  input: HTMLInputElement | undefined
  commands: readonly string[] = seededCommands
  @tracked lines = [
    {
      id: 0,
      command: "deploy --env preview",
      output: respond("deploy --env preview"),
    },
  ]

  history = createInputHistory({
    entries: () => this.commands,
    read: () => this.input?.value ?? "",
    write: (value: string) => {
      if (this.input) {
        this.input.value = value
      }
    },
  })

  attach = (el: HTMLInputElement) => {
    this.input = el
  }

  run = () => {
    const field = this.input
    const command = field?.value.trim()
    if (!field || !command) {
      return
    }
    field.value = ""
    this.commands = [...this.commands, command]
    if (command === "clear") {
      this.lines = []
      return
    }
    this.lines = [
      ...this.lines,
      { id: this.commands.length, command, output: respond(command) },
    ].slice(-3)
  }

  onKeyDown = (event: KeyboardEvent) => {
    if (this.history.keydown(event)) {
      return
    }
    if (event.key === "Enter" && !isComposing(event)) {
      event.preventDefault()
      this.run()
    }
  }

  <template>
    <div class="rc-term">
      <div class="rc-term-bar" aria-hidden="true">
        <span class="rc-term-dots">
          <i></i>
          <i></i>
          <i></i>
        </span>
        <span>~/atlas</span>
      </div>
      <ol class="rc-term-log" aria-live="polite" aria-label="Output">
        {{#each this.lines key="id" as |line|}}
          <li>
            <span class="rc-term-echo">
              <span
                class="rc-term-prompt"
                aria-hidden="true"
              >›</span>{{line.command}}
            </span>
            <span class="rc-term-out">{{line.output}}</span>
          </li>
        {{/each}}
      </ol>
      <div class="rc-term-input">
        <span class="rc-term-prompt" aria-hidden="true">›</span>
        <input
          type="text"
          aria-label="Command"
          placeholder="Type a command"
          autocomplete="off"
          autocapitalize="off"
          spellcheck="false"
          class="rc-term-field"
          {{onInsert this.attach}}
          {{on "keydown" this.onKeyDown}}
        />
      </div>
      <p class="rc-term-hint" aria-hidden="true">
        <kbd>↑</kbd>
        <kbd>↓</kbd>
        history
        <kbd>⏎</kbd>
        run
      </p>
    </div>
  </template>
}

/* Activity feed */

const quietTime = (hour: number) =>
  `${Math.floor(hour) % 24}:${hour % 1 ? "30" : "00"}`

const shownValue = (change: ObservedChange, value: unknown) =>
  typeof value === "boolean"
    ? value
      ? "on"
      : "off"
    : change.component === "slider" && typeof value === "number"
      ? quietTime(value)
      : String(value)

class ActivityFeed extends Component {
  digestLabel = `${guidFor(this)}-digest`
  quietTime = quietTime
  @tracked changes: (ObservedChange & { at: number })[] = []

  mount = (root: Element) => {
    let count = 0
    const timers = new Set<number>()
    const stop = observe(
      (change) => {
        this.changes = [{ ...change, at: ++count }, ...this.changes].slice(0, 5)
        const element = elementOf(change.ref)
        if (!element) {
          return
        }
        element.setAttribute("data-rc-flash", "")
        const timer = window.setTimeout(() => {
          element.removeAttribute("data-rc-flash")
          timers.delete(timer)
        }, 700)
        timers.add(timer)
      },
      { within: () => root }
    )
    return () => {
      stop()
      timers.forEach((timer) => window.clearTimeout(timer))
    }
  }

  <template>
    <div class="rc-activity" {{onInsert this.mount}}>
      <div class="rc-prefs">
        <div class="rc-pref">
          <span class="rc-pref-name" id={{this.digestLabel}}>Email digest</span>
          <Switch
            aria-labelledby={{this.digestLabel}}
            @defaultChecked={{true}}
            class="rc-switch"
            as |s|
          >
            <s.Thumb class="rc-switch-thumb" />
          </Switch>
        </div>
        <div class="rc-pref">
          <span class="rc-pref-name">Send</span>
          <SegmentedControl
            aria-label="Send"
            @defaultValue="Daily"
            class="rc-seg"
            as |s|
          >
            <s.Indicator class="rc-seg-indicator" />
            <s.Item @value="Daily" class="rc-seg-item">Daily</s.Item>
            <s.Item @value="Weekly" class="rc-seg-item">Weekly</s.Item>
          </SegmentedControl>
        </div>
        <Slider
          @defaultValue={{21}}
          @min={{18}}
          @max={{24}}
          @step={{0.5}}
          @format={{this.quietTime}}
          class="rc-quiet"
          as |s|
        >
          <div class="rc-pref">
            <span class="rc-pref-name">Quiet after</span>
            <s.Value class="rc-quiet-value" />
          </div>
          <s.Control class="rc-quiet-control">
            <s.Track class="rc-quiet-track">
              <s.Indicator class="rc-quiet-fill" />
              <s.Thumb aria-label="Quiet after" class="rc-quiet-thumb" />
            </s.Track>
          </s.Control>
        </Slider>
      </div>
      <div class="rc-feed">
        <span class="rc-feed-title">
          <span class="rc-feed-live" aria-hidden="true"></span>
          Changes
        </span>
        {{#if this.changes.length}}
          <ol class="rc-feed-list">
            {{#each this.changes key="at" as |change|}}
              <li class="rc-feed-item">
                <span class="rc-feed-label">{{change.label}}</span>
                <span class="rc-feed-values">
                  <s>{{shownValue change change.previous}}</s>
                  <span aria-label="to">→</span>
                  <strong>{{shownValue change change.value}}</strong>
                </span>
                <span class="rc-feed-source">
                  {{change.source}}
                  ·
                  {{change.reason}}
                </span>
              </li>
            {{/each}}
          </ol>
        {{else}}
          <p class="rc-feed-empty">Change a setting.</p>
        {{/if}}
      </div>
    </div>
  </template>
}

export const tiles: Tile[] = [
  {
    id: "collections-release-history",
    title: "Scrub the release history.",
    blurb: "Arrow keys or a drag move through every version.",
    size: "wide",
    tone: "paper",
    Demo: ReleaseHistory,
  },
  {
    id: "collections-request-waterfall",
    title: "Read the request waterfall.",
    blurb:
      "Every request on one clock, with the ones it started tucked inside.",
    size: "large",
    tone: "white",
    Demo: RequestWaterfall,
  },
  {
    id: "collections-invoice-pages",
    title: "Page 4 of 212.",
    blurb:
      "The page list keeps its length, so nothing shifts under the pointer.",
    size: "tall",
    tone: "sky",
    Demo: Invoices,
  },
  {
    id: "collections-board-history",
    title: "Undo 'Moved card to Done'.",
    blurb:
      "Every change in words, from you or an agent, one step back at a time.",
    size: "large",
    tone: "butter",
    Demo: BoardHistory,
  },
  {
    id: "collections-command-recall",
    title: "Recall the last command.",
    blurb: "Arrow up brings it back, and leaves an IME alone.",
    size: "s",
    tone: "ink",
    Demo: CommandLine,
  },
  {
    id: "collections-activity-feed",
    title: "Watch what changed.",
    blurb: "One stream of every change, who made it and how.",
    size: "tall",
    tone: "sage",
    Demo: ActivityFeed,
  },
]
