import { capabilities, setModifierManager } from "@ember/modifier"
import type { ModifierLike } from "@glint/template"

type Setup = (el: any) => void | (() => void)
type State = { cleanup?: void | (() => void); destroyed: boolean }

/**
 * `{{onInsert this.setup}}` runs `setup(el)` once the element is in the page,
 * and the function it returns when the element leaves. It runs a microtask
 * after render, so tracked state it sets doesn't change what just rendered.
 */
const onInsert = setModifierManager(
  () => ({
    capabilities: capabilities("3.22", { disableAutoTracking: true }),
    createModifier: (): State => ({ destroyed: false }),
    installModifier: (
      state: State,
      el: Element,
      { positional }: { positional: unknown[] }
    ) => {
      void Promise.resolve().then(() => {
        if (!state.destroyed) {
          state.cleanup = (positional[0] as Setup)(el)
        }
      })
    },
    updateModifier: () => {},
    destroyModifier: (state: State) => {
      state.destroyed = true
      state.cleanup?.()
    },
  }),
  function () {} as unknown as ModifierLike<{
    Element: Element
    Args: { Positional: [Setup] }
  }>
)

export { onInsert }
