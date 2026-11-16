import Component from "@glimmer/component"
import { Check, ChevronDown, X } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const people = [
  { value: "hollis", label: "Hollis Grant" },
  { value: "ines", label: "Inès Moreau" },
  { value: "kofi", label: "Kofi Mensah" },
  { value: "wren", label: "Wren Takahashi" },
  { value: "tomasz", label: "Tomasz Wójcik" },
]

export default class Clearable extends Component {
  log = useLog(this)

  onValueChange = (value: string | null, details: { reason: string }) =>
    this.log(`value: ${JSON.stringify(value)} (${details.reason})`)

  <template>
    <Field as |f|>
      <f.Label>Assignee</f.Label>
      <Select
        @defaultValue="ines"
        @placeholder="Unassigned"
        @onValueChange={{this.onValueChange}}
        as |s|
      >
        <div data-slot="row">
          <s.Trigger @field={{f.field}}>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Clear aria-label="Clear assignee">{{icon X}}</s.Clear>
        </div>
        <s.Content>
          {{#each people key="value" as |person|}}
            <s.Item @value={{person.value}} as |item|>
              {{person.label}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </s.Item>
          {{/each}}
        </s.Content>
      </Select>
    </Field>
  </template>
}
