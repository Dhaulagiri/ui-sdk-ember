import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import {
  Collapsible,
  createCollapsibleController,
} from "ember-ui-sdk/collapsible"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const recoveryCodes = ["7KQ2-M9XD", "P4TR-8HZC", "W3NB-6JUE", "C5YF-2LSA"]

export default class Controlled extends Component {
  log = useLog(this)
  collapsible = createCollapsibleController()
  @tracked open = false

  toggle = () => this.collapsible.toggle()
  close = () => this.collapsible.close()

  onOpenChange = (next: boolean, details: { reason: string }) => {
    this.open = next
    this.log(`${next ? "Opened" : "Closed"} (${details.reason})`)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.toggle}}>Toggle</button>
      </div>
      <Collapsible
        data-variant="card"
        @open={{this.open}}
        @controller={{this.collapsible}}
        @onOpenChange={{this.onOpenChange}}
        as |c|
      >
        <c.Trigger>
          <span data-slot="stack">
            <span>Recovery codes</span>
            <span data-slot="hint">Each code signs you in once</span>
          </span>
          {{icon ChevronDown}}
        </c.Trigger>
        <c.Panel>
          <div data-slot="stack">
            <ul>
              {{#each recoveryCodes key="@identity" as |code|}}
                <li>{{code}}</li>
              {{/each}}
            </ul>
            <button type="button" {{on "click" this.close}}>Done</button>
          </div>
        </c.Panel>
      </Collapsible>
    </div>
  </template>
}
