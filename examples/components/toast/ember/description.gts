import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"

export default class Description extends Component {
  toast = createToaster()

  showToast = () => {
    this.toast({
      title: "Event has been created",
      description: "Monday, January 3rd at 6:00pm",
    })
  }

  <template>
    <button type="button" {{on "click" this.showToast}}>
      Show toast
    </button>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <div data-slot="stack">
          <t.Title />
          <t.Description />
        </div>
      </t.Toast>
    </ToastRegion>
  </template>
}
