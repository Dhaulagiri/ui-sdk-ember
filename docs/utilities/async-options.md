---
title: Async Options
description: Load search results, cancel stale requests, and fetch the next page.
---

`useAsyncOptions` loads items as someone types. It waits for typing to pause, cancels requests that are replaced, and keeps the previous results visible while loading.

[combobox/async](../../examples/components/combobox/ember/async.gts)

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

| Option      | What It Does                                                                    | Default |
| ----------- | ------------------------------------------------------------------------------- | ------- |
| `debounce`  | Milliseconds typing must pause before a request starts.                         | `200`   |
| `query`     | The starting search text.                                                       | `""`    |
| `immediate` | Loads that text as soon as the component mounts.                                | `false` |
| `minLength` | Characters the text needs before anything loads. Shorter text clears the items. | `0`     |

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

[combobox/infinite](../../examples/components/combobox/ember/infinite.gts)

Open the movie list and scroll down, or use Arrow Down to reach the last result. The next page is added to the list.

## Retry a Search

`status` is `"loading"` during a request, `"error"` after a failure, and `"idle"` otherwise. `error` holds the failure, and the previous items stay available.

Call `this.movies.reload()` from a retry button to load the current query again, starting at page `0`. `this.movies.state.hasMore` tells you whether another page is available.
