import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import {
  createTriggerMenuController,
  TriggerMenu,
} from "ember-ui-sdk/trigger-menu"
import { useLog } from "../../../shared/ember/log"

const people = [
  { value: "hollis", label: "Hollis Grant" },
  { value: "ines", label: "Inès Moreau" },
  { value: "kofi", label: "Kofi Mensah" },
  { value: "wren", label: "Wren Takahashi" },
  { value: "tomasz", label: "Tomasz Wójcik" },
]

export default class Controller extends Component {
  log = useLog(this)
  menu = createTriggerMenuController()
  triggers = [{ char: "@", items: people }]

  keepFocus = (event: Event) => {
    event.preventDefault()
  }

  mention = async () => {
    const closed = await this.menu.open({ trigger: "@" })
    this.log(`Closed (${closed.reason})`)
  }

  insertDate = () => {
    this.menu.insert(
      new Date().toLocaleDateString("en-US", {
        month: "long",
        day: "numeric",
      })
    )
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button
          type="button"
          {{on "mousedown" this.keepFocus}}
          {{on "click" this.mention}}
        >Mention</button>
        <button
          type="button"
          {{on "mousedown" this.keepFocus}}
          {{on "click" this.insertDate}}
        >
          Insert Date
        </button>
      </div>
      <TriggerMenu @controller={{this.menu}} @triggers={{this.triggers}} as |m|>
        <Field as |f|>
          <f.Label>Message</f.Label>
          <f.Control @render={{true}} as |control|>
            <m.Input @render={{true}} as |input|>
              <textarea
                {{input.part}}
                {{control.part}}
                placeholder="Write a message…"
              ></textarea>
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
    </div>
  </template>
}
