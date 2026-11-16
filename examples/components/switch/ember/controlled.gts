import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Switch, createSwitchController } from "ember-ui-sdk/switch"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  wifi = createSwitchController()
  @tracked checked = true

  toggle = () => this.wifi.toggle()

  onCheckedChange = (next: boolean, details: { reason: string }) => {
    this.checked = next
    this.log(`${next ? "On" : "Off"} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.toggle}}>Toggle</button>
      </div>
      <label data-slot="label">
        Wi-Fi
        <Switch
          @checked={{this.checked}}
          @onCheckedChange={{this.onCheckedChange}}
          @controller={{this.wifi}}
          as |s|
        >
          <s.Thumb />
        </Switch>
      </label>
    </div>
  </template>
}
