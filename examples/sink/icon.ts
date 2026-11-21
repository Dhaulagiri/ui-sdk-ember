import { createElement, type IconNode } from "lucide"

/** A Lucide icon as an SVG element, which a template renders as is: `{{icon Wifi 16}}`. */
function icon(node: IconNode, size = 16) {
  return createElement(node, {
    "aria-hidden": "true",
    width: String(size),
    height: String(size),
  })
}

export { icon }
