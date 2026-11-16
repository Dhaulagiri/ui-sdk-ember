import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import {
  CircleCheck,
  Info,
  LoaderCircle,
  OctagonX,
  TriangleAlert,
} from "lucide"
import { createToaster, ToastRegion } from "ember-ui-sdk/toast"
import { icon } from "../../../shared/ember/icon"

export default class Types extends Component {
  toast = createToaster()

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  upload = () => new Promise((resolve) => setTimeout(resolve, 2000))

  defaultToast = () => {
    this.toast("Event created")
  }

  successToast = () => {
    this.toast.success("Changes saved")
  }

  infoToast = () => {
    this.toast.info("A new version is available")
  }

  warningToast = () => {
    this.toast.warning("Storage is almost full")
  }

  errorToast = () => {
    this.toast.error("Couldn't save changes")
  }

  loadingToast = () => {
    this.toast.promise(this.upload, {
      loading: "Uploading photos…",
      success: "Photos uploaded",
      error: "Upload failed",
    })
  }

  <template>
    <div data-slot="row">
      <button type="button" {{on "click" this.defaultToast}}>Default</button>
      <button type="button" {{on "click" this.successToast}}>Success</button>
      <button type="button" {{on "click" this.infoToast}}>Info</button>
      <button type="button" {{on "click" this.warningToast}}>Warning</button>
      <button type="button" {{on "click" this.errorToast}}>Error</button>
      <button type="button" {{on "click" this.loadingToast}}>Loading</button>
    </div>
    <ToastRegion @toaster={{this.toast}} as |toast item t|>
      <t.Toast>
        <span data-show="success">{{icon CircleCheck}}</span>
        <span data-show="info">{{icon Info}}</span>
        <span data-show="warning">{{icon TriangleAlert}}</span>
        <span data-show="error">{{icon OctagonX}}</span>
        <span data-show="loading">{{icon LoaderCircle}}</span>
        <t.Title />
      </t.Toast>
    </ToastRegion>
  </template>
}
