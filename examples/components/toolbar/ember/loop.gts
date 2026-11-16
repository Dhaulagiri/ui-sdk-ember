import Component from "@glimmer/component"
import { concat, fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { useLog } from "../../../shared/ember/log"

const labels = ["First", "Previous", "Next", "Last"]

export default class Loop extends Component {
  log = useLog(this)

  <template>
    <Toolbar @loop={{false}} aria-label="Pages" as |t|>
      {{#each labels key="@identity" as |label|}}
        <t.Button
          {{on "click" (fn this.log (concat label " page"))}}
        >{{label}}</t.Button>
      {{/each}}
    </Toolbar>
  </template>
}
