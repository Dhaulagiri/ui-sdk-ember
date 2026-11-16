import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"

const movieTitles = [
  "The Shawshank Redemption",
  "The Godfather",
  "The Dark Knight",
  "Pulp Fiction",
  "Schindler's List",
  "The Lord of the Rings",
  "Fight Club",
  "Forrest Gump",
  "Inception",
  "The Matrix",
  "Goodfellas",
  "Interstellar",
  "Parasite",
  "Spirited Away",
  "Whiplash",
  "The Prestige",
  "The Departed",
  "Gladiator",
  "Alien",
  "Casablanca",
  "Amélie",
  "Arrival",
]

function searchMovies(query: string, { signal }: { signal: AbortSignal }) {
  return new Promise<{ value: string; label: string }[]>((resolve, reject) => {
    const timer = setTimeout(() => {
      const needle = query.trim().toLowerCase()
      resolve(
        movieTitles
          .filter((title) => title.toLowerCase().includes(needle))
          .map((title) => ({
            value: title.toLowerCase().replace(/\W+/g, "-"),
            label: title,
          }))
      )
    }, 500)
    signal.addEventListener("abort", () => {
      clearTimeout(timer)
      reject(signal.reason)
    })
  })
}

const statusText = (state: {
  status: string
  loading: boolean
  count: number
}) =>
  state.status === "error"
    ? "Couldn't load movies."
    : state.loading
      ? "Searching…"
      : `${state.count} ${state.count === 1 ? "movie" : "movies"}`

export default class Async extends Component {
  movies = useAsyncOptions(this, searchMovies, {
    debounce: 300,
    query: "the",
    immediate: true,
  })

  statusText = statusText

  onQueryChange = (query: string) => {
    this.movies.setQuery(query)
  }

  <template>
    <Combobox
      @items={{this.movies.state.items}}
      @defaultQuery="the"
      @filter={{false}}
      @status={{this.movies.state.status}}
      @onQueryChange={{this.onQueryChange}}
      as |c|
    >
      <div data-slot="stack">
        <c.Label>Movie</c.Label>
        <div data-slot="row">
          <c.Input placeholder="Search movies…" />
          <c.Trigger aria-label="Show movies">{{icon ChevronDown}}</c.Trigger>
        </div>
      </div>
      <c.Content>
        <c.Status as |s|>{{this.statusText s.state}}</c.Status>
        <c.Empty as |e|>
          {{#unless e.state.loading}}No movies match “{{e.state.query}}”.{{/unless}}
        </c.Empty>
        <c.List as |list|>
          {{#each list.state.items key="value" as |item|}}
            <c.Item
              @value={{item.value}}
              @label={{item.label}}
              @disabled={{item.disabled}}
              as |i|
            >
              {{item.label}}
              <i.Indicator>{{icon Check}}</i.Indicator>
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Combobox>
  </template>
}
