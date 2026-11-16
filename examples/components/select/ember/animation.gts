import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"
import Component from "@glimmer/component"

const roles = [
  { value: "viewer", label: "Viewer" },
  { value: "commenter", label: "Commenter" },
  { value: "editor", label: "Editor" },
  { value: "admin", label: "Admin" },
]

export default class Animation extends Component {
  log = useLog(this)
  roles = roles

  onOpenChangeComplete = (open: boolean) => {
    this.log(open ? "Finished opening" : "Finished closing")
  }

  <template>
    <Field as |f|>
      <f.Label>Role</f.Label>
      <Select
        @defaultValue="editor"
        @onOpenChangeComplete={{this.onOpenChangeComplete}}
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
              <item.Indicator @keepMounted={{true}}>{{icon
                  Check
                }}</item.Indicator>
            </s.Item>
          {{/each}}
        </s.Content>
      </Select>
    </Field>
  </template>
}
