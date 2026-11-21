import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
// Before the tiles, whose own rules win where they style the same elements.
import "../../vendor/ui/apps/docs/app/sink/bento/bento.css"
import "./sink.css"
import { Filter } from "./filter.gts"
import { groupOf, tiles } from "./registry.ts"
import { Tile } from "./tile.gts"
import type { TaggedTile } from "./types.ts"

type Mode = "any" | "all"

const listParam = (params: URLSearchParams, key: string) =>
  params.get(key)?.split(",").filter(Boolean) ?? []

/**
 * A port of ui-sdk.dev/sink: small interfaces built on ember-ui-sdk, tagged with
 * what each uses. `?only=forms` shows a group, `?uses=Dialog,Menu` filters.
 */
export class Sink extends Component {
  params = new URLSearchParams(location.search)
  only = listParam(this.params, "only")
  @tracked selected = listParam(this.params, "uses")
  @tracked mode: Mode = this.params.get("mode") === "all" ? "all" : "any"

  pool = this.only.length
    ? tiles.filter(
        (tile) =>
          this.only.includes(tile.id) ||
          this.only.includes(groupOf.get(tile.id) ?? "")
      )
    : tiles

  get chosen() {
    return new Set(this.selected)
  }

  matches = (tile: TaggedTile) => {
    const { selected, chosen } = this
    if (!selected.length) {
      return true
    }
    return this.mode === "all"
      ? selected.every((name) => tile.uses.includes(name))
      : tile.uses.some((name) => chosen.has(name))
  }

  hidden = (tile: TaggedTile) => !this.matches(tile)

  get shown() {
    return this.pool.filter(this.matches).length
  }

  writeUrl() {
    const next = new URLSearchParams(location.search)
    if (this.selected.length) {
      next.set("uses", this.selected.join(","))
    } else {
      next.delete("uses")
    }
    if (this.mode === "all") {
      next.set("mode", "all")
    } else {
      next.delete("mode")
    }
    const search = next.toString()
    history.replaceState(
      history.state,
      "",
      `${location.pathname}${search ? `?${search}` : ""}${location.hash}`
    )
  }

  setSelected = (names: string[]) => {
    this.selected = names
    this.writeUrl()
  }

  setMode = (mode: Mode) => {
    this.mode = mode
    this.writeUrl()
  }

  toggle = (name: string, pressed: boolean) =>
    this.setSelected(
      pressed
        ? [...new Set([...this.selected, name])]
        : this.selected.filter((other) => other !== name)
    )

  <template>
    <div class="sink">
      <h1 class="sr-only">ember-ui-sdk sink</h1>
      <main class="bento">
        {{#each this.pool key="id" as |tile|}}
          <Tile
            @tile={{tile}}
            @hidden={{this.hidden tile}}
            @selected={{this.chosen}}
            @onToggle={{this.toggle}}
          />
        {{/each}}
        {{#unless this.shown}}
          <p class="bento-empty">No tile uses all of those together.</p>
        {{/unless}}
      </main>
      <Filter
        @selected={{this.selected}}
        @onSelectedChange={{this.setSelected}}
        @mode={{this.mode}}
        @onModeChange={{this.setMode}}
        @shown={{this.shown}}
      />
    </div>
  </template>
}
