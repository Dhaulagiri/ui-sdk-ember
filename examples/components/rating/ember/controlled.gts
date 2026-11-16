import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Rating, createRatingController } from "ember-ui-sdk/rating"
import { Star } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  rating = createRatingController()
  @tracked value: number | null = 4

  clear = () => this.rating.setValue(null)

  onValueChange = (next: number | null, details: { reason: string }) => {
    this.value = next
    this.log(`value: ${next} (${details.reason})`)
  }

  <template>
    <div>
      <div data-slot="controls">
        <button type="button" {{on "click" this.clear}}>Clear Rating</button>
      </div>
      <Rating
        aria-label="Rating"
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @controller={{this.rating}}
        as |r|
      >
        <r.Item as |i|>{{icon Star}}</r.Item>
      </Rating>
    </div>
  </template>
}
