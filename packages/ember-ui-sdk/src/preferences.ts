import { isDestroying, registerDestructor } from "@ember/destroyable"
import { tracked } from "@glimmer/tracking"

class Current<State> {
  @tracked current: State

  constructor(state: State) {
    this.current = state
  }
}

/**
 * A preference's state, like `{ value: "dark" }`, or a color scheme's, as
 * the tracked `.current`, for the life of `owner`, a component. It's the
 * server's until rendered, so rehydration matches, and the saved value
 * right after.
 * @experimental
 */
function usePreference<State>(
  owner: object,
  preference: {
    get: () => State
    initialState: State
    subscribe: (listener: () => void) => () => void
  }
) {
  const state = new Current(preference.initialState)
  if (typeof window !== "undefined") {
    let stop: (() => void) | undefined
    queueMicrotask(() => {
      if (isDestroying(owner)) {
        return
      }
      // Subscribing first reads back what was saved.
      stop = preference.subscribe(() => (state.current = preference.get()))
      state.current = preference.get()
    })
    registerDestructor(owner, () => stop?.())
  }
  return state as { readonly current: State }
}

export { default as Preferences } from "./preferences/preferences.gts"
export { usePreference }
