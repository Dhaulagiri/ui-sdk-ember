import type { TOC } from "@ember/component/template-only"
import { fn, get } from "@ember/helper"
import type Owner from "@ember/owner"
import { on } from "@ember/modifier"
import { registerDestructor } from "@ember/destroyable"
import { htmlSafe } from "@ember/template"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  bindLayer,
  createPopup,
  definePrimitive,
  popupClose,
  popupContent,
  popupState,
  popupTrigger,
  position,
} from "@ui-sdk/core"
import { popoverPreset } from "@ui-sdk/core/popover"
import {
  Archive,
  ArrowLeft,
  ArrowUpRight,
  Bell,
  CalendarDays,
  Check,
  ChevronDown,
  ChevronRight,
  ChevronUp,
  Clock,
  Copy,
  CreditCard,
  Database,
  Ellipsis,
  Eye,
  FileCode,
  File,
  Folder,
  GitBranch,
  GitPullRequest,
  House,
  KeyRound,
  MessageCircle,
  Pencil,
  Receipt,
  RefreshCw,
  Rocket,
  RotateCcw,
  Search,
  Settings,
  SquareTerminal,
  Trash2,
  TriangleAlert,
  UserPlus,
  Users,
  ChartLine,
  X,
  type IconNode,
} from "lucide"
import { AlertDialog, createConfirm } from "ember-ui-sdk/alert-dialog"
import { Command, createCommandController } from "ember-ui-sdk/command"
import { createDialogController, Dialog } from "ember-ui-sdk/dialog"
import { Drawer } from "ember-ui-sdk/drawer"
import { HoverCard } from "ember-ui-sdk/hover-card"
import { Menu } from "ember-ui-sdk/menu"
import { Menubar } from "ember-ui-sdk/menubar"
import { NavigationMenu } from "ember-ui-sdk/navigation-menu"
import { Popover } from "ember-ui-sdk/popover"
import { attach, createParts } from "ember-ui-sdk/primitive"
import { useShortcut, useShortcutHint } from "ember-ui-sdk/shortcuts"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { Tooltip } from "ember-ui-sdk/tooltip"
import "../../../vendor/ui/apps/docs/app/sink/tiles/overlays.css"
import { icon } from "../icon.ts"
import type { Tile } from "../types.ts"

const wait = (ms: number) =>
  new Promise<void>((resolve) => setTimeout(resolve, ms))

/** An icon that carries a class (and, for the odd one, an accessible name). */
function iconc(
  node: IconNode,
  size: number,
  className: string,
  label?: string
) {
  const svg = icon(node, size)
  svg.setAttribute("class", className)
  if (label) {
    svg.removeAttribute("aria-hidden")
    svg.setAttribute("aria-label", label)
    svg.setAttribute("role", "img")
  }
  return svg
}

const Avatar = <template>
  <span class="ov-avatar" data-size={{if @size @size "md"}} aria-hidden="true">
    {{@initials}}
  </span>
</template> as TOC<{
  Args: { initials: string; size?: "sm" | "md" | "lg" }
}>

/** Splits a formatted hint into keycaps: "Ctrl+Alt+N" or "⌘⌥N". */
const keysOf = (text: string) => {
  // The hint wraps its keys in bidi isolates (U+2066…U+2069); keep only the visible keys.
  const visible = text.replace(/[⁦-⁩]/g, "")
  return visible.includes("+") ? visible.split("+") : [...visible]
}

