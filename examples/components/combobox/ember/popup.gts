import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown, Search } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"

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

export default class Popup extends Component {
  @tracked query = ""

  onQueryChange = (next: string) => {
    this.query = next
  }

  onOpenChange = (open: boolean) => {
    if (open) {
      this.query = ""
    }
  }

  onOpenChangeComplete = (open: boolean) => {
    if (!open) {
      document.querySelector<HTMLElement>("#country-trigger")?.focus()
    }
  }

  <template>
    <Combobox
      @query={{this.query}}
      @onQueryChange={{this.onQueryChange}}
      @defaultValue="jp"
      @itemToLabel={{countryLabel}}
      @onOpenChange={{this.onOpenChange}}
      @onOpenChangeComplete={{this.onOpenChangeComplete}}
      as |c|
    >
      <c.Trigger @render={{true}} as |t|>
        <button
          {{t.part}}
          id="country-trigger"
          aria-label="Country"
          type="button"
        >
          <span>
            <c.Value as |state|>
              {{#if state.label}}{{state.label}}{{else}}Select a country{{/if}}
            </c.Value>
          </span>
          {{icon ChevronDown}}
        </button>
      </c.Trigger>
      <c.Content @anchor="#country-trigger">
        <div data-slot="row">
          {{icon Search}}
          <c.Input
            autofocus
            aria-label="Search countries"
            placeholder="Search…"
          />
        </div>
        <c.Empty>No countries found.</c.Empty>
        <c.List>
          {{#each countries key="value" as |country|}}
            <c.Item @value={{country.value}} @label={{country.label}} as |item|>
              {{country.label}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Combobox>
  </template>
}
