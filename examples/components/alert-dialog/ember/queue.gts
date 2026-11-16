import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { AlertDialog, createConfirm } from "ember-ui-sdk/alert-dialog"
import { useLog } from "../../../shared/ember/log"

export default class Queue extends Component {
  log = useLog(this)
  confirm = createConfirm<{ name: string }>()

  review = async () => {
    const acme = this.confirm({ name: "Acme" })
    const globex = this.confirm({ name: "Globex" })
    const [first, second] = await Promise.all([acme, globex])
    this.log(`Acme: ${first ? "confirmed" : "canceled"}`)
    this.log(`Globex: ${second ? "confirmed" : "canceled"}`)
  }

  <template>
    <div data-slot="stack">
      <button type="button" {{on "click" this.review}}>Review Two Projects</button>
      <AlertDialog @controller={{this.confirm.controller}} as |d|>
        <d.Backdrop />
        <d.Content as |content|>
          <div data-slot="stack">
            <d.Title>Archive {{content.state.payload.name}}?</d.Title>
            <d.Description>
              Archived projects leave the active list. You can restore them
              later.
            </d.Description>
          </div>
          <div data-slot="row">
            <d.Close>Cancel</d.Close>
            <d.Close data-variant="solid" @value="confirm">Archive</d.Close>
          </div>
        </d.Content>
      </AlertDialog>
    </div>
  </template>
}
