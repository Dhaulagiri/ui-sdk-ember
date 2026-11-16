import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { useLog } from "../../../shared/ember/log"

export default class Shortcut extends Component {
  log = useLog(this)
  toast = createToaster({ duration: 10000 })

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  sendMessage = () => {
    this.toast("Message sent", {
      action: { label: "Undo", onAction: () => this.log("Message unsent") },
    })
  }

  <template>
    <button type="button" {{on "click" this.sendMessage}}>
      Send Message
    </button>
    <ToastRegion
      @toaster={{this.toast}}
      @shortcut="alt+t"
      aria-label="Alerts"
      as |toast item t|
    >
      <t.Toast>
        <t.Title />
        <t.Action data-variant="solid" />
      </t.Toast>
    </ToastRegion>
  </template>
}
