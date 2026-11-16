import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { X } from "lucide"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Custom extends Component {
  log = useLog(this)
  toast = createToaster()

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  newMessage = () => {
    this.toast({
      title: "Hollis Grant",
      description: "Can you review the draft?",
      data: { initials: "HG" },
      action: {
        label: "Reply",
        onAction: () => this.log("Replying to Hollis Grant"),
      },
    })
  }

  inertOf = (state: { leaving: boolean; expanded: boolean; index: number }) =>
    state.leaving || (!state.expanded && state.index > 0) ? true : undefined

  <template>
    <button type="button" {{on "click" this.newMessage}}>
      New Message
    </button>
    <ToastRegion
      @toaster={{this.toast}}
      aria-label="Messages"
      as |toast item t|
    >
      <t.Toast @render={{true}} as |p|>
        <li {{p.part}} inert={{this.inertOf p.state}}>
          <span data-slot="media">{{toast.data.initials}}</span>
          <div data-slot="stack">
            <t.Title />
            <t.Description />
          </div>
          <t.Action data-variant="solid" />
          <t.Close aria-label="Close">{{icon X}}</t.Close>
        </li>
      </t.Toast>
    </ToastRegion>
  </template>
}
