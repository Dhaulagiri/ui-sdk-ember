import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Check } from "lucide"
import { Checkbox } from "ember-ui-sdk/checkbox"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { icon } from "../../../shared/ember/icon"

const notifications = [
  { title: "Event created", description: "Friday, June 12 at 10:00 AM" },
  { title: "Message sent" },
  {
    title: "Hollis Grant joined",
    description: "They can now edit the Launch plan and see its comments.",
  },
  { title: "Changes saved" },
  { title: "Invoice sent", description: "Inès Moreau · $240.00" },
  { title: "Photos uploaded", description: "12 photos added to Summer trip" },
]

export default class Stacking extends Component {
  toast = createToaster()
  count = 0
  @tracked expanded = false

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  onCheckedChange = (next: boolean | "indeterminate") => {
    this.expanded = next === true
  }

  addToast = () => {
    this.toast(notifications[this.count++ % notifications.length])
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <label data-slot="label">
          <Checkbox
            @checked={{this.expanded}}
            @onCheckedChange={{this.onCheckedChange}}
            as |c|
          >
            <c.Indicator>{{icon Check}}</c.Indicator>
          </Checkbox>
          Always expanded
        </label>
      </div>
      <button type="button" {{on "click" this.addToast}}>Add Toast</button>
      <ToastRegion
        @toaster={{this.toast}}
        @maxVisible={{4}}
        @expanded={{this.expanded}}
        as |toast item t|
      >
        <t.Toast>
          <div data-slot="stack">
            <t.Title />
            <t.Description />
          </div>
        </t.Toast>
      </ToastRegion>
    </div>
  </template>
}
