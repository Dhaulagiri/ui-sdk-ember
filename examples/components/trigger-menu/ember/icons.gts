import Component from "@glimmer/component"
import { Clock, Reply, Search, Share, Trash2 } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { icon } from "../../../shared/ember/icon"

const commands = [
  { value: "reply", icon: Reply, mirror: true },
  { value: "remind", icon: Clock },
  { value: "search", icon: Search },
  { value: "share", icon: Share },
  { value: "clear", icon: Trash2 },
]

export default class Icons extends Component {
  triggers = [{ char: "/", boundary: "start", type: "command" }]
  commands = commands

  <template>
    <TriggerMenu @triggers={{this.triggers}} as |m|>
      <Field as |f|>
        <f.Label>Message</f.Label>
        <f.Control @render={{true}} as |control|>
          <m.Input @render={{true}} as |input|>
            <textarea
              {{input.part}}
              {{control.part}}
              placeholder="Type / for commands…"
            ></textarea>
          </m.Input>
        </f.Control>
      </Field>
      <m.Content>
        <m.List>
          {{#each this.commands key="value" as |command|}}
            <m.Item @value={{command.value}} as |item|>
              <item.Icon @mirror={{command.mirror}}>{{icon
                  command.icon
                }}</item.Icon>
              {{command.value}}
            </m.Item>
          {{/each}}
        </m.List>
      </m.Content>
    </TriggerMenu>
  </template>
}
