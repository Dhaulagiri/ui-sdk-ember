import { createElement, type IconNode } from "lucide"

/**
 * A Lucide icon as an SVG element, which a template renders as is:
 * `{{icon Wifi 16}}`. Extra attributes, like a class the tile's CSS targets or
 * `fill="currentColor"` for upstream's filled icons, go in `attrs`.
 */
function icon(node: IconNode, size = 16, attrs: Record<string, string> = {}) {
  return createElement(node, {
    "aria-hidden": "true",
    width: String(size),
    height: String(size),
    ...attrs,
  })
}

export { icon }
