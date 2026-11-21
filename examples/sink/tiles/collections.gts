import type { TOC } from "@ember/component/template-only"
import { array, fn, hash } from "@ember/helper"
import { capabilities, on, setModifierManager } from "@ember/modifier"
import { guidFor } from "@ember/object/internals"
import { htmlSafe } from "@ember/template"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import type { ModifierLike } from "@glint/template"
import {
  bindFindable,
  createInlineEdit,
  createStickToBottom,
  createTreeCollection,
  createVirtualizer,
  hiddenAttrs,
  supportsHiddenUntilFound,
} from "@ui-sdk/core"
import {
  ArrowDown,
  BookOpenText,
  Bookmark,
  Check,
  ChevronDown,
  ChevronLeft,
  ChevronRight,
  FileAudio,
  FileImage,
  FileText,
  Folder,
  FolderOpen,
  Minus,
  Music,
  Pause,
  Pencil,
  Play,
  Plus,
  Search,
  Send,
  Shuffle,
  Volume2,
  X,
  type IconNode,
} from "lucide"
import { Accordion } from "ember-ui-sdk/accordion"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { Avatar } from "ember-ui-sdk/avatar"
import { Carousel } from "ember-ui-sdk/carousel"
import { Collapsible } from "ember-ui-sdk/collapsible"
import { Combobox } from "ember-ui-sdk/combobox"
import { Listbox } from "ember-ui-sdk/listbox"
import { Meter } from "ember-ui-sdk/meter"
import { Pagination } from "ember-ui-sdk/pagination"
import { Progress } from "ember-ui-sdk/progress"
import { ScrollArea } from "ember-ui-sdk/scroll-area"
import { Separator } from "ember-ui-sdk/separator"
import { Tabs } from "ember-ui-sdk/tabs"
import {
  createTokenInputController,
  TokenInput,
  type TokenInputValue,
} from "ember-ui-sdk/token-input"
import {
  toggleTreeChecked,
  Tree,
  treeCheckedStates,
  treeFromPaths,
  visibleTreeRows,
  type TreeItemData,
} from "ember-ui-sdk/tree"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import "../../../vendor/ui/apps/docs/app/sink/tiles/collections.css"
import { icon } from "../icon.ts"
import { onInsert } from "../on-insert.ts"
import type { Tile } from "../types.ts"

/* Shared helpers */

/** `{{findable this.shown}}` writes the hidden attribute, which `until-found` lets find in page open. */
const findable = setModifierManager(
  () => {
    const apply = (el: Element, positional: unknown[]) => {
      const { hidden } = hiddenAttrs(positional[0] as boolean, true)
      if (hidden === undefined) {
        el.removeAttribute("hidden")
      } else {
        el.setAttribute("hidden", hidden)
      }
    }
    return {
      capabilities: capabilities("3.22"),
      createModifier: () => ({ el: undefined as Element | undefined }),
      installModifier: (
        modifier: { el?: Element },
        el: Element,
        { positional }: { positional: unknown[] }
      ) => {
        modifier.el = el
        apply(el, positional)
      },
      updateModifier: (
        modifier: { el?: Element },
        { positional }: { positional: unknown[] }
      ) => apply(modifier.el!, positional),
      destroyModifier: () => {},
    }
  },
  function () {} as unknown as ModifierLike<{
    Element: Element
    Args: { Positional: [boolean] }
  }>
)

const inView = (el: Element, set: (value: boolean) => void) => {
  const observer = new IntersectionObserver(([entry]) =>
    set(entry.isIntersecting)
  )
  observer.observe(el)
  return () => observer.disconnect()
}

const prefersReducedMotion = () =>
  typeof matchMedia !== "undefined" &&
  matchMedia("(prefers-reduced-motion: reduce)").matches

const clock = (seconds: number) =>
  `${Math.floor(seconds / 60)}:${String(Math.floor(seconds % 60)).padStart(2, "0")}`

const eq = (a: unknown, b: unknown) => a === b
const plusOne = (value: number) => value + 1
const place = (value: number) => (value + 1).toLocaleString("en-US")
const isNumber = (value: unknown) => typeof value === "number"
const keepFocus = (event: Event) => event.preventDefault()
const dataOn = (value: unknown) => (value ? "true" : undefined)

const coverStyle = (hue: number, size: number) =>
  htmlSafe(`--hue: ${hue}; --size: ${size}px`)

