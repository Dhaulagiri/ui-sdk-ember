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

export default class Demo extends Component {
  triggers = [{ char: "@", type: "mention", items: people }]

  <template>
    <TriggerMenu @triggers={{this.triggers}} as |m|>
      <Field as |f|>
        <f.Label>Message</f.Label>
        <f.Control @render={{true}} as |control|>
          <m.Input @render={{true}} as |input|>
            <textarea
              {{input.part}}
              {{control.part}}
              placeholder="Type @ to mention someone…"
            ></textarea>
          </m.Input>
        </f.Control>
      </Field>
      <div data-slot="visually-hidden">
        <m.Status />
      </div>
      <m.Content>
        <m.Empty>No one found</m.Empty>
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
