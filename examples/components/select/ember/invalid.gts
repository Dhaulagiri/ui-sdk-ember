import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { Check, ChevronDown } from "lucide"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const methods = [
  { value: "standard", label: "Standard" },
  { value: "express", label: "Express" },
  { value: "overnight", label: "Overnight" },
]

export default class Invalid extends Component {
  log = useLog(this)

  submit = (event: SubmitEvent) => {
    event.preventDefault()
    const form = event.currentTarget as HTMLFormElement
    this.log(`Submitted shipping=${new FormData(form).get("shipping")}`)
  }

  <template>
    <form data-slot="stack" {{on "submit" this.submit}}>
      <Field @name="shipping" as |f|>
        <f.Label>Shipping method</f.Label>
        <Select
          @name="shipping"
          @required={{true}}
          @placeholder="Select a shipping method"
          as |s|
        >
          <s.Trigger @field={{f.field}}>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each methods key="value" as |method|}}
              <s.Item @value={{method.value}} as |item|>
                {{method.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
        <f.Description>Express arrives in two business days.</f.Description>
        <f.Error @match="valueMissing">Choose a shipping method.</f.Error>
      </Field>
      <button type="submit" data-variant="solid">Continue</button>
    </form>
  </template>
}
