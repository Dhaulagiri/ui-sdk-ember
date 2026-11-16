import Component from "@glimmer/component"
import { CornerDownLeft } from "lucide"
import { Command } from "ember-ui-sdk/command"
import { icon } from "../../../shared/ember/icon"

const pages = ["Composition", "Installation", "Styling"]

export default class CustomRendering extends Component {
  pages = pages

  hashOf = (page: string) => `#${page.toLowerCase()}`

  <template>
    <Command as |c|>
      <c.Input aria-label="Search docs" placeholder="Search docs…" />
      <c.List>
        {{#each this.pages key="@identity" as |page|}}
          <c.Item @value={{page}} @render={{true}} as |item|>
            <a {{item.part}} href={{this.hashOf page}}>
              <item.Text />
              {{#if item.state.highlighted}}{{icon CornerDownLeft}}{{/if}}
            </a>
          </c.Item>
        {{/each}}
      </c.List>
    </Command>
  </template>
}
