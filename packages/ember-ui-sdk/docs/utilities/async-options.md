# Async Options

Load search results, cancel stale requests, and fetch the next page.

`useAsyncOptions` loads items as someone types. It waits for typing to pause, cancels requests that are replaced, and keeps the previous results visible while loading.

```glimmer-ts title="async.gts"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, ChevronDown } from "lucide"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

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
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Change the movie search and wait for the results. Use the arrow keys to choose a movie, then press Enter.

## Load Results

Call the helper in a component class, passing the component as its owner and a loader. This example expects `/api/movies` to return an array of movie titles:

```gts
import Component from "@glimmer/component"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Combobox } from "ember-ui-sdk/combobox"

export default class Movies extends Component {
  movies = useAsyncOptions(this, async (query, { signal }) => {
    const response = await fetch(`/api/movies?q=${encodeURIComponent(query)}`, {
      signal,
    })
    if (!response.ok) throw new Error("Couldn't load movies")
    return response.json()
  })

  onQueryChange = (query: string) => {
    this.movies.setQuery(query)
  }

  <template>
    <Combobox
      @items={{this.movies.state.items}}
      @filter={{false}}
      @status={{this.movies.state.status}}
      @onQueryChange={{this.onQueryChange}}
      as |c|
    >
      <c.Label>Movie</c.Label>
      <c.Input placeholder="Search movies…" />
      <c.Content>
        <c.Status as |s|>{{s.state.status}}</c.Status>
        <c.Empty>No movies match.</c.Empty>
        <c.List as |list|>
          {{#each list.state.items key="@identity" as |movie|}}
            <c.Item @value={{movie}} @label={{movie}}>{{movie}}</c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Combobox>
  </template>
}
```

Read `this.movies.state` in the template so Glimmer tracks it. Copying the state into a plain variable keeps only its value at that moment.

Pass `signal` to `fetch` so a newer search can cancel the request. The helper cancels on destroy. `@filter={{false}}` leaves matching and ordering to the server.

Use `c.Status` and `c.Empty` to show loading, error, and empty messages, as in the demo. The same pattern works with [Select](../components/select.md#async-search), [Autocomplete](../components/autocomplete.md#async-suggestions), and [Command](../components/command.md#async-results).

## Choose When to Load

The third argument sets the starting behavior:

| Option      | What It Does                                            | Default |
| ----------- | ------------------------------------------------------- | ------- |
| `debounce`  | Milliseconds typing must pause before a request starts. | `200`   |
| `query`     | The starting search text.                               | `""`    |
| `immediate` | Loads that text as soon as the component mounts.        | `false` |

```ts
movies = useAsyncOptions(this, searchMovies, { immediate: true, debounce: 300 })
```

For initial choices, use `immediate: true`. Until that first load starts, `status` is already `"loading"`, so the list never flashes an empty state. If you set `query`, use the same starting text for the combobox's `@defaultQuery`.

## Load More

For paged results, the loader receives `page`, starting at `0`. Return `{ items, hasMore }`:

```ts
import type { AsyncOptionsContext } from "ember-ui-sdk/async-options"

async function loadMoviePages(
  query: string,
  { signal, page }: AsyncOptionsContext
) {
  const response = await fetch(
    `/api/movies?q=${encodeURIComponent(query)}&page=${page}`,
    { signal }
  )
  if (!response.ok) throw new Error("Couldn't load movies")
  const data: { titles: string[]; next: number | null } = await response.json()
  return { items: data.titles, hasMore: data.next !== null }
}

export { loadMoviePages }
```

Pass `loadMoviePages` to `useAsyncOptions` in place of the inline loader above.

Pass `@onLoadMore` to Combobox, with a method that calls `this.movies.loadMore()`. Combobox asks for another page when scrolling or keyboard navigation reaches the last item. The helper appends the new items.

```glimmer-ts title="infinite.gts"
import Component from "@glimmer/component"
import { Check, ChevronDown } from "lucide"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "./icon"

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
            <c.Item @value={{item.value}} @label={{item.label}} @disabled={{item.disabled}} as |i|>
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
```

```glimmer-ts title="icon.ts"
import { createElement, type IconNode } from "lucide"

function icon(node: IconNode) {
  return createElement(node, { "aria-hidden": "true" })
}

export { icon }
```

Open the movie list and scroll down, or use Arrow Down to reach the last result. The next page is added to the list.

## Retry a Search

`status` is `"loading"` during a request, `"error"` after a failure, and `"idle"` otherwise. `error` holds the failure, and the previous items stay available.

Call `this.movies.reload()` from a retry button to load the current query again, starting at page `0`. `this.movies.state.hasMore` tells you whether another page is available.
