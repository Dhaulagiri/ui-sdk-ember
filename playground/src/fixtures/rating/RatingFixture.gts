import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { createRatingController, Rating } from "ember-ui-sdk/rating"
import { ratingOptions } from "tests/fixtures/page.ts"
import { ratingFixture } from "tests/fixtures/rating.ts"

const { quality, value, average } = ratingFixture

export default class RatingFixture extends Component {
  quality = quality
  value = value
  average = average
  controller = createRatingController()
  options = ratingOptions()
  @tracked action = ""
  @tracked submitted = ""

  onValueChange = (
    score: number | null,
    details: { reason: string; cancel: () => void }
  ) => {
    if (score === this.options.cancel) {
      return details.cancel()
    }
    this.action = `${score}:${details.reason}`
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = Array.from(
      new FormData(event.currentTarget as HTMLFormElement),
      ([key, entry]) => `${key}=${entry}`
    ).join("&")
  }

  rateFive = () => this.controller.setValue(5)

  <template>
    <form class="fixture" {{on "submit" this.onSubmit}}>
      <button type="button">Before</button>
      <Rating
        aria-label={{this.quality.label}}
        @name={{this.quality.name}}
        @defaultValue={{this.quality.defaultValue}}
        @disabled={{this.options.disabled}}
        @controller={{this.controller}}
        @onValueChange={{this.onValueChange}}
        as |r|
      >
        <r.Item as |i|>
          <span class="star">{{i.state.fill}}</span>
        </r.Item>
      </Rating>
      <button type="button">After</button>
      <Rating
        aria-label={{this.value.label}}
        @name={{this.value.name}}
        @step={{this.value.step}}
        @deselectable={{true}}
      />
      <Rating
        @value={{this.average.value}}
        @getValueLabel={{this.average.getValueLabel}}
        @readOnly={{true}}
      />
      <button type="submit">Save</button>
      <button type="reset">Reset</button>
      <button type="button" {{on "click" this.rateFive}}>Rate five</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output aria-label="Submitted">{{this.submitted}}</output>
    </form>
  </template>
}
