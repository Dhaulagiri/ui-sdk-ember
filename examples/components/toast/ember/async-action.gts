import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { useLog } from "../../../shared/ember/log"

const wait = (ms: number) =>
  new Promise<void>((resolve) => setTimeout(resolve, ms))

export default class AsyncAction extends Component {
  log = useLog(this)
  toast = createToaster({ duration: 6000 })

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  deleteFile = () => {
    this.toast("File deleted", {
      description: "Q3 report.pdf",
      action: {
        label: "Undo",
        onAction: async () => {
          await wait(1500)
          this.log("Q3 report.pdf restored")
        },
      },
    })
  }

  <template>
    <button type="button" {{on "click" this.deleteFile}}>
      Delete File
    </button>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <div data-slot="stack">
          <t.Title />
          <t.Description />
        </div>
        <t.Action data-variant="solid" as |action|>
          {{#if action.state.pending}}Restoring…{{else if
            action.state.error
          }}Retry{{else}}Undo{{/if}}
        </t.Action>
      </t.Toast>
    </ToastRegion>
  </template>
}
