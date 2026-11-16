import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import { Progress } from "ember-ui-sdk/progress"
import { useLog } from "../../../shared/ember/log"

const total = 5

export default class Controlled extends Component {
  log = useLog(this)
  @tracked uploaded = 1

  get done() {
    return this.uploaded >= total
  }

  get doneText() {
    return String(this.done)
  }

  get percent() {
    return (this.uploaded / total) * 100
  }

  uploadNext = () => {
    if (this.uploaded >= total) {
      return
    }
    this.uploaded++
    this.log(`Uploaded ${this.uploaded} of ${total} photos`)
  }

  reset = () => {
    this.uploaded = 0
    this.log("Reset to 0 photos")
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button
          type="button"
          aria-disabled={{this.doneText}}
          {{on "click" this.uploadNext}}
        >Upload Next</button>
        <button type="button" {{on "click" this.reset}}>Reset</button>
      </div>
      <Progress @value={{this.percent}} as |p|>
        <p.Label>Uploading photos</p.Label>
        <p.Value />
        <p.Track>
          <p.Indicator />
        </p.Track>
      </Progress>
    </div>
  </template>
}
