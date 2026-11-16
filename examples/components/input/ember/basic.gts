import Component from "@glimmer/component"
import { Field } from "ember-ui-sdk/field"
import { Input, InputGroup } from "ember-ui-sdk/input"
import { X } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Basic extends Component {
  log = useLog(this)

  onValueChange = (value: string, details: { reason: string }) => {
    this.log(`${value ? `“${value}”` : "Empty"} (${details.reason})`)
  }

  <template>
    <Field @name="website" as |f|>
      <f.Label>Website</f.Label>
      <InputGroup as |g|>
        <span>https://</span>
        <Input
          placeholder="example.com"
          @defaultValue="hollisgrant.com"
          @onValueChange={{this.onValueChange}}
          @field={{f.field}}
        />
        <g.Clear aria-label="Clear website">{{icon X}}</g.Clear>
      </InputGroup>
      <f.Description>Shown on your public profile.</f.Description>
    </Field>
  </template>
}
