import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import {
  SegmentedControl,
  createSegmentedControlController,
} from "ember-ui-sdk/segmented-control"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  range = createSegmentedControlController()
  @tracked value: string | null = "week"

  showMonth = () => this.range.setValue("month")

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    this.log(`value: ${next} (${details.reason})`)
  }

  <template>
    <div>
      <div data-slot="controls">
        <button type="button" {{on "click" this.showMonth}}>Show Month</button>
      </div>
      <SegmentedControl
        aria-label="Range"
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @controller={{this.range}}
        as |s|
      >
        <s.Indicator />
        <s.Item @value="day">Day</s.Item>
        <s.Item @value="week">Week</s.Item>
        <s.Item @value="month">Month</s.Item>
      </SegmentedControl>
    </div>
  </template>
}
