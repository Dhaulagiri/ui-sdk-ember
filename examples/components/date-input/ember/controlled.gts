import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"
import { useLog } from "../../../shared/ember/log"

export default class Controlled extends Component {
  log = useLog(this)
  @tracked value: string | null = "2026-11-02"

  clear = () => {
    this.value = null
  }

  onValueChange = (next: string | null) => {
    this.value = next
    this.log(`Due date ${next ?? "empty"}`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.clear}}>Clear</button>
      </div>
      <Field as |f|>
        <f.Label>Due date</f.Label>
        <DateInput
          @value={{this.value}}
          @onValueChange={{this.onValueChange}}
          @field={{f.field}}
        />
      </Field>
    </div>
  </template>
}
