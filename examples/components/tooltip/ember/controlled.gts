import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  @tracked open = false

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.open = next === true
  }

  onOpenChange = (
    next: boolean,
    details: { reason: string; event?: Event; cancel: () => void }
  ) => {
    const target = details.event?.target
    const inControls =
      target instanceof Element && target.closest('[data-slot="controls"]')
    if (inControls && details.reason !== "escape-key") {
      return details.cancel()
    }
    this.open = next
    this.log(`${next ? "Opened" : "Closed"} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <label data-slot="label">
          <Checkbox
            @checked={{this.open}}
            @onCheckedChange={{this.onCheckedChange}}
            as |c|
          >
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Open
        </label>
      </div>
      <Tooltip @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |t|>
        <t.Trigger>Export</t.Trigger>
        <t.Content>Download as CSV</t.Content>
      </Tooltip>
    </div>
  </template>
}
