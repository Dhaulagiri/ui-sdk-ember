import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { on } from "@ember/modifier"
import { Check, ChevronDown, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { Field } from "ember-ui-sdk/field"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const countries = [
  { value: "ar", label: "Argentina" },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria" },
  { value: "be", label: "Belgium" },
  { value: "br", label: "Brazil" },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark" },
  { value: "fi", label: "Finland" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "gr", label: "Greece" },
  { value: "jp", label: "Japan" },
  { value: "nl", label: "Netherlands" },
  { value: "es", label: "Spain" },
  { value: "se", label: "Sweden" },
  { value: "ch", label: "Switzerland" },
]

const countryLabel = (value: string) =>
  countries.find((country) => country.value === value)?.label ?? value

const interests = ["Design", "Engineering", "Marketing", "Research", "Sales"]

export default class Form extends Component {
  log = useLog(this)

  submit = (event: SubmitEvent) => {
    event.preventDefault()
    const entries = [
      ...new FormData(event.currentTarget as HTMLFormElement),
    ].map(([name, value]) => `${name}=${value}`)
    this.log(`Submitted ${entries.join("&")}`)
  }

  <template>
    <form data-slot="stack" {{on "submit" this.submit}}>
      <Field @name="country" as |f|>
        <f.Label>Country</f.Label>
        <Combobox
          @required={{true}}
          @itemToLabel={{countryLabel}}
          @field={{f.field}}
          as |c|
        >
          <div data-slot="row">
            <c.Input placeholder="Search countries…" />
            <c.Trigger aria-label="Show countries">{{icon
                ChevronDown
              }}</c.Trigger>
          </div>
          <c.Content>
            <c.Empty>No countries found.</c.Empty>
            <c.List>
              {{#each countries key="value" as |country|}}
                <c.Item
                  @value={{country.value}}
                  @label={{country.label}}
                  as |item|
                >
                  {{country.label}}
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </c.Item>
              {{/each}}
            </c.List>
          </c.Content>
        </Combobox>
        <f.Description>Where we ship your order.</f.Description>
        <div>
          <f.Error @match="valueMissing">Choose a country.</f.Error>
        </div>
      </Field>
      <Field @name="interests" as |f|>
        <f.Label>Interests</f.Label>
        <Combobox
          @multiple={{true}}
          @defaultValue={{array "Design"}}
          @field={{f.field}}
          as |c|
        >
          <c.Chips>
            <c.Value as |state|>
              {{#each state.value key="@identity" as |interest|}}
                <c.Chip @value={{interest}} as |chip|>
                  {{interest}}
                  <chip.Remove aria-label="Remove {{interest}}">{{icon
                      X
                    }}</chip.Remove>
                </c.Chip>
              {{/each}}
            </c.Value>
            <c.Input placeholder="Add interests…" />
          </c.Chips>
          <c.Content>
            <c.List>
              {{#each interests key="@identity" as |interest|}}
                <c.Item @value={{interest}} as |item|>
                  {{interest}}
                  <item.Indicator>{{icon Check}}</item.Indicator>
                </c.Item>
              {{/each}}
            </c.List>
          </c.Content>
        </Combobox>
      </Field>
      <div data-slot="row">
        <button type="submit">Submit</button>
        <button type="reset">Reset</button>
      </div>
    </form>
  </template>
}
