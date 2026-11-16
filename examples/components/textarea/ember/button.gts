import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { Textarea, createInputController } from "ember-ui-sdk/textarea"
import { useLog } from "../../../shared/ember/log"

export default class Button extends Component {
  log = useLog(this)
  message = createInputController()

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = new FormData(event.currentTarget as HTMLFormElement)
    this.log(`Sent “${data.get("message")}”`)
    this.message.clear()
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field @name="message" as |f|>
        <f.Label>Message</f.Label>
        <Textarea
          @controller={{this.message}}
          @field={{f.field}}
          required
          placeholder="Write a reply to Hollis Grant…"
        />
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Send Message</button>
      </div>
    </form>
  </template>
}
