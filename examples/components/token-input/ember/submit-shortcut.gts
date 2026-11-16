import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { toLabel, TokenInput } from "ember-ui-sdk/token-input"
import { useLog } from "../../../shared/ember/log"

export default class SubmitShortcut extends Component {
  log = useLog(this)

  onSubmit = (value: Parameters<typeof toLabel>[0]) => {
    this.log(`Sent ${toLabel(value)}`)
  }

  <template>
    <Field as |f|>
      <f.Label>Message</f.Label>
      <TokenInput
        @submitShortcut="mod+enter"
        @onSubmit={{this.onSubmit}}
        @field={{f.field}}
        as |t|
      >
        <t.Editor placeholder="Write a message…" />
      </TokenInput>
    </Field>
  </template>
}
