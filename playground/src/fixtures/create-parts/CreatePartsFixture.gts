import { array } from "@ember/helper"
import { on } from "@ember/modifier"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { createChange, createPreference, definePrimitive } from "@ui-sdk/core"
import { listbox } from "@ui-sdk/core/listbox"
import { Preferences, usePreference } from "ember-ui-sdk/preferences"
import { attach, createParts } from "ember-ui-sdk/primitive"
import { useShortcut, useShortcutHint } from "ember-ui-sdk/shortcuts"
import { rating } from "../../../../vendor/ui/examples/core/rating-stages/keyboard.ts"

const muteButton = definePrimitive({
  name: "mute-button",
  options: { muted: "boolean", onMutedChange: "callback" },
  controlled: ["muted"],
  state: (options: {
    muted?: boolean
    onMutedChange?: (muted: boolean) => void
  }) => ({ muted: options.muted ?? false }),
  sync: (options) =>
    options.muted === undefined ? {} : { muted: options.muted },
  api: (context) => {
    const change = createChange(context)
    return {
      toggle: (event?: Event) =>
        change("muted", !context.store.get().muted, { reason: "press", event }),
    }
  },
  slots: (slot) => ({
    root: slot<{}, { muted: boolean }>({
      state: (state) => ({ muted: state.muted }),
      attrs: (state) => ({
        type: "button",
        "aria-pressed": String(state.muted),
        "data-muted": state.muted ? "" : undefined,
      }),
      press: ({ api }, event) => api.toggle(event),
    }),
  }),
})

const { Root: MuteButton } = createParts(muteButton, { root: "button" })
const { Root: Rating } = createParts(rating, {
  root: "div",
  star: "button",
})
const { Root: Fruits } = createParts(listbox, {
  root: "div",
  item: "div",
  "item-indicator": "span",
})

const density = createPreference({
  attribute: "data-density",
  values: ["compact", "comfortable"],
  defaultValue: "comfortable",
})

const stars = ["1", "2", "3", "4", "5"]

export default class CreatePartsFixture extends Component {
  @tracked muted = false
  @tracked score = 2
  @tracked bolded = 0
  @tracked element = ""
  hint = useShortcutHint("mod+b")
  density = usePreference(this, density)

  constructor(owner: Owner, args: object) {
    super(owner, args)
    useShortcut(this, "mod+b", () => this.bolded++)
  }

  setMuted = (muted: boolean) => (this.muted = muted)
  setScore = (score: number) => (this.score = score)
  toggleDensity = () =>
    density.set(
      this.density.current.value === "compact" ? "comfortable" : "compact"
    )
  capture = (el: Element) => {
    this.element = el.tagName.toLowerCase()
    return () => (this.element = "")
  }

  <template>
    <Preferences @preferences={{array density}}>
      <div class="fixture">
        <button type="button">Before</button>
        <MuteButton class="mute" as |m|>{{if
            m.state.muted
            "Unmute"
            "Mute"
          }}</MuteButton>

        <MuteButton
          @muted={{this.muted}}
          @onMutedChange={{this.setMuted}}
        >Controlled</MuteButton>
        <output aria-label="Muted">{{if this.muted "yes" "no"}}</output>

        <MuteButton @render={{true}} as |m|>
          <a href="#mute" class="rendered" role="button" {{m.part}}>Rendered</a>
        </MuteButton>

        <Rating
          aria-label="Rating"
          @value={{this.score}}
          @onValueChange={{this.setScore}}
          as |r|
        >
          {{#each stars as |star|}}
            <r.Star @value={{star}} aria-label="{{star}} stars">★</r.Star>
          {{/each}}
        </Rating>
        <output aria-label="Score">{{this.score}}</output>

        <Fruits aria-label="Fruit" @defaultValue="apple" as |l|>
          <l.Item @value="apple" as |i|>Apple<i.ItemIndicator
              class="check"
            >✓</i.ItemIndicator></l.Item>
          <l.Item @value="pear" as |i|>Pear<i.ItemIndicator
              class="check"
            >✓</i.ItemIndicator></l.Item>
        </Fruits>

        <span
          class="hint"
          aria-keyshortcuts={{this.hint.ariaKeyshortcuts}}
        >{{this.hint.text}}</span>
        <output aria-label="Bolded">{{this.bolded}}</output>

        <button type="button" {{on "click" this.toggleDensity}}>Density</button>
        <output aria-label="Density">{{this.density.current.value}}</output>

        <p class="attached" {{attach this.capture}}>Attached</p>
        <output aria-label="Attached">{{this.element}}</output>
      </div>
    </Preferences>
  </template>
}
