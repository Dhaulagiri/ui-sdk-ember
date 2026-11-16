import Component from "@glimmer/component"
import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const languages = [
  { value: "en", label: "English" },
  { value: "fr", label: "French" },
  { value: "de", label: "German" },
  { value: "ja", label: "Japanese" },
  { value: "pt", label: "Portuguese" },
  { value: "es", label: "Spanish" },
]

type ValueState = { placeholder: boolean; label: string; labels: string[] }

const summary = (state: ValueState) =>
  state.placeholder
    ? "Select languages"
    : state.labels.length > 2
      ? `${state.labels[0]} and ${state.labels.length - 1} more`
      : state.label

export default class Multiple extends Component {
  log = useLog(this)
  defaultValue = ["en", "ja"]

  onValueChange = (value: string[]) =>
    this.log(`value: ${JSON.stringify(value)}`)

  <template>
    <Field as |f|>
      <f.Label>Languages</f.Label>
      <Select
        @multiple={{true}}
        @defaultValue={{this.defaultValue}}
        @placeholder="Select languages"
        @onValueChange={{this.onValueChange}}
        as |s|
      >
        <s.Trigger @field={{f.field}}>
          <s.Value as |value|>{{summary value.state}}</s.Value>
          {{icon ChevronDown}}
        </s.Trigger>
        <s.Content>
          {{#each languages key="value" as |language|}}
            <s.Item @value={{language.value}} as |item|>
              {{language.label}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </s.Item>
          {{/each}}
        </s.Content>
      </Select>
    </Field>
  </template>
}
