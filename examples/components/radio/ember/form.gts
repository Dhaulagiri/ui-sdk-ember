import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Field } from "ember-ui-sdk/field"
import { RadioGroup } from "ember-ui-sdk/radio"
import { useLog } from "../../../shared/ember/log"

const speeds = [
  { value: "standard", label: "Standard", detail: "Free, 5 to 7 days" },
  { value: "express", label: "Express", detail: "$9, 2 days" },
  { value: "overnight", label: "Overnight", detail: "$24, next day" },
]

export default class Form extends Component {
  log = useLog(this)

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.log(
      `Submitted shipping=${new FormData(event.currentTarget as HTMLFormElement).get("shipping")}`
    )
  }

  <template>
    <div data-slot="stack">
      <Field as |f|>
        <f.Label>Shipping speed</f.Label>
        <RadioGroup
          @name="shipping"
          @form="checkout"
          @required={{true}}
          @defaultValue="standard"
          @field={{f.field}}
          as |g|
        >
          {{#each speeds key="value" as |speed|}}
            <label data-slot="label">
              <g.Radio @value={{speed.value}} as |r|>
                <r.Indicator />
              </g.Radio>
              {{speed.label}}
              <span data-slot="hint">({{speed.detail}})</span>
            </label>
          {{/each}}
        </RadioGroup>
      </Field>
      <form id="checkout" data-slot="row" {{on "submit" this.onSubmit}}>
        <button type="submit" data-variant="solid">Continue</button>
        <button type="reset">Reset</button>
      </form>
    </div>
  </template>
}
