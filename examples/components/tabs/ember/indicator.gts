import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Tabs } from "ember-ui-sdk/tabs"

const orientations = [
  { value: "horizontal", label: "Horizontal" },
  { value: "vertical", label: "Vertical" },
] as const

type Orientation = "horizontal" | "vertical"

export default class Indicator extends Component {
  @tracked orientation: Orientation = "horizontal"

  setOrientation = (value: Orientation) => {
    this.orientation = value
  }

  isPressed = (value: Orientation) => String(this.orientation === value)

  <template>
    <div>
      <div data-slot="controls" role="group" aria-label="Orientation">
        {{#each orientations key="value" as |option|}}
          <button
            type="button"
            data-size="sm"
            aria-pressed={{this.isPressed option.value}}
            {{on "click" (fn this.setOrientation option.value)}}
          >
            {{option.label}}
          </button>
        {{/each}}
      </div>
      <Tabs @defaultValue="music" @orientation={{this.orientation}} as |t|>
        <t.List aria-label="Library">
          <t.Tab @value="music">Music</t.Tab>
          <t.Tab @value="podcasts">Podcasts</t.Tab>
          <t.Tab @value="audiobooks">Audiobooks</t.Tab>
          <t.Indicator />
        </t.List>
        <t.Panel @value="music">312 songs in 24 albums, synced to this device.</t.Panel>
        <t.Panel @value="podcasts">8 shows you follow, with 3 new episodes.</t.Panel>
        <t.Panel @value="audiobooks">2 books in progress, 6 hours left in total.</t.Panel>
      </Tabs>
    </div>
  </template>
}
