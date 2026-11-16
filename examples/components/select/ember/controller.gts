import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import {
  Select,
  SelectTrigger,
  createSelectController,
} from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const statuses = [
  { value: "backlog", label: "Backlog" },
  { value: "todo", label: "Todo" },
  { value: "in-progress", label: "In Progress" },
  { value: "done", label: "Done" },
]

export default class ControllerExample extends Component {
  log = useLog(this)
  statuses = statuses
  status = createSelectController<string>()

  openAndWait = async () => {
    const { reason } = await this.status.open()
    this.log(`Closed by ${reason}, with ${this.status.getValue() ?? "nothing"}`)
  }

  markDone = () => {
    this.status.setValue("done")
  }

  clear = () => {
    this.status.clear()
  }

  focus = () => {
    this.status.focus()
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.openAndWait}}>Open and Wait</button>
        <button type="button" {{on "click" this.markDone}}>Mark Done</button>
        <button type="button" {{on "click" this.clear}}>Clear</button>
        <button type="button" {{on "click" this.focus}}>Focus</button>
      </div>
      <Select
        @controller={{this.status}}
        @items={{this.statuses}}
        @placeholder="Select a status"
        as |s|
      >
        <s.Content>
          {{#each this.statuses key="value" as |item|}}
            <s.Item @value={{item.value}} as |entry|>
              {{item.label}}
              <entry.Indicator>{{icon Check}}</entry.Indicator>
            </s.Item>
          {{/each}}
        </s.Content>
      </Select>
      <Field as |f|>
        <f.Label>Status</f.Label>
        <SelectTrigger @controller={{this.status}} @field={{f.field}} as |t|>
          <t.Value />
          {{icon ChevronDown}}
        </SelectTrigger>
      </Field>
    </div>
  </template>
}
