import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { Switch } from "ember-ui-sdk/switch"
import { useLog } from "../../../shared/ember/log"

export default class Invalid extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Submitted two-factor=${new FormData(event.currentTarget as HTMLFormElement).get("two-factor")}`
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <div data-slot="row">
          <div data-slot="stack">
            <f.Label>Two-factor authentication</f.Label>
            <f.Description>Required for admins of this workspace.</f.Description>
          </div>
          <Switch
            @name="two-factor"
            @required={{true}}
            @field={{f.field}}
            as |s|
          >
            <s.Thumb />
          </Switch>
        </div>
        <f.Error @match="valueMissing">Turn this on to continue.</f.Error>
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Continue</button>
      </div>
    </form>
  </template>
}
