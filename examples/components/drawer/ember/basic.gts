import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Minus, Plus } from "lucide"
import { Drawer } from "ember-ui-sdk/drawer"
import { icon } from "../../../shared/ember/icon"

const goal = { initial: 350, min: 200, max: 400, step: 10 }

export default class Basic extends Component {
  goal = goal
  @tracked calories = goal.initial

  decrease = () => {
    this.calories -= goal.step
  }

  increase = () => {
    this.calories += goal.step
  }

  get atMin() {
    return this.calories <= goal.min
  }

  get atMax() {
    return this.calories >= goal.max
  }

  <template>
    <Drawer as |d|>
      <d.Trigger>Open Drawer</d.Trigger>
      <d.Backdrop />
      <d.Content>
        <div data-slot="grip" aria-hidden="true"></div>

        <div data-slot="stack">
          <d.Title>Move goal</d.Title>
          <d.Description>Set your daily activity goal.</d.Description>
        </div>

        <div data-slot="row">
          <button
            type="button"
            aria-label="Decrease"
            disabled={{this.atMin}}
            {{on "click" this.decrease}}
          >
            {{icon Minus}}
          </button>
          <div data-slot="stack">
            <div aria-live="polite">{{this.calories}}</div>
            <div data-slot="hint">Calories/day</div>
          </div>
          <button
            type="button"
            aria-label="Increase"
            disabled={{this.atMax}}
            {{on "click" this.increase}}
          >
            {{icon Plus}}
          </button>
        </div>

        <div data-slot="stack">
          <d.Close data-variant="solid" @value="submit">Submit</d.Close>
          <d.Close>Cancel</d.Close>
        </div>
      </d.Content>
    </Drawer>
  </template>
}
