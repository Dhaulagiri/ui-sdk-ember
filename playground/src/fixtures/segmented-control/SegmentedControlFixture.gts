import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  createSegmentedControlController,
  SegmentedControl,
} from "ember-ui-sdk/segmented-control"
import { segmentedControlOptions } from "tests/fixtures/page.ts"
import { segmentedControlFixture } from "tests/fixtures/segmented-control.ts"

export default class SegmentedControlFixture extends Component {
  fixture = segmentedControlFixture
  controller = createSegmentedControlController()
  options = segmentedControlOptions()
  @tracked action = ""
  @tracked submitted = ""

  onValueChange = (
    value: string | null,
    details: { reason: string; cancel: () => void }
  ) => {
    if (value === this.options.cancel) {
      return details.cancel()
    }
    this.action = `${value}:${details.reason}`
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = Array.from(
      new FormData(event.currentTarget as HTMLFormElement),
      ([key, value]) => `${key}=${value}`
    ).join("&")
  }

  showCalendar = () => this.controller.setValue("calendar")

  <template>
    <form class="fixture" {{on "submit" this.onSubmit}}>
      <button type="button">Before</button>
      <SegmentedControl
        aria-label={{this.fixture.label}}
        @name={{this.fixture.name}}
        @defaultValue={{this.options.defaultValue}}
        @disabled={{this.options.disabled}}
        @orientation={{this.options.orientation}}
        @controller={{this.controller}}
        @onValueChange={{this.onValueChange}}
        as |s|
      >
        <s.Indicator />
        {{#each this.fixture.items key="value" as |item|}}
          <s.Item
            @value={{item.value}}
            @disabled={{item.disabled}}
          >{{item.label}}</s.Item>
        {{/each}}
      </SegmentedControl>
      <button type="button">After</button>
      <button type="submit">Save</button>
      <button type="reset">Reset</button>
      <button type="button" {{on "click" this.showCalendar}}>Show calendar</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output aria-label="Submitted">{{this.submitted}}</output>
    </form>
  </template>
}
