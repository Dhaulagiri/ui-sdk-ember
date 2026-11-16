import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Dialog } from "ember-ui-sdk/dialog"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const topics = [
  { label: "Product updates", checked: true },
  { label: "Security alerts", checked: true },
  { label: "Weekly digest", checked: false },
]

export default class Controlled extends Component {
  log = useLog(this)
  topics = topics
  @tracked open = false

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.open = next === true
  }

  onOpenChange = (next: boolean, details: { reason: string }) => {
    this.open = next
    this.log(`${next ? "Opened" : "Closed"} (${details.reason})`)
  }

  onOpenChangeComplete = (next: boolean) => {
    this.log(next ? "Finished opening" : "Finished closing")
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
      <Dialog
        @open={{this.open}}
        @onOpenChange={{this.onOpenChange}}
        @onOpenChangeComplete={{this.onOpenChangeComplete}}
        as |d|
      >
        <d.Trigger>Notification Settings</d.Trigger>
        <d.Backdrop />
        <d.Content>
          <div data-slot="stack">
            <d.Title>Notification settings</d.Title>
            <d.Description>Choose what we email you about.</d.Description>
          </div>
          <div data-slot="stack">
            {{#each this.topics key="label" as |topic|}}
              <label data-slot="label">
                <Checkbox @defaultChecked={{topic.checked}} as |c|>
                  <c.Indicator>{{icon Check}}</c.Indicator>
                </Checkbox>
                {{topic.label}}
              </label>
            {{/each}}
          </div>
          <div data-slot="row">
            <d.Close data-variant="solid">Done</d.Close>
          </div>
        </d.Content>
      </Dialog>
    </div>
  </template>
}
