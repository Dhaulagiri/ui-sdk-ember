import Component from "@glimmer/component"
import { Dialog } from "ember-ui-sdk/dialog"
import { useLog } from "../../../shared/ember/log"

export default class Animation extends Component {
  log = useLog(this)

  onOpenChangeComplete = (open: boolean) => {
    this.log(open ? "Finished opening" : "Finished closing")
  }

  <template>
    <Dialog @onOpenChangeComplete={{this.onOpenChangeComplete}} as |d|>
      <d.Trigger>Slide In</d.Trigger>
      <d.Backdrop />
      <d.Content @keepMounted={{true}}>
        <div data-slot="stack">
          <d.Title>Slide and fade</d.Title>
          <d.Description>300ms in and out. Focus returns as soon as it starts
            closing.</d.Description>
        </div>
        <div data-slot="row">
          <d.Close data-variant="solid">Close</d.Close>
        </div>
      </d.Content>
    </Dialog>
  </template>
}
