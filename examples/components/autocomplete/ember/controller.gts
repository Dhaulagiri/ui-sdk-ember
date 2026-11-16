import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import {
  Autocomplete,
  createAutocompleteController,
} from "ember-ui-sdk/autocomplete"

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

export default class Controller extends Component {
  fruit = createAutocompleteController()

  openList = () => {
    this.fruit.open()
  }

  typePea = () => {
    this.fruit.setValue("Pea")
  }

  clearFruit = () => {
    this.fruit.clear()
  }

  focusFruit = () => {
    this.fruit.focus()
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" data-size="sm" {{on "click" this.openList}}>
          Open
        </button>
        <button type="button" data-size="sm" {{on "click" this.typePea}}>
          Type “Pea”
        </button>
        <button type="button" data-size="sm" {{on "click" this.clearFruit}}>
          Clear
        </button>
        <button type="button" data-size="sm" {{on "click" this.focusFruit}}>
          Focus
        </button>
      </div>
      <Autocomplete @controller={{this.fruit}} as |c|>
        <c.Label>Fruit</c.Label>
        <c.Input />
        <c.Content>
          <c.Empty>No fruits found.</c.Empty>
          <c.List>
            {{#each fruits key="@identity" as |item|}}
              <c.Item @value={{item}}>
                {{item}}
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Autocomplete>
    </div>
  </template>
}
