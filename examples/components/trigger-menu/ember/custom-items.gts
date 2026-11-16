import Component from "@glimmer/component"
import { array, concat } from "@ember/helper"
import { Users } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { icon } from "../../../shared/ember/icon"

const people = [
  { value: "hollis", label: "Hollis Grant" },
  { value: "ines", label: "Inès Moreau" },
  { value: "kofi", label: "Kofi Mensah" },
  { value: "wren", label: "Wren Takahashi" },
  { value: "tomasz", label: "Tomasz Wójcik", disabled: true },
]

export default class CustomItems extends Component {
  people = people
  triggers = [
    {
      char: "@",
      spaces: 2,
      maxLength: 30,
      pattern: /[\p{L}.'-]/u,
      filter: "startsWith",
      insert: (item: { label: string }) => `@${item.label.split(" ")[0]} `,
    },
  ]

  notifyHere = (
    _value: unknown,
    details: { insert: (text: string) => void }
  ) => {
    details.insert("@here ")
  }

  <template>
    <TriggerMenu @triggers={{this.triggers}} as |m|>
      <Field as |f|>
        <f.Label>Message</f.Label>
        <f.Control @render={{true}} as |control|>
          <m.Input @render={{true}} as |input|>
            <textarea
              {{input.part}}
              {{control.part}}
              placeholder="Type @ and a first name…"
            ></textarea>
          </m.Input>
        </f.Control>
      </Field>
      <m.Content>
        <m.List>
          <m.Group as |g|>
            <g.Label>People</g.Label>
            {{#each this.people key="value" as |person|}}
              <g.Item
                @value={{person.value}}
                @label={{person.label}}
                @disabled={{person.disabled}}
              >
                {{person.label}}
                <span data-slot="hint">{{if
                    person.disabled
                    "Deactivated"
                    (concat "@" person.value)
                  }}</span>
              </g.Item>
            {{/each}}
          </m.Group>
          <m.Separator />
          <m.Item
            @value="here"
            @label="here"
            @keywords={{array "everyone" "channel"}}
            @onSelect={{this.notifyHere}}
            as |item|
          >
            <item.Icon>{{icon Users}}</item.Icon>
            Notify everyone here
          </m.Item>
        </m.List>
      </m.Content>
    </TriggerMenu>
  </template>
}
