import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { FieldSet } from "ember-ui-sdk/field"
import { Switch } from "ember-ui-sdk/switch"
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
      <FieldSet as |s|>
        <s.Legend>Email notifications</s.Legend>
        <label data-slot="label">
          Product updates
          <Switch @name="updates" as |s|>
            <s.Thumb />
          </Switch>
        </label>
        <label data-slot="label">
          Security alerts
          <Switch @name="security" @defaultChecked={{true}} as |s|>
            <s.Thumb />
          </Switch>
        </label>
        <label data-slot="label">
          Weekly digest
          <Switch
            @name="digest"
            @value="weekly"
            @defaultChecked={{true}}
            as |s|
          >
            <s.Thumb />
          </Switch>
        </label>
      </FieldSet>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Save</button>
        <button type="reset">Reset</button>
      </div>
    </form>
  </template>
}
