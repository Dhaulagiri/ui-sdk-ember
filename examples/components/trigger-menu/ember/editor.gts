import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { TriggerMenu, textFieldAdapter } from "ember-ui-sdk/trigger-menu"
import { attach } from "ember-ui-sdk/primitive"

const people = [
  { value: "hollis", label: "Hollis Grant" },
  { value: "ines", label: "Inès Moreau" },
  { value: "kofi", label: "Kofi Mensah" },
  { value: "wren", label: "Wren Takahashi" },
  { value: "tomasz", label: "Tomasz Wójcik" },
]

export default class Editor extends Component {
  triggers = [{ char: "@", items: people }]
  @tracked editor: ReturnType<typeof textFieldAdapter> | null = null

  setEditor = (element: HTMLTextAreaElement) => {
    this.editor = textFieldAdapter(element)
  }

  <template>
    <TriggerMenu @editor={{this.editor}} @triggers={{this.triggers}} as |m|>
      <Field as |f|>
        <f.Label>Notes</f.Label>
        <f.Control @render={{true}} as |control|>
          <textarea
            {{attach this.setEditor}}
            {{control.part}}
            placeholder="Type @ to mention someone…"
          ></textarea>
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
