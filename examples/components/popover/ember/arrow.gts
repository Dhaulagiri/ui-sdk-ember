import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { CircleQuestionMark } from "lucide"
import { Popover } from "ember-ui-sdk/popover"
import { icon } from "../../../shared/ember/icon"

const sides = [
  { value: "top", label: "Top" },
  { value: "right", label: "Right" },
  { value: "bottom", label: "Bottom" },
  { value: "left", label: "Left" },
] as const

type Side = (typeof sides)[number]["value"]

type Details = { reason: string; event?: Event; cancel: () => void }

export default class Arrow extends Component {
  @tracked open = false
  @tracked side: Side = "bottom"

  setSide = (side: Side) => {
    this.side = side
  }

  isPressed = (side: Side) => String(this.side === side)

  onOpenChange = (next: boolean, details: Details) => {
    const target = details.event?.target
    const inControls =
      target instanceof Element && target.closest('[data-slot="controls"]')
    if (inControls && details.reason !== "escape-key") {
      return details.cancel()
    }
    this.open = next
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls" role="group" aria-label="Side">
        {{#each sides key="value" as |option|}}
          <button
            type="button"
            data-size="sm"
            aria-pressed={{this.isPressed option.value}}
            {{on "click" (fn this.setSide option.value)}}
          >
            {{option.label}}
          </button>
        {{/each}}
      </div>
      <Popover @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |p|>
        <p.Trigger aria-label="Help">{{icon CircleQuestionMark}}</p.Trigger>
        <p.Content @side={{this.side}} @sideOffset={{10}} @arrowPadding={{12}}>
          <p.Arrow />
          <p.Title>Keyboard shortcuts</p.Title>
          <p.Description>Press ? anywhere to see them all.</p.Description>
        </p.Content>
      </Popover>
    </div>
  </template>
}
