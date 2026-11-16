import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { useLog } from "../../../shared/ember/log"

const people = [
  { value: "hollis", label: "Hollis Grant" },
  { value: "ines", label: "Inès Moreau" },
  { value: "kofi", label: "Kofi Mensah" },
  { value: "wren", label: "Wren Takahashi" },
  { value: "tomasz", label: "Tomasz Wójcik" },
]

const commands = [
  {
    value: "status",
    label: "status",
    arguments: [
      {
        name: "status",
        hint: "<status>",
        required: true,
        items: ["available", "busy", "away"],
      },
    ],
  },
]

export default class Controlled extends Component {
  log = useLog(this)
  triggers = [
    { char: "@", items: people },
    { char: "/", boundary: "start", items: commands },
  ]
  @tracked open = false

  onOpenChange = (next: boolean, details: { reason: string }) => {
    this.open = next
    this.log(`${next ? "Opening" : "Closing"} (${details.reason})`)
  }

  onOpenChangeComplete = (next: boolean) => {
    this.log(next ? "Open" : "Closed")
  }

  onQueryChange = (query: string, details: { argument?: string }) => {
    this.log(
      `Query “${query}”${details.argument ? ` for ${details.argument}` : ""}`
    )
  }

  <template>
    <TriggerMenu
      @triggers={{this.triggers}}
      @open={{this.open}}
      @onOpenChange={{this.onOpenChange}}
      @onOpenChangeComplete={{this.onOpenChangeComplete}}
      @onQueryChange={{this.onQueryChange}}
      @shortcut="ctrl+j"
      as |m|
    >
      <Field as |f|>
        <f.Label>Message</f.Label>
        <f.Control @render={{true}} as |control|>
          <m.Input @render={{true}} as |input|>
            <textarea
              {{input.part}}
              {{control.part}}
              placeholder="Type @ or /…"
            ></textarea>
          </m.Input>
        </f.Control>
      </Field>
    </TriggerMenu>
  </template>
}
