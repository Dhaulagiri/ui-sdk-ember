import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const priorities = [
  { value: "urgent", label: "Urgent" },
  { value: "high", label: "High" },
  { value: "medium", label: "Medium" },
  { value: "low", label: "Low" },
  { value: "none", label: "No priority" },
]

export default class AlignItem extends Component {
  @tracked aligned = true

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.aligned = next === true
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <label data-slot="label">
          <Checkbox
            @checked={{this.aligned}}
            @onCheckedChange={{this.onCheckedChange}}
            as |c|
          >
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Align item with trigger
        </label>
      </div>
      <Field as |f|>
        <f.Label>Priority</f.Label>
        <Select @defaultValue="medium" as |s|>
          <s.Trigger @field={{f.field}}>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content @alignItemWithTrigger={{this.aligned}}>
            {{#each priorities key="value" as |priority|}}
              <s.Item @value={{priority.value}} as |item|>
                {{priority.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </Field>
    </div>
  </template>
}
