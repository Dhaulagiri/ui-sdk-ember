import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { useLog } from "../../../shared/ember/log"

export default class Action extends Component {
  log = useLog(this)
  toast = createToaster()

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  archive = () => {
    this.toast("Message archived", {
      action: { label: "Undo", onAction: () => this.log("Message restored") },
      cancel: { label: "Dismiss", onCancel: () => this.log("Kept archived") },
      onDismiss: ({ reason }) => this.log(`Closed (${reason})`),
    })
  }

  <template>
    <button type="button" {{on "click" this.archive}}>
      Archive Message
    </button>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <t.Title />
        {{#if toast.cancel}}
          <t.Close
            @action={{toast.cancel.onCancel}}
          >{{toast.cancel.label}}</t.Close>
        {{/if}}
        <t.Action data-variant="solid" />
      </t.Toast>
    </ToastRegion>
  </template>
}
