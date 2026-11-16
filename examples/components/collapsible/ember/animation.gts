import Component from "@glimmer/component"
import { Collapsible } from "ember-ui-sdk/collapsible"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const notes = [
  "Search now matches file contents, not only names.",
  "Shared links remember the folder they were opened from.",
  "Uploads resume after the connection drops.",
]

export default class Animation extends Component {
  log = useLog(this)

  onOpenChangeComplete = (open: boolean) => {
    this.log(open ? "Finished opening" : "Finished closing")
  }

  <template>
    <Collapsible
      data-variant="card"
      @onOpenChangeComplete={{this.onOpenChangeComplete}}
      as |c|
    >
      <c.Trigger>
        <span data-slot="stack">
          <span>Release notes</span>
          <span data-slot="hint">Version 2.4, released October 28</span>
        </span>
        {{icon ChevronDown}}
      </c.Trigger>
      <c.Panel>
        <ul>
          {{#each notes key="@identity" as |note|}}
            <li>{{note}}</li>
          {{/each}}
        </ul>
      </c.Panel>
    </Collapsible>
  </template>
}
