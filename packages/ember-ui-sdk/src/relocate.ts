import { capabilities, setModifierManager } from "@ember/modifier"
import type { ModifierLike } from "@glint/template"

type State = {
  marker?: Comment
  held?: boolean
  moving?: boolean
}

function place(state: State, el: HTMLElement, target: HTMLElement | null) {
  state.marker ??=
    (el.before(document.createComment("")), el.previousSibling as Comment)
  const marker = state.marker
  if (target ? el.parentNode === target : el.previousSibling === marker) {
    return
  }
  const held = state.held
  state.moving = true
  if (target) {
    target.append(el)
  } else if (marker.parentNode) {
    marker.after(el)
  }
  state.moving = false
  if (held && el.isConnected) {
    el.focus({ preventScroll: true })
  }
}

/**
 * Moves its element into `target`, or back where it rendered while there is
 * none, keeping focus it held: `{{relocate this.header}}`.
 */
const relocate = setModifierManager(
  () => ({
    capabilities: capabilities("3.22"),
    createModifier: () => ({}) as State & { off?: () => void },
    installModifier(
      state: State & { off?: () => void },
      el: HTMLElement,
      { positional }: { positional: unknown[] }
    ) {
      const focus = () => (state.held = true)
      const blur = (event: FocusEvent) => {
        if (!state.moving && event.relatedTarget) {
          state.held = false
        }
      }
      el.addEventListener("focus", focus)
      el.addEventListener("blur", blur)
      state.held = el.ownerDocument.activeElement === el
      state.off = () => {
        el.removeEventListener("focus", focus)
        el.removeEventListener("blur", blur)
      }
      ;(state as State & { el?: HTMLElement }).el = el
      place(state, el, (positional[0] as HTMLElement | null) ?? null)
    },
    updateModifier(
      state: State & { el?: HTMLElement },
      { positional }: { positional: unknown[] }
    ) {
      place(state, state.el!, (positional[0] as HTMLElement | null) ?? null)
    },
    destroyModifier(state: State & { off?: () => void; el?: HTMLElement }) {
      state.off?.()
      state.el?.remove()
      state.marker?.remove()
    },
  }),
  function () {} as unknown as ModifierLike<{
    Element: HTMLElement
    Args: { Positional: [HTMLElement | null] }
  }>
)

export { relocate }
