import {
  defineEmberComponent,
  extendBasicCatalog,
  type EmberCatalogComponent,
} from "ember-a2ui"
import { A2Button, A2Tabs, Modal } from "./components/containers.gts"
import {
  A2CheckBox,
  A2Slider,
  ChoicePicker,
  DateTimeInput,
  TextField,
} from "./components/inputs.gts"

/** The basic catalog's id. Agents that only know the basic catalog send this. */
export const BASIC_CATALOG_ID =
  "https://a2ui.org/specification/v1_0/catalogs/basic/catalog.json"

/**
 * The basic catalog with its interactive components drawn by ember-ui-sdk.
 * It's the same catalog to an agent: same names, same props.
 */
export const UI_SDK_CATALOG_ID =
  "https://dhaulagiri.github.io/ui-sdk-ember/a2ui/basic-ui-sdk/v1/catalog.json"

// Each entry keeps the basic catalog's own schema, so a message that the
// basic catalog accepts is one this catalog accepts.
const basic = extendBasicCatalog(BASIC_CATALOG_ID, [])

// Each component types its own props, which the schema guarantees.
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const replacements: Record<string, EmberCatalogComponent<any>> = {
  Button: A2Button,
  CheckBox: A2CheckBox,
  ChoicePicker,
  DateTimeInput,
  Modal,
  Slider: A2Slider,
  Tabs: A2Tabs,
  TextField,
}

/** The names this catalog draws with ember-ui-sdk; the rest stay the basic catalog's. */
export const replaced = Object.keys(replacements)

/**
 * The catalog for an `A2uiSession`. Pass `id` to register it under the basic
 * catalog's id instead, so surfaces that name the basic catalog get it.
 */
export function uiSdkCatalog(id = UI_SDK_CATALOG_ID) {
  return extendBasicCatalog(
    id,
    Object.entries(replacements).map(([name, component]) => {
      const schema = basic.components.get(name)?.schema
      if (!schema) {
        throw new Error(`The basic catalog has no ${name}`)
      }
      return defineEmberComponent({ name, schema, component })
    })
  )
}
