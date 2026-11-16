import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { fromText, toText, TokenInput } from "ember-ui-sdk/token-input"
import { useLog } from "../../../shared/ember/log"

const chat = {
  format: (token: { value: string }) => `<@${token.value}>`,
  parse: (text: string) =>
    text.split(/(<@[\w.-]+>)/).map((part) => {
      const id = /^<@([\w.-]+)>$/.exec(part)?.[1]
      return id ? { type: "mention", value: id, label: `@${id}` } : part
    }),
}

const draft = fromText("Ping <@hollis> and <@ines> about the launch", chat)

export default class Codec extends Component {
  log = useLog(this)
  chat = chat
  draft = draft

  onValueChange = (value: Parameters<typeof toText>[0]) => {
    this.log(toText(value, chat))
  }

  <template>
    <Field as |f|>
      <f.Label>Message</f.Label>
      <TokenInput
        @codec={{this.chat}}
        @copy="label"
        @defaultValue={{this.draft}}
        @onValueChange={{this.onValueChange}}
        @field={{f.field}}
        as |t|
      >
        <t.Editor />
      </TokenInput>
    </Field>
  </template>
}
