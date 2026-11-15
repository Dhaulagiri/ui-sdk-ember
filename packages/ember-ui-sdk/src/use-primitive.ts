import { registerDestructor } from "@ember/destroyable"
import type { OptionsOf, Primitive, TypesOf } from "@ui-sdk/core"
import { schemaOf } from "@ui-sdk/core/renderer"

/**
 * A root's instance, which its parts receive as `@handle`.
 * @experimental
 */
type PrimitiveHandle<P extends Primitive = Primitive> = {
  /** The primitive the instance was made from. */
  primitive: P
  /** The core instance, with its `get()`, `part()` and `api`. */
  instance: ReturnType<P>
  /** The methods its definition declares, like Tabs' `setValue`. */
  readonly api: TypesOf<P>["api"]
  /** The instance's state now. Reading it tracks nothing. */
  readonly state: TypesOf<P>["state"]
  /** Hands the root's current arguments to the instance. */
  sync: () => void
}

let count = 0

/** Reads `args` by the names the schema gives, so each one read is tracked. */
function pick(names: object, args: object) {
  const result: Record<string, unknown> = {}
  for (const name in names) {
    result[name] = (args as Record<string, unknown>)[name]
  }
  return result
}

/**
 * Creates a root's instance from its arguments for the life of `owner`.
 * Controlled keys follow data down, actions up: `@value` with
 * `@onValueChange`. `extra` adds options the arguments don't hold.
 * @experimental
 */
function usePrimitive<P extends Primitive>(
  owner: { args: object },
  primitive: P,
  extra: () => Partial<OptionsOf<P>> = () => ({})
) {
  const id = `ui-sdk-e${++count}`
  const names = schemaOf(primitive).options
  // Some options aren't in the schema, like Popover's `modal`, so every
  // argument but `render` goes to the instance too.
  const options = () => {
    const { render, ...args } = owner.args as Record<string, unknown>
    const result: Record<string, unknown> = {
      ...pick(names, args),
      ...args,
      ...extra(),
      id,
    }
    for (const [name, value] of Object.entries(result)) {
      if (/^on[A-Z]/.test(name) && typeof value === "function") {
        result[name] = callback(value)
      }
    }
    return result as OptionsOf<P> & { id: string }
  }
  const handle: PrimitiveHandle<P> = {
    primitive,
    instance: primitive(options()) as ReturnType<P>,
    get api() {
      return handle.instance.api as TypesOf<P>["api"]
    },
    get state() {
      return handle.instance.get() as TypesOf<P>["state"]
    },
    sync: () => {
      rendering(() => handle.instance.setOptions(options()))
      synced.get(handle)?.forEach((run) => run())
    },
  }
  // Glimmer's VM keeps the last references it read, which can lead to the
  // handle, so a destroyed one lets go of its instance and the elements it holds.
  registerDestructor(owner, () => {
    handle.instance.destroy()
    handle.instance = undefined as never
  })
  return handle
}

const synced = new WeakMap<PrimitiveHandle, Set<() => void>>()

/** Runs `run` after each time `handle` hands its arguments over. Returns what stops it. */
function onSync(handle: PrimitiveHandle, run: () => void) {
  const runs = synced.get(handle) ?? new Set()
  synced.set(handle, runs.add(run))
  return () => runs.delete(run)
}

// While Ember renders, a tracked value read earlier in the same render can't
// change, so the changes the core reports then reach templates a microtask later.
let depth = 0
const pending = new Set<() => void>()

function rendering<T>(run: () => T) {
  depth++
  try {
    return run()
  } finally {
    depth--
  }
}

function afterRender(change: () => void) {
  if (!depth) {
    return change()
  }
  if (!pending.size) {
    queueMicrotask(() => {
      const changes = [...pending]
      pending.clear()
      changes.forEach((run) => run())
    })
  }
  pending.add(change)
}

// A change the instance reports while Ember renders, like a controlled
// layout's commit once `sync` hands it over, reaches the caller after the
// render, since its handler may set tracked state the render read.
function callback(run: Function) {
  return (...args: unknown[]) =>
    depth ? afterRender(() => run(...args)) : run(...args)
}

/**
 * Hands a root's arguments to its instance whenever they change. Put it
 * first in the root's template: `{{syncOptions this.handle}}`.
 * @experimental
 */
function syncOptions(handle: PrimitiveHandle) {
  handle.sync()
}

export {
  afterRender,
  onSync,
  type PrimitiveHandle,
  pick,
  rendering,
  syncOptions,
  usePrimitive,
}
