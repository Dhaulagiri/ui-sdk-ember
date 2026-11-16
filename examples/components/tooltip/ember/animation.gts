import Component from "@glimmer/component"
import { Archive } from "lucide"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Animation extends Component {
  log = useLog(this)

  onOpenChange = (open: boolean) => {
    this.log(open ? "Opening" : "Closing")
  }

  onOpenChangeComplete = (open: boolean) => {
    this.log(open ? "Open" : "Closed")
  }

  <template>
    <Tooltip
      @onOpenChange={{this.onOpenChange}}
      @onOpenChangeComplete={{this.onOpenChangeComplete}}
      as |t|
    >
      <t.Trigger aria-label="Archive">{{icon Archive}}</t.Trigger>
      <t.Content>Archive</t.Content>
    </Tooltip>
  </template>
}
