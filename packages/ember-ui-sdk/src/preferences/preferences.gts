import { capabilities, setModifierManager } from "@ember/modifier"
import { htmlSafe } from "@ember/template"
import Component from "@glimmer/component"
import type { ModifierLike } from "@glint/template"
import { preferencesScript, type PreferenceLike } from "@ui-sdk/core"

type State = { stop?: () => void }

const show = setModifierManager(
  () => ({
    capabilities: capabilities("3.22"),
    createModifier: (): State => ({}),
    installModifier: (
      state: State,
      element: Element,
      { positional }: { positional: unknown[] }
    ) => {
      const list = positional[0] as readonly PreferenceLike[]
      const write = () => {
        for (const preference of list) {
          ;(preference.global
            ? document.documentElement
            : element
          ).setAttribute(preference.attribute, preference.get().value)
        }
      }
      // Subscribing first reads back what was saved.
      const stops = list.map((preference) => preference.subscribe(write))
      write()
      state.stop = () => stops.forEach((stop) => stop())
    },
    updateModifier: () => {},
    destroyModifier: (state: State) => state.stop?.(),
  }),
  function () {} as unknown as ModifierLike<{
    Element: Element
    Args: { Positional: [readonly PreferenceLike[]] }
  }>
)

/**
 * Shows preferences on `data-*` attributes, so CSS styles by them from the
 * first paint: global ones on `<html>`, the rest on its own element, which
 * has `display: contents`. On the server it renders one inline script as its
 * first child, which puts every saved value on its attribute as the page
 * loads. Content that reads a preference, through `usePreference`, catches
 * up once rendered in the browser.
 * @experimental
 */
class Preferences extends Component<{
  Element: HTMLDivElement
  Args: {
    /** The preferences to show, from `createPreference` or `createColorScheme`. */
    preferences: readonly PreferenceLike[]
    /** The nonce your Content Security Policy gives inline scripts. */
    nonce?: string
  }
  Blocks: { default: [] }
}> {
  // The browser never runs a script Glimmer inserts, so only the server's counts.
  get script(): ReturnType<typeof htmlSafe> | undefined {
    if (typeof window !== "undefined") {
      return undefined
    }
    const nonce = this.args.nonce
      ? ` nonce="${this.args.nonce.replace(/[&"<>]/g, (char) => `&#${char.charCodeAt(0)};`)}"`
      : ""
    return htmlSafe(
      `<script${nonce}>${preferencesScript(this.args.preferences)}</script>`
    )
  }

  <template>
    <div
      ...attributes
      data-slot="preferences"
      style="display: contents"
      {{show @preferences}}
    >{{this.script}}{{yield}}</div>
  </template>
}

export default Preferences
