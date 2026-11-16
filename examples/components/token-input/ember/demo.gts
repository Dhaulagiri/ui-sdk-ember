import Component from "@glimmer/component"
import { X } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { TokenInput } from "ember-ui-sdk/token-input"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { icon } from "../../../shared/ember/icon"

const people = [
  { value: "hollis", label: "Hollis Grant" },
  { value: "ines", label: "Inès Moreau" },
  { value: "kofi", label: "Kofi Mensah" },
  { value: "wren", label: "Wren Takahashi" },
  { value: "tomasz", label: "Tomasz Wójcik" },
]

export default class Demo extends Component {
  people = people
  triggers = [{ char: "@", type: "mention", items: people }]

  <template>
    <Field as |f|>
      <f.Label>Message</f.Label>
      <TokenInput @field={{f.field}} as |t|>
        <t.Tokens as |token parts|>
          <parts.Token>
            {{token.label}}
            <parts.Remove>{{icon X}}</parts.Remove>
          </parts.Token>
        </t.Tokens>
        <t.Editor placeholder="Type @ to mention someone…" />
        <TriggerMenu @editor={{t.editor}} @triggers={{this.triggers}} as |m|>
          <m.Content>
            <m.List as |list|>
              {{#each list.state.items key="value" as |item|}}
                <m.Item @value={{item.value}} @label={{item.label}}>
                  {{item.label}}
                </m.Item>
              {{/each}}
            </m.List>
          </m.Content>
        </TriggerMenu>
      </TokenInput>
    </Field>
  </template>
}
