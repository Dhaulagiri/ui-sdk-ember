import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Popover } from "ember-ui-sdk/popover"
import { Select } from "ember-ui-sdk/select"
import { Textarea } from "ember-ui-sdk/textarea"
import { icon } from "../../../shared/ember/icon"

const modes = [
  { value: "false", label: "Non-modal" },
  { value: "trap-focus", label: "Trap focus" },
  { value: "true", label: "Modal" },
]

type Mode = "false" | "trap-focus" | "true"

const notes = {
  false: "Tab can leave, and focus leaving closes it.",
  "trap-focus": "Tab stays inside. The page still scrolls and takes clicks.",
  true: "Tab stays inside. The page is inert and doesn't scroll.",
}

export default class Modal extends Component {
  @tracked mode: Mode = "false"

  get modal() {
    return this.mode === "true"
      ? true
      : this.mode === "false"
        ? false
        : "trap-focus"
  }

  get note() {
    return notes[this.mode]
  }

  onValueChange = (next: string | null) => {
    if (next) {
      this.mode = next as Mode
    }
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select
          @items={{modes}}
          @value={{this.mode}}
          @onValueChange={{this.onValueChange}}
          as |s|
        >
          <s.Label>Modal</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each modes key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <Popover @modal={{this.modal}} as |p|>
        <p.Trigger>Add Comment</p.Trigger>
        <p.Content>
          <p.Title>Add a comment</p.Title>
          <p.Description>{{this.note}}</p.Description>
          <Field as |f|>
            <f.Label>Comment</f.Label>
            <Textarea @field={{f.field}} @defaultValue="Looks good to me." />
          </Field>
          <div data-slot="row">
            <p.Close>Cancel</p.Close>
            <p.Close data-variant="solid">Comment</p.Close>
          </div>
        </p.Content>
      </Popover>
    </div>
  </template>
}
