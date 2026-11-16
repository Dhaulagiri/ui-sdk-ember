import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { confirm } from "ember-ui-sdk/alert-dialog"
import { OverlayHost } from "ember-ui-sdk/overlays"
import { useLog } from "../../../shared/ember/log"

export default class ConfirmAnywhere extends Component {
  log = useLog(this)

  archive = async () => {
    const yes = await confirm({
      title: "Archive this project?",
      description: "It moves to Archived, and you can restore it anytime.",
      confirmLabel: "Archive",
    })
    this.log(yes ? "Archived the project" : "Kept the project")
  }

  <template>
    <button type="button" {{on "click" this.archive}}>Archive Project</button>
    <OverlayHost />
  </template>
}
