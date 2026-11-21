// Helpers for building custom parts on the same primitives the components use.
export { attach, type Attachment } from "./attach"
export { createParts, type Parts } from "./create-parts"
export {
  type PartBinding,
  type PartModifier,
  type PartSignature,
  type RootYield,
  usePart,
} from "./use-part"
export {
  type PrimitiveHandle,
  syncOptions,
  usePrimitive,
} from "./use-primitive"
