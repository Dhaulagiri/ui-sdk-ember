import { capabilities, setModifierManager } from "@ember/modifier"
import type { ModifierLike } from "@glint/template"
import { rendering } from "./use-primitive"

/**
 * A modifier that runs `callback(el)` once its element is in the page:
 * `{{onInsert this.learn}}`. Tracked state it sets renders a microtask later.
 * A function the callback returns runs when the element leaves.
 */
const onInsert = setModifierManager(
  () => ({
    capabilities: capabilities("3.22", { disableAutoTracking: true }),
    createModifier: () => ({ cleanup: undefined as void | (() => void) }),
    installModifier: (
      modifier: { cleanup: void | (() => void) },
      el: Element,
      { positional }: { positional: unknown[] }
    ) =>
      rendering(() => {
        modifier.cleanup = (
          positional[0] as (el: Element) => void | (() => void)
        )(el)
      }),
    updateModifier: () => {},
    destroyModifier: (modifier: { cleanup: void | (() => void) }) =>
      rendering(() => modifier.cleanup?.()),
  }),
  function () {} as unknown as ModifierLike<{
    Element: Element
    Args: { Positional: [(el: any) => void | (() => void)] }
  }>
)

export { onInsert }
