import { registerDestructor } from "@ember/destroyable"
import { tracked } from "@glimmer/tracking"
import {
  createAsyncOptions,
  type AsyncOptionsContext,
  type AsyncOptionsOptions,
  type AsyncOptionsState,
} from "@ui-sdk/core/async-options"

class Cell<T> {
  @tracked value: T

  constructor(value: T) {
    this.value = value
  }
}

/**
 * Options loaded for what the user types, latest first, for the life of
 * `owner`. Returns the state, which reading tracks, and `setQuery`, for a
 * combobox with `@filter={{false}}`.
 * @experimental
 */
function useAsyncOptions<Item>(
  owner: object,
  load: (
    query: string,
    context: AsyncOptionsContext
  ) => Promise<Item[] | { items: Item[]; hasMore?: boolean }>,
  options?: AsyncOptionsOptions
) {
  // An `immediate` load starts once the owner is in the page. Until then it
  // shows as loading, so nothing says "no match" first.
  const helper = createAsyncOptions<Item>(load, {
    ...options,
    immediate: false,
  })
  const immediate = !!options?.immediate
  const initial = helper.getState()
  const state = new Cell<AsyncOptionsState<Item>>(
    immediate ? { ...initial, status: "loading" } : initial
  )
  const unsubscribe = helper.subscribe(() => (state.value = helper.getState()))
  let destroyed = false
  queueMicrotask(() => {
    if (!destroyed && immediate && helper.getState() === initial) {
      helper.reload()
    }
  })
  registerDestructor(owner, () => {
    destroyed = true
    unsubscribe()
    helper.cancel()
  })
  return {
    /** The items, the status, whether more pages exist and the last error. Reading it tracks it. */
    get state() {
      return state.value
    },
    setQuery: helper.setQuery,
    reload: helper.reload,
    loadMore: helper.loadMore,
  }
}

export {
  type AsyncOptions,
  type AsyncOptionsContext,
  type AsyncOptionsOptions,
  type AsyncOptionsState,
  type AsyncOptionsStatus,
  createAsyncOptions,
} from "@ui-sdk/core/async-options"
export { useAsyncOptions }
