import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Command } from "ember-ui-sdk/command"
import { useLog } from "../../../shared/ember/log"

const themes = [
  { value: "light", label: "Light" },
  { value: "dark", label: "Dark" },
  { value: "system", label: "System" },
]

export default class Controlled extends Component {
  log = useLog(this)
  themes = themes
  @tracked value: string | null = "dark"
  @tracked query = ""
  @tracked pages = ["theme"]

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    this.log(`Highlighted ${next ?? "nothing"} (${details.reason})`)
  }

  onQueryChange = (next: string, details: { reason: string }) => {
    this.query = next
    this.log(`Query “${next}” (${details.reason})`)
  }

  onPagesChange = (next: string[], details: { reason: string }) => {
    this.pages = next
    this.log(`Pages [${next.join(", ")}] (${details.reason})`)
  }

  onAction = (next: string) => {
    this.log(`Ran ${next}`)
  }

  <template>
    <Command
      @value={{this.value}}
      @onValueChange={{this.onValueChange}}
      @query={{this.query}}
      @onQueryChange={{this.onQueryChange}}
      @pages={{this.pages}}
      @onPagesChange={{this.onPagesChange}}
      @onAction={{this.onAction}}
      as |c|
    >
      <c.Input aria-label="Search themes" placeholder="Search themes…" />
      <c.List>
        <c.Page as |p|>
          <p.Item @value="theme" @page="theme">Change theme…</p.Item>
        </c.Page>
        <c.Page @value="theme" as |p|>
          {{#each this.themes key="value" as |theme|}}
            <p.Item @value={{theme.value}}>
              {{theme.label}}
            </p.Item>
          {{/each}}
        </c.Page>
      </c.List>
    </Command>
  </template>
}
