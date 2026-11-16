import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { Check, MessageSquare } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Link extends Component {
  log = useLog(this)

  follow = (event: MouseEvent) => {
    if (
      event.button !== 0 ||
      event.metaKey ||
      event.ctrlKey ||
      event.shiftKey ||
      event.altKey
    ) {
      return
    }
    event.preventDefault()
    this.log(`Opened ${(event.currentTarget as HTMLAnchorElement).textContent}`)
  }

  <template>
    <Toolbar aria-label="Pull request" as |t|>
      <t.Button
        aria-label="Approve"
        {{on "click" (fn this.log "Approved")}}
      >{{icon Check}}</t.Button>
      <t.Button
        aria-label="Comment"
        {{on "click" (fn this.log "Comment")}}
      >{{icon MessageSquare}}</t.Button>
      <t.Separator />
      <t.Link href="#files" {{on "click" this.follow}}>Files Changed</t.Link>
      <t.Link href="#checks" {{on "click" this.follow}}>Checks</t.Link>
    </Toolbar>
  </template>
}
