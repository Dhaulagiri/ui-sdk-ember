import type { Feature } from "@ui-sdk/core/renderer"

let count = 0

/**
 * The props of a slot a feature ships, read from `args` by the names the
 * feature gives: the root's schema only knows the primitive's own slots.
 */
function featureProps(feature: Feature, slot: string, args: () => object) {
  const names: Record<string, unknown> =
    (feature as { slots: Record<string, { props?: Record<string, unknown> }> })
      .slots[slot]?.props ?? {}
  const id = `ui-sdk-e-feature${++count}`
  return () => {
    const props: Record<string, unknown> = {}
    for (const [name, kind] of Object.entries(names)) {
      props[name] = (args() as Record<string, unknown>)[name]
      if (kind === "id" && props[name] === undefined) {
        props[name] = id
      }
    }
    return props
  }
}

export { featureProps }
