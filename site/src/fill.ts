import { capabilities, setModifierManager } from "@ember/modifier"
import type { ModifierLike } from "@glint/template"

type State = { element?: Element; cleanup?: () => void }
type Positional = [
  (element: any, ...args: any[]) => void | (() => void),
  ...any[],
]

// {{fill callback arg}} runs callback(element, arg) on insert and again,
// after the previous run's cleanup, whenever an argument changes.
const fill = setModifierManager(
  () => {
    const run = (state: State, positional: Positional) => {
      const [callback, ...rest] = positional
      const cleanup = callback(state.element, ...rest)
      state.cleanup = typeof cleanup === "function" ? cleanup : undefined
    }
    return {
      capabilities: capabilities("3.22"),
      createModifier: (): State => ({}),
      installModifier(
        state: State,
        element: Element,
        { positional }: { positional: Positional }
      ) {
        state.element = element
        run(state, positional)
      },
      updateModifier(state: State, { positional }: { positional: Positional }) {
        state.cleanup?.()
        run(state, positional)
      },
      destroyModifier: (state: State) => state.cleanup?.(),
    }
  },
  function () {} as unknown as ModifierLike<{
    Element: Element
    Args: { Positional: Positional }
  }>
)

export { fill }
