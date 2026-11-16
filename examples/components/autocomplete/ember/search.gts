import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { useLog } from "../../../shared/ember/log"

const recent = ["react hooks", "tailwind grid", "web components", "vue v-model"]

export default class Search extends Component {
  log = useLog(this)

  preventSubmit = (event: SubmitEvent) => {
    event.preventDefault()
  }

  submitted = (value: string) => {
    this.log(`Searched “${value}”`)
  }

  <template>
    <form role="search" data-slot="stack" {{on "submit" this.preventSubmit}}>
      <Autocomplete
        @submitOnSelect={{true}}
        @name="q"
        @onSubmit={{this.submitted}}
        as |c|
      >
        <c.Input type="search" aria-label="Search" placeholder="Search…" />
        <c.Content>
          <c.Empty>No results.</c.Empty>
          <c.List>
            {{#each recent key="@identity" as |search|}}
              <c.Item @value={{search}}>
                {{search}}
              </c.Item>
            {{/each}}
          </c.List>
        </c.Content>
      </Autocomplete>
    </form>
  </template>
}
