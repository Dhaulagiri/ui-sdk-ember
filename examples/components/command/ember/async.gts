import Component from "@glimmer/component"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Command } from "ember-ui-sdk/command"

function searchIssues(query: string, { signal }: { signal: AbortSignal }) {
  const issues = [
    "Fix login redirect",
    "Dark mode flicker",
    "Add billing page",
    "Search is slow",
    "Update dependencies",
    "Crash on upload",
    "Export to CSV",
    "Keyboard shortcuts help",
  ]
  return new Promise<{ value: string; label: string }[]>((resolve, reject) => {
    const timer = setTimeout(() => {
      const needle = query.trim().toLowerCase()
      resolve(
        issues
          .filter((issue) => issue.toLowerCase().includes(needle))
          .map((issue) => ({
            value: issue.toLowerCase().replaceAll(" ", "-"),
            label: issue,
          }))
      )
    }, 400)
    signal.addEventListener("abort", () => {
      clearTimeout(timer)
      reject(new DOMException("Aborted", "AbortError"))
    })
  })
}

export default class Async extends Component {
  issues = useAsyncOptions(this, searchIssues, {
    debounce: 250,
    immediate: true,
  })

  onQueryChange = (query: string) => {
    this.issues.setQuery(query)
  }

  statusText = (state: { loading: boolean; count: number }) =>
    state.loading
      ? "Searching…"
      : `${state.count} ${state.count === 1 ? "issue" : "issues"}`

  <template>
    <Command
      @filter={{false}}
      @status={{this.issues.state.status}}
      @onQueryChange={{this.onQueryChange}}
      @onLoadMore={{this.issues.loadMore}}
      as |c|
    >
      <c.Input aria-label="Search issues" placeholder="Search issues…" />
      <c.Status as |s|>{{this.statusText s.state}}</c.Status>
      <c.Empty as |e|>
        {{#unless e.state.loading}}No issues match “{{e.state.query}}”.{{/unless}}
      </c.Empty>
      <c.List>
        {{#each this.issues.state.items key="value" as |issue|}}
          <c.Item @value={{issue.value}} @label={{issue.label}}>
            {{issue.label}}
          </c.Item>
        {{/each}}
      </c.List>
    </Command>
  </template>
}
