import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { attach } from "ember-ui-sdk/primitive"

const people = [
  { value: "hollis", label: "Hollis Grant" },
  { value: "ines", label: "Inès Moreau" },
  { value: "kofi", label: "Kofi Mensah" },
  { value: "wren", label: "Wren Takahashi" },
  { value: "tomasz", label: "Tomasz Wójcik" },
]

export default class Positioning extends Component {
  triggers = [{ char: "@", items: people }]
  @tracked field: HTMLElement | null = null

  setField = (element: HTMLElement) => {
    this.field = element
  }

  <template>
    <TriggerMenu @triggers={{this.triggers}} as |m|>
      <Field {{attach this.setField}} as |f|>
        <f.Label>Comment</f.Label>
        <f.Control @render={{true}} as |control|>
          <m.Input @render={{true}} as |field|>
            <input
              {{field.part}}
              {{control.part}}
              placeholder="Type @ to mention someone…"
            />
          </m.Input>
        </f.Control>
      </Field>
      <m.Content
        @side="top"
        @align="start"
        @sideOffset={{8}}
        @alignOffset={{-5}}
        @collisionPadding={{16}}
        @anchor={{this.field}}
        @container={{this.field}}
        @keepMounted={{true}}
      >
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
