import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Check, ChevronDown } from "lucide"
import { Combobox, createComboboxController } from "ember-ui-sdk/combobox"
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

export default class Controller extends Component {
  log = useLog(this)
  country = createComboboxController<string>()
  itemToLabel = countryLabel

  openAndWait = async () => {
    const { reason } = await this.country.open()
    this.log(
      `Closed by ${reason}, with ${this.country.getValue() ?? "nothing"}`
    )
  }

  search = () => {
    this.country.focus()
    this.country.setQuery("sw")
    this.country.open()
  }

  chooseGermany = () => {
    this.country.setValue("de")
  }

  clear = () => {
    this.country.clear()
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.openAndWait}}>Open and Wait</button>
        <button type="button" {{on "click" this.search}}>Search “sw”</button>
        <button type="button" {{on "click" this.chooseGermany}}>Choose Germany</button>
        <button type="button" {{on "click" this.clear}}>Clear</button>
      </div>
      <Combobox
        @controller={{this.country}}
        @itemToLabel={{this.itemToLabel}}
        as |c|
      >
        <div data-slot="stack">
          <c.Label>Country</c.Label>
          <div data-slot="row">
            <c.Input placeholder="Search countries…" />
            <c.Trigger aria-label="Show countries">{{icon
                ChevronDown
              }}</c.Trigger>
          </div>
        </div>
        <c.Content>
          <c.Empty>No countries found.</c.Empty>
          <c.List>
            {{#each countries key="value" as |item|}}
              <c.Item @value={{item.value}} @label={{item.label}} as |entry|>
                {{item.label}}
                <entry.Indicator>{{icon Check}}</entry.Indicator>
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Combobox>
    </div>
  </template>
}
