import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { CheckboxGroup } from "ember-ui-sdk/checkbox"
import { Check, Minus } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const people = [
  {
    id: "hollis",
    name: "Hollis Grant",
    email: "hollis@example.com",
    role: "Owner",
  },
  {
    id: "ines",
    name: "Inès Moreau",
    email: "ines@example.com",
    role: "Editor",
  },
  {
    id: "kofi",
    name: "Kofi Mensah",
    email: "kofi@example.com",
    role: "Viewer",
  },
  {
    id: "wren",
    name: "Wren Takahashi",
    email: "wren@example.com",
    role: "Editor",
  },
]

const ids = people.map((person) => person.id)

export default class Table extends Component {
  log = useLog(this)
  @tracked selected: string[] = ["hollis"]

  onValueChange = (next: string[]) => {
    this.selected = next
    this.log(`${next.length} of ${people.length} selected`)
  }

  <template>
    <CheckboxGroup
      @value={{this.selected}}
      @onValueChange={{this.onValueChange}}
      @allValues={{ids}}
      aria-label="Team members"
      as |g|
    >
      <table>
        <caption data-slot="visually-hidden">Team members</caption>
        <thead>
          <tr>
            <th>
              <g.Checkbox @parent={{true}} aria-label="Select all" as |c|>
                <c.Indicator>
                  {{icon Check}}
                  {{icon Minus}}
                </c.Indicator>
              </g.Checkbox>
            </th>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
          </tr>
        </thead>
        <tbody>
          {{#each people key="id" as |person|}}
            <tr>
              <td>
                <g.Checkbox
                  @value={{person.id}}
                  aria-label="Select {{person.name}}"
                  as |c|
                >
                  <c.Indicator>{{icon Check}}</c.Indicator>
                </g.Checkbox>
              </td>
              <td>{{person.name}}</td>
              <td>{{person.email}}</td>
              <td>{{person.role}}</td>
            </tr>
          {{/each}}
        </tbody>
      </table>
    </CheckboxGroup>
  </template>
}
