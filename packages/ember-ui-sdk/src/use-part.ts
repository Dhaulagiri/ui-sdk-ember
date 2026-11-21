import { registerDestructor } from "@ember/destroyable"
import { capabilities, setModifierManager } from "@ember/modifier"
import { join } from "@ember/runloop"
import type { ModifierLike } from "@glint/template"
import { tracked } from "@glimmer/tracking"
import type { Part, Primitive, PropsOf, SlotName, StateOf } from "@ui-sdk/core"
import {
  applyAttrs,
  attrs as partAttrs,
  bind,
  handlers,
  on,
  partState,
  present as isPresent,
  renderVersion,
  sameSlotState,
  schemaOf,
  selectedKeys,
  subscribe,
} from "@ui-sdk/core/renderer"
import {
  afterRender,
  pick,
  rendering,
  type PrimitiveHandle,
} from "./use-primitive"

class Cell {
  @tracked count = 0

  read() {
    return this.count
  }

  bump() {
    afterRender(() => this.count++)
  }
}

type PartModifier = ModifierLike<{ Element: Element }>

/**
 * One part of a component, which its template renders: whether it's present,
 * its state, and the modifier that binds its element.
 * @experimental
 */
type PartBinding<State = Record<string, unknown>> = {
  /** Whether the part's element should exist. Reading it tracks it. */
  readonly present: boolean
  /** The part's attributes. Reading it tracks them. */
  readonly attrs: Record<string, string | undefined>
  /** The part's state. Reading a key tracks that key, and only that key. */
  readonly state: State
  /** Binds an element to the part: `<div {{this.part.modifier}}>`. */
  readonly modifier: PartModifier
  /** What a part yields: its modifier as `part` and its `state`. */
  readonly yielded: { part: PartModifier; state: State }
}

/**
 * A part component's signature: `@handle` from its root, `@render` to bind
 * your own element with the yielded `part`, and the slot's props as arguments.
 * @experimental
 */
type PartSignature<
  P extends Primitive,
  S extends SlotName<P>,
  E extends Element = HTMLElement,
  Args = {},
  Parts = Record<string, any>,
> = {
  Element: E
  Args: Omit<
    {
      /** The root's instance. The root's yielded parts pass it already. */
      handle: PrimitiveHandle<P>
      /** Renders no element: bind your own with the yielded `part` modifier. */
      render?: boolean
    },
    keyof Args
  > &
    Partial<Omit<PropsOf<P, S>, keyof Args>> &
    Args
  Blocks: {
    default: [{ part: PartModifier; state: StateOf<P, S> } & Parts]
  }
}

/**
 * What a root yields beside its parts: its `part` modifier, the state of its
 * slot, `root` unless `S` names another, and its `handle`. A root's block
 * param is this and its parts, each with the arguments the root binds:
 * `RootYield<typeof tabs> & { Tab: WithBoundArgs<typeof TabsTab, "handle"> }`.
 * @experimental
 */
type RootYield<
  P extends Primitive,
  S extends SlotName<P> = "root" & SlotName<P>,
> = {
  /** Binds your own element to the root with `@render={{true}}`. */
  part: PartModifier
  /** The state of the root's slot. Reading a key tracks that key. */
  state: StateOf<P, S>
  /** The root's instance, for a part rendered outside its block. */
  handle: PrimitiveHandle<P>
}

const bindings = new WeakMap<object, Binding>()
let count = 0

class Binding {
  #channel: string
  #handle: () => PrimitiveHandle
  #slot: string
  #props: () => Record<string, unknown>
  #record?: Part
  #selected?: string
  #unsubscribe = () => {}
  #el?: HTMLElement
  #unbind?: () => void
  #version?: number
  #shown?: boolean
  #presence = new Cell()
  #rendered?: Cell
  #cells = new Map<string, { cell: Cell; value: unknown }>()
  modifier: PartModifier
  state: Record<string, unknown>
  yielded: { part: PartModifier; state: Record<string, unknown> }

