import Component from "@glimmer/component"
import { Button } from "ember-ui-sdk/button"

const wait = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms))

export default class Pending extends Component {
  save = () => wait(1500)

  <template>
    <Button @onClick={{this.save}} @pendingAnnouncement="Saving">Save</Button>
  </template>
}
