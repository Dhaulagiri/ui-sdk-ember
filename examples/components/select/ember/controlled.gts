import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const roles = [
  { value: "viewer", label: "Viewer" },
  { value: "commenter", label: "Commenter" },
  { value: "editor", label: "Editor" },
  { value: "admin", label: "Admin" },
  { value: "owner", label: "Owner" },
]

export default class Controlled extends Component {
  log = useLog(this)
  roles = roles
  @tracked value: string | null = "viewer"
  @tracked open = false

  makeEditor = () => {
    this.value = "editor"
  }

  showOpen = () => {
    this.open = true
  }

  onValueChange = (
    next: string | null,
    details: { reason: string; cancel: () => void }
  ) => {
    if (next === "owner") {
      details.cancel()
      this.log("Only the owner can transfer ownership")
      return
    }
    this.value = next
    this.log(`value: ${next} (${details.reason})`)
  }

  onOpenChange = (next: boolean, details: { reason: string }) => {
    this.open = next
    this.log(`open: ${next} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.makeEditor}}>Make Editor</button>
        <button type="button" {{on "click" this.showOpen}}>Open</button>
      </div>
      <Field as |f|>
        <f.Label>Role</f.Label>
        <Select
          @value={{this.value}}
          @onValueChange={{this.onValueChange}}
          @open={{this.open}}
          @onOpenChange={{this.onOpenChange}}
          as |s|
        >
          <s.Trigger @field={{f.field}}>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.roles key="value" as |role|}}
              <s.Item @value={{role.value}} as |item|>
                {{role.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </Field>
    </div>
  </template>
}
