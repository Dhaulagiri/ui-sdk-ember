import { capabilities, setModifierManager } from "@ember/modifier"
import type { ModifierLike } from "@glint/template"
import type { field, fieldSet } from "@ui-sdk/core/field"
import {
  checkFieldOutside,
  fieldControlId,
  fieldOutsideAttrs,
  fieldOutsideState,
  type FieldOutsideSlot,
} from "@ui-sdk/core/renderer"
import { usePart, type PartBinding } from "../use-part"
import type { PrimitiveHandle } from "../use-primitive"

/**
 * What a Field gives the controls and parts inside it, as the `@field` argument
 * its yielded parts receive.
 * @experimental
 */
type FieldContext = {
  /** The field's instance. */
  handle: PrimitiveHandle<typeof field>
  /** The name the field's control submits under. */
  readonly name: string | undefined
  /** Whether the field disables its control. */
  readonly disabled: boolean | undefined
}

/**
 * What a FieldSet gives the parts inside it.
 * @experimental
 */
type FieldSetContext = {
  /** The set's instance. */
  handle: PrimitiveHandle<typeof fieldSet>
}

const noopManager = {
  capabilities: capabilities("3.22"),
  createModifier: () => ({}),
  installModifier: () => {},
  updateModifier: () => {},
  destroyModifier: () => {},
}

const none = setModifierManager(
  () => noopManager,
  function () {} as unknown as ModifierLike<{ Element: Element }>
)

// A part outside any Field: a plain element with no field wiring, so a
// FieldLabel is a native <label> that labels the control it wraps.
function outside(slot: FieldOutsideSlot) {
  const manager = {
    ...noopManager,
    installModifier: (_: object, el: Element) => {
      for (const [name, value] of Object.entries(fieldOutsideAttrs(slot))) {
        el.setAttribute(name, value)
      }
      checkFieldOutside(el, slot)
    },
  }
  return setModifierManager(
    () => manager,
    function () {} as unknown as ModifierLike<{ Element: Element }>
  )
}

const outsideModifiers = {
  label: outside("label"),
  description: outside("description"),
  error: outside("error"),
  control: outside("control"),
}

/**
 * Controls inside a field take its name and disabled state, and its ids and
 * validity through the field's control slot. `modifier` binds that slot to the
 * control's element beside the control's own. Outside a field, they're empty.
 * @experimental
 */
function useFieldControl(
  owner: { args: { field?: FieldContext } },
  ids: () => { id?: string; describedBy?: string } = () => ({})
) {
  const field = owner.args.field
  const part = field
    ? usePart(owner, () => field.handle, "control", ids, "ember-field")
    : undefined
  return { ...useFieldValues(owner), modifier: part ? part.modifier : none }
}

/**
 * The name and disabled state a Field gives a control that has parts of its
 * own, like a password input, whose control part binds the field itself.
 */
function useFieldValues(owner: { args: { field?: FieldContext } }) {
  return {
    get name() {
      return owner.args.field?.name
    },
    get disabled() {
      return owner.args.field?.disabled
    },
    get controlId() {
      const field = owner.args.field
      return field ? fieldControlId(field.handle.api.id) : undefined
    },
  }
}

/**
 * One of a field's parts, or a plain element outside any field.
 */
function useFieldPart<S extends "label" | "description" | "error" | "control">(
  owner: { args: { field?: FieldContext | FieldSetContext } },
  slot: S,
  props: () => Record<string, unknown> = () => ({})
) {
  const field = owner.args.field
  if (field) {
    return usePart(
      owner,
      () =>
        field.handle as PrimitiveHandle<
          typeof import("@ui-sdk/core/field").field
        >,
      slot,
      props as never
    ) as PartBinding<Record<string, any>>
  }
  return {
    present: true,
    state: fieldOutsideState as unknown as Record<string, unknown>,
    modifier: outsideModifiers[slot],
    yielded: {
      part: outsideModifiers[slot],
      state: fieldOutsideState as unknown as Record<string, unknown>,
    },
  } as PartBinding<Record<string, any>>
}

export {
  type FieldContext,
  type FieldSetContext,
  useFieldControl,
  useFieldPart,
  useFieldValues,
}
