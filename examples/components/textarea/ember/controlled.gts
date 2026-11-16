import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { Textarea } from "ember-ui-sdk/textarea"

export default class Controlled extends Component {
  @tracked bio =
    "Product designer in Lisbon. I write about type and interfaces."

  onValueChange = (value: string) => {
    this.bio = value
  }

  <template>
    <Field @name="bio" as |f|>
      <f.Label>Bio</f.Label>
      <Textarea
        @value={{this.bio}}
        @onValueChange={{this.onValueChange}}
        maxlength="160"
        @field={{f.field}}
      />
      <f.Description>{{this.bio.length}} / 160 characters</f.Description>
    </Field>
  </template>
}
