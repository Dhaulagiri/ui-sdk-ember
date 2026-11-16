import Component from "@glimmer/component"
import { createElement, Heart } from "lucide"
import { Toggle } from "ember-ui-sdk/toggle"

export default class Render extends Component {
  heart = (pressed: boolean) =>
    createElement(Heart, {
      fill: pressed ? "currentColor" : "none",
      "aria-hidden": "true",
    })

  <template>
    <Toggle aria-label="Favorite" @render={{true}} as |t|>
      <button {{t.part}}>
        <t.Icon>{{this.heart t.state.pressed}}</t.Icon>
      </button>
    </Toggle>
  </template>
}
