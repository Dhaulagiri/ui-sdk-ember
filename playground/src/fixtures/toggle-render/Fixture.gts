import { array } from "@ember/helper"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Button } from "ember-ui-sdk/button"
import { Separator } from "ember-ui-sdk/separator"
import { Toggle, ToggleGroup } from "ember-ui-sdk/toggle"

const starClass = (pressed: boolean) =>
  `toggle ${pressed ? "is-pressed" : "is-unpressed"}`
const star = (pressed: boolean) => (pressed ? "★" : "☆")

export default class ToggleRenderFixture extends Component {
  @tracked action = ""

  span = () => (this.action = "span")
  onPressedChange = (pressed: boolean) =>
    (this.action = pressed ? "star" : "unstar")
  onValueChange = (value: string[]) => (this.action = value.join(", "))

  <template>
    <div class="fixture">
      <button>Before</button>
      <Button @onClick={{this.span}} @render={{true}} as |b|>
        <span {{b.part}} class="button">Span button</span>
      </Button>
      <Button @disabled={{true}} @render={{true}} as |b|>
        <a {{b.part}} class="button" href="#old">Old docs</a>
      </Button>
      <Toggle @onPressedChange={{this.onPressedChange}} @render={{true}} as |t|>
        <button {{t.part}} class={{starClass t.state.pressed}}>
          <span aria-hidden="true">{{star t.state.pressed}}</span>
          Star
        </button>
      </Toggle>
      <ToggleGroup
        class="toggle-group"
        aria-label="View"
        @defaultValue={{array "grid"}}
        @onValueChange={{this.onValueChange}}
        as |g|
      >
        <g.Toggle @value="grid" @render={{true}} as |t|>
          <span {{t.part}} class="toggle">Grid</span>
        </g.Toggle>
        <g.Toggle @value="list" @render={{true}} as |t|>
          <span {{t.part}} class="toggle">List</span>
        </g.Toggle>
      </ToggleGroup>
      <Separator @render={{true}} as |s|>
        <hr {{s.part}} class="rule" />
      </Separator>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
