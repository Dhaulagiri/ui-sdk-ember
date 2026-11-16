import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"

export default class Link extends Component {
  toast = createToaster()

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  sendInvoice = () => {
    this.toast("Invoice sent", {
      description: "Hollis Grant · $240.00",
      action: { label: "View", href: "#" },
    })
  }

  <template>
    <button type="button" {{on "click" this.sendInvoice}}>
      Send Invoice
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
