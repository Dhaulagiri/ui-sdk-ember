import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { registerDestructor } from "@ember/destroyable"
import { Save } from "lucide"
import { on } from "@ember/modifier"
import { registerShortcut } from "@ui-sdk/core/shortcuts"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Shortcut extends Component {
  log = useLog(this)

  constructor(owner: Owner, args: object) {
    super(owner, args)
    const offSave = registerShortcut("mod+s", () => this.log("Saved"))
    const offShare = registerShortcut("mod+shift+e", () => this.log("Shared"))
    registerDestructor(this, () => {
      offSave()
      offShare()
    })
  }

  saved = () => {
    this.log("Saved")
  }

  shared = () => {
    this.log("Shared")
  }

  <template>
    <div data-slot="row">
      <Tooltip @shortcut="mod+s" as |t|>
        <t.Trigger aria-label="Save" {{on "click" this.saved}}>{{icon
            Save
          }}</t.Trigger>
        <t.Content>
          Save
          <t.Shortcut />
        </t.Content>
      </Tooltip>
      <Tooltip @shortcut="mod+shift+e" as |t|>
        <t.Trigger {{on "click" this.shared}}>Share</t.Trigger>
        <t.Content>
          Share with your team
          <t.Shortcut />
        </t.Content>
      </Tooltip>
    </div>
  </template>
}
