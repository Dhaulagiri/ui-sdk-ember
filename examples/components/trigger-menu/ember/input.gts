import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"

const people = [
  { value: "hollis", label: "Hollis Grant" },
  { value: "ines", label: "Inès Moreau" },
  { value: "kofi", label: "Kofi Mensah" },
  { value: "wren", label: "Wren Takahashi" },
  { value: "tomasz", label: "Tomasz Wójcik" },
]

export default class Input extends Component {
  triggers = [{ char: "@", items: people }]

  <template>
    <TriggerMenu
      @triggers={{this.triggers}}
      @autoHighlight={{false}}
      @loop={{false}}
      as |m|
    >
      <Field as |f|>
        <f.Label>Task</f.Label>
        <f.Control @render={{true}} as |control|>
          <m.Input @render={{true}} as |field|>
            <input
              {{field.part}}
              {{control.part}}
              placeholder="Type @ to assign someone…"
            />
          </m.Input>
        </f.Control>
      </Field>
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
  </template>
}
