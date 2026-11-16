import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { Rating } from "ember-ui-sdk/rating"
import { Star } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Submitted stay=${new FormData(event.currentTarget as HTMLFormElement).get("stay")}`
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.onSubmit}}>
      <Field as |f|>
        <f.Label>Rate your stay</f.Label>
        <Rating @name="stay" @required={{true}} @field={{f.field}} as |r|>
          <r.Item as |i|>{{icon Star}}</r.Item>
        </Rating>
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid">Send Review</button>
        <button type="reset">Reset</button>
      </div>
    </form>
  </template>
}
