import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Popover } from "ember-ui-sdk/popover"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

type Details = { reason: string; event?: Event; cancel: () => void }

export default class Controlled extends Component {
  log = useLog(this)
  @tracked open = false

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.open = next === true
  }

  onOpenChange = (next: boolean, details: Details) => {
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
      <Popover @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |p|>
        <p.Trigger>Set Status</p.Trigger>
        <p.Content>
          <p.Title>Set a status</p.Title>
          <p.Description>Your team sees it next to your name.</p.Description>
          <Field as |f|>
            <f.Label>Status</f.Label>
            <Input @field={{f.field}} @defaultValue="In a meeting" />
          </Field>
          <div data-slot="row">
            <p.Close>Cancel</p.Close>
            <p.Close data-variant="solid">Save</p.Close>
          </div>
        </p.Content>
      </Popover>
    </div>
  </template>
}
