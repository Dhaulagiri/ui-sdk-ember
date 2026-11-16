import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { useLog } from "../../../shared/ember/log"

export default class Demo extends Component {
  log = useLog(this)
  toast = createToaster()

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  createEvent = () => {
    this.toast("Event created", {
      description: "Friday, June 12 at 10:00 AM",
      action: { label: "Undo", onAction: () => this.log("Event removed") },
    })
  }

  <template>
    <button type="button" {{on "click" this.createEvent}}>
      Create Event
    </button>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <div data-slot="stack">
          <t.Title />
          <t.Description />
        </div>
        <t.Action data-variant="solid" />
      </t.Toast>
    </ToastRegion>
  </template>
}
