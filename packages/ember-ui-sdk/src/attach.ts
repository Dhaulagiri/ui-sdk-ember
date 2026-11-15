import { capabilities, setModifierManager } from "@ember/modifier"
import type { ModifierLike } from "@glint/template"

/**
 * A function `attach` runs with an element, returning an optional cleanup.
 * @experimental
 */
type Attachment = (element: any) => void | (() => void)

type State = {
  run?: Attachment
  element?: Element
  cleanup: void | (() => void)
  live: boolean
}

// A microtask later, so the element is in the page and the attachment may set
// tracked state the render read.
function start(state: State, run: Attachment, element: Element) {
  state.run = run
  queueMicrotask(() => {
    if (state.live && state.run === run) {
      state.cleanup = run(element)
    }
  })
}

function stop(state: State) {
  const cleanup = state.cleanup
  state.cleanup = undefined
  queueMicrotask(() => cleanup?.())
}

/**
 * Runs a function with the element once it's in the page, and the cleanup
 * it returns when the element goes or the function changes, like Svelte's
 * `{@attach}` and React's ref callback: `<div {{attach this.setAnchor}}>`.
 * @experimental
 */
const attach = setModifierManager(
  () => ({
    capabilities: capabilities("3.22", { disableAutoTracking: true }),
    createModifier: () => ({ cleanup: undefined, live: true }) as State,
    installModifier: (
      state: State,
      element: Element,
      { positional }: { positional: unknown[] }
    ) => {
      state.element = element
      start(state, positional[0] as Attachment, element)
    },
    updateModifier: (
      state: State,
      { positional }: { positional: unknown[] }
    ) => {
      if (positional[0] !== state.run && state.element) {
        stop(state)
        start(state, positional[0] as Attachment, state.element)
      }
    },
    destroyModifier: (state: State) => {
      state.live = false
      stop(state)
    },
  }),
  function () {}
) as unknown as ModifierLike<{
  Args: { Positional: [Attachment] }
  Element: Element
}>

export { attach, type Attachment }
