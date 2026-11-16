import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { CircleCheck, LoaderCircle } from "lucide"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Update extends Component {
  log = useLog(this)
  toast = createToaster()
  timer?: ReturnType<typeof setInterval>

  willDestroy() {
    super.willDestroy()
    clearInterval(this.timer)
    this.toast.dismiss()
  }

  upload = () => {
    clearInterval(this.timer)
    const id = this.toast.loading("Uploading report.pdf… 0%", { id: "upload" })
    let progress = 0
    this.timer = setInterval(() => {
      progress += 20
      const done = progress >= 100
      const open = this.toast.update(
        id,
        done
          ? { title: "Report uploaded", type: "success" }
          : { title: `Uploading report.pdf… ${progress}%` }
      )
      if (!open) {
        this.log("Upload canceled")
      }
      if (done || !open) {
        clearInterval(this.timer)
      }
    }, 700)
  }

  cancelUpload = () => {
    this.toast.dismiss("upload")
  }

  dismissAll = () => {
    this.toast.dismiss()
  }

  <template>
    <div data-slot="row">
      <button type="button" {{on "click" this.upload}}>Upload Report</button>
      <button type="button" {{on "click" this.cancelUpload}}>Cancel Upload</button>
      <button type="button" {{on "click" this.dismissAll}}>Dismiss All</button>
    </div>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <span data-show="success">{{icon CircleCheck}}</span>
        <span data-show="loading">{{icon LoaderCircle}}</span>
        <t.Title />
      </t.Toast>
    </ToastRegion>
  </template>
}
