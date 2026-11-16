import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { useLog } from "../../../shared/ember/log"

export default class Validation extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Subscribed ${new FormData(event.currentTarget as HTMLFormElement).get("email")}`
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field @name="email" as |f|>
        <f.Label>Email</f.Label>
        <Input
          type="email"
          required
          placeholder="hollis@example.com"
          @field={{f.field}}
        />
        <f.Description>
          {{#if f.state.valid}}Looks good.{{else}}We'll send you a confirmation
            link.{{/if}}
        </f.Description>
        <f.Error @match="valueMissing">Enter your email address.</f.Error>
        <f.Error @match="typeMismatch">Enter an email address like
          hollis@example.com.</f.Error>
      </Field>
      <Field @name="website" as |f|>
        <f.Label>Website</f.Label>
        <Input
          type="url"
          required
          placeholder="https://example.com"
          @field={{f.field}}
        />
        <f.Error />
      </Field>
      <button type="submit" data-variant="solid">Subscribe</button>
    </form>
  </template>
}
