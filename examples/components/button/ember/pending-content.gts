import Component from "@glimmer/component"
import { Button } from "ember-ui-sdk/button"
import { ArrowDownToLine, LoaderCircle } from "lucide"
import { icon } from "../../../shared/ember/icon"

const wait = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms))

export default class PendingContent extends Component {
  save = () => wait(1500)

  <template>
    <Button @onClick={{this.save}} @pendingAnnouncement="Saving">
      <span data-show="idle">{{icon ArrowDownToLine}}</span>
      <span data-show="pending" data-slot="spinner">{{icon LoaderCircle}}</span>
      Save
    </Button>
  </template>
}
