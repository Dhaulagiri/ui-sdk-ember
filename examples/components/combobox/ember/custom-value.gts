import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const titles = [
  "Designer",
  "Engineer",
  "Engineering manager",
  "Product manager",
  "Researcher",
]

export default class CustomValue extends Component {
  log = useLog(this)
  @tracked value: string | null = null

  onValueChange = (next: string | null, details: { reason: string }) => {
    this.value = next
    this.log(`${next ? `“${next}”` : "No title"} (${details.reason})`)
  }

  <template>
    <Combobox
      @allowCustomValue={{true}}
      @value={{this.value}}
      @onValueChange={{this.onValueChange}}
      as |c|
    >
      <div data-slot="stack">
        <c.Label>Job title</c.Label>
        <c.Input placeholder="Type any title…" />
      </div>
      <c.Content>
        <c.Empty as |e|>
          Press Enter to use “{{e.state.query}}”.
        </c.Empty>
        <c.List>
          {{#each titles key="@identity" as |title|}}
            <c.Item @value={{title}} as |item|>
              {{title}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </c.Item>
          {{/each}}
        </c.List>
      </c.Content>
    </Combobox>
  </template>
}
