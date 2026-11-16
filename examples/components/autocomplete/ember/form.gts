import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { Field } from "ember-ui-sdk/field"
import { useLog } from "../../../shared/ember/log"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

export default class Form extends Component {
  log = useLog(this)

  submit = (event: SubmitEvent) => {
    event.preventDefault()
    const data = [...new FormData(event.currentTarget as HTMLFormElement)].map(
      ([name, value]) => `${name}=${value}`
    )
    this.log(`Submitted ${data.join("&")}`)
  }

  <template>
    <form id="order" data-slot="stack" {{on "submit" this.submit}}>
      <Field as |f|>
        <f.Label>Fruit</f.Label>
        <Autocomplete
          @name="fruit"
          @form="order"
          @required={{true}}
          @defaultValue="Apple"
          @field={{f.field}}
          as |c|
        >
          <c.Input />
          <c.Content>
            <c.Empty>No fruits found.</c.Empty>
            <c.List>
              {{#each fruits key="@identity" as |fruit|}}
                <c.Item @value={{fruit}}>
                  {{fruit}}
                </c.Item>
              {{/each}}
            </c.List>
          </c.Content>
        </Autocomplete>
        <f.Description>Any fruit, listed or not.</f.Description>
        <div><f.Error /></div>
      </Field>
      <div data-slot="row">
        <button type="submit" data-variant="solid"> Submit </button>
        <button type="reset"> Reset </button>
      </div>
    </form>
  </template>
}
