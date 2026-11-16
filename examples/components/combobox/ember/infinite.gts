import Component from "@glimmer/component"
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

function searchMoviePages(
  query: string,
  { signal, page }: { signal: AbortSignal; page: number }
) {
  return new Promise<{
    items: { value: string; label: string }[]
    hasMore: boolean
  }>((resolve, reject) => {
    const timer = setTimeout(() => {
      const needle = query.trim().toLowerCase()
      const found = movieTitles
        .filter((title) => title.toLowerCase().includes(needle))
        .map((title) => ({
          value: title.toLowerCase().replace(/\W+/g, "-"),
          label: title,
        }))
      resolve({
        items: found.slice(page * 5, page * 5 + 5),
        hasMore: found.length > page * 5 + 5,
      })
    }, 500)
    signal.addEventListener("abort", () => {
      clearTimeout(timer)
      reject(signal.reason)
    })
  })
}

export default class Infinite extends Component {
  movies = useAsyncOptions(this, searchMoviePages, { immediate: true })

  onQueryChange = (query: string) => {
    this.movies.setQuery(query)
  }

  onLoadMore = () => {
    this.movies.loadMore()
  }

  statusText = (state: { loading: boolean; count: number }) =>
    state.loading
      ? "Loading more…"
      : this.movies.state.hasMore
        ? `${state.count} loaded`
        : `All ${state.count}`

  <template>
    <Combobox
      @items={{this.movies.state.items}}
      @filter={{false}}
      @status={{this.movies.state.status}}
      @onQueryChange={{this.onQueryChange}}
      @onLoadMore={{this.onLoadMore}}
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
        <c.Empty as |e|>
          {{#unless e.state.loading}}No movies found.{{/unless}}
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
        <c.Status as |s|>{{this.statusText s.state}}</c.Status>
      </c.Content>
    </Combobox>
  </template>
}
