import type { ComponentLike } from "@glint/template"

/** How much of the grid a tile takes: one cell, two columns, two rows, or two by two. */
export type TileSize = "s" | "wide" | "tall" | "large"

/** The tile's ground. Demos read `--tile-*` variables, so they work on every tone. */
export type TileTone =
  "white" | "paper" | "ink" | "blueprint" | "signal" | "sage" | "sky" | "butter"

export type Tile = {
  /** Upstream's id, like "forms-plan-picker". */
  id: string
  /** The bold run-in lead: "Pick a plan." */
  title: string
  /** The gray continuation: one short sentence. */
  blurb?: string
  size?: TileSize
  tone?: TileTone
  Demo: ComponentLike
}

/** A tile with the ui-sdk names upstream's version of it uses. */
export type TaggedTile = Tile & { uses: string[] }
