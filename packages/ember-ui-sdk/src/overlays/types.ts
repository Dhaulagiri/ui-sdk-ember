/**
 * Arguments for the toast regions the overlay host renders, and the region's `class`.
 * @experimental
 */
type OverlayHostToastProps = {
  side?: "top" | "bottom"
  align?: "start" | "center" | "end"
  maxVisible?: number
  expanded?: boolean
  shortcut?: string | null
  class?: string
}

export type { OverlayHostToastProps }
