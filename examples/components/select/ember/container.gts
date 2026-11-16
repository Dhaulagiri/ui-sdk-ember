import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"
import { attach } from "ember-ui-sdk/primitive"

const fonts = [
  { value: "inter", label: "Inter" },
  { value: "geist", label: "Geist" },
  { value: "source-serif", label: "Source Serif" },
  { value: "geist-mono", label: "Geist Mono" },
]

export default class Container extends Component {
  fonts = fonts
  @tracked container: HTMLElement | null = null

  setContainer = (element: HTMLElement) => {
    this.container = element
  }

  <template>
    <div data-slot="stack">
      <Field as |f|>
        <f.Label>Font</f.Label>
        <Select @container={{this.container}} @defaultValue="inter" as |s|>
          <s.Trigger @field={{f.field}}>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.fonts key="value" as |font|}}
              <s.Item @value={{font.value}} as |item|>
                {{font.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </Field>
      <div {{attach this.setContainer}} data-slot="card"></div>
    </div>
  </template>
}
