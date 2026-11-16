import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { useLog } from "../../../shared/ember/log"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
  "Cherry",
  "Grape",
  "Lemon",
  "Mango",
  "Orange",
  "Peach",
  "Pear",
  "Pineapple",
  "Strawberry",
]

export default class Controlled extends Component {
  log = useLog(this)
  @tracked value = ""
  @tracked open = false

  changeValue = (
    next: string,
    details: { reason: string; cancel: () => void }
  ) => {
    if (next.length > 12) {
      return details.cancel()
    }
    this.value = next
    this.log(`text: ${details.reason}`)
  }

  onOpenChange = (next: boolean, details: { reason: string }) => {
    this.open = next
    this.log(`${next ? "opened" : "closed"}: ${details.reason}`)
  }

  onOpenChangeComplete = (next: boolean) => {
    this.log(`${next ? "opened" : "closed"} and settled`)
  }

  onHighlight = (highlighted: string | null) => {
    if (highlighted) this.log(`highlighted ${highlighted}`)
  }

  <template>
    <div data-slot="stack">
      <Autocomplete
        @value={{this.value}}
        @open={{this.open}}
        @debug={{true}}
        @onValueChange={{this.changeValue}}
        @onOpenChange={{this.onOpenChange}}
        @onOpenChangeComplete={{this.onOpenChangeComplete}}
        @onHighlight={{this.onHighlight}}
        as |c|
      >
        <c.Label>Fruit (12 characters at most)</c.Label>
        <c.Input />
        <c.Content>
          <c.Empty>No fruits found.</c.Empty>
          <c.List>
            {{#each fruits key="@identity" as |fruit|}}
              <c.Item @value={{fruit}}>
                {{fruit}}
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Autocomplete>
    </div>
  </template>
}
