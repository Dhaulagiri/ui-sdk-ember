import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const countries = [
  { value: "ar", label: "Argentina", keywords: ["república argentina"] },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria", keywords: ["österreich"] },
  { value: "be", label: "Belgium", keywords: ["belgië", "belgique"] },
  { value: "br", label: "Brazil", keywords: ["brasil"] },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "dk", label: "Denmark", keywords: ["danmark"] },
  { value: "fi", label: "Finland", keywords: ["suomi"] },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany", keywords: ["deutschland"] },
  { value: "gr", label: "Greece", keywords: ["hellas", "ελλάδα"] },
  { value: "jp", label: "Japan", keywords: ["nippon", "日本"] },
  { value: "nl", label: "Netherlands", keywords: ["holland", "nederland"] },
  { value: "es", label: "Spain", keywords: ["españa"] },
  { value: "se", label: "Sweden", keywords: ["sverige"] },
  {
    value: "ch",
    label: "Switzerland",
    keywords: ["schweiz", "suisse", "svizzera"],
  },
]

function fuzzy(item: { label: string }, query: string) {
  let at = 0
  for (const char of item.label.toLowerCase()) {
    if (char === query[at]?.toLowerCase()) {
      at++
    }
  }
  return at === query.length
}

const filters = {
  contains: "contains",
  startsWith: "startsWith",
  fuzzy,
}

const modes = [
  { value: "contains", label: "Contains" },
  { value: "startsWith", label: "Starts with" },
  { value: "fuzzy", label: "Fuzzy" },
]

export default class Filter extends Component {
  @tracked mode = "contains"

  modes = modes

  get filter() {
    return filters[this.mode as keyof typeof filters]
  }

  onModeChange = (next: string | null) => {
    if (next) this.mode = next
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <Select
          @items={{this.modes}}
          @value={{this.mode}}
          @onValueChange={{this.onModeChange}}
          as |s|
        >
          <s.Label>Filter</s.Label>
          <s.Trigger>
            <s.Value />
            {{icon ChevronDown}}
          </s.Trigger>
          <s.Content>
            {{#each this.modes key="value" as |option|}}
              <s.Item @value={{option.value}} as |item|>
                {{option.label}}
                <item.Indicator>{{icon Check}}</item.Indicator>
              </s.Item>
            {{/each}}
          </s.Content>
        </Select>
      </div>
      <Combobox @filter={{this.filter}} as |c|>
        <div data-slot="stack">
          <c.Label>Country</c.Label>
          <div data-slot="row">
            <c.Input placeholder="Try “an”, “swd” or “deutschland”" />
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
                @keywords={{country.keywords}}
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
