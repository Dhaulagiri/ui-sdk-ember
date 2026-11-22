import type { TOC } from "@ember/component/template-only"
import { fn } from "@ember/helper"
import { Toggle } from "ember-ui-sdk/toggle"
import type { TaggedTile } from "./types.ts"

const has = (set: ReadonlySet<string>, name: string) => set.has(name)

/** One tile: its demo, its lead and its tags, which pick filters. */
const TileView: TOC<{
  Args: {
    tile: TaggedTile
    hidden: boolean
    selected: ReadonlySet<string>
    onToggle: (name: string, pressed: boolean) => void
  }
}> = <template>
  <article
    class="tile"
    data-size={{if @tile.size @tile.size "s"}}
    data-tone={{if @tile.tone @tile.tone "white"}}
    id={{@tile.id}}
    hidden={{@hidden}}
  >
    <div class="tile-stage">
      <@tile.Demo />
    </div>
    <footer class="tile-copy">
      <p class="tile-title">
        <strong>{{@tile.title}}</strong>
        {{@tile.blurb}}
      </p>
      {{! The tags filter the grid; an agent reads the tiles, not them. }}
      <div class="tile-uses" aria-label="Uses" data-agent-hidden>
        {{#each @tile.uses as |name|}}
          <Toggle
            class="tile-use"
            @pressed={{has @selected name}}
            @onPressedChange={{fn @onToggle name}}
          >{{name}}</Toggle>
        {{/each}}
      </div>
    </footer>
  </article>
</template>

export { TileView as Tile }