/** Album art and book covers: a gradient block with type, never a photo. */
const Cover: TOC<{
  Element: HTMLSpanElement
  Args: { hue: number; size: number; title?: string }
}> = <template>
  <span
    aria-hidden="true"
    class="cl-cover"
    style={{coverStyle @hue @size}}
    ...attributes
  >{{#if @title}}<span class="cl-cover-type">{{@title}}</span>{{/if}}</span>
</template>

const initialsOf = (name: string) =>
  name
    .split(" ")
    .map((part) => part[0])
    .join("")

/* 1. Now playing: tabs with a moving indicator over three track lists, and live progress. */

type Track = {
  id: string
  title: string
  artist: string
  secs: number
  hue: number
}

const albumTracks: Track[] = [
  {
    id: "sh-1",
    title: "Harbour Bell",
    artist: "The Low Orchard",
    secs: 214,
    hue: 210,
  },
  {
    id: "sh-2",
    title: "Kelp Forest",
    artist: "The Low Orchard",
    secs: 251,
    hue: 210,
  },
  {
    id: "sh-3",
    title: "Undertow",
    artist: "The Low Orchard",
    secs: 228,
    hue: 210,
  },
  {
    id: "sh-4",
    title: "Gull Song",
    artist: "The Low Orchard",
    secs: 187,
    hue: 210,
  },
  {
    id: "sh-5",
    title: "Salt on the Window",
    artist: "The Low Orchard",
    secs: 302,
    hue: 210,
  },
  {
    id: "sh-6",
    title: "Brine",
    artist: "The Low Orchard",
    secs: 166,
    hue: 210,
  },
  {
    id: "sh-7",
    title: "Pier at Dusk",
    artist: "The Low Orchard",
    secs: 274,
    hue: 210,
  },
  {
    id: "sh-8",
    title: "Lantern Rowing",
    artist: "The Low Orchard",
    secs: 339,
    hue: 210,
  },
]

const queueTracks: Track[] = [
  {
    id: "q-1",
    title: "Glass Meridian",
    artist: "Noor Sato",
    secs: 236,
    hue: 28,
  },
  {
    id: "q-2",
    title: "Copper Weather",
    artist: "Field Hymnal",
    secs: 262,
    hue: 140,
  },
  { id: "q-3", title: "Slow Comet", artist: "Ada Rune", secs: 198, hue: 330 },
  {
    id: "q-4",
    title: "Tin Can Telephone",
    artist: "The Marigolds",
    secs: 171,
    hue: 75,
  },
  {
    id: "q-5",
    title: "Overpass Choir",
    artist: "Sable Junction",
    secs: 289,
    hue: 250,
  },
  {
    id: "q-6",
    title: "Weathervane",
    artist: "Holm & Ash",
    secs: 223,
    hue: 175,
  },
]

const playedTracks: Track[] = [
  { id: "p-1", title: "Paper Kite", artist: "Hollis June", secs: 205, hue: 55 },
  { id: "p-2", title: "Sundial", artist: "Marta Kell", secs: 244, hue: 12 },
  {
    id: "p-3",
    title: "Lemon Grove Static",
    artist: "Cassette Coast",
    secs: 218,
    hue: 95,
  },
  {
    id: "p-4",
    title: "Orbital Lullaby",
    artist: "Fen Okoye",
    secs: 312,
    hue: 230,
  },
]

const everyTrack = [...albumTracks, ...queueTracks, ...playedTracks]

const speaking = (id: string, current: string, playing: boolean) =>
  id === current && playing

const pickValue = (onPick: (id: string) => void, value: unknown) => {
  if (typeof value === "string") {
    onPick(value)
  }
}

const TrackList: TOC<{
  Args: {
    label: string
    tracks: Track[]
    current: string
    playing: boolean
    numbered?: boolean
    onPick: (id: string) => void
  }
}> = <template>
  <ScrollArea class="cl-player-area" as |s|>
    <s.Viewport aria-label={{@label}} class="cl-player-viewport">
      <s.Content>
        <Listbox
          aria-label={{@label}}
          @activation="manual"
          @value={{@current}}
          @onValueChange={{fn pickValue @onPick}}
          class="cl-tracks"
          as |l|
        >
          {{#each @tracks key="id" as |track index|}}
            <l.Item @value={{track.id}} @label={{track.title}} class="cl-track">
              <span class="cl-track-lead">
                {{#if (speaking track.id @current @playing)}}
                  {{icon Volume2 16}}
                {{else if @numbered}}
                  {{plusOne index}}
                {{else}}
                  <Cover @hue={{track.hue}} @size={{32}} />
                {{/if}}
              </span>
              <span class="cl-stack">
                <span class="cl-track-title">{{track.title}}</span>
                <span class="cl-sub">{{track.artist}}</span>
              </span>
              <span class="cl-mono cl-dim">{{clock track.secs}}</span>
            </l.Item>
          {{/each}}
        </Listbox>
      </s.Content>
    </s.Viewport>
    <s.Scrollbar @orientation="vertical" class="cl-scrollbar" as |sb|>
      <sb.Thumb class="cl-thumb" />
    </s.Scrollbar>
  </ScrollArea>
</template>

class NowPlaying extends Component {
  @tracked current = "sh-3"
  @tracked elapsed = 71
  @tracked playing = false
  @tracked visible = false

  albumTracks = albumTracks
  queueTracks = queueTracks
  playedTracks = playedTracks

  get track() {
    return everyTrack.find((item) => item.id === this.current) ?? albumTracks[0]
  }

  get done() {
    return this.elapsed >= this.track.secs
  }

  get running() {
    return this.playing && !this.done && this.visible
  }

  get livePlaying() {
    return this.playing && !this.done
  }

  get shown() {
    return Math.min(this.elapsed, this.track.secs)
  }

  get time() {
    return `${clock(this.shown)} / ${clock(this.track.secs)}`
  }

  watch = (el: Element) => {
    const stop = inView(el, (value) => (this.visible = value))
    const timer = setInterval(() => {
      if (this.running) {
        this.elapsed++
      }
    }, 1000)
    return () => {
      stop()
      clearInterval(timer)
    }
  }

  pick = (id: string) => {
    this.current = id
    this.elapsed = 0
    this.playing = true
  }

  toggle = () => {
    if (this.done) {
      this.elapsed = 0
    }
    this.playing = this.done ? true : !this.playing
  }

  valueLabel = (value: number | null) =>
    `${clock(value ?? 0)} of ${clock(this.track.secs)}`

  <template>
    <div class="cl-player" {{onInsert this.watch}}>
      <header class="cl-player-head">
        <Cover
          @hue={{210}}
          @size={{92}}
          @title="Saltwater Hymns"
          class="cl-player-art"
        />
        <div class="cl-stack">
          <span class="cl-kicker">Album</span>
          <span class="cl-player-title">Saltwater Hymns</span>
          <span class="cl-sub">
            The Low Orchard · 2026 · 8 songs, 32 min
          </span>
        </div>
      </header>
      <Tabs @defaultValue="album" class="cl-player-tabs" as |t|>
        <t.List aria-label="Track lists" class="cl-tabs">
          <t.Tab @value="album" class="cl-tab">Album</t.Tab>
          <t.Tab @value="next" class="cl-tab">Up next</t.Tab>
          <t.Tab @value="played" class="cl-tab">Played</t.Tab>
          <t.Indicator class="cl-tab-indicator" />
        </t.List>
        <t.Panel @value="album" class="cl-tab-panel">
          <TrackList
            @label="Album tracks"
            @tracks={{this.albumTracks}}
            @numbered={{true}}
            @current={{this.current}}
            @playing={{this.livePlaying}}
            @onPick={{this.pick}}
          />
        </t.Panel>
        <t.Panel @value="next" class="cl-tab-panel">
          <TrackList
            @label="Up next"
            @tracks={{this.queueTracks}}
            @current={{this.current}}
            @playing={{this.livePlaying}}
            @onPick={{this.pick}}
          />
        </t.Panel>
        <t.Panel @value="played" class="cl-tab-panel">
          <TrackList
            @label="Recently played"
            @tracks={{this.playedTracks}}
            @current={{this.current}}
            @playing={{this.livePlaying}}
            @onPick={{this.pick}}
          />
        </t.Panel>
      </Tabs>
      <div class="cl-now">
        <button
          type="button"
          class="cl-play"
          aria-label={{if this.livePlaying "Pause" "Play"}}
          {{on "click" this.toggle}}
        >
          {{#if this.livePlaying}}
            {{icon Pause 16}}
          {{else}}
            {{icon Play 16}}
          {{/if}}
        </button>
        <div class="cl-now-main">
          <div class="cl-now-line">
            <span class="cl-track-title">{{this.track.title}}</span>
            <span class="cl-sub">{{this.track.artist}}</span>
          </div>
          <Progress
            @value={{this.shown}}
            @max={{this.track.secs}}
            aria-label="Playback position"
            @getValueLabel={{this.valueLabel}}
            class="cl-now-progress"
            as |p|
          >
            <p.Track class="cl-now-track">
              <p.Indicator class="cl-now-fill" />
            </p.Track>
          </Progress>
        </div>
        <span class="cl-mono cl-dim cl-now-time">{{this.time}}</span>
      </div>
    </div>
  </template>
}

/* 2. Ten thousand tracks, virtualized inside a custom scroll area. */

const LIBRARY_SIZE = 10_000
const libWordsA = [
  "Amber",
  "Hollow",
  "Silver",
  "Velvet",
  "Golden",
  "Faded",
  "Electric",
  "Distant",
  "Gentle",
  "Lucid",
  "Crimson",
  "Tender",
  "Restless",
  "Sunken",
  "Bright",
  "Midnight",
  "Northern",
  "Borrowed",
  "Second",
  "Little",
]
const libWordsB = [
  "Avenue",
  "Signal",
  "Orbit",
  "Garden",
  "Mirror",
  "Season",
  "Echo",
  "Harvest",
  "Satellite",
  "Meadow",
  "Station",
  "Fever",
  "Postcard",
  "Canyon",
  "Parade",
  "Telegram",
  "Ballroom",
  "Relay",
  "Monsoon",
  "Atlas",
  "Hours",
  "Departures",
  "Rooftops",
]
const libFirst = [
  "Noa",
  "Elio",
  "Saskia",
  "Bruno",
  "Yara",
  "Idris",
  "Lotte",
  "Mateo",
  "Ines",
  "Kenji",
  "Aurelie",
  "Tobias",
  "Zadie",
  "Ravi",
  "Freya",
  "Olu",
]
const libLast = [
  "Fenwick",
  "Calder",
  "Moreau",
  "Achebe",
  "Lindqvist",
  "Okada",
  "Varela",
  "Brandauer",
  "Quill",
  "Sorensen",
  "Albright",
  "Nakamura",
  "Duarte",
]

function libraryTrack(index: number) {
  const a = libWordsA[(index * 7) % libWordsA.length]
  const b = libWordsB[(index * 13 + Math.floor(index / 23)) % libWordsB.length]
  const first = libFirst[(index * 5 + Math.floor(index / 16)) % libFirst.length]
  const last = libLast[(index * 3 + Math.floor(index / 13)) % libLast.length]
  return {
    title: `${a} ${b}`,
    artist: `${first} ${last}`,
    secs: 140 + ((index * 37) % 220),
    hue: (index * 47) % 360,
  }
}

const libraryRow = (index: number, jumped: number | null) => ({
  ...libraryTrack(index),
  index,
  jumped: jumped === index,
})

class TenThousand extends Component {
  virtual = createVirtualizer({
    count: () => LIBRARY_SIZE,
    estimate: () => 52,
    overscan: 6,
  })
  @tracked rows = this.virtual.items()
  @tracked total = this.virtual.size()
  @tracked jumped: number | null = null

  get boxStyle() {
    return htmlSafe(`height: ${this.total}px`)
  }

  get entries() {
    return this.rows.map((row) => ({
      row,
      track: libraryRow(row.index, this.jumped),
      style: htmlSafe(
        `transform: translateY(${row.start}px); height: ${row.size}px`
      ),
    }))
  }

  attach = (el: HTMLElement) => {
    const sync = () =>
      Promise.resolve().then(() => {
        this.rows = this.virtual.items()
        this.total = this.virtual.size()
      })
    const unsubscribe = this.virtual.subscribe(sync)
    const disconnect = this.virtual.connect(el)
    sync()
    return () => {
      unsubscribe()
      disconnect()
    }
  }

  jump = () => {
    const index = Math.floor(Math.random() * LIBRARY_SIZE)
    this.jumped = index
    this.virtual.scrollToIndex(index, { align: "center" })
  }

  <template>
    <div class="cl-lib">
      <header class="cl-lib-head">
        <div class="cl-stack">
          <span class="cl-lib-count">
            10,000
            <span>tracks</span>
          </span>
          <span class="cl-mono cl-dim" aria-live="polite">
            {{this.rows.length}}
            rows in the DOM
          </span>
        </div>
        <button
          type="button"
          class="b-btn cl-lib-jump"
          {{on "click" this.jump}}
        >
          {{icon Shuffle 16}}
          Jump
        </button>
      </header>
      <ScrollArea class="cl-lib-area" as |s|>
        <s.Viewport
          aria-label="Library"
          class="cl-lib-viewport"
          {{onInsert this.attach}}
        >
          <s.Content>
            <div
              role="list"
              aria-label="Tracks"
              class="cl-lib-box"
              style={{this.boxStyle}}
            >
              {{#each this.entries key="row.key" as |entry|}}
                <div
                  role="listitem"
                  aria-setsize={{LIBRARY_SIZE}}
                  aria-posinset={{plusOne entry.row.index}}
                  class="cl-lib-row"
                  data-jumped={{dataOn entry.track.jumped}}
                  style={{entry.style}}
                >
                  <Cover @hue={{entry.track.hue}} @size={{34}} />
                  <span class="cl-stack">
                    <span class="cl-track-title">{{entry.track.title}}</span>
                    <span class="cl-sub">{{entry.track.artist}}</span>
                  </span>
                  <span class="cl-stack cl-lib-meta">
                    <span class="cl-mono cl-dim">{{clock
                        entry.track.secs
                      }}</span>
                    <span class="cl-mono cl-faint">#{{place
                        entry.row.index
                      }}</span>
                  </span>
                </div>
              {{/each}}
            </div>
          </s.Content>
        </s.Viewport>
        <div class="cl-fade cl-fade-bottom"></div>
        <s.Scrollbar @orientation="vertical" class="cl-scrollbar" as |sb|>
          <sb.Thumb class="cl-thumb" />
        </s.Scrollbar>
      </ScrollArea>
    </div>
  </template>
}

/* 3. A music folder: Tree from file paths, with a preview beside a vertical separator. */

const filePaths = [
  "Music/Albums/Marsh Radio/01 Reedbed.flac",
  "Music/Albums/Marsh Radio/02 Heron Call.flac",
  "Music/Albums/Marsh Radio/03 Peat Fire.flac",
  "Music/Albums/Marsh Radio/cover.jpg",
  "Music/Albums/Quiet Hours/01 Vespers.flac",
  "Music/Albums/Quiet Hours/02 Night Porter.flac",
  "Music/Playlists/Gym rotation.m3u",
  "Audiobooks/The Iron Atlas/Part 1.m4b",
  "Audiobooks/The Iron Atlas/Part 2.m4b",
  "Books/Winter Botany.epub",
  "Books/Field Guide to Moss.pdf",
  "Podcasts/",
]

const fileItems = treeFromPaths(filePaths)

const fileMeta: Record<string, { kind: string; size: string; extra: string }> =
  {
    "Music/Albums/Marsh Radio/01 Reedbed.flac": {
      kind: "FLAC audio",
      size: "38.4 MB",
      extra: "4:12 · 24-bit / 96 kHz",
    },
    "Music/Albums/Marsh Radio/02 Heron Call.flac": {
      kind: "FLAC audio",
      size: "41.9 MB",
      extra: "4:37 · 24-bit / 96 kHz",
    },
    "Music/Albums/Marsh Radio/03 Peat Fire.flac": {
      kind: "FLAC audio",
      size: "29.2 MB",
      extra: "3:15 · 24-bit / 96 kHz",
    },
    "Music/Albums/Marsh Radio/cover.jpg": {
      kind: "JPEG image",
      size: "1.2 MB",
      extra: "1400 × 1400",
    },
    "Music/Albums/Quiet Hours/01 Vespers.flac": {
      kind: "FLAC audio",
      size: "33.0 MB",
      extra: "3:48 · 16-bit / 44.1 kHz",
    },
    "Music/Albums/Quiet Hours/02 Night Porter.flac": {
      kind: "FLAC audio",
      size: "45.7 MB",
      extra: "5:02 · 16-bit / 44.1 kHz",
    },
    "Music/Playlists/Gym rotation.m3u": {
      kind: "Playlist",
      size: "2 KB",
      extra: "42 tracks",
    },
    "Audiobooks/The Iron Atlas/Part 1.m4b": {
      kind: "Audiobook",
      size: "212 MB",
      extra: "6 h 41 min",
    },
    "Audiobooks/The Iron Atlas/Part 2.m4b": {
      kind: "Audiobook",
      size: "188 MB",
      extra: "5 h 57 min",
    },
    "Books/Winter Botany.epub": {
      kind: "EPUB book",
      size: "3.8 MB",
      extra: "312 pages",
    },
    "Books/Field Guide to Moss.pdf": {
      kind: "PDF document",
      size: "18.1 MB",
      extra: "96 pages",
    },
  }

function fileIcon(path: string) {
  if (/\.(flac|m4b|mp3)$/.test(path)) {
    return FileAudio
  }
  if (path.endsWith(".jpg")) {
    return FileImage
  }
  if (path.endsWith(".pdf")) {
    return FileText
  }
  if (path.endsWith(".epub")) {
    return BookOpenText
  }
  return FileText
}

function findItem(
  items: TreeItemData[],
  value: string
): TreeItemData | undefined {
  for (const item of items) {
    if (item.value === value) {
      return item
    }
    const inside = item.children && findItem(item.children, value)
    if (inside) {
      return inside
    }
  }
}

const isFolder = (item: TreeItemData) => !!item.children
const childrenOf = (item: TreeItemData) => item.children ?? []
const rowIcon = (item: TreeItemData) =>
  item.children ? Folder : fileIcon(item.value)

class FileRows extends Component<{
  Args: { parts: any; items: TreeItemData[] }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} class="cl-ftree-item" as |i|>
        <i.Label class="cl-ftree-row" as |l|>
          {{#if (isFolder item)}}
            <i.Indicator class="cl-ftree-caret">{{icon
                ChevronRight
                14
              }}</i.Indicator>
          {{else}}
            <span class="cl-ftree-caret"></span>
          {{/if}}
          {{#if (isFolder item)}}
            {{#if l.state.expanded}}
              {{icon FolderOpen 14 (hash class="cl-ftree-icon")}}
            {{else}}
              {{icon Folder 14 (hash class="cl-ftree-icon")}}
            {{/if}}
          {{else}}
            {{icon (rowIcon item) 14 (hash class="cl-ftree-icon")}}
          {{/if}}
          <span class="cl-ellipsis">{{item.label}}</span>
        </i.Label>
        {{#if (isFolder item)}}
          <i.Group class="cl-ftree-group" as |g|>
            <FileRows @parts={{g}} @items={{childrenOf item}} />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}

class MusicFolder extends Component {
  fileItems = fileItems
  expanded = ["Music", "Music/Albums", "Music/Albums/Marsh Radio"]
  @tracked selected: string | null =
    "Music/Albums/Marsh Radio/02 Heron Call.flac"

  onValueChange = (value: unknown) => {
    this.selected = (value as string | null) ?? null
  }

  get item() {
    return this.selected ? findItem(fileItems, this.selected) : undefined
  }

  get meta() {
    return this.selected ? fileMeta[this.selected] : undefined
  }

  get previewIcon() {
    return this.item?.children ? Folder : fileIcon(this.selected ?? "")
  }

  get folder() {
    return this.selected?.split("/").slice(0, -1).join(" / ")
  }

  get size() {
    return this.meta?.size ?? `${this.item?.children?.length ?? 0} items`
  }

  <template>
    <div class="cl-files">
      <Tree
        aria-label="Library folders"
        @items={{this.fileItems}}
        @defaultExpanded={{this.expanded}}
        @value={{this.selected}}
        @onValueChange={{this.onValueChange}}
        class="cl-ftree"
        as |t|
      >
        <FileRows @parts={{t}} @items={{this.fileItems}} />
      </Tree>
      <Separator @orientation="vertical" class="cl-files-sep" />
      <div class="cl-preview" aria-live="polite">
        {{#if this.item}}
          <span class="cl-preview-icon">{{icon this.previewIcon 14}}</span>
          <span class="cl-preview-name">{{this.item.label}}</span>
          <span class="cl-sub">{{if this.folder this.folder "Library"}}</span>
          <dl class="cl-preview-facts">
            <dt>Kind</dt>
            <dd>{{if this.meta this.meta.kind "Folder"}}</dd>
            <dt>Size</dt>
            <dd class="cl-mono">{{this.size}}</dd>
            {{#if this.meta}}
              <dt>Details</dt>
              <dd class="cl-mono">{{this.meta.extra}}</dd>
            {{/if}}
          </dl>
        {{else}}
          <span class="cl-sub">Select a file to see its details.</span>
        {{/if}}
      </div>
    </div>
  </template>
}

/* 4. What syncs offline: a checkbox tree from createTreeCollection, with mixed folders. */

const syncNodes: {
  key: string
  parent: string | null
  label: string
  mb?: number
}[] = [
  { key: "road", parent: null, label: "Road trip" },
  { key: "road/1", parent: "road", label: "Coastline Drive", mb: 9.4 },
  { key: "road/2", parent: "road", label: "Mile Marker", mb: 7.1 },
  { key: "road/3", parent: "road", label: "Two-Lane Blacktop", mb: 11.6 },
  { key: "focus", parent: null, label: "Deep focus" },
  { key: "focus/1", parent: "focus", label: "Grid Lines", mb: 14.3 },
  { key: "focus/2", parent: "focus", label: "Low Hum", mb: 12.5 },
  { key: "focus/3", parent: "focus", label: "Afterimage", mb: 10.9 },
]
const syncTree = createTreeCollection(syncNodes)
const syncInfo = new Map(syncNodes.map((node) => [node.key, node]))

const levelStyle = (level: number) => htmlSafe(`--level: ${level}`)

class OfflineSync extends Component {
  @tracked checked = ["road/1", "road/3", "focus"]
  @tracked expanded = ["road"]

  get state() {
    return treeCheckedStates(syncTree, this.checked)
  }

  get total() {
    const { state } = this
    return syncNodes
      .reduce(
        (sum, node) =>
          sum + (node.mb && state(node.key) === true ? node.mb : 0),
        0
      )
      .toFixed(1)
  }

  get rows() {
    const { state, expanded } = this
    return syncTree.visible(expanded).map((key) => {
      const node = syncInfo.get(key)!
      const branch = syncTree.isBranch(key)
      const open = expanded.includes(key)
      const value = state(key)
      return {
        key,
        node,
        branch,
        open,
        level: syncTree.level(key),
        mixed: value === "indeterminate",
        on: value === true,
        ariaChecked: value === "indeterminate" ? "mixed" : String(value),
        boxState: value === "indeterminate" ? "mixed" : value ? "on" : "off",
        action: `${open ? "Collapse" : "Expand"} ${node.label}`,
        nameClass: branch ? "cl-sync-name" : "cl-sync-name cl-sync-leaf",
        meta: branch
          ? `${syncTree.children(key).length} songs`
          : `${node.mb?.toFixed(1)} MB`,
      }
    })
  }

  toggleOpen = (key: string) => {
    this.expanded = this.expanded.includes(key)
      ? this.expanded.filter((item) => item !== key)
      : [...this.expanded, key]
  }

  toggleChecked = (key: string) => {
    this.checked = toggleTreeChecked(syncTree, this.checked, key)
  }

  <template>
    <div class="cl-sync">
      <div class="cl-sync-head">
        <span class="cl-label">Keep offline</span>
        <span class="cl-mono">{{this.total}} MB</span>
      </div>
      <ul class="cl-sync-list" aria-label="Playlists to keep offline">
        {{#each this.rows key="key" as |row|}}
          <li class="cl-sync-row" style={{levelStyle row.level}}>
            {{#if row.branch}}
              <button
                type="button"
                class="cl-sync-caret"
                aria-expanded={{if row.open "true" "false"}}
                aria-label={{row.action}}
                {{on "click" (fn this.toggleOpen row.key)}}
              >{{icon ChevronRight 14}}</button>
            {{else}}
              <span class="cl-sync-caret"></span>
            {{/if}}
            <button
              type="button"
              role="checkbox"
              aria-checked={{row.ariaChecked}}
              class="cl-sync-check"
              {{on "click" (fn this.toggleChecked row.key)}}
            >
              <span class="cl-checkbox" data-state={{row.boxState}}>
                {{#if row.mixed}}
                  {{icon Minus 14}}
                {{else if row.on}}
                  {{icon Check 14}}
                {{/if}}
              </span>
              <span class={{row.nameClass}}>{{row.node.label}}</span>
            </button>
            <span class="cl-mono cl-faint">{{row.meta}}</span>
          </li>
        {{/each}}
      </ul>
    </div>
  </template>
}

/* 5. A book's contents: Tree rendered as flat rows from visibleTreeRows. */

const contents: TreeItemData[] = [
  {
    value: "part-1",
    label: "Coast",
    children: [
      { value: "ch-1", label: "The Survey Ship" },
      { value: "ch-2", label: "Soundings" },
      { value: "ch-3", label: "A Map of Fog" },
    ],
  },
  {
    value: "part-2",
    label: "Interior",
    children: [
      { value: "ch-4", label: "Salt Roads" },
      { value: "ch-5", label: "The Borderless Room" },
    ],
  },
  {
    value: "part-3",
    label: "Return",
    children: [
      { value: "ch-6", label: "Homecoming Charts" },
      { value: "ch-7", label: "Legend and Scale" },
    ],
  },
]
const contentPages: Record<string, number> = {
  "part-1": 1,
  "ch-1": 3,
  "ch-2": 27,
  "ch-3": 52,
  "part-2": 81,
  "ch-4": 83,
  "ch-5": 118,
  "part-3": 151,
  "ch-6": 153,
  "ch-7": 189,
}
const partNames: Record<string, string> = {
  "part-1": "Part one",
  "part-2": "Part two",
  "part-3": "Part three",
}

const contentRow = (item: TreeItemData, level: number) => ({
  item,
  level,
  branch: !!item.children,
  number: item.value.slice(3),
  part: partNames[item.value],
  page: contentPages[item.value],
})

class BookContents extends Component {
  contents = contents
  @tracked expanded = ["part-1"]

  // Each row keeps one object, so Glimmer retains it instead of updating it mid-render.
  cache = new Map<string, ReturnType<typeof contentRow>>()

  get rows() {
    return visibleTreeRows(contents, this.expanded).map(({ item, level }) => {
      let row = this.cache.get(item.value)
      if (!row) {
        row = contentRow(item, level)
        this.cache.set(item.value, row)
      }
      return row
    })
  }

  onExpandedChange = (next: string[]) => {
    this.expanded = next
  }

  <template>
    <div class="cl-toc">
      <div class="cl-toc-head">
        <span class="cl-toc-title">The Cartographer’s Daughter</span>
        <span class="cl-sub">Ines Varga · 204 pages</span>
      </div>
      <Tree
        aria-label="Contents"
        @items={{this.contents}}
        @expanded={{this.expanded}}
        @onExpandedChange={{this.onExpandedChange}}
        @defaultValue="ch-2"
        @expandOnPress={{true}}
        class="cl-toc-tree"
        as |t|
      >
        {{#each this.rows key="item.value" as |row|}}
          <t.Item
            @value={{row.item.value}}
            @branch={{row.branch}}
            class="cl-toc-item"
            as |i|
          >
            <i.Label class="cl-toc-row" data-level={{row.level}}>
              {{#if row.branch}}
                <i.Indicator class="cl-toc-caret">{{icon
                    ChevronRight
                    14
                  }}</i.Indicator>
              {{else}}
                <span class="cl-toc-num">{{row.number}}</span>
              {{/if}}
              <span class="cl-ellipsis">
                {{#if row.branch}}
                  <span class="cl-toc-part">{{row.part}}</span>
                  {{row.item.label}}
                {{else}}
                  {{row.item.label}}
                {{/if}}
              </span>
              <span class="cl-toc-page">{{row.page}}</span>
            </i.Label>
          </t.Item>
        {{/each}}
      </Tree>
    </div>
  </template>
}

/* 6. A podcast's seasons in an accordion. */

const seasons = [
  {
    value: "s3",
    label: "Season 3",
    meta: "2026 · 8 episodes",
    episodes: [
      { title: "Night Market Recipes", length: "38 min" },
      { title: "The Ferry Strike", length: "44 min" },
    ],
  },
  {
    value: "s2",
    label: "Season 2",
    meta: "2025 · 10 episodes",
    episodes: [
      { title: "Ice Road Choir", length: "51 min" },
      { title: "Shortwave Hobbyists", length: "36 min" },
    ],
  },
  {
    value: "s1",
    label: "Season 1",
    meta: "2024 · 6 episodes",
    episodes: [
      { title: "Pilot: Slack Water", length: "29 min" },
      { title: "The Eel Fishers", length: "42 min" },
    ],
  },
]

const Seasons = <template>
  <div class="cl-seasons">
    <span class="cl-label">Low Tide Radio</span>
    <Accordion @defaultValue={{array "s3"}} class="cl-acc" as |a|>
      {{#each seasons key="value" as |season|}}
        <a.Item @value={{season.value}} class="cl-acc-item" as |i|>
          <i.Header class="cl-acc-header">
            <i.Trigger class="cl-acc-trigger">
              <span class="cl-acc-name">{{season.label}}</span>
              <span class="cl-sub">{{season.meta}}</span>
              {{icon ChevronDown 14 (hash class="cl-acc-caret")}}
            </i.Trigger>
          </i.Header>
          <i.Panel class="cl-acc-panel">
            <ul class="cl-acc-eps">
              {{#each season.episodes key="title" as |episode|}}
                <li>
                  <span class="cl-ellipsis">{{episode.title}}</span>
                  <span class="cl-mono cl-faint">{{episode.length}}</span>
                </li>
              {{/each}}
            </ul>
          </i.Panel>
        </a.Item>
      {{/each}}
    </Accordion>
  </div>
</template>

/* 7. Album credits fold away; avatars fall back to initials. */

const portrait = (a: string, b: string) =>
  `data:image/svg+xml,${encodeURIComponent(
    `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${a}"/><stop offset="1" stop-color="${b}"/></linearGradient></defs><rect width="64" height="64" fill="url(#g)"/><circle cx="32" cy="26" r="11" fill="#fff" fill-opacity=".55"/><rect x="14" y="42" width="36" height="22" rx="11" fill="#fff" fill-opacity=".55"/></svg>`
  )}`

const credits: { name: string; role: string; image?: string }[] = [
  {
    name: "Mira Okafor",
    role: "Vocals, piano",
    image: portrait("#e0a96d", "#b5523b"),
  },
  { name: "Dev Anand", role: "Producer" },
  { name: "June Halloran", role: "Mixing engineer" },
]

const Credits = <template>
  <Collapsible @defaultOpen={{true}} class="cl-credits" as |c|>
    <div class="cl-credits-head">
      <span class="cl-stack">
        <span class="cl-track-title">Paper Lanterns</span>
        <span class="cl-sub">Mira Okafor · 11 songs</span>
      </span>
      <c.Trigger class="cl-credits-trigger">
        Credits
        {{icon ChevronDown 14}}
      </c.Trigger>
    </div>
    <c.Panel class="cl-credits-panel">
      <ul class="cl-credits-list">
        {{#each credits key="name" as |person|}}
          <li>
            <Avatar class="cl-avatar" as |a|>
              {{#if person.image}}
                <a.Image
                  @src={{person.image}}
                  alt={{person.name}}
                  class="cl-avatar-img"
                />
              {{/if}}
              <a.Fallback class="cl-avatar-fallback">{{initialsOf
                  person.name
                }}</a.Fallback>
            </Avatar>
            <span class="cl-ellipsis">{{person.name}}</span>
            <span class="cl-sub cl-ellipsis">{{person.role}}</span>
          </li>
        {{/each}}
      </ul>
    </c.Panel>
  </Collapsible>
</template>

/* 8. A podcast backlog: multiple selection kept across pages. */

const episodeTitles = [
  "The last bookshop in Tromsø",
  "Ghostwriters, unmasked",
  "Why paperbacks won",
  "Marginalia of famous readers",
  "A year of reading slowly",
  "The translator’s choice",
  "Libraries after midnight",
  "Fan fiction goes to court",
  "Serial novels, again",
  "The hardest first line",
  "Audiobooks and the ear",
  "Banned in three countries",
  "The editor’s red pen",
  "Reading on the night train",
  "Poetry that sells",
  "Inside a printing plant",
  "Short stories, long tails",
  "The cover redesign wars",
  "Letters to dead authors",
  "Bestseller lists, decoded",
  "The secondhand economy",
  "Bookbinding by hand",
  "Unfinished novels",
  "The reader’s diary",
]
const episodes = episodeTitles.map((title, index) => ({
  id: `ep-${24 - index}`,
  number: 24 - index,
  title,
  length: 28 + ((index * 11) % 30),
}))
const EPISODES_PER_PAGE = 3

class Backlog extends Component {
  pageCount = episodes.length / EPISODES_PER_PAGE
  @tracked page = 1
  @tracked picked = ["ep-24", "ep-22", "ep-17"]

  get onPage() {
    return episodes.slice(
      (this.page - 1) * EPISODES_PER_PAGE,
      this.page * EPISODES_PER_PAGE
    )
  }

  get pageIds() {
    return this.onPage.map((episode) => episode.id)
  }

  get pickedHere() {
    const { pageIds } = this
    return this.picked.filter((id) => pageIds.includes(id))
  }

  onValueChange = (value: string[]) => {
    const { pageIds } = this
    this.picked = [
      ...this.picked.filter((id) => !pageIds.includes(id)),
      ...value,
    ]
  }

  onPageChange = (page: number) => {
    this.page = page
  }

  <template>
    <div class="cl-backlog">
      <div class="cl-backlog-head">
        <span class="cl-label">The Margin Notes</span>
        <span class="cl-mono cl-dim" aria-live="polite">
          {{this.picked.length}}
          selected
        </span>
      </div>
      <Listbox
        @multiple={{true}}
        aria-label="Episodes to download"
        @value={{this.pickedHere}}
        @onValueChange={{this.onValueChange}}
        class="cl-eps"
        as |l|
      >
        {{#each this.onPage key="id" as |episode|}}
          <l.Item
            @value={{episode.id}}
            @label={{episode.title}}
            class="cl-ep"
            as |i|
          >
            <span class="cl-mono cl-faint">{{episode.number}}</span>
            <span class="cl-ellipsis">{{episode.title}}</span>
            <span class="cl-mono cl-faint">{{episode.length}}m</span>
            <span class="cl-ep-box">
              <i.Indicator class="cl-ep-check">{{icon Check 14}}</i.Indicator>
            </span>
          </l.Item>
        {{/each}}
      </Listbox>
      <Pagination
        aria-label="Episode pages"
        @pageCount={{this.pageCount}}
        @page={{this.page}}
        @onPageChange={{this.onPageChange}}
        @siblings={{0}}
        @boundaries={{1}}
        class="cl-pages"
        as |p|
      >
        <p.List class="cl-pages-list" as |l|>
          <p.Item>
            <p.Previous aria-label="Previous page" class="cl-page">{{icon
                ChevronLeft
                14
              }}</p.Previous>
          </p.Item>
          {{#each l.state.items key="@identity" as |item|}}
            <p.Item>
              {{#if (isNumber item)}}
                <p.Link @page={{item}} class="cl-page" />
              {{else}}
                <p.Ellipsis class="cl-page-gap" />
              {{/if}}
            </p.Item>
          {{/each}}
          <p.Item>
            <p.Next aria-label="Next page" class="cl-page">{{icon
                ChevronRight
                14
              }}</p.Next>
          </p.Item>
        </p.List>
      </Pagination>
    </div>
  </template>
}

/* 9. Lyrics in a scroll area with edge fades, a custom thumb and a reading line. */

const lyrics = [
  [
    "The freight yard hums in a minor key",
    "Sodium light on the overpass",
    "You fold the map the wrong way round",
    "And we laugh till the windows fog",
  ],
  [
    "Four in the morning, northbound",
    "Every town just a name and a bell",
    "Keep the radio low, keep the heater on",
    "We’ll be home before the gulls",
  ],
  [
    "Somewhere a baker lifts the shutters",
    "Somewhere a ferry starts its turn",
    "I count the poles like rosary beads",
    "You sleep with your boots still on",
  ],
  [
    "Four in the morning, northbound",
    "Nothing ahead but the long white line",
    "If the road runs out, we’ll walk it",
    "We’ll be home before the gulls",
  ],
]

const Lyrics = <template>
  <div class="cl-lyrics">
    <div class="cl-lyrics-head">
      {{icon Music 16}}
      <span class="cl-ellipsis">
        Four in the Morning, Northbound
        <span class="cl-dim">· Wren &amp; the Tidelines</span>
      </span>
    </div>
    <ScrollArea class="cl-lyrics-area" as |s|>
      <s.Viewport aria-label="Lyrics" class="cl-lyrics-viewport">
        <s.Content class="cl-lyrics-content">
          {{#each lyrics as |verse|}}
            <p>
              {{#each verse as |line|}}
                <span>{{line}}</span>
              {{/each}}
            </p>
          {{/each}}
        </s.Content>
      </s.Viewport>
      <div class="cl-fade cl-fade-top"></div>
      <div class="cl-fade cl-fade-bottom"></div>
      <div class="cl-lyrics-line" aria-hidden="true"></div>
      <s.Scrollbar @orientation="vertical" class="cl-scrollbar" as |sb|>
        <sb.Thumb class="cl-thumb" />
      </s.Scrollbar>
    </ScrollArea>
  </div>
</template>

/* 10. New releases in a carousel of covers. */

const releases = [
  { title: "Soft Machinery", artist: "Lumen Ward", hue: 200 },
  { title: "Blue Hour Club", artist: "Okra & Lime", hue: 245 },
  { title: "Northern Rooms", artist: "Saga Holm", hue: 165 },
  { title: "Midnight Bakery", artist: "The Pastry Saints", hue: 40 },
  { title: "Concrete Garden", artist: "Juno Vale", hue: 120 },
  { title: "Heat Haze", artist: "Marisol", hue: 18 },
  { title: "Second Summer", artist: "Ferris Day", hue: 85 },
  { title: "Dial Tone Love", artist: "Pip Arroyo", hue: 350 },
]

const byArtist = (title: string, artist: string) => `${title} by ${artist}`

const NewReleases = <template>
  <Carousel
    aria-label="New releases"
    @slidesPerPage="auto"
    class="cl-carousel"
    as |c|
  >
    <div class="cl-carousel-head">
      <span class="cl-stack">
        <span class="cl-track-title">New this Friday</span>
        <span class="cl-sub">8 albums from artists you follow</span>
      </span>
      <span class="cl-carousel-nav">
        <c.Previous aria-label="Previous albums" class="cl-round">{{icon
            ChevronLeft
            16
          }}</c.Previous>
        <c.Next aria-label="Next albums" class="cl-round">{{icon
            ChevronRight
            16
          }}</c.Next>
      </span>
    </div>
    <c.Viewport class="cl-carousel-viewport">
      <c.Content class="cl-carousel-content">
        {{#each releases key="title" as |album|}}
          <c.Item
            aria-label={{byArtist album.title album.artist}}
            class="cl-slide"
          >
            <Cover @hue={{album.hue}} @size={{108}} @title={{album.title}} />
            <span class="cl-slide-title cl-ellipsis">{{album.title}}</span>
            <span class="cl-sub cl-ellipsis">{{album.artist}}</span>
          </c.Item>
        {{/each}}
      </c.Content>
    </c.Viewport>
  </Carousel>
</template>

/* 11. Importing a folder: determinate bars fill, an unknown count pulses. */

const importFiles = [
  { id: "dawn", name: "Dawn chorus, Øresund.wav", size: "212 MB", rate: 3 },
  { id: "rain", name: "Rain on a tin roof.wav", size: "96 MB", rate: 5 },
  { id: "photos", name: "Sleeve photos", size: "Folder", rate: 6 },
]
const importStart: Record<string, number | null> = {
  dawn: 62,
  rain: 18,
  photos: null,
}

class FolderImport extends Component {
  @tracked values = importStart
  @tracked running = false

  get complete() {
    return importFiles.every((file) => this.values[file.id] === 100)
  }

  get status() {
    return this.complete
      ? "Imported to Library"
      : this.running
        ? "Importing…"
        : "Paused"
  }

  get action() {
    return this.complete ? "Again" : this.running ? "Pause" : "Resume"
  }

  get rows() {
    const { complete } = this
    return importFiles.map((file) => {
      const value = complete ? 100 : this.values[file.id]
      return {
        file,
        value,
        text:
          value === null
            ? "Counting files"
            : value === 100
              ? "Done"
              : `${value}%`,
      }
    })
  }

  watch = () => {
    const timer = setInterval(() => {
      if (!this.running) {
        return
      }
      const next = { ...this.values }
      const audioDone = next.dawn === 100 && next.rain === 100
      for (const file of importFiles) {
        const value = next[file.id]
        if (value === null) {
          next[file.id] = audioDone ? 0 : null
        } else {
          next[file.id] = Math.min(100, value + file.rate)
        }
      }
      this.values = next
    }, 140)
    return () => clearInterval(timer)
  }

  press = () => {
    if (this.complete) {
      this.values = importStart
      this.running = false
    } else {
      this.running = !this.running
    }
  }

  <template>
    <div class="cl-import" {{onInsert this.watch}}>
      <div class="cl-import-head">
        <span class="cl-stack">
          <span class="cl-track-title">Field Recordings 2025</span>
          <span class="cl-sub">{{this.status}}</span>
        </span>
        <button
          type="button"
          class="b-btn"
          data-variant="primary"
          {{on "click" this.press}}
        >{{this.action}}</button>
      </div>
      <ul class="cl-import-list">
        {{#each this.rows key="file.id" as |row|}}
          <li>
            <Progress
              @value={{row.value}}
              aria-label={{row.file.name}}
              class="cl-import-progress"
              as |p|
            >
              <span class="cl-import-line">
                <span class="cl-ellipsis">{{row.file.name}}</span>
                <span class="cl-mono cl-dim">{{row.text}}</span>
              </span>
              <p.Track class="cl-import-track">
                <p.Indicator class="cl-import-fill" />
              </p.Track>
            </Progress>
          </li>
        {{/each}}
      </ul>
    </div>
  </template>
}

/* 12. A yearly reading goal drawn as a ring meter. */

const GOAL = 52

class ReadingGoal extends Component {
  goal = GOAL
  @tracked read = 34

  get met() {
    return this.read >= GOAL
  }

  get left() {
    return this.met ? "Goal met" : `${GOAL - this.read} to go`
  }

  get note() {
    return this.met
      ? "Every book now is a bonus."
      : "Ahead of pace for December."
  }

  get empty() {
    return this.read <= 0
  }

  format = (value: number) => String(value)
  valueLabel = (value: number | null) => `${value} of ${GOAL} books`
  remove = () => {
    this.read = Math.max(0, this.read - 1)
  }
  add = () => {
    this.read = Math.min(GOAL, this.read + 1)
  }

  <template>
    <div class="cl-goal">
      <Meter
        @value={{this.read}}
        @max={{this.goal}}
        aria-label="2026 reading goal"
        @format={{this.format}}
        @getValueLabel={{this.valueLabel}}
        class="cl-ring"
        as |m|
      >
        <span class="cl-ring-face">
          <m.Value class="cl-ring-num" />
          <span class="cl-sub">of {{this.goal}} books</span>
        </span>
      </Meter>
      <div class="cl-goal-side">
        <span class="cl-label">2026 reading goal</span>
        <span class="cl-goal-left">{{this.left}}</span>
        <span class="cl-sub">{{this.note}}</span>
        <div class="cl-goal-actions">
          <button
            type="button"
            class="cl-goal-minus"
            aria-label="Remove a book"
            disabled={{this.empty}}
            {{on "click" this.remove}}
          >{{icon Minus 14}}</button>
          <button
            type="button"
            class="b-btn"
            data-variant="primary"
            disabled={{this.met}}
            {{on "click" this.add}}
          >
            {{icon Plus 14}}
            Log a book
          </button>
        </div>
      </div>
    </div>
  </template>
}

/* 13. @mentions in a book club note. */

const readers = [
  { value: "priya", label: "Priya Raman", hue: 20 },
  { value: "oskar", label: "Oskar Lind", hue: 200 },
  { value: "hana", label: "Hana Mori", hue: 330 },
  { value: "leo", label: "Leo Brandt", hue: 120 },
  { value: "ama", label: "Ama Owusu", hue: 60 },
]
const readerHue = new Map(readers.map((reader) => [reader.value, reader.hue]))
const readerTriggers = [{ char: "@", items: readers }]
const hueStyle = (hue: number | undefined) => htmlSafe(`--hue: ${hue ?? 0}`)
const readerStyle = (value: string) => hueStyle(readerHue.get(value))

class ClubNote extends Component {
  id = `${guidFor(this)}-note`
  triggers = readerTriggers
  draft = "Finished the lighthouse chapter. "

  <template>
    <div class="cl-club">
      <div class="cl-club-head">
        <label for={{this.id}} class="cl-label">Tuesday book club</label>
        <span class="cl-sub">The Salt Archive · ch. 9</span>
      </div>
      <TriggerMenu @triggers={{this.triggers}} as |m|>
        <m.Input
          id={{this.id}}
          placeholder="Type @ to mention a reader"
          class="cl-club-input"
        >{{this.draft}}</m.Input>
        <m.Status class="cl-sr" />
        <m.Content class="b-pop cl-menu">
          <m.Empty class="cl-menu-empty">No reader by that name.</m.Empty>
          <m.List as |list|>
            {{#each list.state.items key="value" as |item|}}
              <m.Item
                @value={{item.value}}
                @label={{item.label}}
                class="b-item cl-menu-item"
              >
                <span
                  aria-hidden="true"
                  class="cl-initials"
                  style={{readerStyle item.value}}
                >{{initialsOf item.label}}</span>
                {{item.label}}
              </m.Item>
            {{/each}}
          </m.List>
        </m.Content>
      </TriggerMenu>
      <span class="cl-sub">Type @ to mention · 5 readers</span>
    </div>
  </template>
}

/* 14. A question with chapter tokens: TokenInput with a TriggerMenu inside. */

const chapters = [
  { value: "ch-1", label: "Barometer" },
  { value: "ch-2", label: "The Long Fog" },
  { value: "ch-3", label: "Hailstones" },
  { value: "ch-4", label: "Thaw" },
  { value: "ch-5", label: "Lightning Rods" },
  { value: "epilogue", label: "Clear Skies" },
]
const chapterTriggers = [{ char: "@", type: "chapter", items: chapters }]

const promptStart: TokenInputValue = [
  "Compare ",
  { type: "chapter", value: "ch-2", label: "The Long Fog" },
  " with ",
  { type: "chapter", value: "ch-4", label: "Thaw" },
  " ",
]

class ChapterPrompt extends Component {
  prompt = createTokenInputController()
  start = promptStart
  triggers = chapterTriggers
  @tracked asked: string | null = null

  get hint() {
    return this.asked ?? "@ adds a chapter"
  }

  send = (value: TokenInputValue) => {
    const count = value.filter((part) => typeof part !== "string").length
    if (!this.prompt.getLabel().trim()) {
      return
    }
    this.asked =
      count === 1 ? "Asked about 1 chapter." : `Asked about ${count} chapters.`
    this.prompt.clear()
  }

  ask = () => this.send(this.prompt.getValue())

  <template>
    <div class="cl-prompt">
      <span class="cl-label">A Thousand Small Weathers</span>
      <TokenInput
        @controller={{this.prompt}}
        @defaultValue={{this.start}}
        @onSubmit={{this.send}}
        as |t|
      >
        <t.Tokens as |token parts|>
          <parts.Token class="cl-token">
            {{icon Bookmark 14}}
            {{token.label}}
            <parts.Remove class="cl-token-remove">{{icon X 14}}</parts.Remove>
          </parts.Token>
        </t.Tokens>
        <div class="cl-prompt-box">
          <t.Editor
            aria-label="Question about the book"
            placeholder="Ask about a chapter"
            class="cl-prompt-editor"
          />
          <div class="cl-prompt-foot">
            <span class="cl-sub" aria-live="polite">{{this.hint}}</span>
            <button
              type="button"
              class="cl-send"
              aria-label="Ask"
              {{on "mousedown" keepFocus}}
              {{on "click" this.ask}}
            >{{icon Send 14}}</button>
          </div>
        </div>
        <TriggerMenu @editor={{t.editor}} @triggers={{this.triggers}} as |m|>
          <m.Content class="b-pop cl-menu">
            <m.Empty class="cl-menu-empty">No chapter matches.</m.Empty>
            <m.List as |list|>
              {{#each list.state.items key="value" as |item|}}
                <m.Item
                  @value={{item.value}}
                  @label={{item.label}}
                  class="b-item cl-menu-item"
                >
                  {{icon Bookmark 14}}
                  {{item.label}}
                </m.Item>
              {{/each}}
            </m.List>
          </m.Content>
        </TriggerMenu>
      </TokenInput>
    </div>
  </template>
}

/* 15. Book search with results that load as you type. */

type Book = {
  value: string
  label: string
  author: string
  year: number
  hue: number
}

const catalog: Book[] = [
  ["The Quiet Engine", "Rhea Castellan", 2019, 210],
  ["Salt & Saffron", "Omar Haddad", 2021, 35],
  ["A Field Guide to Leaving", "Bea Lindgren", 2017, 150],
  ["The Clockmaker’s Garden", "Eamon Pryce", 2023, 95],
  ["Moth Season", "Ines Tal", 2020, 300],
  ["Lowland Psalms", "Kofi Mensah", 2015, 60],
  ["The Ninth Lantern", "Clara Whitlock", 2022, 15],
  ["Every River Ends", "Arjun Mehta", 2018, 190],
  ["Quarry Light", "Sunniva Berg", 2024, 120],
  ["The Understudy", "Paloma Reyes", 2016, 340],
  ["Small Gods of August", "Theo Nakashima", 2021, 50],
  ["The Weight of Feathers", "Mae Abernathy", 2014, 260],
  ["Station Eleven Minutes", "Joss Kerrigan", 2023, 230],
  ["House of Echoing Tiles", "Leila Farahani", 2019, 175],
  ["Glasswing", "Ronan Voss", 2020, 280],
  ["The Orchard Keeper’s Wife", "Hedda Strand", 2012, 80],
].map(([label, author, year, hue]) => ({
  value: String(label).toLowerCase().replace(/\W+/g, "-"),
  label: String(label),
  author: String(author),
  year: Number(year),
  hue: Number(hue),
}))

function searchCatalog(query: string, { signal }: { signal: AbortSignal }) {
  return new Promise<Book[]>((resolve, reject) => {
    const timer = setTimeout(() => {
      const needle = query.trim().toLowerCase()
      resolve(
        catalog
          .filter(
            (book) =>
              !needle ||
              `${book.label} ${book.author}`.toLowerCase().includes(needle)
          )
          .slice(0, 6)
      )
    }, 450)
    signal.addEventListener("abort", () => {
      clearTimeout(timer)
      reject(signal.reason)
    })
  })
}

const searchStatus = (state: {
  status: string
  loading: boolean
  count: number
}) =>
  state.status === "error"
    ? "Couldn’t reach the catalog."
    : state.loading
      ? "Searching…"
      : `${state.count} ${state.count === 1 ? "book" : "books"}`

const searchEmpty = (state: {
  empty: boolean
  loading: boolean
  query: string
}) => (state.empty && !state.loading ? `No books match “${state.query}”.` : "")

class BookSearch extends Component {
  books = useAsyncOptions(this, searchCatalog, {
    debounce: 250,
    immediate: true,
  })
  @tracked chosen: Book = catalog[0]

  statusText = searchStatus
  emptyText = searchEmpty

  onValueChange = (value: string, details: { reason: string }) => {
    this.books.setQuery(value)
    const match = catalog.find((book) => book.label === value)
    if (match && details.reason === "item-press") {
      this.chosen = match
    }
  }

  <template>
    <div class="cl-search">
      <Autocomplete
        @items={{this.books.state.items}}
        @filter={{false}}
        @status={{this.books.state.status}}
        @onValueChange={{this.onValueChange}}
        as |c|
      >
        <c.Label class="cl-label">Find a book</c.Label>
        <div class="cl-search-field">
          {{icon Search 14 (hash class="cl-search-icon")}}
          <c.Input
            placeholder="Title or author"
            class="b-input cl-search-input"
          />
        </div>
        <c.Content @sideOffset={{6}} class="b-pop cl-search-pop">
          <c.Status class="cl-menu-status" as |s|>{{this.statusText
              s.state
            }}</c.Status>
          <c.Empty class="cl-menu-empty" as |e|>{{this.emptyText
              e.state
            }}</c.Empty>
          <c.List class="cl-search-list" as |list|>
            {{#each list.state.items key="value" as |book|}}
              <c.Item
                @value={{book.value}}
                @label={{book.label}}
                class="b-item cl-search-item"
              >
                <Cover @hue={{book.hue}} @size={{22}} />
                <span class="cl-ellipsis">{{book.label}}</span>
                <span class="cl-sub cl-ellipsis">{{book.author}}</span>
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Autocomplete>
      <div class="cl-search-card" aria-live="polite">
        <Cover @hue={{this.chosen.hue}} @size={{44}} />
        <span class="cl-stack">
          <span class="cl-track-title cl-ellipsis">{{this.chosen.label}}</span>
          <span class="cl-sub">{{this.chosen.author}}
            ·
            {{this.chosen.year}}</span>
        </span>
      </div>
    </div>
  </template>
}

/* 16. Genres for a playlist, as chips in a multi-select combobox. */

const genres = [
  { value: "dream-pop", label: "Dream pop" },
  { value: "post-rock", label: "Post-rock" },
  { value: "shoegaze", label: "Shoegaze" },
  { value: "ambient", label: "Ambient" },
  { value: "jazz-fusion", label: "Jazz fusion" },
  { value: "krautrock", label: "Krautrock" },
  { value: "bossa-nova", label: "Bossa nova" },
  { value: "neo-soul", label: "Neo-soul" },
  { value: "chamber-pop", label: "Chamber pop" },
  { value: "synthwave", label: "Synthwave" },
  { value: "folk", label: "Folk" },
]
const genreLabel = (value: string) =>
  genres.find((genre) => genre.value === value)?.label ?? value
const stringValues = (value: unknown) =>
  Array.isArray(value)
    ? value.filter((item): item is string => typeof item === "string")
    : []
const labelAt = (labels: readonly string[], index: number) => labels[index]
const removeLabel = (labels: readonly string[], index: number) =>
  `Remove ${labels[index]}`

class PlaylistGenres extends Component {
  genres = genres
  genreLabel = genreLabel
  @tracked picked = ["dream-pop", "post-rock"]

  get summary() {
    return this.picked.length
      ? `About ${this.picked.length * 37 + 12} songs match`
      : "Add a genre to fill it"
  }

  get placeholder() {
    return this.picked.length ? "Add more" : "Add a genre"
  }

  onValueChange = (value: unknown) => {
    this.picked = (value as string[] | null) ?? []
  }

  <template>
    <div class="cl-genres">
      <div class="cl-genres-head">
        <Cover @hue={{265}} @size={{36}} />
        <span class="cl-stack">
          <span class="cl-track-title">Night Bus Mix</span>
          <span class="cl-sub">{{this.summary}}</span>
        </span>
      </div>
      <Combobox
        @multiple={{true}}
        @value={{this.picked}}
        @onValueChange={{this.onValueChange}}
        @itemToLabel={{this.genreLabel}}
        as |c|
      >
        <c.Label class="cl-label">Genres</c.Label>
        <c.Chips class="cl-chips">
          <c.Value as |state|>
            {{#each
              (stringValues state.value) key="@identity"
              as |value index|
            }}
              <c.Chip @value={{value}} class="cl-chip" as |chip|>
                {{labelAt state.labels index}}
                <chip.Remove
                  aria-label={{removeLabel state.labels index}}
                  class="cl-chip-remove"
                >{{icon X 14}}</chip.Remove>
              </c.Chip>
            {{/each}}
          </c.Value>
          <c.Input placeholder={{this.placeholder}} class="cl-chips-input" />
        </c.Chips>
        <c.Content @sideOffset={{6}} class="b-pop cl-genre-pop">
          <c.Empty class="cl-menu-empty">No genre by that name.</c.Empty>
          <c.List>
            {{#each this.genres key="value" as |genre|}}
              <c.Item
                @value={{genre.value}}
                @label={{genre.label}}
                class="b-item cl-genre-item"
                as |item|
              >
                {{genre.label}}
                <item.Indicator class="cl-genre-check">{{icon
                    Check
                    14
                  }}</item.Indicator>
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Combobox>
    </div>
  </template>
}

/* 17. A copy log that follows its newest line until you scroll up. */

const logFiles = [
  ["Disc 1/01 Low Season.flac", "41.8 MB"],
  ["Disc 1/02 Paper Moon Motel.flac", "37.2 MB"],
  ["Disc 1/03 Cold Open.flac", "29.6 MB"],
  ["Disc 1/04 Tram Lines.flac", "44.0 MB"],
  ["Disc 2/01 Smoke Signals.flac", "35.5 MB"],
  ["Disc 2/02 The Long Way Down.flac", "48.3 MB"],
  ["Disc 2/03 Tidepool.flac", "31.9 MB"],
  ["Disc 2/04 Allotment.flac", "26.7 MB"],
  ["booklet.pdf", "12.4 MB"],
]

function logLine(index: number) {
  const [name, size] = logFiles[index % logFiles.length]
  const seconds = 14 * 3600 + 2 * 60 + index * 3
  const time = [
    Math.floor(seconds / 3600),
    Math.floor(seconds / 60) % 60,
    seconds % 60,
  ]
    .map((part) => String(part).padStart(2, "0"))
    .join(":")
  const skipped = index % 7 === 5
  return { id: index, time, name, size: skipped ? "exists" : size, skipped }
}

class SyncLog extends Component {
  stick = createStickToBottom()
  @tracked visible = false
  @tracked following = this.stick.get().following
  @tracked count = 9

  get lines() {
    const { count } = this
    return Array.from({ length: Math.min(count, 120) }, (_, index) =>
      logLine(count - Math.min(count, 120) + index)
    )
  }

  get tabindex() {
    return this.following ? -1 : 0
  }

  watch = (el: Element) => {
    const stop = inView(el, (value) => (this.visible = value))
    const timer = setInterval(() => {
      if (this.visible) {
        this.count++
      }
    }, 1100)
    return () => {
      stop()
      clearInterval(timer)
    }
  }

  attach = (el: HTMLElement) => {
    const sync = () =>
      Promise.resolve().then(() => {
        this.following = this.stick.get().following
      })
    const unsubscribe = this.stick.subscribe(sync)
    const disconnect = this.stick.connect(el)
    sync()
    return () => {
      unsubscribe()
      disconnect()
    }
  }

  jump = () =>
    this.stick.scrollToBottom({
      behavior: prefersReducedMotion() ? "auto" : "smooth",
    })

  <template>
    <div class="cl-log" {{onInsert this.watch}}>
      <div class="cl-log-head">
        <span class="cl-log-live" data-live={{dataOn this.visible}}>
          Copying to pocket player
        </span>
        <span class="cl-mono cl-dim">{{this.count}} files</span>
      </div>
      <div class="cl-log-wrap">
        <div
          class="cl-log-scroller"
          tabindex="0"
          role="log"
          aria-label="Copy log"
          {{onInsert this.attach}}
        >
          {{#each this.lines key="id" as |line|}}
            <div class="cl-log-line" data-skipped={{dataOn line.skipped}}>
              <span>{{line.time}}</span>
              <span class="cl-ellipsis">{{line.name}}</span>
              <span>{{line.size}}</span>
            </div>
          {{/each}}
        </div>
        <button
          type="button"
          class="cl-log-jump"
          data-visible={{dataOn (eq this.following false)}}
          tabindex={{this.tabindex}}
          aria-hidden={{if this.following "true" "false"}}
          {{on "click" this.jump}}
        >
          {{icon ArrowDown 14}}
          Jump to latest
        </button>
      </div>
    </div>
  </template>
}

/* 18. Rename playlists in place with createInlineEdit. */

type RenameState = { editing: string | null; names: Record<string, string> }
type InlineEditContext = Parameters<typeof createInlineEdit<RenameState>>[0]

const playlistRows = [
  { id: "morning", count: 24, hue: 50 },
  { id: "commute", count: 61, hue: 190 },
  { id: "rainy", count: 18, hue: 230 },
  { id: "kitchen", count: 33, hue: 10 },
]

class RenamePlaylists extends Component {
  hint = `${guidFor(this)}-hint`
  list?: HTMLElement
  lastEdited: string | null = null

  @tracked snapshot: RenameState = {
    editing: null,
    names: {
      morning: "Morning pages",
      commute: "Commute (long)",
      rainy: "Rainy Sunday",
      kitchen: "Kitchen dancing",
    },
  }

  // createInlineEdit only calls store.get and store.set, so this stands in for a primitive's store.
  store = {
    get: () => this.snapshot,
    set: (patch: Partial<RenameState>) => {
      this.snapshot = { ...this.snapshot, ...patch }
      if ("editing" in patch) {
        this.returnFocus()
      }
    },
  }

  edit = createInlineEdit(
    { store: this.store } as unknown as InlineEditContext,
    {
      key: "editing",
      value: (id) => this.snapshot.names[id],
      commit: (id, text) => {
        const name = text.trim()
        if (!name) {
          return false
        }
        this.store.set({ names: { ...this.snapshot.names, [id]: name } })
        return true
      },
    }
  )

  get rows() {
    const { editing, names } = this.snapshot
    return playlistRows.map((row) => ({
      ...row,
      name: names[row.id],
      editing: editing === row.id,
    }))
  }

  // The button that started editing unmounts while the input shows, so put focus back on its replacement.
  returnFocus() {
    const { editing } = this.snapshot
    if (editing) {
      this.lastEdited = editing
      return
    }
    const id = this.lastEdited
    this.lastEdited = null
    setTimeout(() => {
      const active = document.activeElement
      if (id && (!active || active === document.body)) {
        this.list
          ?.querySelector<HTMLButtonElement>(
            `[data-row="${id}"] .cl-rename-name`
          )
          ?.focus()
      }
    }, 0)
  }

  attachList = (el: HTMLElement) => {
    this.list = el
  }

  bindInput = (el: HTMLInputElement) => this.edit.bindInput(el)

  inputKeydown = (event: KeyboardEvent) => this.edit.inputKeydown(event)
  inputBlur = (event: FocusEvent) => this.edit.end("focus-out", event)
  keydown = (id: string, event: KeyboardEvent) => this.edit.keydown(event, id)
  dblclick = (id: string, event: MouseEvent) => this.edit.dblclick(event, id)
  start = (id: string) => this.edit.start(id)

  <template>
    <div class="cl-rename">
      <ul class="cl-rename-list" {{onInsert this.attachList}}>
        {{#each this.rows key="id" as |row|}}
          <li
            data-row={{row.id}}
            class="cl-rename-row"
            data-editing={{dataOn row.editing}}
          >
            <Cover @hue={{row.hue}} @size={{30}} />
            {{#if row.editing}}
              <input
                aria-label="Rename {{row.name}}"
                class="cl-rename-input"
                {{onInsert this.bindInput}}
                {{on "keydown" this.inputKeydown}}
                {{on "blur" this.inputBlur}}
              />
            {{else}}
              <button
                type="button"
                class="cl-rename-name"
                aria-describedby={{this.hint}}
                {{on "keydown" (fn this.keydown row.id)}}
                {{on "dblclick" (fn this.dblclick row.id)}}
              >
                <span class="cl-ellipsis">{{row.name}}</span>
                <span class="cl-mono cl-faint">{{row.count}}</span>
              </button>
            {{/if}}
            <button
              type="button"
              class="cl-rename-pen"
              aria-label="Rename {{row.name}}"
              tabindex="-1"
              {{on "mousedown" keepFocus}}
              {{on "click" (fn this.start row.id)}}
            >{{icon Pencil 14}}</button>
          </li>
        {{/each}}
      </ul>
      <p id={{this.hint}} class="cl-sub cl-rename-hint">
        Double-click, Enter or F2 to rename
      </p>
    </div>
  </template>
}

/* 19. A passage that find in page can open: bindFindable with hiddenAttrs. */

class HiddenPassage extends Component {
  supported = supportsHiddenUntilFound()
  @tracked shown = false
  @tracked found = false

  get label() {
    return this.shown ? "Hide passage" : "Show passage"
  }

  get note() {
    return this.found
      ? "Opened by find in page."
      : this.supported
        ? "Or find “brass key” on this page."
        : "Find in page can’t open it here."
  }

  bind = (el: HTMLElement) =>
    bindFindable(el, {
      shown: () => this.shown,
      findable: () => true,
      reveal: () => {
        this.found = true
        this.shown = true
      },
    })

  toggle = () => {
    this.found = false
    this.shown = !this.shown
  }

  <template>
    <div class="cl-passage">
      <span class="cl-label">Chapter 7 · The Lamplighter’s Ledger</span>
      <p class="cl-passage-text">
        Every evening Maren climbed the ninety steps and lit the lamp by hand.
      </p>
      <div
        class="cl-passage-hidden"
        data-found={{dataOn this.found}}
        {{findable this.shown}}
        {{onInsert this.bind}}
      >
        <p class="cl-passage-text">
          Under the logbook she found a brass key, cold as river stone, and a
          second ledger in her mother’s hand.
        </p>
      </div>
      <div class="cl-passage-foot">
        <button
          type="button"
          class="b-btn"
          aria-expanded={{if this.shown "true" "false"}}
          {{on "click" this.toggle}}
        >{{this.label}}</button>
        <span class="cl-sub">{{this.note}}</span>
      </div>
    </div>
  </template>
}

export const tiles: Tile[] = [
  {
    id: "collections-now-playing",
    title: "Now playing.",
    blurb: "Tabs over three lists, with live progress.",
    size: "large",
    Demo: NowPlaying,
  },
  {
    id: "collections-ten-thousand",
    title: "Ten thousand tracks.",
    blurb: "Only the rows in view render.",
    size: "tall",
    tone: "paper",
    Demo: TenThousand,
  },
  {
    id: "collections-music-folder",
    title: "Your music folder.",
    blurb: "A file tree built from plain paths.",
    size: "wide",
    Demo: MusicFolder,
  },
  {
    id: "collections-offline-sync",
    title: "Pick what syncs.",
    blurb: "Mixed when partly checked.",
    tone: "sage",
    Demo: OfflineSync,
  },
  {
    id: "collections-book-contents",
    title: "Contents, flattened.",
    blurb: "Nested chapters rendered as flat rows.",
    tone: "paper",
    Demo: BookContents,
  },
  {
    id: "collections-seasons",
    title: "Season by season.",
    blurb: "One season open at a time.",
    Demo: Seasons,
  },
  {
    id: "collections-credits",
    title: "Read the credits.",
    blurb: "Liner notes fold away; initials stand in.",
    tone: "butter",
    Demo: Credits,
  },
  {
    id: "collections-backlog",
    title: "Queue a backlog.",
    blurb: "Selection holds across every page.",
    Demo: Backlog,
  },
  {
    id: "collections-lyrics",
    title: "Scroll the lyrics.",
    blurb: "Custom thumb, fades at both edges.",
    tone: "ink",
    Demo: Lyrics,
  },
  {
    id: "collections-new-releases",
    title: "Fresh this Friday.",
    blurb: "Swipe, use the arrow keys or the buttons.",
    size: "wide",
    tone: "paper",
    Demo: NewReleases,
  },
  {
    id: "collections-folder-import",
    title: "Import in progress.",
    blurb: "Known sizes fill; unknown ones pulse.",
    tone: "blueprint",
    Demo: FolderImport,
  },
  {
    id: "collections-reading-goal",
    title: "Reading goal.",
    blurb: "A meter drawn as a ring.",
    tone: "signal",
    Demo: ReadingGoal,
  },
  {
    id: "collections-club-note",
    title: "Tag the club.",
    blurb: "Type @ to mention a reader.",
    tone: "sky",
    Demo: ClubNote,
  },
  {
    id: "collections-chapter-prompt",
    title: "Ask about chapters.",
    blurb: "Chapters drop in as tokens.",
    Demo: ChapterPrompt,
  },
  {
    id: "collections-book-search",
    title: "Search the stacks.",
    blurb: "Results load as you type.",
    Demo: BookSearch,
  },
  {
    id: "collections-playlist-genres",
    title: "Tag a playlist.",
    blurb: "Each genre you pick becomes a chip.",
    tone: "paper",
    Demo: PlaylistGenres,
  },
  {
    id: "collections-sync-log",
    title: "Follows the tail.",
    blurb: "New lines stay in view until you scroll.",
    tone: "ink",
    Demo: SyncLog,
  },
  {
    id: "collections-rename",
    title: "Rename in place.",
    blurb: "Enter saves, Escape puts it back.",
    tone: "paper",
    Demo: RenamePlaylists,
  },
  {
    id: "collections-hidden-passage",
    title: "Found when searched.",
    blurb: "Find in page opens the hidden passage.",
    Demo: HiddenPassage,
  },
]
