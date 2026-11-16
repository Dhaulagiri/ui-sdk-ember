import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const statuses = [
  { value: "backlog", label: "Backlog" },
  { value: "todo", label: "Todo" },
  { value: "in-progress", label: "In Progress" },
  { value: "done", label: "Done" },
]

type ModalMode = boolean | "pointer"

const modes: { value: ModalMode; label: string }[] = [
  { value: "pointer", label: "Pointer" },
  { value: true, label: "Modal" },
  { value: false, label: "Non-modal" },
]

export default class Modal extends Component {
  log = useLog(this)
  statuses = statuses
  modes = modes
  @tracked modal: ModalMode = "pointer"

  setModal = (value: ModalMode) => {
    this.modal = value
  }

  pressed = (value: ModalMode) => String(this.modal === value)

  saveDraft = () => {
    this.log("Pressed Save Draft")
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls" role="group" aria-label="Modal">
        {{#each this.modes key="label" as |mode|}}
          <button
            type="button"
            aria-pressed={{this.pressed mode.value}}
            {{on "click" (fn this.setModal mode.value)}}
          >
            {{mode.label}}
          </button>
        {{/each}}
      </div>
      <Field as |f|>
        <f.Label>Status</f.Label>
        <Select @modal={{this.modal}} @defaultValue="todo" as |s|>
          <s.Trigger @field={{f.field}}>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.statuses key="value" as |status|}}
              <s.Item @value={{status.value}} as |item|>
                {{status.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </Field>
      <button type="button" {{on "click" this.saveDraft}}>Save Draft</button>
    </div>
  </template>
}
