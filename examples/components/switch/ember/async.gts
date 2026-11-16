import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Switch, createSwitchController } from "ember-ui-sdk/switch"
import { LoaderCircle } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const save = (_checked: boolean) =>
  new Promise((resolve) => setTimeout(resolve, 800))

export default class Async extends Component {
  log = useLog(this)
  backups = createSwitchController()
  @tracked saving = false

  onCheckedChange = (
    next: boolean,
    details: { reason: string; cancel: () => void }
  ) => {
    if (details.reason === "imperative") {
      return
    }
    details.cancel()
    if (this.saving) {
      return
    }
    this.saving = true
    this.log("Saving…")
    save(next).then(() => {
      this.backups.setChecked(next, { reason: "imperative" })
      this.saving = false
      this.log(`Saved: ${next ? "on" : "off"}`)
    })
  }

  <template>
    <label data-slot="label">
      Automatic backups
      <Switch
        @controller={{this.backups}}
        aria-busy={{if this.saving "true" "false"}}
        @onCheckedChange={{this.onCheckedChange}}
        as |s|
      >
        <s.Thumb>
          {{#if this.saving}}
            <span data-slot="spinner">{{icon LoaderCircle}}</span>
          {{/if}}
        </s.Thumb>
      </Switch>
    </label>
  </template>
}
