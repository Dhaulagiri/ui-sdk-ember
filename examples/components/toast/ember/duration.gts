import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"

export default class Duration extends Component {
  toast = createToaster()

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  oneSecond = () => {
    this.toast("Link copied", { duration: 1000 })
  }

  fiveSeconds = () => {
    this.toast("Changes saved")
  }

  untilDismissed = () => {
    this.toast("Your session expires in 5 minutes", {
      duration: Infinity,
      dismissible: false,
      cancel: { label: "Got It" },
    })
  }

  <template>
    <div data-slot="row">
      <button type="button" {{on "click" this.oneSecond}}>1 Second</button>
      <button type="button" {{on "click" this.fiveSeconds}}>5 Seconds</button>
      <button type="button" {{on "click" this.untilDismissed}}>
        Until Dismissed
      </button>
    </div>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <t.Title />
        {{#if toast.cancel}}
          <t.Close data-variant="solid" @action={{toast.cancel.onCancel}}>
            {{toast.cancel.label}}
          </t.Close>
        {{/if}}
      </t.Toast>
    </ToastRegion>
  </template>
}
