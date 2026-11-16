import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Field } from "ember-ui-sdk/field"
import { Select } from "ember-ui-sdk/select"
import { icon } from "../../../shared/ember/icon"

const countryList = [
  { value: "ar", label: "Argentina" },
  { value: "au", label: "Australia" },
  { value: "at", label: "Austria" },
  { value: "be", label: "Belgium" },
  { value: "br", label: "Brazil" },
  { value: "ca", label: "Canada" },
  { value: "cl", label: "Chile" },
  { value: "cn", label: "China" },
  { value: "dk", label: "Denmark" },
  { value: "fi", label: "Finland" },
  { value: "fr", label: "France" },
  { value: "de", label: "Germany" },
  { value: "gr", label: "Greece" },
  { value: "in", label: "India" },
  { value: "ie", label: "Ireland" },
  { value: "it", label: "Italy" },
  { value: "jp", label: "Japan" },
  { value: "mx", label: "Mexico" },
  { value: "nl", label: "Netherlands" },
  { value: "no", label: "Norway" },
  { value: "pt", label: "Portugal" },
  { value: "es", label: "Spain" },
  { value: "se", label: "Sweden" },
  { value: "ch", label: "Switzerland" },
]

function searchCountries(
  query: string,
  { signal, page }: { signal: AbortSignal; page: number }
) {
  return new Promise<{ items: typeof countryList; hasMore: boolean }>(
    (resolve, reject) => {
      const timer = setTimeout(() => {
        const needle = query.trim().toLowerCase()
        const found = countryList.filter((country) =>
          country.label.toLowerCase().includes(needle)
        )
        resolve({
          items: found.slice(page * 6, page * 6 + 6),
          hasMore: found.length > page * 6 + 6,
        })
      }, 400)
      signal.addEventListener("abort", () => {
        clearTimeout(timer)
        reject(signal.reason)
      })
    }
  )
}

type ListState = { loading: boolean; status: string; count: number }

const statusText = (state: ListState) =>
  state.loading
    ? "Loading…"
    : state.status === "error"
      ? "Couldn't load countries."
      : `${state.count} shown`

export default class AsyncSearch extends Component {
  @tracked query = ""
  results = useAsyncOptions(this, searchCountries, { immediate: true })

  onQueryChange = (next: string) => {
    this.query = next
    this.results.setQuery(next)
  }

  <template>
    <Field as |f|>
      <f.Label>Country</f.Label>
      <Select
        @items={{this.results.state.items}}
        @filter={{false}}
        @status={{this.results.state.status}}
        @query={{this.query}}
        @onQueryChange={{this.onQueryChange}}
        @onLoadMore={{this.results.loadMore}}
        @placeholder="Select a country"
        as |s|
      >
        <s.Trigger @field={{f.field}}>
          <s.Value />
          {{icon ChevronDown}}
        </s.Trigger>
        <s.Content>
          <s.Input
            aria-label="Search countries"
            placeholder="Search countries…"
          />
          <s.Empty as |empty|>
            {{#unless empty.state.loading}}No countries match “{{empty.state.query}}”.{{/unless}}
          </s.Empty>
          <s.List as |list|>
            {{#each list.state.items key="value" as |item|}}
              <s.Item
                @value={{item.value}}
                @label={{item.label}}
                @disabled={{item.disabled}}
                as |option|
              >
                {{item.label}}
                <option.Indicator>{{icon Check}}</option.Indicator>
              </s.Item>
            {{/each}}
          </s.List>
          <s.Status as |status|>{{statusText status.state}}</s.Status>
        </s.Content>
      </Select>
    </Field>
  </template>
}
