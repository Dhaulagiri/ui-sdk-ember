import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
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

export default class Controlled extends Component {
  log = useLog(this)
  itemToLabel = countryLabel
  @tracked value: string | null = "fr"
  @tracked query = "France"
  @tracked open = false

  chooseJapan = () => {
    this.value = "jp"
  }

  showOpen = () => {
    this.open = true
  }

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    this.log(`value: ${next} (${details.reason})`)
  }

  onQueryChange = (next: string, details: { reason: string }) => {
    this.query = next
    this.log(`query: “${next}” (${details.reason})`)
  }

  onOpenChange = (next: boolean, details: { reason: string }) => {
    this.open = next
    this.log(`open: ${next} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.chooseJapan}}>Choose Japan</button>
        <button type="button" {{on "click" this.showOpen}}>Open</button>
      </div>
      <Combobox
        @value={{this.value}}
        @onValueChange={{this.onValueChange}}
        @query={{this.query}}
        @onQueryChange={{this.onQueryChange}}
        @open={{this.open}}
        @onOpenChange={{this.onOpenChange}}
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
    </div>
  </template>
}