const Keys = <template>
  <span class="ov-keys" aria-hidden="true">
    {{#each (keysOf @text) as |key|}}
      <kbd class="ov-kbd">{{key}}</kbd>
    {{/each}}
  </span>
</template> as TOC<{ Args: { text: string } }>

const flag = (value: unknown) => (value ? "" : undefined)
const str = (value: unknown) => String(value ?? "")

/* 1. Command palette with pages, always open */

type PaletteEntry = {
  value: string
  label: string
  icon: IconNode
  page?: string
  shortcut?: string
  hint?: string
}

const paletteSuggested: PaletteEntry[] = [
  {
    value: "deploy",
    label: "Deploy to production",
    icon: Rocket,
    shortcut: "alt+shift+d",
  },
  {
    value: "rollback",
    label: "Roll back last deploy",
    icon: RotateCcw,
    shortcut: "alt+shift+r",
  },
  { value: "logs", label: "Tail production logs", icon: SquareTerminal },
]

const paletteNavigate: PaletteEntry[] = [
  {
    value: "projects",
    label: "Switch project…",
    icon: Folder,
    page: "projects",
    hint: "4",
  },
  {
    value: "people",
    label: "Assign ENG-506 to…",
    icon: Users,
    page: "people",
  },
  { value: "invoices", label: "Open invoices", icon: CreditCard },
  { value: "invite", label: "Invite to workspace", icon: UserPlus },
]

const paletteProjects = [
  { value: "atlas-api", detail: "Go · iad1" },
  { value: "web-dashboard", detail: "Next.js · edge" },
  { value: "billing-worker", detail: "Rust · queue" },
  { value: "docs-site", detail: "Astro · static" },
]

const palettePeople = [
  { value: "Priya Raman", initials: "PR", detail: "Backend" },
  { value: "Tomás Ortega", initials: "TO", detail: "Payments" },
  { value: "Mei Lin", initials: "ML", detail: "Design systems" },
]

const paletteResults: Record<string, string> = {
  deploy: "Live on production in 38s",
  rollback: "Rolled back to build 2207",
  logs: "Streaming logs from 6 regions",
  invoices: "Opened 3 unpaid invoices",
  invite: "Invite link copied",
}

const pageTitles: Record<string, string> = {
  projects: "Projects",
  people: "Assign",
}

class Palette extends Component {
  command = createCommandController()
  @tracked pages: string[] = []
  @tracked result = ""
  @tracked query = ""
  suggested = paletteSuggested
  navigate = paletteNavigate
  projects = paletteProjects
  people = palettePeople

  get page() {
    return this.pages.at(-1)
  }

  get crumb() {
    return this.page ? pageTitles[this.page] : ""
  }

  get placeholder() {
    return this.page ? "Filter…" : "Type a command or search…"
  }

  get showVercel() {
    const query = this.query.trim()
    return query.length >= 3 && "vercel".startsWith(query.toLowerCase())
  }

  get results() {
    return this.result ? [this.result] : []
  }

  get busy() {
    return this.result.endsWith("…") ? "" : undefined
  }

  setPages = (pages: string[]) => {
    this.pages = pages
  }

  setQuery = (query: string) => {
    this.query = query
  }

  run = async (value: string) => {
    if (value === "back") {
      return this.command.pop()
    }
    const { page } = this
    if (page === "projects") {
      this.result = `Switched to ${value}`
    } else if (page === "people") {
      this.result = `ENG-506 assigned to ${value}`
    } else if (value === "vercel") {
      this.result = "Building on ▲…"
      await wait(900)
      this.result = "▲ Ready. Deployed to production in 0.9s"
    } else if (value === "deploy") {
      this.result = "Deploying…"
      await wait(1200)
      this.result = paletteResults["deploy"]!
    } else {
      this.result = paletteResults[value] ?? value
    }
    if (page) {
      this.pages = []
    }
  }

  <template>
    <Command
      class="ov-cmd"
      @controller={{this.command}}
      @pages={{this.pages}}
      @onPagesChange={{this.setPages}}
      @onAction={{this.run}}
      @onQueryChange={{this.setQuery}}
      @loop={{true}}
      as |c|
    >
      <div class="ov-cmd-search">
        {{icon Search 16}}
        {{#if this.page}}<span class="ov-cmd-crumb">{{this.crumb}}</span>{{/if}}
        <c.Input
          aria-label="Search commands"
          placeholder={{this.placeholder}}
          class="ov-cmd-input"
        />
      </div>
      <c.Empty class="ov-cmd-empty">Nothing matches that.</c.Empty>
      <c.List class="ov-cmd-list">
        <c.Page as |p|>
          <p.Group class="ov-cmd-group" as |g|>
            <g.Label class="ov-cmd-label">Suggested</g.Label>
            {{#each this.suggested key="value" as |entry|}}
              <g.Item
                @value={{entry.value}}
                @page={{entry.page}}
                @shortcut={{entry.shortcut}}
                @label={{entry.label}}
                class="ov-cmd-item"
                as |item|
              >
                <item.Icon class="ov-cmd-icon">{{icon
                    entry.icon
                    16
                  }}</item.Icon>
                <item.Text class="ov-cmd-text">{{entry.label}}</item.Text>
                {{#if entry.hint}}<span
                    class="ov-cmd-hint"
                  >{{entry.hint}}</span>{{/if}}
                {{#if entry.shortcut}}<item.Shortcut
                    class="ov-cmd-shortcut"
                  />{{/if}}
                {{#if entry.page}}{{iconc
                    ChevronRight
                    16
                    "ov-cmd-caret"
                  }}{{/if}}
              </g.Item>
            {{/each}}
          </p.Group>
          <p.Group class="ov-cmd-group" as |g|>
            <g.Label class="ov-cmd-label">Navigate</g.Label>
            {{#each this.navigate key="value" as |entry|}}
              <g.Item
                @value={{entry.value}}
                @page={{entry.page}}
                @shortcut={{entry.shortcut}}
                @label={{entry.label}}
                class="ov-cmd-item"
                as |item|
              >
                <item.Icon class="ov-cmd-icon">{{icon
                    entry.icon
                    16
                  }}</item.Icon>
                <item.Text class="ov-cmd-text">{{entry.label}}</item.Text>
                {{#if entry.hint}}<span
                    class="ov-cmd-hint"
                  >{{entry.hint}}</span>{{/if}}
                {{#if entry.shortcut}}<item.Shortcut
                    class="ov-cmd-shortcut"
                  />{{/if}}
                {{#if entry.page}}{{iconc
                    ChevronRight
                    16
                    "ov-cmd-caret"
                  }}{{/if}}
              </g.Item>
            {{/each}}
          </p.Group>
          {{#if this.showVercel}}
            <p.Item
              @value="vercel"
              @label="vercel --prod"
              class="ov-cmd-item"
              as |item|
            >
              <item.Icon class="ov-cmd-icon">
                <span class="ov-cmd-vercel" aria-hidden="true">▲</span>
              </item.Icon>
              <item.Text class="ov-cmd-text ov-cmd-mono">vercel --prod</item.Text>
            </p.Item>
          {{/if}}
        </c.Page>
        <c.Page @value="projects" as |p|>
          {{#each this.projects key="value" as |project|}}
            <p.Item @value={{project.value}} class="ov-cmd-item" as |item|>
              <item.Icon class="ov-cmd-icon">{{icon Folder 16}}</item.Icon>
              <item.Text
                class="ov-cmd-text ov-cmd-mono"
              >{{project.value}}</item.Text>
              <span class="ov-cmd-hint">{{project.detail}}</span>
            </p.Item>
          {{/each}}
        </c.Page>
        <c.Page @value="people" as |p|>
          {{#each this.people key="value" as |person|}}
            <p.Item @value={{person.value}} class="ov-cmd-item" as |item|>
              <Avatar @initials={{person.initials}} @size="sm" />
              <item.Text class="ov-cmd-text">{{person.value}}</item.Text>
              <span class="ov-cmd-hint">{{person.detail}}</span>
            </p.Item>
          {{/each}}
        </c.Page>
        {{#if this.page}}
          <c.Item @value="back" class="ov-cmd-item" as |item|>
            <item.Icon @mirror={{true}} class="ov-cmd-icon">{{icon
                ArrowLeft
                16
              }}</item.Icon>
            Go back
          </c.Item>
        {{/if}}
      </c.List>
      <footer class="ov-cmd-foot">
        <output class="ov-cmd-result">
          {{#each this.results key="@identity" as |result|}}
            <span class="ov-cmd-done" data-busy={{this.busy}}>
              {{icon Check 13}}
              {{result}}
            </span>
          {{/each}}
        </output>
        <span class="ov-cmd-keys">
          <span>
            <kbd class="ov-kbd">↵</kbd>
            Run
          </span>
          {{#if this.page}}
            <span>
              <kbd class="ov-kbd">⌫</kbd>
              Back
            </span>
          {{/if}}
        </span>
      </footer>
    </Command>
  </template>
}

/* 2. Dialog with an async close action */

type OpenDetails = { reason?: string }

class Invite extends Component {
  @tracked email = ""
  @tracked error = ""
  @tracked sent: string[] = []

  get more() {
    return 4 + this.sent.length
  }

  get status() {
    const last = this.sent.at(-1)
    return last ? `Invite sent to ${last}` : "7 members · 2 admins"
  }

  get invalid() {
    return this.error ? "true" : undefined
  }

  get invalidFlag() {
    return this.error ? "" : undefined
  }

  setEmail = (event: Event) => {
    this.email = (event.target as HTMLInputElement).value
  }

  send = async () => {
    if (!/^\S+@\S+\.\S+$/.test(this.email)) {
      this.error = "Enter a work email address."
      throw new Error("invalid")
    }
    this.error = ""
    await wait(900)
  }

  onOpenChange = (open: boolean, details: OpenDetails) => {
    if (open) {
      this.email = ""
      this.error = ""
    } else if (details.reason === "action") {
      this.sent = [...this.sent, this.email]
    }
  }

  <template>
    <div class="ov-team">
      <div class="ov-team-avatars">
        <Avatar @initials="JB" @size="lg" />
        <Avatar @initials="AO" @size="lg" />
        <Avatar @initials="SR" @size="lg" />
        <span
          class="ov-avatar ov-avatar-more"
          data-size="lg"
          aria-hidden="true"
        >+{{this.more}}</span>
      </div>
      <p class="ov-team-name">Helix team</p>
      <p class="ov-team-meta">{{this.status}}</p>
      <Dialog @onOpenChange={{this.onOpenChange}} as |d|>
        <d.Trigger class="b-btn ov-trigger" data-variant="primary">
          {{icon UserPlus 16}}
          Invite people
        </d.Trigger>
        <d.Backdrop class="ov-backdrop" />
        <d.Content class="ov-dialog">
          <d.Title class="ov-dialog-title">Invite to Helix</d.Title>
          <d.Description class="ov-dialog-desc">
            They can deploy every Helix project.
          </d.Description>
          <label class="ov-field">
            <span class="b-label">Work email</span>
            <input
              class="b-input"
              type="email"
              placeholder="name@helix.dev"
              value={{this.email}}
              aria-invalid={{this.invalid}}
              data-invalid={{this.invalidFlag}}
              {{on "input" this.setEmail}}
            />
            {{#if this.error}}<span
                class="ov-field-error"
              >{{this.error}}</span>{{/if}}
          </label>
          <div class="ov-actions">
            <d.Close class="b-btn">Not now</d.Close>
            <d.Close
              class="b-btn"
              data-variant="primary"
              @action={{this.send}}
              as |c|
            >{{if c.state.pending "Sending…" "Send invite"}}</d.Close>
          </div>
          <d.Close class="ov-dialog-x" aria-label="Close">{{icon
              X
              16
            }}</d.Close>
        </d.Content>
      </Dialog>
    </div>
  </template>
}

/* 3. AlertDialog with a pending destructive action */

class DeleteProject extends Component {
  @tracked deleted = false
  restore?: HTMLButtonElement

  get meta() {
    return this.deleted ? "Deleted just now" : "Last deploy 41 days ago"
  }

  get deletedFlag() {
    return flag(this.deleted)
  }

  setRestore = (el: HTMLButtonElement) => {
    this.restore = el
  }

  undelete = () => {
    this.deleted = false
  }

  remove = () => wait(1100)

  onOpenChange = (open: boolean, details: OpenDetails) => {
    if (!open && details.reason === "action") {
      this.deleted = true
    }
  }

  onOpenChangeComplete = (open: boolean) => {
    if (!open) {
      this.restore?.focus()
    }
  }

  <template>
    <div class="ov-project" data-deleted={{this.deletedFlag}}>
      <div class="ov-project-head">
        <span class="ov-project-icon">{{icon Clock 16}}</span>
        <div class="ov-project-text">
          <p class="ov-project-name">legacy-cron</p>
          <p class="ov-project-meta">{{this.meta}}</p>
        </div>
      </div>
      <AlertDialog
        @pendingAnnouncement="Deleting legacy-cron"
        @onOpenChange={{this.onOpenChange}}
        @onOpenChangeComplete={{this.onOpenChangeComplete}}
        as |d|
      >
        {{#if this.deleted}}
          <button
            type="button"
            class="b-btn ov-wide-btn"
            {{attach this.setRestore}}
            {{on "click" this.undelete}}
          >
            {{icon RotateCcw 16}}
            Restore project
          </button>
        {{else}}
          <d.Trigger class="b-btn ov-wide-btn">
            {{icon Trash2 16}}
            Delete project
          </d.Trigger>
        {{/if}}
        <d.Backdrop class="ov-backdrop" />
        <d.Content class="ov-dialog ov-alert">
          <span class="ov-alert-icon">{{icon TriangleAlert 16}}</span>
          <d.Title class="ov-dialog-title">Delete legacy-cron?</d.Title>
          <d.Description class="ov-dialog-desc">
            Its 12 deployments and both domains go with it. This can’t be
            undone.
          </d.Description>
          <div class="ov-actions">
            <d.Close class="b-btn">Cancel</d.Close>
            <d.Close
              @value="confirm"
              class="b-btn ov-destroy"
              @action={{this.remove}}
              as |c|
            >{{if c.state.pending "Deleting…" "Delete project"}}</d.Close>
          </div>
        </d.Content>
      </AlertDialog>
    </div>
  </template>
}

/* 4. createConfirm: await an answer from a row action */

const tokenSeed = [
  { name: "ci-runner", id: "sk_live_…4f2a" },
  { name: "grafana-sync", id: "sk_live_…91cd" },
  { name: "local-dev", id: "sk_test_…07be" },
]

class Tokens extends Component {
  confirm = createConfirm<{ name: string }>()
  @tracked tokens = tokenSeed
  reset?: HTMLButtonElement

  setReset = (el: HTMLButtonElement) => {
    this.reset = el
  }

  restoreAll = () => {
    this.tokens = tokenSeed
  }

  revoke = async (name: string, event: Event) => {
    const button = event.currentTarget as HTMLButtonElement
    if (!(await this.confirm({ name }))) {
      return
    }
    const row = button.closest("li")
    const next = (
      row?.nextElementSibling ?? row?.previousElementSibling
    )?.querySelector("button")
    ;(next ?? this.reset)?.focus()
    this.tokens = this.tokens.filter((token) => token.name !== name)
  }

  <template>
    <div class="ov-tokens">
      <p class="ov-tokens-head">
        {{icon KeyRound 14}}
        API tokens
      </p>
      {{#if this.tokens.length}}
        <ul class="ov-tokens-list">
          {{#each this.tokens key="name" as |token|}}
            <li class="ov-token">
              <span class="ov-token-text">
                <span class="ov-token-name">{{token.name}}</span>
                <span class="ov-token-id">{{token.id}}</span>
              </span>
              <button
                type="button"
                class="b-btn ov-token-revoke"
                aria-label="Revoke {{token.name}}"
                {{on "click" (fn this.revoke token.name)}}
              >Revoke</button>
            </li>
          {{/each}}
        </ul>
      {{else}}
        <div class="ov-tokens-empty">
          <p>No active tokens</p>
          <button
            type="button"
            class="b-btn"
            {{attach this.setReset}}
            {{on "click" this.restoreAll}}
          >Restore tokens</button>
        </div>
      {{/if}}
      <AlertDialog @controller={{this.confirm.controller}} as |d|>
        <d.Backdrop class="ov-backdrop" />
        <d.Content class="ov-dialog ov-alert" as |content|>
          <span class="ov-alert-icon">{{icon KeyRound 14}}</span>
          <d.Title class="ov-dialog-title">Revoke
            {{content.state.payload.name}}?</d.Title>
          <d.Description class="ov-dialog-desc">
            Anything still using this token starts getting 401s right away.
          </d.Description>
          <div class="ov-actions">
            <d.Close class="b-btn">Keep it</d.Close>
            <d.Close @value="confirm" class="b-btn ov-destroy">Revoke token</d.Close>
          </div>
        </d.Content>
      </AlertDialog>
    </div>
  </template>
}

/* 5. createDialogController: open from code and await a value */

const regionList = [
  { id: "iad1", city: "Washington, D.C.", ms: "18 ms" },
  { id: "sfo1", city: "San Francisco", ms: "64 ms" },
  { id: "fra1", city: "Frankfurt", ms: "97 ms" },
  { id: "hnd1", city: "Tokyo", ms: "152 ms" },
]

class Region extends Component {
  picker = createDialogController<string, string>()
  regions = regionList
  @tracked region = "fra1"
  @tracked moving: string | null = null
  @tracked isOpen = false

  get current() {
    return regionList.find((r) => r.id === this.region)!
  }

  get city() {
    return this.moving ? "Migrating…" : this.current.city
  }

  get meta() {
    return this.moving
      ? `Copying to ${this.moving}, writes paused`
      : `${this.current.id} · primary · 2.4 GB`
  }

  get openFlag() {
    return flag(this.isOpen)
  }

  get busy() {
    return this.moving ? true : undefined
  }

  isCurrent = (payload: unknown, id: string) => payload === id

  currentFlag = (payload: unknown, id: string) => flag(payload === id)

  setOpen = (open: boolean) => {
    this.isOpen = open
  }

  move = async () => {
    const { returnValue } = await this.picker.open({ payload: this.region })
    if (!returnValue || returnValue === this.region) {
      return
    }
    this.moving = returnValue
    await wait(1400)
    this.region = returnValue
    this.moving = null
  }

  <template>
    <div class="ov-region">
      <p class="ov-region-lead">
        {{icon Database 16}}
        pg-main
      </p>
      <p class="ov-region-city">{{this.city}}</p>
      <p class="ov-region-meta">{{this.meta}}</p>
      <button
        type="button"
        class="b-btn ov-trigger"
        aria-haspopup="dialog"
        data-open={{this.openFlag}}
        disabled={{this.busy}}
        {{on "click" this.move}}
      >Move region…</button>
      <Dialog @controller={{this.picker}} @onOpenChange={{this.setOpen}} as |d|>
        <d.Backdrop class="ov-backdrop" />
        <d.Content class="ov-dialog ov-region-dialog" as |content|>
          <d.Title class="ov-dialog-title">Move pg-main</d.Title>
          <d.Description class="ov-dialog-desc">
            Pick the region nearest your traffic.
          </d.Description>
          <div class="ov-region-list">
            {{#each this.regions key="id" as |r|}}
              <d.Close
                @value={{r.id}}
                class="ov-region-option"
                data-current={{this.currentFlag content.state.payload r.id}}
                aria-current={{if
                  (this.isCurrent content.state.payload r.id)
                  "true"
                }}
              >
                <span class="ov-region-id">{{r.id}}</span>
                <span class="ov-region-name">{{r.city}}</span>
                <span class="ov-region-ms">{{r.ms}}</span>
                {{iconc Check 16 "ov-region-check"}}
              </d.Close>
            {{/each}}
          </div>
        </d.Content>
      </Dialog>
    </div>
  </template>
}

/* 6. Drawer with snap points and a handle */

const logLines = [
  ["00:01", "Cloning acme/payments-gateway"],
  ["00:03", "Restored build cache from build 4820"],
  ["00:05", "Installing 412 packages with pnpm"],
  ["00:19", "Running tsc --build"],
  ["00:31", "src/ledger/settle.ts:88 error TS2322"],
  ["00:31", "  Type 'Cents' is not assignable to type 'number'."],
  ["00:32", "Found 1 error in src/ledger/settle.ts"],
  ["00:32", "Command failed with exit code 2"],
  ["00:48", "Build failed. Previous deploy keeps serving."],
] as const

const logErrorFlag = (text: string) =>
  flag(/error|failed|assignable/i.test(text))

const snapPoints = [0.5, 1]

class BuildLog extends Component {
  @tracked status: "failed" | "queued" | "ready" = "failed"
  lines = logLines
  snapPoints = snapPoints
  logErrorFlag = logErrorFlag

  get label() {
    return { failed: "Build failed", queued: "Rebuilding", ready: "Live" }[
      this.status
    ]
  }

  get locked() {
    return this.status !== "failed"
  }

  retry = async () => {
    await wait(1000)
    this.status = "queued"
    setTimeout(() => (this.status = "ready"), 2200)
  }

  <template>
    <div class="ov-build">
      <p class="ov-build-status" data-status={{this.status}}>
        <span class="ov-dot" aria-hidden="true"></span>
        {{this.label}}
      </p>
      <p class="ov-build-name">payments-gateway</p>
      <p class="ov-build-meta">Build 4821 · 48s</p>
      <Drawer @snapPoints={{this.snapPoints}} @defaultSnapPoint={{0.5}} as |d|>
        <d.Trigger class="b-btn ov-trigger">
          {{icon SquareTerminal 16}}
          View log
        </d.Trigger>
        <d.Backdrop class="ov-drawer-backdrop" />
        <d.Content class="ov-drawer">
          <d.Handle aria-label="Resize log" class="ov-handle" />
          <header class="ov-drawer-head">
            <div>
              <d.Title class="ov-dialog-title">Build 4821</d.Title>
              <d.Description class="ov-dialog-desc">
                payments-gateway failed after 48s.
              </d.Description>
            </div>
            <d.Close
              class="b-btn"
              data-variant="primary"
              @action={{this.retry}}
              disabled={{this.locked}}
              as |c|
            >{{if c.state.pending "Queuing…" "Retry build"}}</d.Close>
          </header>
          <ol class="ov-log">
            {{#each this.lines as |line|}}
              <li data-error={{this.logErrorFlag (get line 1)}}>
                <span class="ov-log-time">{{get line 0}}</span>
                <span>{{get line 1}}</span>
              </li>
            {{/each}}
          </ol>
        </d.Content>
      </Drawer>
    </div>
  </template>
}

/* 7. Popover with an arrow and a small form */

const releaseSlots = [
  { id: "tonight", day: "Tonight", time: "22:00" },
  { id: "tomorrow", day: "Tomorrow", time: "07:30" },
  { id: "monday", day: "Monday", time: "10:00" },
]

class Schedule extends Component {
  @tracked pick = "tomorrow"
  @tracked scheduled: string | null = null
  slots = releaseSlots

  get chosen() {
    return releaseSlots.find((slot) => slot.id === this.scheduled)
  }

  get meta() {
    const { chosen } = this
    return chosen
      ? `Ships ${chosen.day.toLowerCase()} at ${chosen.time}`
      : "12 commits since v2.13.2"
  }

  get label() {
    return this.chosen ? "Reschedule" : "Schedule"
  }

  checked = (id: string) => (this.pick === id ? "true" : "false")

  choose = (id: string) => {
    this.pick = id
  }

  schedule = () => {
    this.scheduled = this.pick
  }

  <template>
    <div class="ov-release">
      <p class="ov-release-tag">
        {{icon GitPullRequest 16}}
        Release
      </p>
      <p class="ov-release-version">v2.14.0</p>
      <p class="ov-release-meta">{{this.meta}}</p>
      <Popover as |p|>
        <p.Trigger class="b-btn ov-trigger">
          {{icon CalendarDays 16}}
          {{this.label}}
        </p.Trigger>
        <p.Content
          class="b-pop ov-pop"
          @side="bottom"
          @sideOffset={{10}}
          @collisionPadding={{12}}
        >
          <p.Arrow class="ov-arrow" />
          <p.Title class="ov-pop-title">Ship v2.14.0</p.Title>
          <p.Description class="ov-pop-desc">
            Rolls out to all regions.
          </p.Description>
          <div class="ov-slots" role="radiogroup" aria-label="Release time">
            {{#each this.slots key="id" as |slot|}}
              <button
                type="button"
                role="radio"
                aria-checked={{this.checked slot.id}}
                class="ov-slot"
                {{on "click" (fn this.choose slot.id)}}
              >
                <span>{{slot.day}}</span>
                <span class="ov-slot-time">{{slot.time}}</span>
              </button>
            {{/each}}
          </div>
          <p.Close
            class="b-btn ov-pop-submit"
            data-variant="primary"
            {{on "click" this.schedule}}
          >Schedule release</p.Close>
        </p.Content>
      </Popover>
    </div>
  </template>
}

/* 8. Tooltips with shortcut hints, bound with useShortcut */

const diffFiles = [
  { path: "src/api/handlers.ts", add: 24, del: 9 },
  { path: "src/lib/ratelimit.ts", add: 61, del: 0 },
  { path: "test/ratelimit.test.ts", add: 38, del: 2 },
  { path: "package.json", add: 1, del: 1 },
]

const ToolButton = <template>
  <Tooltip @shortcut={{@keys}} @delay={{300}} as |t|>
    <t.Trigger
      class="ov-tool"
      aria-label={{@label}}
      aria-pressed={{@pressed}}
      {{on "click" @onPress}}
    >{{yield}}</t.Trigger>
    <t.Content class="ov-tip" @sideOffset={{8}}>
      <t.Arrow class="ov-tip-arrow" />
      {{@label}}
      <t.Shortcut class="ov-tip-key" />
    </t.Content>
  </Tooltip>
</template> as TOC<{
  Args: {
    label: string
    keys: string
    onPress: () => void
    pressed?: "true" | "false"
  }
  Blocks: { default: [] }
}>

class DiffToolbar extends Component {
  @tracked index = 0
  @tracked viewed: number[] = []
  inside = false
  files = diffFiles

  constructor(owner: Owner, args: object) {
    super(owner, args)
    const when = () => this.inside
    useShortcut(this, "k", this.prev, { when, description: "Previous file" })
    useShortcut(this, "j", this.next, { when, description: "Next file" })
    useShortcut(this, "v", this.toggle, {
      when,
      description: "Mark file viewed",
    })
  }

  get file() {
    return diffFiles[this.index]!
  }

  get position() {
    return `${this.index + 1} / ${diffFiles.length}`
  }

  get viewedCount() {
    return this.viewed.length
  }

  get pressed() {
    return this.viewed.includes(this.index) ? "true" : "false"
  }

  viewedFlag = (i: number) => flag(this.viewed.includes(i))
  currentFlag = (i: number) => flag(i === this.index)

  prev = () => {
    this.index = Math.max(0, this.index - 1)
  }

  next = () => {
    this.index = Math.min(diffFiles.length - 1, this.index + 1)
  }

  toggle = () => {
    const { index } = this
    this.viewed = this.viewed.includes(index)
      ? this.viewed.filter((i) => i !== index)
      : [...this.viewed, index]
  }

  enter = () => {
    this.inside = true
  }

  leave = (event: FocusEvent) => {
    if (
      !(event.currentTarget as Element).contains(event.relatedTarget as Node)
    ) {
      this.inside = false
    }
  }

  <template>
    <div
      class="ov-diff"
      {{on "focusin" this.enter}}
      {{on "focusout" this.leave}}
    >
      <div class="ov-diff-bar" role="toolbar" aria-label="Review">
        <ToolButton @label="Previous file" @keys="k" @onPress={{this.prev}}>
          {{icon ChevronUp 16}}
        </ToolButton>
        <ToolButton @label="Next file" @keys="j" @onPress={{this.next}}>
          {{icon ChevronDown 16}}
        </ToolButton>
        <span class="ov-diff-sep" aria-hidden="true"></span>
        <ToolButton
          @label="Mark viewed"
          @keys="v"
          @onPress={{this.toggle}}
          @pressed={{this.pressed}}
        >
          {{icon Eye 16}}
        </ToolButton>
        <span class="ov-diff-count">{{this.position}}</span>
      </div>
      <p class="ov-diff-path" aria-live="polite">{{this.file.path}}</p>
      <p class="ov-diff-stats">
        <span class="ov-diff-add">+{{this.file.add}}</span>
        <span class="ov-diff-del">−{{this.file.del}}</span>
        <span class="ov-diff-viewed">{{this.viewedCount}} of 4 viewed</span>
      </p>
      <div class="ov-diff-progress" aria-hidden="true">
        {{#each this.files as |_file i|}}
          <span
            data-viewed={{this.viewedFlag i}}
            data-current={{this.currentFlag i}}
          ></span>
        {{/each}}
      </div>
    </div>
  </template>
}

/* 9. useShortcut with platform-aware hints */

const quickKeys = [
  { keys: "mod+alt+n", label: "New branch", result: "Created feat/usage-caps" },
  {
    keys: "mod+alt+p",
    label: "Deploy preview",
    result: "Preview queued for pr-318",
  },
  {
    keys: "alt+shift+i",
    label: "Invite teammate",
    result: "Invite link ready to paste",
  },
]

type QuickItem = (typeof quickKeys)[number]

class QuickKey extends Component<{
  Args: { item: QuickItem; onRun: () => void; hit: boolean }
}> {
  hint = useShortcutHint(() => this.args.item.keys)

  constructor(owner: Owner, args: never) {
    super(owner, args)
    useShortcut(this, this.args.item.keys, () => this.args.onRun(), {
      description: this.args.item.label,
    })
  }

  get hit() {
    return flag(this.args.hit)
  }

  <template>
    <button
      type="button"
      class="ov-quick"
      data-hit={{this.hit}}
      aria-keyshortcuts={{this.hint.ariaKeyshortcuts}}
      {{on "click" @onRun}}
    >
      <span>{{@item.label}}</span>
      <Keys @text={{this.hint.text}} />
    </button>
  </template>
}

class QuickKeys extends Component {
  @tracked last: number | null = null
  @tracked flash = false
  items = quickKeys
  timer?: ReturnType<typeof setTimeout>

  constructor(owner: Owner, args: object) {
    super(owner, args)
    registerDestructor(this, () => clearTimeout(this.timer))
  }

  get output() {
    return this.last === null
      ? "Works from anywhere on the page"
      : quickKeys[this.last]!.result
  }

  hit = (index: number) => this.flash && this.last === index

  run = (index: number) => {
    this.last = index
    this.flash = true
    clearTimeout(this.timer)
    this.timer = setTimeout(() => (this.flash = false), 650)
  }

  <template>
    <div class="ov-quickkeys">
      {{#each this.items key="keys" as |item index|}}
        <QuickKey
          @item={{item}}
          @hit={{this.hit index}}
          @onRun={{fn this.run index}}
        />
      {{/each}}
      <output class="ov-quick-out">{{this.output}}</output>
    </div>
  </template>
}

/* 10. HoverCard on a mention */

const preventDefault = (event: Event) => event.preventDefault()

const Mention = <template>
  <article class="ov-comment">
    <header class="ov-comment-head">
      <Avatar @initials="RS" />
      <span class="ov-comment-who">Ravi Shah</span>
      <span class="ov-comment-when">4m</span>
    </header>
    <div class="ov-comment-body">
      Retry budgets are per tenant now.
      <HoverCard @delay={{250}} as |h|>
        <h.Trigger
          href="#lena-fischer"
          class="ov-mention"
          {{on "click" preventDefault}}
        >@lena</h.Trigger>
        <h.Content
          class="b-pop ov-card"
          @sideOffset={{10}}
          @collisionPadding={{12}}
        >
          <h.Arrow class="ov-arrow" />
          <div class="ov-card-head">
            <Avatar @initials="LF" @size="lg" />
            <div>
              <div class="ov-card-name">Lena Fischer</div>
              <div class="ov-card-role">Platform · Berlin</div>
            </div>
          </div>
          <div class="ov-card-row">
            {{icon Clock 14}}
            16:42 local time
          </div>
          <div class="ov-card-row ov-card-oncall">
            <span class="ov-dot" aria-hidden="true"></span>
            On call until Friday
          </div>
        </h.Content>
      </HoverCard>
      can you sanity-check the alert thresholds?
    </div>
  </article>
</template>

/* 11. Row menus with submenus, each trigger wearing a tooltip */

const deployRows = [
  {
    sha: "d8f3a1c",
    message: "Cap webhook backoff at 30s",
    branch: "main",
    status: "Ready",
    age: "2m",
    prod: true,
  },
  {
    sha: "41be09f",
    message: "Spend limits on the billing page",
    branch: "feat/spend-limits",
    status: "Building",
    age: "6m",
    prod: false,
  },
  {
    sha: "9c27e4d",
    message: "Move sessions to Redis 7",
    branch: "infra/redis-7",
    status: "Error",
    age: "1h",
    prod: false,
  },
]

const deployActions: Record<string, (sha: string) => string> = {
  visit: (sha) => `Opened preview for ${sha}`,
  redeploy: (sha) => `Redeploying ${sha}`,
  promote: (sha) => `Promoted ${sha} to production`,
  "copy-url": (sha) => `Copied ${sha}.preview.relay.app`,
  "copy-sha": (sha) => `Copied ${sha}`,
  "copy-branch": () => "Copied branch name",
  logs: (sha) => `Opened logs for ${sha}`,
}

const lower = (text: string) => text.toLowerCase()

class Deploys extends Component {
  @tracked note = ""
  rows = deployRows
  lower = lower

  act = (sha: string, value: string) => {
    this.note = deployActions[value]?.(sha) ?? ""
  }

  <template>
    <div class="ov-deploys">
      <div class="ov-deploys-head">
        <p class="ov-deploys-title">Deployments</p>
        <output class="ov-deploys-note">{{this.note}}</output>
      </div>
      <ul class="ov-deploys-list">
        {{#each this.rows key="sha" as |row|}}
          <li class="ov-deploy">
            <span
              class="ov-deploy-status"
              data-status={{this.lower row.status}}
            >
              <span class="ov-dot" aria-hidden="true"></span>
              {{row.status}}
            </span>
            <span class="ov-deploy-msg">
              <span class="ov-deploy-text">{{row.message}}</span>
              <span class="ov-deploy-sha">{{row.sha}}</span>
            </span>
            <span class="ov-deploy-branch">
              {{icon GitBranch 14}}
              {{row.branch}}
            </span>
            <span class="ov-deploy-age">{{row.age}}</span>
            <Menu @onAction={{fn this.act row.sha}} as |m|>
              <Tooltip @delay={{400}} as |t|>
                <m.Trigger @render={{true}} as |mt|>
                  <t.Trigger @render={{true}} as |tt|>
                    <button
                      type="button"
                      class="ov-dots"
                      aria-label="Actions for {{row.sha}}"
                      {{mt.part}}
                      {{tt.part}}
                    >{{icon Ellipsis 16}}</button>
                  </t.Trigger>
                </m.Trigger>
                <t.Content class="ov-tip" @side="top" @sideOffset={{6}}>
                  More actions
                </t.Content>
              </Tooltip>
              <m.Content
                class="b-pop ov-menu"
                @align="end"
                @sideOffset={{6}}
                @collisionPadding={{12}}
              >
                <m.Item @value="visit" class="b-item ov-menu-item">
                  <m.ItemIcon class="ov-menu-icon">{{icon
                      ArrowUpRight
                      14
                    }}</m.ItemIcon>
                  Visit preview
                </m.Item>
                <m.Item @value="redeploy" class="b-item ov-menu-item">
                  <m.ItemIcon class="ov-menu-icon">{{icon
                      RefreshCw
                      14
                    }}</m.ItemIcon>
                  Redeploy
                </m.Item>
                <m.Item
                  @value="promote"
                  class="b-item ov-menu-item"
                  @disabled={{row.prod}}
                >
                  <m.ItemIcon class="ov-menu-icon">{{icon
                      Rocket
                      14
                    }}</m.ItemIcon>
                  Promote to production
                </m.Item>
                <m.Sub as |s|>
                  <s.Trigger class="b-item ov-menu-item">
                    <m.ItemIcon class="ov-menu-icon">{{icon
                        Copy
                        14
                      }}</m.ItemIcon>
                    Copy
                    {{iconc ChevronRight 14 "ov-menu-caret"}}
                  </s.Trigger>
                  <s.Content class="b-pop ov-menu" @collisionPadding={{12}}>
                    <s.Item @value="copy-url" class="b-item ov-menu-item">
                      Preview URL
                    </s.Item>
                    <s.Item @value="copy-sha" class="b-item ov-menu-item">
                      Commit SHA
                    </s.Item>
                    <s.Item @value="copy-branch" class="b-item ov-menu-item">
                      Branch name
                    </s.Item>
                  </s.Content>
                </m.Sub>
                <m.Separator class="ov-menu-sep" />
                <m.Item @value="logs" class="b-item ov-menu-item">
                  <m.ItemIcon class="ov-menu-icon">{{icon
                      SquareTerminal
                      14
                    }}</m.ItemIcon>
                  Runtime logs
                </m.Item>
              </m.Content>
            </Menu>
          </li>
        {{/each}}
      </ul>
    </div>
  </template>
}

/* 12. Context menu on file rows */

const treeSeed = ["Dockerfile", "deploy.yml", "schema.prisma", "README.md"]

class FileTree extends Component {
  @tracked files = treeSeed
  @tracked note = "Right-click a file"
  str = str

  get empty() {
    return this.files.length === 0
  }

  restore = () => {
    this.files = treeSeed
  }

  act = (value: string, file: string) => {
    if (value === "copy") {
      this.note = `Copied infra/${file}`
    }
    if (value === "open") {
      this.note = `Opened ${file}`
    }
    if (value === "duplicate") {
      const dot = file.lastIndexOf(".")
      const copy =
        dot > 0
          ? `${file.slice(0, dot)}-copy${file.slice(dot)}`
          : `${file}-copy`
      this.files = this.files.includes(copy)
        ? this.files
        : this.files.flatMap((f) => (f === file ? [f, copy] : [f]))
      this.note = `Duplicated ${file}`
    }
    if (value === "trash") {
      this.files = this.files.filter((f) => f !== file)
      this.note = `Moved ${file} to trash`
    }
  }

  <template>
    <div class="ov-tree">
      <p class="ov-tree-head">
        {{icon Folder 14}}
        infra
        <span class="ov-tree-hint">
          or focus and
          <kbd class="ov-kbd">⇧F10</kbd>
        </span>
      </p>
      <Menu as |m|>
        <ul class="ov-tree-list">
          {{#each this.files key="@identity" as |file|}}
            <li>
              <m.ContextTrigger
                @payload={{file}}
                tabindex="0"
                class="ov-tree-row"
              >
                {{icon FileCode 14}}
                {{file}}
              </m.ContextTrigger>
            </li>
          {{/each}}
          {{#if this.empty}}
            <li>
              <button
                type="button"
                class="b-btn ov-tree-reset"
                {{on "click" this.restore}}
              >Restore files</button>
            </li>
          {{/if}}
        </ul>
        <m.Content class="b-pop ov-menu" as |content|>
          {{#let (this.str content.state.payload) as |file|}}
            <m.Group as |g|>
              <g.Label class="ov-menu-label">{{file}}</g.Label>
              <m.Item
                class="b-item ov-menu-item"
                @onSelect={{fn this.act "open" file}}
              >
                <m.ItemIcon class="ov-menu-icon">{{icon File 14}}</m.ItemIcon>
                Open
              </m.Item>
              <m.Item
                class="b-item ov-menu-item"
                @onSelect={{fn this.act "copy" file}}
              >
                <m.ItemIcon class="ov-menu-icon">{{icon Copy 14}}</m.ItemIcon>
                Copy path
              </m.Item>
              <m.Item
                class="b-item ov-menu-item"
                @onSelect={{fn this.act "duplicate" file}}
              >
                <m.ItemIcon class="ov-menu-icon">{{icon
                    FileCode
                    14
                  }}</m.ItemIcon>
                Duplicate
              </m.Item>
              <m.Separator class="ov-menu-sep" />
              <m.Item
                class="b-item ov-menu-item"
                @onSelect={{fn this.act "trash" file}}
              >
                <m.ItemIcon class="ov-menu-icon">{{icon Trash2 14}}</m.ItemIcon>
                Move to trash
              </m.Item>
            </m.Group>
          {{/let}}
        </m.Content>
      </Menu>
      <output class="ov-tree-note">{{this.note}}</output>
    </div>
  </template>
}

/* 13. Menu item that opens a dialog through its controller */

class BranchRename extends Component {
  rename = createDialogController<undefined, string>()
  @tracked branch = "feat/usage-alerts"
  @tracked draft = "feat/usage-alerts"
  @tracked note = "3 commits ahead of develop"

  setDraft = (event: Event) => {
    this.draft = (event.target as HTMLInputElement).value
  }

  startRename = async () => {
    this.draft = this.branch
    const { returnValue } = await this.rename.open()
    const clean = this.draft.trim().replace(/\s+/g, "-")
    if (returnValue === "save" && clean && clean !== this.branch) {
      this.branch = clean
      this.note = "Renamed on origin"
    }
  }

  onAction = (value: string) => {
    if (value === "copy") {
      this.note = "Name copied"
    }
    if (value === "compare") {
      this.note = "+148 −31 against develop"
    }
  }

  <template>
    <div class="ov-branch">
      <div class="ov-branch-card">
        <span class="ov-branch-icon">{{icon GitBranch 16}}</span>
        <span class="ov-branch-text">
          <span class="ov-branch-name">{{this.branch}}</span>
          <span class="ov-branch-meta">{{this.note}}</span>
        </span>
        <span class="ov-branch-pr">
          {{icon GitPullRequest 16}}
          Draft pull request · 2 reviewers
        </span>
        <Menu @onAction={{this.onAction}} as |m|>
          <m.Trigger class="ov-dots" aria-label="Branch actions">{{icon
              Ellipsis
              16
            }}</m.Trigger>
          <m.Content class="b-pop ov-menu" @align="end" @sideOffset={{6}}>
            <m.Item class="b-item ov-menu-item" @onSelect={{this.startRename}}>
              <m.ItemIcon class="ov-menu-icon">{{icon Pencil 16}}</m.ItemIcon>
              Rename…
            </m.Item>
            <m.Item @value="copy" class="b-item ov-menu-item">
              <m.ItemIcon class="ov-menu-icon">{{icon Copy 16}}</m.ItemIcon>
              Copy name
            </m.Item>
            <m.Item @value="compare" class="b-item ov-menu-item">
              <m.ItemIcon class="ov-menu-icon">{{icon
                  GitPullRequest
                  16
                }}</m.ItemIcon>
              Compare with develop
            </m.Item>
          </m.Content>
        </Menu>
      </div>
      <Dialog @controller={{this.rename}} as |d|>
        <d.Backdrop class="ov-backdrop" />
        <d.Content class="ov-dialog">
          <d.Title class="ov-dialog-title">Rename branch</d.Title>
          <d.Description class="ov-dialog-desc">
            Open pull requests follow the new name.
          </d.Description>
          <label class="ov-field">
            <span class="b-label">Branch name</span>
            <input
              class="b-input ov-mono-input"
              value={{this.draft}}
              spellcheck="false"
              {{on "input" this.setDraft}}
            />
          </label>
          <div class="ov-actions">
            <d.Close class="b-btn">Keep current</d.Close>
            <d.Close
              @value="save"
              class="b-btn"
              data-variant="primary"
            >Rename</d.Close>
          </div>
        </d.Content>
      </Dialog>
    </div>
  </template>
}

/* 14. Menubar with submenus, checkbox and radio items */

const codeLines = [
  "export async function GET(req: Request, { params }: Ctx) {",
  "  const project = await db.project.findUnique({ where: { slug: params.slug } })",
  "  if (!project) return notFound()",
  '  return Response.json(project, { headers: cache("5m") })',
]

const menubarResults: Record<string, string> = {
  "new-file": "New file",
  save: "Saved route.ts",
  "recent-routes": "Opened api/projects.ts",
  "recent-app": "Opened web/layout.tsx",
  "recent-tf": "Opened infra/main.tf",
  undo: "Undid change",
  redo: "Redid change",
  find: "Searching project",
  staging: "Shipping to staging",
  release: "Releasing to everyone",
  revert: "Reverted to 1.8.3",
}

const densityOptions = ["Compact", "Comfortable"].map((label) => ({
  label,
  value: label.toLowerCase(),
}))

const minimapWidths = [86, 100, 44, 78, 30, 62, 92, 50]
const percent = (width: number) => htmlSafe(`width: ${width}%`)

class Editor extends Component {
  @tracked minimap = true
  @tracked wrap = false
  @tracked numbers = true
  @tracked density = "comfortable"
  @tracked last = "route.ts"
  lines = codeLines
  densities = densityOptions
  widths = minimapWidths
  percent = percent

  get wrapFlag() {
    return flag(this.wrap)
  }

  get numbersFlag() {
    return flag(this.numbers)
  }

  onAction = (value: string) => {
    this.last = menubarResults[value] ?? value
  }

  setMinimap = (checked: boolean) => {
    this.minimap = checked
  }

  setWrap = (checked: boolean) => {
    this.wrap = checked
  }

  setNumbers = (checked: boolean) => {
    this.numbers = checked
  }

  setDensity = (value: string) => {
    this.density = value
  }

  <template>
    <div class="ov-ide">
      <div class="ov-ide-bar">
        <span class="ov-wordmark">relay</span>
        <Menubar aria-label="Editor" class="ov-menubar" as |mb|>
          <mb.Menu @onAction={{this.onAction}} as |m|>
            <m.Trigger class="ov-mb-trigger">File</m.Trigger>
            <m.Content
              class="b-pop ov-menu"
              @sideOffset={{6}}
              @collisionPadding={{12}}
            >
              <m.Item
                @value="new-file"
                @shortcut="mod+n"
                class="b-item ov-menu-item"
              >
                New file
              </m.Item>
              <m.Sub as |s|>
                <s.Trigger class="b-item ov-menu-item">
                  Open recent
                  {{iconc ChevronRight 14 "ov-menu-caret"}}
                </s.Trigger>
                <s.Content class="b-pop ov-menu" @collisionPadding={{12}}>
                  <s.Item
                    @value="recent-routes"
                    class="b-item ov-menu-item ov-mono-item"
                  >
                    api/projects.ts
                  </s.Item>
                  <s.Item
                    @value="recent-app"
                    class="b-item ov-menu-item ov-mono-item"
                  >
                    web/layout.tsx
                  </s.Item>
                  <s.Item
                    @value="recent-tf"
                    class="b-item ov-menu-item ov-mono-item"
                  >
                    infra/main.tf
                  </s.Item>
                </s.Content>
              </m.Sub>
              <m.Separator class="ov-menu-sep" />
              <m.Item
                @value="save"
                @shortcut="mod+s"
                class="b-item ov-menu-item"
              >
                Save
              </m.Item>
            </m.Content>
          </mb.Menu>
          <mb.Menu @onAction={{this.onAction}} as |m|>
            <m.Trigger class="ov-mb-trigger">Edit</m.Trigger>
            <m.Content
              class="b-pop ov-menu"
              @sideOffset={{6}}
              @collisionPadding={{12}}
            >
              <m.Item
                @value="undo"
                @shortcut="mod+z"
                class="b-item ov-menu-item"
              >
                Undo
              </m.Item>
              <m.Item
                @value="redo"
                @shortcut="mod+shift+z"
                class="b-item ov-menu-item"
              >
                Redo
              </m.Item>
              <m.Separator class="ov-menu-sep" />
              <m.Item
                @value="find"
                @shortcut="mod+shift+f"
                class="b-item ov-menu-item"
              >
                Find in project
              </m.Item>
            </m.Content>
          </mb.Menu>
          <mb.Menu as |m|>
            <m.Trigger class="ov-mb-trigger">View</m.Trigger>
            <m.Content
              class="b-pop ov-menu"
              @sideOffset={{6}}
              @collisionPadding={{12}}
            >
              <m.CheckboxItem
                @value="minimap"
                @checked={{this.minimap}}
                @onCheckedChange={{this.setMinimap}}
                class="b-item ov-menu-item"
                as |item|
              >
                <item.Indicator @keepMounted={{true}} class="ov-check">{{icon
                    Check
                    14
                  }}</item.Indicator>
                Minimap
              </m.CheckboxItem>
              <m.CheckboxItem
                @value="wrap"
                @checked={{this.wrap}}
                @onCheckedChange={{this.setWrap}}
                class="b-item ov-menu-item"
                as |item|
              >
                <item.Indicator @keepMounted={{true}} class="ov-check">{{icon
                    Check
                    14
                  }}</item.Indicator>
                Word wrap
              </m.CheckboxItem>
              <m.CheckboxItem
                @value="numbers"
                @checked={{this.numbers}}
                @onCheckedChange={{this.setNumbers}}
                class="b-item ov-menu-item"
                as |item|
              >
                <item.Indicator @keepMounted={{true}} class="ov-check">{{icon
                    Check
                    14
                  }}</item.Indicator>
                Line numbers
              </m.CheckboxItem>
              <m.Separator class="ov-menu-sep" />
              <m.RadioGroup
                @value={{this.density}}
                @onValueChange={{this.setDensity}}
                as |r|
              >
                <r.Label class="ov-menu-label">Density</r.Label>
                {{#each this.densities key="value" as |option|}}
                  <r.Item
                    @value={{option.value}}
                    class="b-item ov-menu-item"
                    as |item|
                  >
                    <span class="ov-check"><item.Indicator
                        class="ov-radio-dot"
                      /></span>
                    {{option.label}}
                  </r.Item>
                {{/each}}
              </m.RadioGroup>
            </m.Content>
          </mb.Menu>
          <mb.Menu @onAction={{this.onAction}} as |m|>
            <m.Trigger class="ov-mb-trigger">Deploy</m.Trigger>
            <m.Content
              class="b-pop ov-menu"
              @sideOffset={{6}}
              @collisionPadding={{12}}
            >
              <m.Item @value="staging" class="b-item ov-menu-item">
                Ship to staging
              </m.Item>
              <m.Item @value="release" class="b-item ov-menu-item">
                Release to everyone
              </m.Item>
              <m.Separator class="ov-menu-sep" />
              <m.Item @value="revert" class="b-item ov-menu-item">
                Revert last release…
              </m.Item>
            </m.Content>
          </mb.Menu>
        </Menubar>
        <output class="ov-ide-status">{{this.last}}</output>
      </div>
      <div
        class="ov-code"
        data-density={{this.density}}
        data-wrap={{this.wrapFlag}}
      >
        <ol class="ov-code-lines" data-numbers={{this.numbersFlag}}>
          {{#each this.lines as |line|}}
            <li><code>{{line}}</code></li>
          {{/each}}
        </ol>
        {{#if this.minimap}}
          <div class="ov-minimap" aria-hidden="true">
            {{#each this.widths as |width|}}
              <span style={{this.percent width}}></span>
            {{/each}}
          </div>
        {{/if}}
      </div>
    </div>
  </template>
}

/* 15. Vertical NavigationMenu in a sidebar */

type SideEntry = { name: string; detail: string }

const sideProjects: SideEntry[] = [
  { name: "storefront", detail: "Production · 3 regions" },
  { name: "inventory-sync", detail: "Cron · every 5 min" },
  { name: "partner-portal", detail: "Preview · pr-77" },
  { name: "data-warehouse", detail: "Paused" },
]

const sideDeploys: SideEntry[] = [
  { name: "Production", detail: "Live since 08:14" },
  { name: "Preview", detail: "11 open branches" },
  { name: "Rollbacks", detail: "Last one Tuesday" },
]

const sideTeam: SideEntry[] = [
  { name: "Members", detail: "14 people" },
  { name: "Roles and access", detail: "4 roles" },
  { name: "Invitations", detail: "3 pending" },
]

const sideSections = [
  { value: "projects", label: "Projects", icon: Folder, items: sideProjects },
  { value: "deploys", label: "Deployments", icon: Rocket, items: sideDeploys },
  { value: "team", label: "Team", icon: Users, items: sideTeam },
]

class Sidebar extends Component {
  @tracked active = "overview"
  sections = sideSections
  overview = { id: "overview", label: "Overview", icon: House }
  usage = { id: "usage", label: "Usage", icon: ChartLine }
  settings = { id: "settings", label: "Settings", icon: Settings }

  isActive = (id: string) => this.active === id

  hasActive = (items: SideEntry[]) =>
    flag(items.some((item) => item.name === this.active))

  go = (id: string, event: Event) => {
    event.preventDefault()
    this.active = id
  }

  <template>
    <div class="ov-side">
      <div class="ov-side-ws">
        <span class="ov-side-ws-text">
          <span class="ov-side-ws-name">Northwind</span>
          <span class="ov-side-ws-plan">Pro workspace</span>
        </span>
      </div>
      <NavigationMenu
        aria-label="Workspace"
        @orientation="vertical"
        class="ov-side-nav"
        @delay={{120}}
        as |n|
      >
        <n.List class="ov-side-list" as |l|>
          <l.Item as |i|>
            <i.Link
              href="#overview"
              @current={{this.isActive "overview"}}
              class="ov-side-link"
              {{on "click" (fn this.go "overview")}}
              as |link|
            >
              <link.Icon class="ov-side-icon">{{icon House 16}}</link.Icon>
              Overview
            </i.Link>
          </l.Item>
          {{#each this.sections key="value" as |section|}}
            <l.Item @value={{section.value}} as |i|>
              <i.Trigger
                class="ov-side-link ov-side-trigger"
                data-current={{this.hasActive section.items}}
              >
                <span class="ov-side-icon">{{icon section.icon 16}}</span>
                {{section.label}}
                {{iconc ChevronRight 16 "ov-side-caret"}}
              </i.Trigger>
              <i.Content class="ov-side-panel" as |c|>
                <p class="ov-side-panel-title">{{section.label}}</p>
                <ul>
                  {{#each section.items key="name" as |item|}}
                    <li>
                      <c.Link
                        href="#{{item.name}}"
                        @current={{this.isActive item.name}}
                        class="ov-side-link"
                        {{on "click" (fn this.go item.name)}}
                      >
                        <span class="ov-side-panel-name">{{item.name}}</span>
                        <span
                          class="ov-side-panel-detail"
                        >{{item.detail}}</span>
                      </c.Link>
                    </li>
                  {{/each}}
                </ul>
              </i.Content>
            </l.Item>
          {{/each}}
          <l.Item as |i|>
            <i.Link
              href="#usage"
              @current={{this.isActive "usage"}}
              class="ov-side-link"
              {{on "click" (fn this.go "usage")}}
              as |link|
            >
              <link.Icon class="ov-side-icon">{{icon ChartLine 16}}</link.Icon>
              Usage
            </i.Link>
          </l.Item>
          <l.Item as |i|>
            <i.Link
              href="#settings"
              @current={{this.isActive "settings"}}
              class="ov-side-link"
              {{on "click" (fn this.go "settings")}}
              as |link|
            >
              <link.Icon class="ov-side-icon">{{icon Settings 16}}</link.Icon>
              Settings
            </i.Link>
          </l.Item>
        </n.List>
        <n.Viewport
          class="ov-side-viewport"
          @sideOffset={{12}}
          @align="start"
          @collisionPadding={{12}}
        />
      </NavigationMenu>
      <div class="ov-side-user">
        <Avatar @initials="DA" />
        <span class="ov-side-ws-text">
          <span class="ov-side-user-name">Diego Alvarez</span>
          <span class="ov-side-user-role">Owner</span>
        </span>
      </div>
    </div>
  </template>
}

/* 16. Stacked toasts with an Undo action */

const inboxSeed: { id: string; icon: IconNode; title: string }[] = [
  {
    id: "approve",
    icon: GitPullRequest,
    title: "Noor Haddad approved pr-312",
  },
  { id: "invoice", icon: Receipt, title: "Invoice INV-2041 is due Friday" },
  {
    id: "staging",
    icon: Rocket,
    title: "Staging deploy finished in 52s",
  },
]

class Inbox extends Component {
  toaster = createToaster({ duration: 6000 })
  @tracked items = inboxSeed

  constructor(owner: Owner, args: object) {
    super(owner, args)
    registerDestructor(this, () => this.toaster.dismiss())
  }

  restore = (id: string) => {
    this.items = inboxSeed.filter(
      (item) => item.id === id || this.items.some((i) => i.id === item.id)
    )
  }

  bringBack = () => {
    this.items = inboxSeed
  }

  archive = (item: (typeof inboxSeed)[number]) => {
    this.items = this.items.filter((i) => i.id !== item.id)
    this.toaster("Archived", {
      id: item.id,
      description: item.title,
      action: {
        label: "Undo",
        onAction: () => this.restore(item.id),
        dismiss: true,
      },
    })
  }

  <template>
    <div class="ov-inbox">
      <p class="ov-inbox-head">
        {{icon Bell 14}}
        Inbox
        <span class="ov-inbox-count">{{this.items.length}}</span>
      </p>
      {{#if this.items.length}}
        <ul class="ov-inbox-list">
          {{#each this.items key="id" as |item|}}
            <li class="ov-inbox-row">
              {{iconc item.icon 14 "ov-inbox-icon"}}
              <span class="ov-inbox-title">{{item.title}}</span>
              <button
                type="button"
                class="ov-inbox-archive"
                aria-label="Archive: {{item.title}}"
                {{on "click" (fn this.archive item)}}
              >{{icon Archive 14}}</button>
            </li>
          {{/each}}
        </ul>
      {{else}}
        <div class="ov-inbox-zero">
          <p>All caught up</p>
          <p class="ov-inbox-zero-note">Zero inbox, zero config ▲</p>
          <button type="button" class="b-btn" {{on "click" this.bringBack}}>
            Bring them back
          </button>
        </div>
      {{/if}}
      <ToastRegion
        @toaster={{this.toaster}}
        @side="bottom"
        @align="end"
        @maxVisible={{3}}
        class="ov-toasts"
        as |toast item t|
      >
        <t.Toast class="ov-toast">
          <div class="ov-toast-text">
            <t.Title class="ov-toast-title" />
            <t.Description class="ov-toast-desc" />
          </div>
          <t.Action class="b-btn ov-toast-undo" />
          <t.Close class="ov-toast-x" aria-label="Dismiss">{{icon
              X
              14
            }}</t.Close>
        </t.Toast>
      </ToastRegion>
    </div>
  </template>
}

/* 17. A popup of our own: definePrimitive + createParts */

const statusPopup = definePrimitive({
  name: "ov-status",
  options: { defaultOpen: "boolean" },
  state: (options: { defaultOpen?: boolean }) => popupState(options),
  api: (context) => createPopup(context, { preset: popoverPreset }),
  slots: (slot) => ({
    trigger: popupTrigger(slot),
    content: popupContent(slot),
    close: popupClose(slot),
  }),
})

const { Root: StatusPopup } = createParts(statusPopup, {
  trigger: "button",
  content: "div",
  close: "button",
})

const presence = [
  { id: "available", label: "Available", until: "" },
  { id: "focus", label: "Focusing", until: "until 15:00" },
  { id: "meeting", label: "In a meeting", until: "for 45 min" },
  { id: "away", label: "Away", until: "back Monday" },
]

class Presence extends Component {
  @tracked status = "focus"
  options = presence

  get current() {
    return presence.find((p) => p.id === this.status)!
  }

  pressed = (id: string) => (id === this.status ? "true" : "false")

  setStatus = (id: string) => {
    this.status = id
  }

  <template>
    <div class="ov-presence">
      <div class="ov-presence-who">
        <span class="ov-presence-avatar">
          <Avatar @initials="HN" @size="lg" />
          <span
            class="ov-presence-dot"
            data-status={{this.status}}
            aria-hidden="true"
          ></span>
        </span>
        <span class="ov-presence-text">
          <span class="ov-presence-name">Hana Novak</span>
          <span class="ov-presence-role">Infra · Prague</span>
        </span>
      </div>
      <StatusPopup as |s|>
        <s.Trigger class="b-btn ov-trigger ov-presence-trigger">
          <span
            class="ov-presence-dot ov-presence-dot-inline"
            data-status={{this.status}}
            aria-hidden="true"
          ></span>
          {{this.current.label}}
          {{#if this.current.until}}<span
              class="ov-presence-until"
            >{{this.current.until}}</span>{{/if}}
          {{icon ChevronDown 14}}
        </s.Trigger>
        <s.Content class="b-pop ov-presence-pop" aria-label="Set status">
          {{#each this.options key="id" as |p|}}
            <s.Close
              class="b-item ov-presence-option"
              aria-pressed={{this.pressed p.id}}
              {{on "click" (fn this.setStatus p.id)}}
            >
              <span
                class="ov-presence-dot ov-presence-dot-inline"
                data-status={{p.id}}
                aria-hidden="true"
              ></span>
              <span class="ov-presence-label">{{p.label}}</span>
              {{#if p.until}}<span
                  class="ov-presence-until"
                >{{p.until}}</span>{{/if}}
            </s.Close>
          {{/each}}
        </s.Content>
      </StatusPopup>
    </div>
  </template>
}

/* 18. position + bindLayer: a comment bubble pinned to a line */

const backoffLines = [
  { n: 12, kind: "", code: "export function nextDelay(attempt: number) {" },
  { n: 13, kind: "del", code: "  return BASE_MS * 2 ** attempt" },
  { n: 14, kind: "add", code: "  const raw = BASE_MS * 2 ** attempt" },
  { n: 15, kind: "add", code: "  return Math.min(raw, MAX_MS) + jitter()" },
  { n: 16, kind: "", code: "}" },
]

class LineComments extends Component {
  @tracked openLine: number | null = null
  @tracked draft = ""
  @tracked notes: Record<number, string> = {
    15: "Jitter fixes the thundering herd.",
  }
  anchors = new Map<number, HTMLButtonElement>()
  lines = backoffLines

  kind = (kind: string) => kind || undefined
  get hasOpen() {
    return this.openLine !== null
  }

  expanded = (n: number) => (this.openLine === n ? "true" : "false")
  openFlag = (n: number) => flag(this.openLine === n)
  note = (n: number) => this.notes[n]
  label = (line: (typeof backoffLines)[number]) =>
    `Line ${line.n}: ${line.code.trim()}. Comment`

  get bubbleLabel() {
    return `Comment on line ${this.openLine}`
  }

  registerAnchor = (n: number, el: HTMLButtonElement) => {
    this.anchors.set(n, el)
    return () => {
      this.anchors.delete(n)
    }
  }

  bubble = (el: HTMLElement) => {
    const line = this.openLine
    const anchor = line === null ? undefined : this.anchors.get(line)
    if (!anchor) {
      return
    }
    const stopLayer = bindLayer(el, {
      topLayer: true,
      contains: (target) => anchor.contains(target),
      onDismiss: (reason) => {
        this.openLine = null
        if (reason === "escape-key") {
          anchor.focus()
        }
      },
    })
    const stopPosition = position(anchor, el, {
      side: "bottom",
      align: "end",
      sideOffset: 6,
      collisionPadding: 12,
    })
    el.querySelector("textarea")?.focus()
    return () => {
      stopPosition()
      stopLayer()
    }
  }

  toggle = (n: number) => {
    this.draft = this.notes[n] ?? ""
    this.openLine = this.openLine === n ? null : n
  }

  setDraft = (event: Event) => {
    this.draft = (event.target as HTMLTextAreaElement).value
  }

  discard = () => {
    this.openLine = null
  }

  post = () => {
    const line = this.openLine
    if (line === null) {
      return
    }
    if (this.draft.trim()) {
      this.notes = { ...this.notes, [line]: this.draft.trim() }
    }
    this.openLine = null
    this.anchors.get(line)?.focus()
  }

  keydown = (event: KeyboardEvent) => {
    if (event.key === "Enter" && (event.metaKey || event.ctrlKey)) {
      this.post()
    }
  }

  <template>
    <div class="ov-lines">
      <p class="ov-lines-file">src/queue/backoff.ts</p>
      <ol class="ov-lines-code">
        {{#each this.lines key="n" as |line|}}
          <li data-kind={{this.kind line.kind}}>
            <button
              type="button"
              class="ov-line"
              aria-expanded={{this.expanded line.n}}
              aria-label={{this.label line}}
              data-open={{this.openFlag line.n}}
              {{attach (fn this.registerAnchor line.n)}}
              {{on "click" (fn this.toggle line.n)}}
            >
              <span class="ov-line-n">{{line.n}}</span>
              <code class="ov-line-code">{{line.code}}</code>
              {{#if (this.note line.n)}}{{iconc
                  MessageCircle
                  14
                  "ov-line-note"
                }}{{/if}}
            </button>
          </li>
        {{/each}}
      </ol>
      {{#if this.hasOpen}}
        <div
          class="ov-bubble"
          role="dialog"
          aria-label={{this.bubbleLabel}}
          {{attach this.bubble}}
        >
          <textarea
            class="b-input ov-bubble-input"
            rows="2"
            placeholder="Leave a comment"
            aria-label="Comment"
            value={{this.draft}}
            {{on "input" this.setDraft}}
            {{on "keydown" this.keydown}}
          ></textarea>
          <div class="ov-bubble-actions">
            <button
              type="button"
              class="b-btn"
              data-variant="ghost"
              {{on "click" this.discard}}
            >Discard</button>
            <button
              type="button"
              class="b-btn"
              data-variant="primary"
              {{on "click" this.post}}
            >Comment</button>
          </div>
        </div>
      {{/if}}
    </div>
  </template>
}

/* 19. Popover holding a Command list: an assignee picker */

const assignees = [
  { id: "amara", name: "Amara Diallo", initials: "AD" },
  { id: "kenji", name: "Kenji Sato", initials: "KS" },
  { id: "elif", name: "Elif Kaya", initials: "EK" },
  { id: "owen", name: "Owen Price", initials: "OP" },
  { id: "yusuf", name: "Yusuf Demir", initials: "YD" },
]

class Assignee extends Component {
  @tracked open = false
  @tracked who: string | null = "kenji"
  people = assignees

  get person() {
    return assignees.find((a) => a.id === this.who)
  }

  get triggerLabel() {
    return `Assignee: ${this.person?.name ?? "nobody"}`
  }

  get current() {
    return this.who ?? "none"
  }

  isWho = (id: string) => id === this.who

  setOpen = (open: boolean) => {
    this.open = open
  }

  onAction = (value: string) => {
    this.who = value === "none" ? null : value
    this.open = false
  }

  <template>
    <div class="ov-issue">
      <p class="ov-issue-id">
        <span class="ov-issue-prio" aria-hidden="true"></span>
        ENG-482 · Urgent
      </p>
      <p class="ov-issue-title">Webhook retries drop payloads</p>
      <Popover @open={{this.open}} @onOpenChange={{this.setOpen}} as |p|>
        <p.Trigger class="ov-assignee" aria-label={{this.triggerLabel}}>
          {{#if this.person}}
            <Avatar @initials={{this.person.initials}} @size="sm" />
          {{else}}
            <span class="ov-avatar ov-avatar-empty" data-size="sm"></span>
          {{/if}}
          {{if this.person this.person.name "Unassigned"}}
          {{icon ChevronDown 14}}
        </p.Trigger>
        <p.Content
          class="b-pop ov-assign-pop"
          @side="bottom"
          @align="start"
          @sideOffset={{6}}
          @collisionPadding={{12}}
          aria-label="Assign"
        >
          <Command
            class="ov-assign"
            @defaultValue={{this.current}}
            @onAction={{this.onAction}}
            as |c|
          >
            <c.Input
              aria-label="Assign to"
              placeholder="Assign to…"
              class="ov-assign-input"
            />
            <c.Empty class="ov-cmd-empty">No teammate by that name</c.Empty>
            <c.List class="ov-assign-list">
              <c.Item
                @value="none"
                @label="No assignee"
                class="b-item ov-assign-item"
              >
                <span
                  class="ov-avatar ov-avatar-empty"
                  data-size="sm"
                  aria-hidden="true"
                ></span>
                No assignee
              </c.Item>
              {{#each this.people key="id" as |a|}}
                <c.Item
                  @value={{a.id}}
                  @label={{a.name}}
                  class="b-item ov-assign-item"
                >
                  <Avatar @initials={{a.initials}} @size="sm" />
                  {{a.name}}
                  {{#if (this.isWho a.id)}}{{iconc
                      Check
                      14
                      "ov-assign-check"
                      "Current"
                    }}{{/if}}
                </c.Item>
              {{/each}}
            </c.List>
          </Command>
        </p.Content>
      </Popover>
    </div>
  </template>
}

export const tiles: Tile[] = [
  {
    id: "overlays-palette",
    title: "Jump anywhere.",
    blurb: "Search commands, then drill into pages.",
    size: "large",
    Demo: Palette,
  },
  {
    id: "overlays-invite",
    title: "Bring people in.",
    blurb: "A dialog that waits while it sends.",
    tone: "paper",
    Demo: Invite,
  },
  {
    id: "overlays-delete",
    title: "Think twice.",
    blurb: "Confirm before anything gets deleted.",
    Demo: DeleteProject,
  },
  {
    id: "overlays-tokens",
    title: "Ask, then await.",
    blurb: "One confirm call answers every row.",
    tone: "paper",
    Demo: Tokens,
  },
  {
    id: "overlays-region",
    title: "Open from code.",
    blurb: "Await the region someone picks.",
    tone: "sky",
    Demo: Region,
  },
  {
    id: "overlays-build-log",
    title: "Pull up the log.",
    blurb: "Drag the sheet between two heights.",
    tone: "ink",
    Demo: BuildLog,
  },
  {
    id: "overlays-schedule",
    title: "Pick a time.",
    blurb: "A small form that points at its button.",
    Demo: Schedule,
  },
  {
    id: "overlays-review",
    title: "Review by keyboard.",
    blurb: "Tooltips teach the keys that work.",
    tone: "blueprint",
    Demo: DiffToolbar,
  },
  {
    id: "overlays-quick-keys",
    title: "Keys for your machine.",
    blurb: "⌘ on a Mac, Ctrl everywhere else.",
    tone: "signal",
    Demo: QuickKeys,
  },
  {
    id: "overlays-mention",
    title: "Know who’s who.",
    blurb: "Pause on a mention to meet them.",
    Demo: Mention,
  },
  {
    id: "overlays-deploys",
    title: "Every row, its actions.",
    blurb: "Menus with submenus, named by tooltips.",
    size: "wide",
    Demo: Deploys,
  },
  {
    id: "overlays-file-tree",
    title: "Right-click works.",
    blurb: "A context menu that knows the file.",
    tone: "paper",
    Demo: FileTree,
  },
  {
    id: "overlays-branch",
    title: "Menu, then dialog.",
    blurb: "Rename opens a dialog from the menu.",
    tone: "sage",
    Demo: BranchRename,
  },
  {
    id: "overlays-menubar",
    title: "A real menu bar.",
    blurb: "Arrow across menus, toggle the view.",
    size: "wide",
    tone: "paper",
    Demo: Editor,
  },
  {
    id: "overlays-sidebar",
    title: "Navigate the workspace.",
    blurb: "Sections open panels beside the sidebar.",
    size: "tall",
    Demo: Sidebar,
  },
  {
    id: "overlays-inbox",
    title: "Undo anything.",
    blurb: "Archived notices stack up with Undo.",
    tone: "butter",
    Demo: Inbox,
  },
  {
    id: "overlays-presence",
    title: "Roll your own.",
    blurb: "A status popup from core popup parts.",
    Demo: Presence,
  },
  {
    id: "overlays-line-comments",
    title: "Pin it to a line.",
    blurb: "Placed and dismissed without a component.",
    tone: "paper",
    Demo: LineComments,
  },
  {
    id: "overlays-assignee",
    title: "Assign in a keystroke.",
    blurb: "Type a name, press Enter.",
    tone: "ink",
    Demo: Assignee,
  },
]
