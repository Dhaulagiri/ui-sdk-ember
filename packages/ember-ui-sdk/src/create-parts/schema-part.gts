import { element } from "@ember/helper"
import Component from "@glimmer/component"
import type { Primitive, PropSpec } from "@ui-sdk/core"
import type { schemaOf } from "@ui-sdk/core/renderer"
import { usePart } from "../use-part"
import {
  syncOptions,
  usePrimitive,
  type PrimitiveHandle,
} from "../use-primitive"

// The props of the parts around one, by slot, as getters.
type Around = Record<string, () => Record<string, unknown>>

type ListApi = { internal: { keyOf: (value: unknown) => string } }

type PartConfig = {
  primitive: Primitive
  schema: NonNullable<ReturnType<typeof schemaOf>>
  slot: string
  tag?: string
  /** Every part `createParts` made, by Pascal name, which each part yields. */
  parts: Record<string, typeof SchemaPart>
}

const kindOf = (spec: PropSpec) => (typeof spec === "object" ? spec.kind : spec)

let count = 0

/**
 * A part from `createParts`, bound by its class's `config` to a primitive,
 * slot and tag. The root makes the instance from its arguments. A part
 * yields `part`, `state`, `handle` and every part, bound to this instance and
 * to the props it gives the parts inside it.
 */
class SchemaPart extends Component<{
  Element: HTMLElement
  Args: { Named: Record<string, any> }
  Blocks: { default: [Record<string, any>] }
}> {
  static config: PartConfig
  // The instance and the parts around it, for parts a root or part yields.
  static bound?: { handle: PrimitiveHandle; around: Around }

  config = (this.constructor as typeof SchemaPart).config
  bound = (this.constructor as typeof SchemaPart).bound
  isRoot = this.config.slot === "root"
  id = `ui-sdk-e-schema${++count}`
  handle: PrimitiveHandle = this.isRoot
    ? usePrimitive(this, this.config.primitive)
    : (this.args.handle ?? this.bound?.handle)
  around: Around = this.isRoot
    ? {}
    : (this.args.around ?? this.bound?.around ?? {})
  props = this.#props()
  part = this.config.tag
    ? usePart(this, () => this.handle, this.config.slot as never, this.props)
    : undefined
  yielded = this.#yielded()

  // The slot's props: its arguments, with `"id"` props made, those it takes
  // `from` the part around it filled in, and a list's `"key"` keying the id.
  #props() {
    const { primitive, schema, slot } = this.config
    const props: Record<string, PropSpec> = schema.slots[slot] ?? {}
    if (!this.handle) {
      throw new Error(
        `A ${primitive.name} ${slot} part needs @handle, or the root's yielded part.`
      )
    }
    for (const spec of Object.values(props)) {
      const from =
        typeof spec === "object" && spec.required && spec.from.split(".")[0]
      if (from && !this.around[from]) {
        throw new Error(
          `A ${primitive.name} ${slot} part must be used inside its ${from}.`
        )
      }
    }
    const keyed = Object.values(props).some((spec) => kindOf(spec) === "key")
    return () => {
      const result: Record<string, unknown> = { id: this.args.id }
      for (const name in props) {
        const spec = props[name]
        let value = this.args[name]
        if (value === undefined && typeof spec === "object") {
          const [from, prop = name] = spec.from.split(".")
          value = this.around[from]?.()[prop]
        }
        if (value === undefined && kindOf(spec) === "id") {
          value = name === "id" ? this.id : `${this.id}-${name}`
        }
        result[name] = value
        if (keyed && kindOf(spec) === "key") {
          result.id ??= (this.handle.api as ListApi).internal.keyOf(value)
        }
      }
      return result
    }
  }

  #yielded() {
    const around = this.isRoot
      ? {}
      : { ...this.around, [this.config.slot]: this.props }
    const context = { handle: this.handle, around }
    const yielded: Record<string, unknown> = {
      handle: this.handle,
      api: this.handle.api,
    }
    if (this.part) {
      yielded.part = this.part.modifier
      yielded.state = this.part.state
    }
    for (const [name, Part] of Object.entries(this.config.parts)) {
      if (name === "Root") {
        continue
      }
      let bound: typeof SchemaPart | undefined
      Object.defineProperty(yielded, name, {
        enumerable: true,
        get: () =>
          (bound ??= class extends Part {
            static bound = context
          }),
      })
    }
    return yielded
  }

  <template>
    {{#if this.isRoot}}{{syncOptions this.handle}}{{/if}}
    {{#if this.part}}
      {{#if this.part.present}}
        {{#if @render}}
          {{yield this.yielded}}
        {{else}}
          {{! @glint-expect-error the element helper types lack a call signature }}
          {{#let (element this.config.tag) as |Tag|}}
            <Tag ...attributes {{this.part.modifier}}>{{yield
                this.yielded
              }}</Tag>
          {{/let}}
        {{/if}}
      {{/if}}
    {{else}}
      {{yield this.yielded}}
    {{/if}}
  </template>
}

export { type PartConfig, SchemaPart }
