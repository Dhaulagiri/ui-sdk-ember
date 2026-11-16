import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Command, createCommandController } from "ember-ui-sdk/command"
import { useLog } from "../../../shared/ember/log"

const themes = [
  { value: "light", label: "Light" },
  { value: "dark", label: "Dark" },
  { value: "system", label: "System" },
]

export default class Controller extends Component {
  log = useLog(this)
  palette = createCommandController()
  themes = themes

  openThemes = () => {
    this.palette.push("theme")
  }

  back = () => {
    this.palette.pop()
  }

  highlightDark = () => {
    this.palette.setValue("dark")
  }

  searchLi = () => {
    this.palette.setQuery("li")
  }

  runHighlighted = () => {
    this.palette.run()
  }

  focus = () => {
    this.palette.focus()
  }

  onAction = (value: string) => {
    this.log(`Ran ${value}`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.openThemes}}>
          Open Themes
        </button>
        <button type="button" {{on "click" this.back}}> Back </button>
        <button type="button" {{on "click" this.highlightDark}}>
          Highlight Dark
        </button>
        <button type="button" {{on "click" this.searchLi}}>
          Search “li”
        </button>
        <button type="button" {{on "click" this.runHighlighted}}>
          Run Highlighted
        </button>
        <button type="button" {{on "click" this.focus}}> Focus </button>
      </div>
      <Command @controller={{this.palette}} @onAction={{this.onAction}} as |c|>
        <c.Input aria-label="Search commands" />
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
    </div>
  </template>
}
