import { concat, fn } from "@ember/helper"
import { capabilities, on, setModifierManager } from "@ember/modifier"
import { schedule } from "@ember/runloop"
import { htmlSafe } from "@ember/template"
import { registerDestructor } from "@ember/destroyable"
import Component from "@glimmer/component"
import type { ModifierLike } from "@glint/template"
import { tracked } from "@glimmer/tracking"
import {
  Check,
  ChevronDown,
  FileText,
  House,
  Inbox,
  Link,
  Mail,
  Monitor,
  Moon,
  Pause,
  Pencil,
  Play,
  RotateCcw,
  RotateCw,
  Send,
  Share2,
  Star,
  Sun,
  Trash2,
  Users,
  ChartColumn,
} from "lucide"
import {
  bindPanel,
  bindPersistentLayer,
  createColorScheme,
  createLocalStorage,
  createPopup,
  createPreference,
  definePrimitive,
  hiddenAttrs,
  isDismissal,
  openAttrs,
  popupArrow,
  popupClose,
  popupContent,
  popupDescription,
  popupState,
  popupTitle,
  popupTrigger,
  supportsTopLayer,
  type ChangeDetails,
} from "@ui-sdk/core"
import { popoverPreset } from "@ui-sdk/core/popover"
import { createConfirm } from "ember-ui-sdk/alert-dialog"
import { Dialog } from "ember-ui-sdk/dialog"
import { Menu } from "ember-ui-sdk/menu"
import { createOverlays, OverlayHost } from "ember-ui-sdk/overlays"
import { Popover } from "ember-ui-sdk/popover"
import { Preferences, usePreference } from "ember-ui-sdk/preferences"
import { createParts } from "ember-ui-sdk/primitive"
import {
  createResizableController,
  Resizable,
  resizableStorageKey,
} from "ember-ui-sdk/resizable"
import { SegmentedControl } from "ember-ui-sdk/segmented-control"
import { registerShortcut, useShortcutHint } from "ember-ui-sdk/shortcuts"
import "../../../vendor/ui/apps/docs/app/sink/tiles/layers.css"
import { icon } from "../icon.ts"
import type { Tile } from "../types.ts"

