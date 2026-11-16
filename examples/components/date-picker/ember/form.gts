import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { DatePicker } from "ember-ui-sdk/date-picker"
import { Field } from "ember-ui-sdk/field"
import { ChevronLeft, ChevronRight, Calendar } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Form extends Component {
  log = useLog(this)

  submit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Submitted due=${new FormData(event.currentTarget as HTMLFormElement).get("due")}`
    )
  }

  <template>
    <form data-slot="stack" {{on "submit" this.submit}}>
      <Field @name="due" as |f|>
        <f.Label>Due date</f.Label>
        <DatePicker @required={{true}} @field={{f.field}} as |dp|>
          <div data-slot="row">
            <dp.Input />
            <dp.Trigger data-variant="ghost">{{icon Calendar}}</dp.Trigger>
          </div>
          <dp.Content>
            <div data-slot="row">
              <dp.Previous data-variant="ghost">{{icon
                  ChevronLeft
                }}</dp.Previous>
              <dp.Heading />
              <dp.Next data-variant="ghost">{{icon ChevronRight}}</dp.Next>
            </div>
            <dp.Grid />
          </dp.Content>
        </DatePicker>
        <f.Description>When the invoice is due.</f.Description>
        <div>
          <f.Error @match="valueMissing">Choose a due date.</f.Error>
        </div>
      </Field>
      <button type="submit">Submit</button>
    </form>
  </template>
}