  constructor(
    handle: () => PrimitiveHandle,
    slot: string,
    props: () => Record<string, unknown>,
    channel: string
  ) {
    this.#channel = channel
    this.#handle = handle
    this.#slot = slot
    this.#props = props
    this.modifier = setModifierManager(
      () => modifierManager,
      function () {} as unknown as PartModifier
    )
    bindings.set(this.modifier, this)
    this.state = new Proxy({} as Record<string, unknown>, {
      get: (_, key) =>
        typeof key === "string" ? this.#readState(key) : undefined,
    })
    this.yielded = { part: this.modifier, state: this.state }
    // Registered as it renders, like the other frameworks' parts, so parts
    // after it, like the panel of a tab selected by default, see it.
    this.#watch()
  }

  /** The part's attributes, for a template that reads them. Reading it tracks them. */
  get attrs() {
    ;(this.#rendered ??= new Cell()).read()
    return partAttrs(this.#watch())
  }

  get present() {
    this.#presence.read()
    return (this.#shown = isPresent(this.#watch()))
  }

  #readState(key: string) {
    const value = (partState(this.#watch()) as Record<string, unknown>)[key]
    let entry = this.#cells.get(key)
    if (!entry) {
      this.#cells.set(key, (entry = { cell: new Cell(), value }))
    }
    entry.cell.read()
    entry.value = value
    return value
  }

  // The part for the current props, subscribed again when its key, or the
  // values it selects on, change.
  #watch() {
    const part = this.#handle().instance.part(this.#slot, this.#props())
    const selected = selectedKeys(part)
    if (part !== this.#record || selected !== this.#selected) {
      this.#unsubscribe()
      this.#record = part
      this.#selected = selected
      this.#unsubscribe = subscribe(part, (liveOnly) => this.#heard(liveOnly))
    }
    return part
  }

  #heard(liveOnly: boolean) {
    // A part outside its root, like a trigger, hears the root's teardown
    // after its handle is gone and before Ember destroys the part.
    if (!this.#handle()?.instance) {
      this.#unsubscribe()
      this.#unsubscribe = () => {}
      this.#record = undefined
      return
    }
    const part = this.#record!
    // Presence may read live state, so it is checked on every change.
    if (this.#shown !== undefined && isPresent(part) !== this.#shown) {
      this.#shown = !this.#shown
      this.#presence.bump()
    }
    if (this.#cells.size) {
      const state = partState(part) as Record<string, unknown>
      for (const [key, entry] of this.#cells) {
        if (!sameSlotState(state[key], entry.value)) {
          entry.value = state[key]
          entry.cell.bump()
        }
      }
    }
    if (liveOnly) {
      return
    }
    const version = renderVersion(this.#handle().instance)
    if (version === this.#version) {
      return
    }
    this.#version = version
    this.#rendered?.bump()
    if (this.#el) {
      this.#apply()
    }
  }

  #apply() {
    this.#version = renderVersion(this.#handle().instance)
    // Parts that differ only by a prop, like rating items, share one record,
    // so each asks again for its own props before reading attributes.
    const own = this.#handle().instance.part(this.#slot, this.#props())
    const attrs = partAttrs(own)
    // A Field's control part shares its element with the control's own part, whose data-slot stays.
    if (this.#channel === "ember-field") {
      delete attrs["data-slot"]
    }
    applyAttrs(this.#el!, attrs, this.#channel)
  }

  attach(el: HTMLElement) {
    // A branch swap installs the new element before it destroys the old one.
    this.#unbind?.()
    this.#unbind = undefined
    this.#el = el
    const part = this.#watch()
    this.#apply()
    // Binding measures and can show a popover, which an element rendered off
    // the page can't, so it binds once it joins the page, a microtask later.
    if (el.isConnected) {
      this.#unbind = bindElement(part, el)
      return
    }
    queueMicrotask(() => {
      if (this.#el === el && !this.#unbind) {
        this.#unbind = bindElement(this.#watch(), el)
      }
    })
  }

  update() {
    const bound = this.#record
    const part = this.#watch()
    if (part !== bound) {
      this.#unbind?.()
      this.#unbind = bindElement(part, this.#el!)
    }
    this.#apply()
  }

  detach(el: HTMLElement) {
    if (this.#el !== el) {
      return
    }
    const unbind = this.#unbind
    this.#unbind = undefined
    this.#el = undefined
    unbind?.()
  }

  destroy() {
    this.#unsubscribe()
    // Glimmer's VM keeps the last references it read, which can lead here, so
    // a destroyed binding lets go of its instance, its element and its owner.
    this.#unsubscribe = () => {}
    this.#record = undefined
    this.#el = undefined
    this.#handle = () => undefined as never
    this.#props = () => ({})
    bindings.delete(this.modifier)
  }
}

// The core's listeners run inside a run loop, so what they change renders
// before the event returns, as a screen reader reading the page then expects.
function bindElement(part: Part, el: HTMLElement) {
  const cleanups = Object.entries(handlers(part)).map(([type, handler]) =>
    on(el, type as keyof HTMLElementEventMap, (event) =>
      join(() => handler!(event))
    )
  )
  cleanups.push(bind(part, el, { by: "framework", attaches: "all" }))
  return () => cleanups.forEach((cleanup) => cleanup())
}

const modifierManager = {
  capabilities: capabilities("3.22"),
  createModifier: (definition: object) => ({
    binding: bindings.get(definition)!,
    el: undefined as HTMLElement | undefined,
  }),
  installModifier: (
    modifier: { binding: Binding; el?: HTMLElement },
    el: Element
  ) => {
    modifier.el = el as HTMLElement
    rendering(() => modifier.binding.attach(el as HTMLElement))
  },
  updateModifier: (modifier: { binding: Binding }) =>
    rendering(() => modifier.binding.update()),
  destroyModifier: (modifier: { binding: Binding; el?: HTMLElement }) =>
    rendering(() => modifier.binding.detach(modifier.el!)),
}

/**
 * Binds one part of `handle`'s instance for the life of `owner`, a part
 * component. Its props are the arguments the slot's schema names, with
 * `extra` over them, like an item's key a parent passes down.
 *
 * `handle` reads the root's instance, usually from an argument: a root
 * yields its own part components with `(component MyTab handle=this.handle)`,
 * so a part rendered by another component binds to the root that created
 * it. A part created without one throws, as it does in the other frameworks.
 * @experimental
 */
function usePart<P extends Primitive, S extends SlotName<P>>(
  owner: { args: object },
  handle: () => PrimitiveHandle<P>,
  slot: S,
  extra: () => Partial<PropsOf<P, S>> = () => ({}),
  channel?: string
) {
  if (!handle()) {
    throw new Error(
      `A ${String(slot)} part needs @handle, or the root's yielded part.`
    )
  }
  const names = () => schemaOf(handle().primitive).slots[slot] ?? {}
  // A prop of kind "id" no argument gives, like a trigger's, keys this part alone.
  const id = `ui-sdk-e-part${++count}`
  // Parts on one element, like a toolbar button around a menu trigger, write
  // their own channels, so each keeps its attributes.
  const binding = new Binding(
    handle as () => PrimitiveHandle,
    slot,
    () => {
      const props: Record<string, unknown> = {
        ...pick(names(), owner.args),
        ...extra(),
      }
      for (const [name, kind] of Object.entries(names())) {
        if (kind === "id" && props[name] === undefined) {
          props[name] = id
        }
      }
      return props
    },
    channel ?? `ember-${id}`
  )
  registerDestructor(owner, () => binding.destroy())
  return binding as unknown as PartBinding<StateOf<P, S>>
}

export {
  type PartBinding,
  type PartModifier,
  type PartSignature,
  type RootYield,
  usePart,
}
