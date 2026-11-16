import Component from "@glimmer/component"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Autocomplete } from "ember-ui-sdk/autocomplete"

function searchCities(query: string, { signal }: { signal: AbortSignal }) {
  const cities = [
    "Amsterdam",
    "Athens",
    "Barcelona",
    "Berlin",
    "Boston",
    "Brussels",
    "Buenos Aires",
    "Cairo",
    "Chicago",
    "Copenhagen",
    "Dublin",
    "Lisbon",
    "London",
    "Los Angeles",
    "Madrid",
    "Paris",
    "Prague",
    "Rome",
    "Seoul",
    "Tokyo",
  ]
  return new Promise<string[]>((resolve, reject) => {
    const timer = setTimeout(() => {
      const needle = query.trim().toLowerCase()
      resolve(cities.filter((city) => city.toLowerCase().startsWith(needle)))
    }, 300)
    signal.addEventListener("abort", () => {
      clearTimeout(timer)
      reject(new DOMException("Aborted", "AbortError"))
    })
  })
}

export default class Async extends Component {
  results = useAsyncOptions(this, searchCities, { debounce: 200 })

  onValueChange = (value: string) => {
    this.results.setQuery(value)
  }

  statusText = (state: { loading: boolean; count: number }) =>
    state.loading
      ? "Searching…"
      : state.count
        ? `${state.count} ${state.count === 1 ? "city" : "cities"}`
        : ""

  <template>
    <Autocomplete
      @items={{this.results.state.items}}
      @filter={{false}}
      @status={{this.results.state.status}}
      @onValueChange={{this.onValueChange}}
      @onLoadMore={{this.results.loadMore}}
      as |c|
    >
      <div data-slot="stack">
        <c.Label>City</c.Label>
        <c.Input placeholder="e.g. Paris" />
      </div>
      <c.Content>
        <c.Status as |s|>{{this.statusText s.state}}</c.Status>
        <c.Empty as |e|>
          {{#unless e.state.loading}}No cities start with “{{e.state.query}}”.{{/unless}}
        </c.Empty>
        <c.List as |list|>
          {{#each list.state.items key="@identity" as |city|}}
            <c.Item @value={{city}}>
              {{city}}
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Autocomplete>
  </template>
}
