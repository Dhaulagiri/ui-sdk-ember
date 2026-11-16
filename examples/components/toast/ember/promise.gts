import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"

export default class PromiseExample extends Component {
  toast = createToaster()
  attempts = 0

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  save = () => {
    const succeeds = ++this.attempts % 2 === 1
    return new Promise<void>((resolve, reject) =>
      setTimeout(
        () => (succeeds ? resolve() : reject(new Error("Network error"))),
        1500
      )
    )
  }

  saveChanges = () => {
    this.toast.promise(this.save, {
      loading: "Saving changes…",
      success: "Changes saved",
      error: {
        title: "Couldn't save changes",
        description: "Check your connection and try again.",
        action: { label: "Retry", onAction: this.saveChanges },
      },
    })
  }

  <template>
    <button type="button" {{on "click" this.saveChanges}}>Save Changes</button>
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