/** Runs `callback(el)` once the element is in the page; what it returns runs when it leaves. */
const onInsert = setModifierManager(
  () => ({
    capabilities: capabilities("3.22", { disableAutoTracking: true }),
    createModifier: () => ({ cleanup: undefined as void | (() => void) }),
    installModifier: (
      modifier: { cleanup: void | (() => void) },
      el: Element,
      { positional }: { positional: unknown[] }
    ) => {
      modifier.cleanup = (
        positional[0] as (el: Element) => void | (() => void)
      )(el)
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

const colorScheme = createColorScheme({
  storage: createLocalStorage("sink-layers-scheme"),
})

const accents = ["iris", "moss", "ember"] as const

const accentLabels = { iris: "Iris", moss: "Moss", ember: "Ember" }

const accent = createPreference({
  values: accents,
  defaultValue: "iris",
  attribute: "data-accent",
  storage: createLocalStorage("sink-layers-accent"),
})

const schemeOptions = [
  { value: "light", label: "Light", icon: Sun },
  { value: "dark", label: "Dark", icon: Moon },
  { value: "system", label: "System", icon: Monitor },
] as const

const revenueBars = [38, 52, 44, 61, 57, 72, 66, 84].map((height) => ({
  style: htmlSafe(`height: ${height}%`),
}))

const appStats = [
  { label: "Orders", value: "1,284" },
  { label: "Refunds", value: "12" },
  { label: "Avg. order", value: "$37.50" },
]

class Theme extends Component {
  scheme = usePreference(this, colorScheme)
  accentPref = usePreference(this, accent)
  schemeOptions = schemeOptions
  preferences = [colorScheme, accent]
  revenueBars = revenueBars
  appStats = appStats

  get status() {
    const scheme = this.scheme.current
    return scheme.value !== "system"
      ? "Saved in this browser"
      : scheme.system === "unknown"
        ? "Follows your system"
        : `Your system is ${scheme.system} right now`
  }

  get swatches() {
    return accents.map((name) => ({
      name,
      label: accentLabels[name],
      pressed: this.accentPref.current.value === name ? "true" : "false",
    }))
  }

  setScheme = (value: string | null) => {
    if (value) {
      colorScheme.set(value as "light" | "dark" | "system")
    }
  }

  setAccent = (name: (typeof accents)[number]) => {
    accent.set(name)
  }

  <template>
    <div class="ly-theme">
      <div class="ly-theme-bar">
        <SegmentedControl
          class="ly-seg"
          aria-label="Theme"
          @value={{this.scheme.current.value}}
          @onValueChange={{this.setScheme}}
          as |s|
        >
          <s.Indicator class="ly-seg-indicator" />
          {{#each this.schemeOptions key="value" as |option|}}
            <s.Item @value={{option.value}} class="ly-seg-item">
              {{icon option.icon 14}}
              {{option.label}}
            </s.Item>
          {{/each}}
        </SegmentedControl>
        <div class="ly-swatches" role="group" aria-label="Accent">
          {{#each this.swatches key="name" as |swatch|}}
            <button
              type="button"
              class="ly-swatch"
              data-accent={{swatch.name}}
              aria-label={{swatch.label}}
              aria-pressed={{swatch.pressed}}
              {{on "click" (fn this.setAccent swatch.name)}}
            >
              {{icon Check 11}}
            </button>
          {{/each}}
        </div>
      </div>
      <p class="ly-theme-status" aria-live="polite">
        {{this.status}}
      </p>
      <Preferences @preferences={{this.preferences}}>
        <div class="ly-app" aria-label="Preview" role="img">
          <div class="ly-app-side" aria-hidden="true">
            <span class="ly-app-logo"></span>
            <span class="ly-app-nav" data-current>
              {{icon House 13}}
              Home
            </span>
            <span class="ly-app-nav">
              {{icon ChartColumn 13}}
              Reports
            </span>
            <span class="ly-app-nav">
              {{icon Users 13}}
              Customers
            </span>
            <span class="ly-app-me">
              <span class="ly-app-avatar">JB</span>
              Jo Berg
            </span>
          </div>
          <div class="ly-app-main" aria-hidden="true">
            <span class="ly-app-head">
              <span>
                <span class="ly-app-kicker">This quarter</span>
                <span class="ly-app-figure">$48,210</span>
              </span>
              <span class="ly-app-delta">+12.4%</span>
            </span>
            <span class="ly-app-stats">
              {{#each this.appStats key="label" as |stat|}}
                <span class="ly-app-stat">
                  <span class="ly-app-kicker">{{stat.label}}</span>
                  <span class="ly-app-stat-value">{{stat.value}}</span>
                </span>
              {{/each}}
            </span>
            <span class="ly-app-chart">
              {{#each this.revenueBars as |bar|}}
                <span class="ly-app-bar" style={{bar.style}}></span>
              {{/each}}
            </span>
            <span class="ly-app-rows">
              <span class="ly-app-row">
                <span class="ly-app-avatar">MO</span>
                Mira Okafor
                <span class="ly-app-amount">$1,240</span>
              </span>
              <span class="ly-app-row">
                <span class="ly-app-avatar">TL</span>
                Tomás Lindqvist
                <span class="ly-app-amount">$860</span>
              </span>
              <span class="ly-app-row">
                <span class="ly-app-avatar">AS</span>
                Aiko Sato
                <span class="ly-app-amount">$615</span>
              </span>
            </span>
          </div>
        </div>
      </Preferences>
    </div>
  </template>
}

const splitId = "sink-layers-mail"
const splitDefault = [38, 62]

const readSavedWidth = () => {
  try {
    const saved = JSON.parse(
      localStorage.getItem(resizableStorageKey(splitId)) ?? "{}"
    ) as Record<string, number[]>
    return Object.values(saved)[0]?.[0]
  } catch {
    return undefined
  }
}

const folders = [
  { label: "Inbox", icon: Inbox, count: 12, current: true },
  { label: "Starred", icon: Star, count: 3, current: false },
  { label: "Sent", icon: Send, count: 0, current: false },
]

class Split extends Component {
  controller = createResizableController()
  @tracked savedWidth: number | undefined
  folders = folders
  defaultSize = splitDefault[0]

  load = () => {
    queueMicrotask(() => (this.savedWidth = readSavedWidth()))
  }

  get saved() {
    return this.savedWidth === undefined
      ? "Default layout"
      : `Saved at ${Math.round(this.savedWidth)}%`
  }

  get unsaved() {
    return this.savedWidth === undefined
  }

  reset = () => {
    this.controller.setLayout(splitDefault)
    localStorage.removeItem(resizableStorageKey(splitId))
    this.savedWidth = undefined
  }

  <template>
    <div class="ly-split" {{onInsert this.load}}>
      <Resizable
        class="ly-split-group"
        @autoSaveId={{splitId}}
        @controller={{this.controller}}
        @onLayoutCommit={{this.load}}
        as |r|
      >
        <r.Panel
          @id="ly-folders"
          @defaultSize={{this.defaultSize}}
          @minSize={{24}}
          @maxSize={{64}}
          class="ly-split-pane ly-split-folders"
        >
          {{#each this.folders key="label" as |folder|}}
            <span
              class="ly-folder"
              data-current={{if folder.current "" undefined}}
            >
              {{icon folder.icon 14}}
              <span class="ly-folder-label">{{folder.label}}</span>
              {{#if folder.count}}
                <span class="ly-folder-count">{{folder.count}}</span>
              {{/if}}
            </span>
          {{/each}}
        </r.Panel>
        <r.Handle aria-label="Resize folders" class="ly-split-handle">
          <span class="ly-split-grip"></span>
        </r.Handle>
        <r.Panel @id="ly-message" class="ly-split-pane">
          <span class="ly-mail-from">
            {{icon Mail 14}}
            Ines Moreau
          </span>
          <span class="ly-mail-subject">Friday review moved</span>
          <span class="ly-mail-line"></span>
          <span class="ly-mail-line"></span>
          <span class="ly-mail-line" data-short></span>
        </r.Panel>
      </Resizable>
      <div class="ly-split-foot">
        <span class="ly-split-saved" aria-live="polite">
          {{this.saved}}
        </span>
        <button
          type="button"
          class="b-btn ly-split-reset"
          disabled={{this.unsaved}}
          {{on "click" this.reset}}
        >
          {{icon RotateCcw 13}}
          Reset
        </button>
      </div>
    </div>
  </template>
}

const episodeLength = 47 * 60 + 12

const clock = (seconds: number) =>
  `${Math.floor(seconds / 60)}:${String(seconds % 60).padStart(2, "0")}`

class Player extends Component {
  @tracked playing = false
  @tracked elapsed = 12 * 60 + 34
  @tracked lifted: DOMRect | null = null
  player: HTMLDivElement | null = null
  timer: ReturnType<typeof setInterval> | undefined
  episodeLength = episodeLength

  constructor(owner: ConstructorParameters<typeof Component>[0], args: {}) {
    super(owner, args)
    registerDestructor(this, () => clearInterval(this.timer))
  }

  setPlayer = (el: Element) => {
    this.player = el as HTMLDivElement
    const stop = bindPersistentLayer(el as HTMLElement)
    return () => {
      this.player = null
      stop?.()
    }
  }

  toggle = () => {
    this.playing = !this.playing
    clearInterval(this.timer)
    if (this.playing) {
      this.timer = setInterval(
        () => (this.elapsed = Math.min(this.elapsed + 1, episodeLength)),
        1000
      )
    }
  }

  skip = (seconds: number) => {
    this.elapsed = Math.min(Math.max(this.elapsed + seconds, 0), episodeLength)
  }

  back = () => this.skip(-15)
  forward = () => this.skip(30)

  onOpenChange = (open: boolean) => {
    if (open && supportsTopLayer() && this.player) {
      this.lifted = this.player.getBoundingClientRect()
      schedule("afterRender", () => this.player?.showPopover())
    }
  }

  onOpenChangeComplete = (open: boolean) => {
    if (!open && this.lifted) {
      this.player?.hidePopover()
      this.lifted = null
    }
  }

  get popover() {
    return this.lifted ? "manual" : undefined
  }

  get style() {
    const { lifted } = this
    return lifted
      ? htmlSafe(
          `top: ${lifted.top}px; left: ${lifted.left}px; width: ${lifted.width}px`
        )
      : undefined
  }

  get playingAttr() {
    return this.playing ? "" : undefined
  }

  get label() {
    return this.playing ? "Pause" : "Play"
  }

  get time() {
    return clock(this.elapsed)
  }

  get remaining() {
    return `-${clock(episodeLength - this.elapsed)}`
  }

  get fill() {
    return htmlSafe(`width: ${(this.elapsed / episodeLength) * 100}%`)
  }

  get link() {
    return `changelog.fm/112?t=${this.elapsed}`
  }

  <template>
    <div class="ly-listen">
      <div class="ly-player-slot">
        <div
          class="ly-player"
          data-playing={{this.playingAttr}}
          popover={{this.popover}}
          style={{this.style}}
          {{onInsert this.setPlayer}}
        >
          <span class="ly-cover" aria-hidden="true">
            <span class="ly-eq">
              <span></span>
              <span></span>
              <span></span>
            </span>
          </span>
          <span class="ly-track">
            <span class="ly-track-title">Shipping on Fridays</span>
            <span class="ly-track-show">Changelog Radio · Ep. 112</span>
          </span>
          <span class="ly-transport">
            <button
              type="button"
              class="ly-icon-btn"
              aria-label="Back 15 seconds"
              {{on "click" this.back}}
            >
              {{icon RotateCcw 16}}
            </button>
            <button
              type="button"
              class="ly-icon-btn ly-play"
              aria-label={{this.label}}
              {{on "click" this.toggle}}
            >
              {{#if this.playing}}
                {{icon Pause 16}}
              {{else}}
                {{icon Play 16}}
              {{/if}}
            </button>
            <button
              type="button"
              class="ly-icon-btn"
              aria-label="Forward 30 seconds"
              {{on "click" this.forward}}
            >
              {{icon RotateCw 16}}
            </button>
          </span>
          <span class="ly-progress">
            <span class="ly-time">{{this.time}}</span>
            <span
              class="ly-progress-track"
              role="progressbar"
              aria-label="Played"
              aria-valuemin="0"
              aria-valuemax={{this.episodeLength}}
              aria-valuenow={{this.elapsed}}
              aria-valuetext={{this.time}}
            >
              <span class="ly-progress-fill" style={{this.fill}}></span>
            </span>
            <span class="ly-time">{{this.remaining}}</span>
          </span>
        </div>
      </div>
      <Dialog
        @onOpenChange={{this.onOpenChange}}
        @onOpenChangeComplete={{this.onOpenChangeComplete}}
        as |d|
      >
        <d.Trigger class="b-btn ly-share">
          {{icon Share2 15}}
          Share episode
        </d.Trigger>
        <d.Backdrop class="ly-backdrop" />
        <d.Content class="ly-dialog">
          <d.Title class="ly-dialog-title">Share episode</d.Title>
          <d.Description class="ly-dialog-desc">
            The player keeps going. Pause or skip it while you’re here.
          </d.Description>
          <div class="ly-link">
            {{icon Link 14}}
            <input
              class="ly-link-input"
              aria-label="Episode link"
              readonly
              value={{this.link}}
            />
          </div>
          <div class="ly-actions">
            <d.Close class="b-btn" data-variant="primary">
              Done
            </d.Close>
          </div>
        </d.Content>
      </Dialog>
    </div>
  </template>
}

const notePopup = definePrimitive({
  name: "ly-note",
  options: { defaultOpen: "boolean", onOpenChange: "callback" },
  state: (options: {
    defaultOpen?: boolean
    onOpenChange?: (open: boolean, details: ChangeDetails<string>) => void
  }) => popupState(options),
  api: (context) => createPopup(context, { preset: popoverPreset }),
  slots: (slot) => ({
    trigger: popupTrigger(slot),
    content: popupContent(slot),
    title: popupTitle(slot),
    description: popupDescription(slot),
    close: popupClose(slot),
    arrow: popupArrow(slot),
  }),
})

const { Root: NotePopup } = createParts(notePopup, {
  trigger: "button",
  content: "div",
  title: "h3",
  description: "p",
  close: "button",
  arrow: "div",
})

class Note extends Component {
  @tracked note = "Rotate after the 14:00 deploy."
  @tracked draft = this.note
  @tracked asking = false
  field: HTMLTextAreaElement | null = null

  setField = (el: Element) => {
    this.field = el as HTMLTextAreaElement
    return () => {
      if (this.field === el) {
        this.field = null
      }
    }
  }

  get noteText() {
    return this.note || "Add a note"
  }

  onOpenChange = (open: boolean, details: ChangeDetails<string>) => {
    if (open) {
      this.draft = this.note
      this.asking = false
      return
    }
    if (isDismissal(details.reason) && this.draft !== this.note) {
      details.cancel()
      if (
        details.reason === "escape-key" ||
        details.reason === "outside-press"
      ) {
        this.asking = true
      }
    }
  }

  onInput = (event: Event) => {
    this.draft = (event.target as HTMLTextAreaElement).value
    this.asking = false
  }

  keepEditing = () => {
    this.asking = false
    this.field?.focus()
  }

  save = () => {
    this.note = this.draft.trim()
  }

  <template>
    <div class="ly-task">
      <div class="ly-task-head">
        <span class="ly-task-check" aria-hidden="true"></span>
        <span class="ly-task-text">
          <span class="ly-task-title">Rotate the staging keys</span>
          <span class="ly-task-meta">Due today · Infra</span>
        </span>
      </div>
      <NotePopup @onOpenChange={{this.onOpenChange}} as |n|>
        <n.Trigger class="ly-note-trigger">
          {{icon Pencil 13}}
          <span class="ly-note-text">{{this.noteText}}</span>
        </n.Trigger>
        <n.Content
          class="b-pop ly-note-pop"
          @sideOffset={{10}}
          @collisionPadding={{12}}
        >
          <n.Arrow class="ly-arrow" />
          <n.Title class="ly-note-title">Edit note</n.Title>
          <n.Description class="ly-note-desc">
            Only your team sees it.
          </n.Description>
          <textarea
            class="b-input ly-note-field"
            aria-label="Note"
            rows="3"
            value={{this.draft}}
            {{on "input" this.onInput}}
            {{onInsert this.setField}}
          ></textarea>
          {{#if this.asking}}
            <div class="ly-discard" role="alert">
              <span>Discard changes?</span>
              <span class="ly-discard-actions">
                <button
                  type="button"
                  class="b-btn"
                  {{on "click" this.keepEditing}}
                >
                  Keep editing
                </button>
                <n.Close class="b-btn ly-destroy">
                  Discard
                </n.Close>
              </span>
            </div>
          {{else}}
            <div class="ly-note-actions">
              <n.Close class="b-btn">Cancel</n.Close>
              <n.Close
                class="b-btn"
                data-variant="primary"
                {{on "click" this.save}}
              >
                Save
              </n.Close>
            </div>
          {{/if}}
        </n.Content>
      </NotePopup>
    </div>
  </template>
}

const receipt = definePrimitive({
  name: "ly-receipt",
  options: { defaultOpen: "boolean" },
  state: (options: { defaultOpen?: boolean }) => ({
    open: options.defaultOpen ?? false,
    exiting: false,
  }),
  api: ({ store, element }) => {
    let toggled = false
    return {
      toggle() {
        toggled = true
        const open = !store.get().open
        store.set({ open, exiting: !open })
      },
      opening: () => (toggled ? "animate" : "mount") as "animate" | "mount",
      trigger: () => element("trigger"),
    }
  },
  slots: (slot) => ({
    trigger: slot({
      attrs: (state, { id }) => ({
        type: "button",
        "aria-expanded": String(state.open),
        "aria-controls": `${id}-panel`,
        ...openAttrs(state.open),
      }),
      press: ({ api }) => api.toggle(),
    }),
    panel: slot({
      present: (state) => state.open || state.exiting,
      attrs: (state, { id }) => ({
        id: `${id}-panel`,
        ...hiddenAttrs(state.open || state.exiting, false),
        ...openAttrs(state.open),
      }),
      bind: (el, { api, store }) =>
        bindPanel(el, {
          size: (el, height) => el.style.setProperty("--ly-panel", height),
          isOpen: () => store.get().open,
          isExiting: () => store.get().exiting,
          isFindable: () => false,
          opening: api.opening,
          reveal: () => {},
          trigger: api.trigger,
          subscribe: store.subscribe,
          settled: () => {},
          exited: () => store.set({ exiting: false }),
        }),
    }),
  }),
})

const { Root: Receipt } = createParts(receipt, {
  trigger: "button",
  panel: "div",
})

const orderData = [
  {
    id: "4821",
    date: "Nov 14",
    status: "Delivered",
    lines: [
      { item: "Ceramic pour-over", qty: 1, price: 38 },
      { item: "Paper filters", qty: 2, price: 7.5 },
      { item: "Single-origin, 250 g", qty: 1, price: 19 },
    ],
  },
  {
    id: "4790",
    date: "Oct 30",
    status: "Delivered",
    lines: [
      { item: "Gooseneck kettle", qty: 1, price: 64 },
      { item: "Descaler", qty: 1, price: 9 },
    ],
  },
  {
    id: "4702",
    date: "Oct 3",
    status: "Refunded",
    lines: [{ item: "Burr grinder", qty: 1, price: 129 }],
  },
  {
    id: "4655",
    date: "Sep 12",
    status: "Delivered",
    lines: [
      { item: "Glass carafe", qty: 1, price: 24 },
      { item: "Cork coasters", qty: 4, price: 3 },
    ],
  },
]

const money = (amount: number) => `$${amount.toFixed(2)}`

const orders = orderData.map((order, index) => {
  const subtotal = order.lines.reduce(
    (sum, line) => sum + line.qty * line.price,
    0
  )
  const tax = subtotal * 0.08
  return {
    id: order.id,
    date: order.date,
    status: order.status,
    statusKey: order.status.toLowerCase(),
    defaultOpen: index === 0,
    subtotal: money(subtotal),
    tax: money(tax),
    total: money(subtotal + tax),
    lines: order.lines.map((line) => ({
      item: line.item,
      multiple: line.qty > 1,
      qty: line.qty,
      amount: money(line.qty * line.price),
    })),
  }
})

const Receipts = <template>
  <div class="ly-orders">
    <p class="ly-orders-head">Orders</p>
    {{#each orders key="id" as |order|}}
      <Receipt @defaultOpen={{order.defaultOpen}} as |r|>
        <section class="ly-order">
          <r.Trigger class="ly-order-trigger">
            <span class="ly-order-text">
              <span class="ly-order-id">Order #{{order.id}}</span>
              <span class="ly-order-meta">
                {{order.date}}
                ·
                <span data-status={{order.statusKey}}>
                  {{order.status}}
                </span>
              </span>
            </span>
            <span class="ly-order-total">{{order.total}}</span>
            <span class="ly-order-caret" aria-hidden="true">{{icon
                ChevronDown
                14
              }}</span>
          </r.Trigger>
          <r.Panel class="ly-receipt">
            <dl class="ly-receipt-lines">
              {{#each order.lines key="item" as |line|}}
                <div class="ly-receipt-line">
                  <dt>
                    {{line.item}}
                    {{#if line.multiple}}
                      <span class="ly-receipt-qty"> × {{line.qty}}</span>
                    {{/if}}
                  </dt>
                  <dd>{{line.amount}}</dd>
                </div>
              {{/each}}
              <div class="ly-receipt-line" data-kind="sum">
                <dt>Subtotal</dt>
                <dd>{{order.subtotal}}</dd>
              </div>
              <div class="ly-receipt-line" data-kind="sum">
                <dt>Tax</dt>
                <dd>{{order.tax}}</dd>
              </div>
              <div class="ly-receipt-line" data-kind="total">
                <dt>Total</dt>
                <dd>{{order.total}}</dd>
              </div>
            </dl>
          </r.Panel>
        </section>
      </Receipt>
    {{/each}}
  </div>
</template>

const stackOverlays = createOverlays()
const confirmRemoval = createConfirm({ overlays: stackOverlays })

const peopleSeed = [
  { name: "Amara Diallo", initials: "AD", role: "Can edit" },
  { name: "Kenji Sato", initials: "KS", role: "Can view" },
  { name: "Elif Kaya", initials: "EK", role: "Can view" },
]

class Stack extends Component {
  @tracked people = peopleSeed
  @tracked sharing = false
  @tracked menuFor: string | null = null
  @tracked asking: string | null = null
  content: HTMLElement | null = null
  hint = useShortcutHint("mod+backspace")
  stackOverlays = stackOverlays

  constructor(owner: ConstructorParameters<typeof Component>[0], args: {}) {
    super(owner, args)
    registerDestructor(
      this,
      registerShortcut(
        "mod+backspace",
        () => {
          const row =
            document.activeElement?.closest<HTMLElement>("[data-person]")
          if (row?.dataset.person) {
            this.remove(row.dataset.person)
          }
        },
        { layer: () => this.content, description: "Remove person" }
      )
    )
  }

  setContent = (el: Element) => {
    this.content = el as HTMLElement
    return () => {
      if (this.content === el) {
        this.content = null
      }
    }
  }

  remove = async (name: string) => {
    this.asking = name
    const removed = await confirmRemoval({
      title: `Remove ${name}?`,
      description: "They lose access to Q3 report.pdf right away.",
      confirmLabel: "Remove",
    })
    this.asking = null
    if (!removed) {
      return
    }
    const row = this.content?.querySelector(
      `[data-person="${CSS.escape(name)}"]`
    )
    const next = (
      row?.nextElementSibling ?? row?.previousElementSibling
    )?.querySelector("button")
    ;(next ?? this.content)?.focus()
    this.people = this.people.filter((person) => person.name !== name)
  }

  onSharingChange = (open: boolean) => {
    this.sharing = open
    if (!open) {
      this.menuFor = null
    }
  }

  onMenuChange = (name: string, open: boolean) => {
    this.menuFor = open ? name : null
  }

  onAction = (person: { name: string }, value: string) => {
    if (value === "remove") {
      this.remove(person.name)
      return
    }
    this.people = this.people.map((other) =>
      other === person ? { ...other, role: value } : other
    )
  }

  invite = () => {
    this.people = peopleSeed
  }

  get shared() {
    const count = this.people.length
    return `Shared with ${count} ${count === 1 ? "person" : "people"}`
  }

  get layers() {
    const names = [
      this.sharing && "Share popover",
      this.menuFor && `Role menu · ${this.menuFor.split(" ")[0]}`,
      this.asking && `Confirm · Remove ${this.asking.split(" ")[0]}?`,
    ].filter((layer): layer is string => !!layer)
    return names.map((name, index) => ({
      name,
      top: index === names.length - 1,
    }))
  }

  <template>
    <div class="ly-stack">
      <div class="ly-file">
        <span class="ly-file-icon" aria-hidden="true">
          {{icon FileText 20}}
        </span>
        <span class="ly-file-text">
          <span class="ly-file-name">Q3 report.pdf</span>
          <span class="ly-file-meta">
            {{this.shared}}
          </span>
        </span>
        <Popover @onOpenChange={{this.onSharingChange}} as |p|>
          <p.Trigger class="b-btn ly-trigger" data-variant="primary">
            Share
          </p.Trigger>
          <p.Content
            class="b-pop ly-share-pop"
            @align="end"
            @sideOffset={{8}}
            @collisionPadding={{12}}
            {{onInsert this.setContent}}
          >
            <p.Title class="ly-share-title">Share report</p.Title>
            <p.Description class="ly-share-desc">
              {{this.hint.text}}
              removes the focused person.
            </p.Description>
            {{#if this.people.length}}
              <ul class="ly-people">
                {{#each this.people key="name" as |person|}}
                  <li class="ly-person" data-person={{person.name}}>
                    <span class="ly-avatar" aria-hidden="true">
                      {{person.initials}}
                    </span>
                    <span class="ly-person-name">{{person.name}}</span>
                    <Menu
                      @onOpenChange={{fn this.onMenuChange person.name}}
                      @onAction={{fn this.onAction person}}
                      as |m|
                    >
                      <m.Trigger
                        class="ly-role"
                        aria-label={{concat person.name ": " person.role}}
                        aria-keyshortcuts={{this.hint.ariaKeyshortcuts}}
                      >
                        {{person.role}}
                        {{icon ChevronDown 12}}
                      </m.Trigger>
                      <m.Content
                        class="b-pop ly-menu"
                        @align="end"
                        @sideOffset={{4}}
                        @collisionPadding={{12}}
                      >
                        <m.Item @value="Can edit" class="b-item">
                          Can edit
                        </m.Item>
                        <m.Item @value="Can view" class="b-item">
                          Can view
                        </m.Item>
                        <m.Separator class="ly-menu-sep" />
                        <m.Item @value="remove" class="b-item ly-danger">
                          {{icon Trash2 14}}
                          Remove access
                        </m.Item>
                      </m.Content>
                    </Menu>
                  </li>
                {{/each}}
              </ul>
            {{else}}
              <button
                type="button"
                class="b-btn ly-people-reset"
                {{on "click" this.invite}}
              >
                Invite everyone back
              </button>
            {{/if}}
            <div class="ly-host">
              <OverlayHost @overlays={{this.stackOverlays}} />
            </div>
          </p.Content>
        </Popover>
      </div>
      <div class="ly-layers">
        <p class="ly-layers-label">Open layers</p>
        <ol class="ly-layers-list" aria-live="polite">
          {{#each this.layers key="name" as |layer|}}
            <li class="ly-layer" data-top={{if layer.top "" undefined}}>
              {{layer.name}}
              {{#if layer.top}}
                <kbd class="ly-esc">Esc</kbd>
              {{/if}}
            </li>
          {{else}}
            <li class="ly-layer" data-empty>
              Nothing open
            </li>
          {{/each}}
        </ol>
      </div>
    </div>
  </template>
}

export const tiles: Tile[] = [
  {
    id: "overlays-theme",
    title: "Light, dark or system.",
    blurb: "Themes its preview, and remembers after a reload.",
    size: "large",
    tone: "paper",
    Demo: Theme,
  },
  {
    id: "overlays-split",
    title: "The split remembers.",
    blurb: "Drag it, reload, and it stays put.",
    Demo: Split,
  },
  {
    id: "overlays-player",
    title: "Plays under a modal.",
    blurb: "The player stays live above the dialog.",
    tone: "ink",
    Demo: Player,
  },
  {
    id: "overlays-discard",
    title: "Discard changes?",
    blurb: "Escape asks first. Save and Cancel don’t.",
    tone: "butter",
    Demo: Note,
  },
  {
    id: "overlays-receipt",
    title: "Expand the receipt.",
    blurb: "Each panel animates to its own height.",
    size: "tall",
    Demo: Receipts,
  },
  {
    id: "overlays-stack",
    title: "Escape closes the top.",
    blurb: "Stacked layers close from the top down.",
    size: "wide",
    tone: "sky",
    Demo: Stack,
  },
]
