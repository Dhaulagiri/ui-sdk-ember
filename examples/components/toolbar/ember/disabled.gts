import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { useLog } from "../../../shared/ember/log"

export default class Disabled extends Component {
  log = useLog(this)

  <template>
    <Toolbar aria-label="Message" as |t|>
      <t.Button {{on "click" (fn this.log "Reply")}}>Reply</t.Button>
      <t.Button
        @disabled={{true}}
        {{on "click" (fn this.log "Archive")}}
      >Archive</t.Button>
      <t.Button
        @disabled={{true}}
        @focusableWhenDisabled={{false}}
        {{on "click" (fn this.log "Delete")}}
      >Delete</t.Button>
    </Toolbar>
  </template>
}
