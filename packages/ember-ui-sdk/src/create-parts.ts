import type { Primitive, SlotName, StateOf, TypesOf } from "@ui-sdk/core"
import { schemaOf } from "@ui-sdk/core/renderer"
import type Component from "@glimmer/component"
import { SchemaPart } from "./create-parts/schema-part.gts"
import type { PartModifier } from "./use-part"
import type { PrimitiveHandle } from "./use-primitive"

type Tag = keyof HTMLElementTagNameMap

// "tab-icon" is "TabIcon".
const pascal = (name: string) =>
  name.replace(/(^|-)(\w)/g, (_, _dash, char: string) => char.toUpperCase())

type Pascal<Name extends string> = Name extends `${infer Head}-${infer Tail}`
  ? `${Capitalize<Head>}${Pascal<Tail>}`
  : Capitalize<Name>

// What a part yields: its modifier and state, the instance, and every part.
type Yielded<P extends Primitive, Tags, State> = {
  part: PartModifier
  state: State
  handle: PrimitiveHandle<P>
  api: TypesOf<P>["api"]
} & PartComponents<P, Tags>

type PartComponent<P extends Primitive, Tags, State, E extends Element> = new (
  ...args: any[]
) => Component<{
  Element: E
  Args: Record<string, any>
  Blocks: { default: [Yielded<P, Tags, State>] }
}>

type PartComponents<P extends Primitive, Tags> = {
  [
    S in keyof TypesOf<P>["slots"] as S extends Exclude<keyof Tags, "root"> &
      string
      ? Pascal<S>
      : never
  ]: PartComponent<
    P,
    Tags,
    StateOf<P, S & SlotName<P>>,
    HTMLElementTagNameMap[Tags[S & keyof Tags] & Tag]
  >
}

/**
 * The components `createParts` makes: `Root`, and one per tagged slot, named in Pascal case.
 * @stable
 */
type Parts<P extends Primitive, Tags extends { [S in SlotName<P>]?: Tag }> = {
  Root: PartComponent<
    P,
    Tags,
    StateOf<P, "root" & SlotName<P>>,
    Tags extends { root: Tag } ? HTMLElementTagNameMap[Tags["root"]] : Element
  >
} & PartComponents<P, Tags>

/**
 * Every part of a primitive as a component. `Root` makes the instance from
 * its arguments, the primitive's options, like `@value` and
 * `@onValueChange`, and yields every part bound to it: `<Root as |r|>
 * <r.Star @value="1" /></Root>`. Each slot named in `tags` becomes a
 * component that renders that tag, named in Pascal case, like `TabIcon` for
 * `tab-icon`; a slot's props are its arguments, and the rest goes on the
 * element. Each part yields `part`, `state` and the parts inside it, which
 * take the props they need from it, like an item indicator its item's value.
 * `@render={{true}}` renders no element: bind your own with `{{x.part}}`.
 * Without a `root` tag, `Root` renders only its block. A part used outside
 * a root's block takes the instance as `@handle`.
 *
 * @example
 * const { Root: Playlist, Track: PlaylistTrack } = createParts(playlist, { root: "ul", track: "li" })
 * @stable
 */
function createParts<
  P extends Primitive,
  const Tags extends { [S in SlotName<P>]?: Tag },
>(primitive: P, tags: Tags) {
  const schema = schemaOf(primitive)
  const parts: Record<string, typeof SchemaPart> = {}
  for (const slot of new Set(["root", ...Object.keys(tags)])) {
    const config = {
      primitive,
      schema,
      slot,
      tag: (tags as Record<string, string>)[slot],
      parts,
    }
    const Part = class extends SchemaPart {
      static config = config
    }
    Object.defineProperty(Part, "name", { value: pascal(slot) })
    parts[pascal(slot)] = Part
  }
  return parts as unknown as Parts<P, Tags>
}

export { createParts, type Parts }
