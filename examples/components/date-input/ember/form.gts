import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"
import { TimeInput } from "ember-ui-sdk/time-input"
import { useLog } from "../../../shared/ember/log"

export default class Form extends Component {
  log = useLog(this)

  onsubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = [...new FormData(event.currentTarget as HTMLFormElement)].map(
      ([name, value]) => `${name}=${value}`
    )
    this.log(`Submitted ${data.join(", ")}`)
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onsubmit}}>
      <Field as |f|>
        <f.Label>Date</f.Label>
        <DateInput
          @name="date"
          @defaultValue="2026-11-02"
          @required={{true}}
          @field={{f.field}}
        />
        <f.Error />
      </Field>
      <Field as |f|>
        <f.Label>Time</f.Label>
        <TimeInput
          @name="time"
          @defaultValue="09:30"
          @required={{true}}
          @field={{f.field}}
        />
        <f.Error />
      </Field>
      <div data-slot="row">
        <button type="reset">Reset</button>
        <button type="submit" data-variant="solid">Book</button>
      </div>
    </form>
  </template>
}
