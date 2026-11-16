import Component from "@glimmer/component"
import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

type Member = { id: number; name: string; email: string }

const members: Member[] = [
  { id: 1, name: "Hollis Grant", email: "hollis@example.com" },
  { id: 2, name: "Inès Moreau", email: "ines@example.com" },
  { id: 3, name: "Kofi Mensah", email: "kofi@example.com" },
  { id: 4, name: "Wren Takahashi", email: "wren@example.com" },
]

const itemToValue = (member: Member) => String(member.id)
const itemToLabel = (member: Member) => member.name
const isItemEqualToValue = (item: Member, value: Member) => item.id === value.id

export default class ObjectValues extends Component {
  log = useLog(this)
  defaultValue = { ...members[1] }

  onValueChange = (member: Member | null) =>
    this.log(`Submits assignee=${member ? member.id : ""}`)

  <template>
    <Field as |f|>
      <f.Label>Assignee</f.Label>
      <Select
        @defaultValue={{this.defaultValue}}
        @onValueChange={{this.onValueChange}}
        @name="assignee"
        @itemToValue={{itemToValue}}
        @itemToLabel={{itemToLabel}}
        @isItemEqualToValue={{isItemEqualToValue}}
        @placeholder="Unassigned"
        as |s|
      >
        <s.Trigger @field={{f.field}}>
          <s.Value />
          {{icon ChevronDown}}
        </s.Trigger>
        <s.Content>
          {{#each members key="id" as |member|}}
            <s.Item @value={{member}} as |item|>
              <span data-slot="stack">
                {{member.name}}
                <span data-slot="hint">{{member.email}}</span>
              </span>
              <item.Indicator>{{icon Check}}</item.Indicator>
            </s.Item>
          {{/each}}
        </s.Content>
      </Select>
    </Field>
  </template>
}
