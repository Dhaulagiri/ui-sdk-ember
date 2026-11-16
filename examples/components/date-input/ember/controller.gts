import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createDateInputController, DateInput } from "ember-ui-sdk/date-input"
import { Field } from "ember-ui-sdk/field"

export default class Controller extends Component {
  publish = createDateInputController()

  christmas = () => {
    this.publish.setValue("2026-12-25")
  }

  editYear = () => {
    this.publish.focus("year")
  }

  clear = () => {
    this.publish.clear()
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.christmas}}>Christmas</button>
        <button type="button" {{on "click" this.editYear}}>Edit Year</button>
        <button type="button" {{on "click" this.clear}}>Clear</button>
      </div>
      <Field as |f|>
        <f.Label>Publish on</f.Label>
        <DateInput @controller={{this.publish}} @field={{f.field}} />
      </Field>
    </div>
  </template>
}
