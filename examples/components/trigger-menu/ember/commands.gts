import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import { on } from "@ember/modifier"
import { useLog } from "../../../shared/ember/log"

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
      {
        name: "until",
        hint: "[until]",
        items: ["30m", "1h", "4h", "today"],
        allowCustomValue: false,
      },
    ],
  },
  {
    value: "search",
    label: "search",
    arguments: [{ name: "query", hint: "<query>", required: true }],
  },
  { value: "away", label: "away", after: "submit" as const },
  { value: "clear", label: "clear" },
]

export default class Commands extends Component {
  log = useLog(this)
  triggers = [
    { char: "/", boundary: "start", type: "command", items: commands },
  ]

  submit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Sent ${new FormData(event.currentTarget as HTMLFormElement).get("message")}`
    )
  }

  onSelect = (
    value: unknown,
    details: { arguments: Record<string, string> }
  ) => {
    this.log(
      ["Chose", `/${value}`, ...Object.values(details.arguments)].join(" ")
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.submit}}>
      <TriggerMenu
        @triggers={{this.triggers}}
        @onSelect={{this.onSelect}}
        as |m|
      >
        <Field @name="message" as |f|>
          <f.Label>Message</f.Label>
          <f.Control @render={{true}} as |control|>
            <m.Input @render={{true}} as |input|>
              <textarea
                name="message"
                {{input.part}}
                {{control.part}}
                placeholder="Type / for commands…"
              ></textarea>
            </m.Input>
          </f.Control>
        </Field>
        <m.Hint />
      </TriggerMenu>
    </form>
  </template>
}
