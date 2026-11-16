import Component from "@glimmer/component"
import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const members = [
  { value: "hollis", name: "Hollis Grant", email: "hollis@example.com" },
  { value: "ines", name: "Inès Moreau", email: "ines@example.com" },
  { value: "kofi", name: "Kofi Mensah", email: "kofi@example.com" },
  { value: "wren", name: "Wren Takahashi", email: "wren@example.com" },
]

const initial = (name: string) => name.slice(0, 1)
const isWren = (value: string) => value === "wren"

export default class CustomRendering extends Component {
  members = members
  initial = initial
  isWren = isWren

  <template>
    <Field as |f|>
      <f.Label>Reviewer</f.Label>
      <Select @defaultValue="hollis" as |s|>
        <s.Trigger @render={{true}} @field={{f.field}} as |t|>
          <button {{t.part}} type="button">
            <s.Value as |v|>
              <span data-slot="badge">{{this.initial v.state.label}}</span>
              {{v.state.label}}
            </s.Value>
            {{icon ChevronDown}}
          </button>
        </s.Trigger>
        <s.Content>
          {{#each this.members key="value" as |member|}}
            <s.Item
              @value={{member.value}}
              @label={{member.name}}
              @disabled={{this.isWren member.value}}
              as |item|
            >
              <span data-slot="badge">{{this.initial member.name}}</span>
              <span data-slot="stack">
                {{member.name}}
                <span data-slot="hint">{{if
                    item.state.disabled
                    "Out of office"
                    member.email
                  }}</span>
              </span>
              <item.Indicator @render={{true}} as |ind|>
                <span {{ind.part}}>
                  {{#if ind.state.selected}}
                    {{icon Check}}
                  {{/if}}
                </span>
              </item.Indicator>
            </s.Item>
          {{/each}}
        </s.Content>
      </Select>
    </Field>
  </template>
}
