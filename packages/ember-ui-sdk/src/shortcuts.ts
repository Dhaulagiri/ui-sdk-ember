import { registerDestructor } from "@ember/destroyable"
import { tracked } from "@glimmer/tracking"
import { initialApple, isApple } from "@ui-sdk/core/renderer"
import {
  ariaKeyshortcuts,
  formatShortcut,
  shortcuts,
  type ShortcutHandler,
  type ShortcutOptions,
} from "@ui-sdk/core/shortcuts"

/**
 * A value, or a getter that reads it.
 * @stable
 */
type MaybeGetter<T> = T | (() => T)

/**
 * Options for `useShortcut`. `layer` also takes a getter.
 * @stable
 */
type UseShortcutOptions = Omit<ShortcutOptions, "layer"> & {
  /** An element inside a popup, or a getter of one. The shortcut belongs to that popup. */
  layer?: MaybeGetter<Element | null | undefined>
}

const read = <T>(value: MaybeGetter<T>) =>
  typeof value === "function" ? (value as () => T)() : value

/**
 * Registers a keyboard shortcut for the life of `owner`, a component, in the
 * shared `shortcuts`. Keys like `"mod+k"`; nothing registers for `null`.
 * Ember has no effects, so keys and options are read once, when it
 * registers; `layer` and `when` are read on each press. Nothing registers on
 * the server.
 * @stable
 */
function useShortcut(
  owner: object,
  keys: MaybeGetter<string | null | undefined>,
  handler: ShortcutHandler,
  options: MaybeGetter<UseShortcutOptions> = {}
) {
  const current = read(keys)
  if (typeof window === "undefined" || !current) {
    return
  }
  const { layer, ...rest } = read(options)
  registerDestructor(
    owner,
    shortcuts.register(current, handler, {
      ...rest,
      layer: layer === undefined ? undefined : () => read(layer),
    })
  )
}

class Platform {
  @tracked apple = initialApple()
}

/**
 * Keys formatted for this platform, like `⌘S` on Apple platforms and `Ctrl+S`
 * elsewhere, with the matching `aria-keyshortcuts`, as tracked getters. The
 * server and the first client render use the same platform, so rehydration
 * matches, and they update right after. Keys can be a getter.
 * @stable
 */
function useShortcutHint(keys: MaybeGetter<string>) {
  const platform = new Platform()
  if (typeof window !== "undefined") {
    queueMicrotask(() => (platform.apple = isApple()))
  }
  return {
    get text() {
      return formatShortcut(read(keys), platform.apple)
    },
    get ariaKeyshortcuts() {
      return ariaKeyshortcuts(read(keys), platform.apple)
    },
  }
}

export {
  ariaKeyshortcuts,
  formatShortcut,
  registerShortcut,
  shortcuts,
} from "@ui-sdk/core/shortcuts"
export type {
  ShortcutHandler,
  ShortcutInfo,
  ShortcutKeys,
  ShortcutOptions,
  Shortcuts,
} from "@ui-sdk/core/shortcuts"
export {
  type MaybeGetter,
  useShortcut,
  useShortcutHint,
  type UseShortcutOptions,
}
