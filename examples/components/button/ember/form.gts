import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Button } from "ember-ui-sdk/button"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { useLog } from "../../../shared/ember/log"

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const entries = [
      ...new FormData(event.currentTarget as HTMLFormElement),
    ].map(([name, value]) => `${name}=${value}`)
    this.log(
      entries.length ? `Submitted ${entries.join("&")}` : "Submitted nothing"
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <f.Label>Email</f.Label>
        <Input
          name="email"
          type="email"
          @defaultValue="ada@example.com"
          @field={{f.field}}
        />
      </Field>
      <div data-slot="row">
        <Button type="submit">Subscribe</Button>
        <Button type="reset">Reset</Button>
      </div>
    </form>
  </template>
}
