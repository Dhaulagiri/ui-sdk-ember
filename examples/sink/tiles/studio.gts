import { concat } from "@ember/helper"
import Component from "@glimmer/component"
import { Redo2, Undo2 } from "lucide"
import { createUndoStack, definePrimitive, matchesShortcut } from "@ui-sdk/core"
import { createParts } from "ember-ui-sdk/primitive"
import { useShortcutHint } from "ember-ui-sdk/shortcuts"
import "../../../vendor/ui/apps/docs/app/sink/tiles/studio.css"
import { icon } from "../icon.ts"
import type { Tile } from "../types.ts"

/** A shortcut's label comes wrapped in direction isolates; keycaps want the bare glyphs. */
const keycaps = (label: string) => {
  const bare = label.replace(/[⁦-⁩]/g, "")
  return bare.includes("+") ? bare.split("+") : [...bare]
}

class Keys extends Component<{ Args: { shortcut: string } }> {
  hint = useShortcutHint(() => this.args.shortcut)

  get keys() {
    return keycaps(this.hint.text)
  }

  <template>
    <span class="st-keys" aria-hidden="true">
      {{#each this.keys key="@index" as |key|}}
        <kbd class="st-kbd">{{key}}</kbd>
      {{/each}}
    </span>
  </template>
}

/* 1. History: a note with undo and redo */

const NOTE_SEED = [
  "",
  "Water the ferns",
  "Water the ferns, return the library books",
  "Water the ferns, return the library books, buy oat milk",
]
const NOTE_LIMIT = 12
const NOTE_DELAY = 800

const notes = definePrimitive({
  name: "st-notes",
  state: () => ({
    text: NOTE_SEED[NOTE_SEED.length - 1],
    back: NOTE_SEED.length - 1,
    ahead: 0,
  }),
  api: (context) => {
    const { store } = context
    const history = createUndoStack(NOTE_SEED[0], {
      limit: NOTE_LIMIT,
      groupDelay: NOTE_DELAY,
    })
    for (const text of NOTE_SEED.slice(1)) {
      history.record(text)
    }
    // The history keeps its entries private, so the step counts mirror its grouping rule.
    let open: number | null = null
    const api = {
      type(text: string) {
        const time = Date.now()
        const joins = open !== null && time - open < NOTE_DELAY
        history.record(text, { group: "typing", time })
        open = time
        const { back } = store.get()
        store.set({
          text,
          back: joins ? back : Math.min(back + 1, NOTE_LIMIT),
          ahead: 0,
        })
      },
      seal() {
        history.seal()
        open = null
      },
      undo() {
        open = null
        const text = history.undo()
        if (text === undefined) {
          return
        }
        const { back, ahead } = store.get()
        store.set({ text, back: back - 1, ahead: ahead + 1 })
      },
      redo() {
        open = null
        const text = history.redo()
        if (text === undefined) {
          return
        }
        const { back, ahead } = store.get()
        store.set({ text, back: back + 1, ahead: ahead - 1 })
      },
      keydown(event: KeyboardEvent) {
        if (matchesShortcut(event, "mod+shift+z")) {
          api.redo()
        } else if (matchesShortcut(event, "mod+z")) {
          api.undo()
        } else {
          return
        }
        event.preventDefault()
      },
    }
    return api
  },
  slots: (slot) => ({
    root: slot<object, { back: number; ahead: number }>({
      state: (state) => ({ back: state.back, ahead: state.ahead }),
    }),
    input: slot({
      attrs: (state) => ({
        value: state.text,
      }),
      on: {
        input: (event, { api }) =>
          api.type((event.target as HTMLTextAreaElement).value),
        keydown: (event, { api }) => api.keydown(event),
        pointerup: (_event, { api }) => api.seal(),
      },
    }),
    undo: slot({
      attrs: (state) => ({
        type: "button",
        disabled: state.back ? undefined : "",
      }),
      press: ({ api }) => api.undo(),
    }),
    redo: slot({
      attrs: (state) => ({
        type: "button",
        disabled: state.ahead ? undefined : "",
      }),
      press: ({ api }) => api.redo(),
    }),
  }),
})

const { Root: Notes } = createParts(notes, {
  root: "div",
  input: "textarea",
  undo: "button",
  redo: "button",
})

const steps = (back: number) => `${back} ${back === 1 ? "step" : "steps"}`

class NoteHistory extends Component {
  undoHint = useShortcutHint("mod+z")
  redoHint = useShortcutHint("mod+shift+z")

  steps = steps

  trail = (back: number, ahead: number) =>
    Array.from({ length: back + 1 + ahead }, (_, index) =>
      index < back ? "past" : index === back ? "now" : "ahead"
    )

  <template>
    <Notes class="st-notes" as |n|>
      <header class="st-notes-head">
        <span class="st-notes-title">Before Saturday</span>
        <Keys @shortcut="mod+z" />
      </header>
      <n.Input
        aria-label="Note"
        aria-keyshortcuts={{concat
          this.undoHint.ariaKeyshortcuts
          " "
          this.redoHint.ariaKeyshortcuts
        }}
        rows="3"
        spellcheck="false"
        class="st-notes-input"
      />
      <footer class="st-notes-foot">
        <n.Undo
          class="st-notes-btn"
          aria-label={{concat "Undo, " (this.steps n.state.back)}}
        >
          {{icon Undo2 16}}
          <span class="st-notes-count">{{n.state.back}}</span>
        </n.Undo>
        <n.Redo
          class="st-notes-btn"
          aria-label={{concat "Redo, " (this.steps n.state.ahead)}}
        >
          {{icon Redo2 16}}
          <span class="st-notes-count">{{n.state.ahead}}</span>
        </n.Redo>
        <span class="st-notes-trail" aria-hidden="true">
          {{#each (this.trail n.state.back n.state.ahead) key="@index" as |at|}}
            <i data-at={{at}}></i>
          {{/each}}
        </span>
      </footer>
    </Notes>
  </template>
}

export const tiles: Tile[] = [
  {
    id: "studio-notes",
    title: "Take it back.",
    blurb: "Typing undoes in runs, not letters.",
    tone: "paper",
    Demo: NoteHistory,
  },
]
