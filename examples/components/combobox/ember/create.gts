import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check, LoaderCircle, Plus, X } from "lucide"
import { Combobox } from "ember-ui-sdk/combobox"
import { icon } from "../../../shared/ember/icon"

function saveLabel(name: string) {
  return new Promise<void>((resolve, reject) =>
    setTimeout(
      () =>
        name.length > 20
          ? reject(new Error("Labels are 20 characters at most."))
          : resolve(),
      800
    )
  )
}

export default class Create extends Component {
  @tracked labels = [
    "Bug",
    "Feature",
    "Documentation",
    "Design",
    "Performance",
    "Security",
    "Testing",
  ]
  @tracked value: string[] = ["Bug"]

  create = async (query: string) => {
    await saveLabel(query)
    this.labels = [...this.labels, query]
    this.value = [...this.value, query]
  }

  onValueChange = (next: string[]) => {
    this.value = next
  }

  <template>
    <Combobox
      @value={{this.value}}
      @onValueChange={{this.onValueChange}}
      @multiple={{true}}
      as |c|
    >
      <div data-slot="stack">
        <c.Label>Labels</c.Label>
        <c.Chips>
          <c.Value as |state|>
            {{#each state.value key="@identity" as |label|}}
              <c.Chip @value={{label}} as |chip|>
                {{label}}
                <chip.Remove aria-label="Remove {{label}}">{{icon
                    X
                  }}</chip.Remove>
              </c.Chip>
            {{/each}}
          </c.Value>
          <c.Input placeholder="Add or create a label…" />
        </c.Chips>
      </div>
      <c.Content>
        <c.List>
          {{#each this.labels key="@identity" as |label|}}
            <c.Item @value={{label}} as |item|>
              {{label}}
              <item.Indicator>{{icon Check}}</item.Indicator>
            </c.Item>
          {{/each}}
          <c.Create @minLength={{2}} @onCreate={{this.create}} as |cr|>
            {{#if cr.state.pending}}
              <span data-slot="spinner">{{icon LoaderCircle}}</span>
              Creating “{{cr.state.query}}”…
            {{else}}
              {{icon Plus}}
              <span data-slot="stack">
                Create “{{cr.state.query}}”
                {{#if cr.state.error}}<span
                    data-slot="hint"
                  >{{cr.state.error.message}}</span>{{/if}}
              </span>
            {{/if}}
          </c.Create>
        </c.List>
      </c.Content>
    </Combobox>
  </template>
}
