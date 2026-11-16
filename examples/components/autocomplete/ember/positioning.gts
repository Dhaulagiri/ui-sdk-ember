import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { attach } from "ember-ui-sdk/primitive"

const fruits = [
  "Apple",
  "Apricot",
  "Avocado",
  "Banana",
  "Blackberry",
  "Blueberry",
]

export default class Positioning extends Component {
  fruits = fruits
  @tracked box: HTMLElement | null = null

  setBox = (element: HTMLElement) => {
    this.box = element
  }

  <template>
    <div {{attach this.setBox}} data-slot="card">
      <Autocomplete @modal="pointer" @container={{this.box}} as |c|>
        <div data-slot="stack">
          <c.Label>Fruit</c.Label>
          <c.Input />
        </div>
        <c.Content
          @side="top"
          @align="end"
          @sideOffset={{10}}
          @alignOffset={{-4}}
          @collisionPadding={{8}}
          @anchor={{this.box}}
          @keepMounted={{true}}
        >
          <c.Empty>No fruits found.</c.Empty>
          <c.List>
            {{#each this.fruits key="@identity" as |fruit|}}
              <c.Item @value={{fruit}}>{{fruit}}</c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Autocomplete>
    </div>
  </template>
}
