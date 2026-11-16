import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ArrowLeft, Moon, Users } from "lucide"
import { Command, createCommandController } from "ember-ui-sdk/command"
import { icon } from "../../../shared/ember/icon"

const themes = [
  { value: "light", label: "Light" },
  { value: "dark", label: "Dark" },
  { value: "system", label: "System" },
]

const teams = [
  { value: "design", label: "Design" },
  { value: "engineering", label: "Engineering" },
  { value: "marketing", label: "Marketing" },
]

export default class Pages extends Component {
  command = createCommandController()
  themes = themes
  teams = teams
  @tracked pages: string[] = []

  get hasPages() {
    return this.pages.length > 0
  }

  get placeholder() {
    return this.pages.length
      ? "Search… (Backspace to go back)"
      : "What do you need?"
  }

  onPagesChange = (next: string[]) => {
    this.pages = next
  }

  onAction = (value: string) => {
    if (value === "back") {
      this.command.pop()
    }
  }

  <template>
    <Command
      @pages={{this.pages}}
      @onPagesChange={{this.onPagesChange}}
      @controller={{this.command}}
      @onAction={{this.onAction}}
      as |c|
    >
      <div data-slot="row">
        {{#each this.pages key="@identity" as |page|}}
          <span data-slot="badge">{{page}}</span>
        {{/each}}
      </div>
      <c.Input aria-label="Search commands" placeholder={{this.placeholder}} />
      <c.Empty>No results found.</c.Empty>
      <c.List>
        <c.Page as |p|>
          <p.Group as |g|>
            <g.Label>Workspace</g.Label>
            <g.Item @value="theme" @page="theme" as |item|>
              <item.Icon>{{icon Moon}}</item.Icon>
              Change theme…
            </g.Item>
            <g.Item @value="teams" @page="teams" as |item|>
              <item.Icon>{{icon Users}}</item.Icon>
              Switch team…
            </g.Item>
          </p.Group>
        </c.Page>
        <c.Page @value="theme" as |p|>
          {{#each this.themes key="value" as |theme|}}
            <p.Item @value={{theme.value}}>
              {{theme.label}}
            </p.Item>
          {{/each}}
        </c.Page>
        <c.Page @value="teams" as |p|>
          {{#each this.teams key="value" as |team|}}
            <p.Item @value={{team.value}}>
              {{team.label}}
            </p.Item>
          {{/each}}
        </c.Page>
        {{#if this.hasPages}}
          <c.Item @value="back" as |item|>
            <item.Icon @mirror={{true}}>{{icon ArrowLeft}}</item.Icon>
            Go back
          </c.Item>
        {{/if}}
      </c.List>
    </Command>
  </template>
}
