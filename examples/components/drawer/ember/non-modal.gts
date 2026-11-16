import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { fn } from "@ember/helper"
import { Drawer } from "ember-ui-sdk/drawer"

const places = [
  { name: "Blue Bottle Coffee", detail: "Coffee · 0.2 mi" },
  { name: "Tartine Bakery", detail: "Bakery · 0.4 mi" },
  { name: "Dolores Park", detail: "Park · 0.5 mi" },
  { name: "Mission Dolores", detail: "Landmark · 0.6 mi" },
  { name: "Ritual Coffee Roasters", detail: "Coffee · 0.7 mi" },
]

const snapPoints = [0.2, 0.6]

export default class NonModal extends Component {
  places = places
  snapPoints = snapPoints
  @tracked destination = places[0].name

  choose = (name: string) => {
    this.destination = name
  }

  isSelected = (name: string) => String(this.destination === name)

  <template>
    <div data-slot="stack">
      <ul data-slot="list" aria-label="Places">
        {{#each this.places key="name" as |place|}}
          <li>
            <button
              type="button"
              aria-pressed={{this.isSelected place.name}}
              {{on "click" (fn this.choose place.name)}}
            >
              {{place.name}}
              <span data-slot="hint">{{place.detail}}</span>
            </button>
          </li>
        {{/each}}
      </ul>
      <Drawer @snapPoints={{this.snapPoints}} @modalAbove={{0.2}} as |d|>
        <d.Trigger>Get Directions</d.Trigger>
        <d.Backdrop />
        <d.Content as |content|>
          <d.Handle aria-label="Resize" />
          <div data-slot="row">
            <div data-slot="stack">
              <d.Title>To {{this.destination}}</d.Title>
              <d.Description>
                {{#if content.state.interactive}}
                  12 min walk. Pick another place behind the sheet.
                {{else}}
                  12 min walk. Drag the sheet down to see the places.
                {{/if}}
              </d.Description>
            </div>
            <d.Close>Done</d.Close>
          </div>
          <ol data-slot="stack">
            <li>Head north on Valencia St.</li>
            <li>Turn left onto 18th St.</li>
            <li>Arrive at {{this.destination}}.</li>
          </ol>
        </d.Content>
      </Drawer>
    </div>
  </template>
}
