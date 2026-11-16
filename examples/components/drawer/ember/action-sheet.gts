import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Drawer, createDrawerController } from "ember-ui-sdk/drawer"
import { useLog } from "../../../shared/ember/log"

type PhotoAction = "share" | "duplicate" | "delete" | "cancel"

export default class ActionSheet extends Component {
  log = useLog(this)
  photoActions = createDrawerController<undefined, PhotoAction>()

  choose = async () => {
    const { returnValue = "cancel" } = await this.photoActions.open()
    this.log(returnValue === "cancel" ? "Canceled" : `Chose ${returnValue}`)
  }

  <template>
    <div data-slot="row">
      <button type="button" {{on "click" this.choose}}>Photo Options</button>
      <Drawer @controller={{this.photoActions}} as |d|>
        <d.Backdrop />
        <d.Content>
          <div data-slot="stack">
            <d.Title>Beach.jpg</d.Title>
            <d.Description>Taken today at 9:41.</d.Description>
          </div>
          <div data-slot="stack">
            <d.Close @value="share">Share</d.Close>
            <d.Close @value="duplicate">Duplicate</d.Close>
            <d.Close @value="delete">Delete</d.Close>
            <d.Close @value="cancel">Cancel</d.Close>
          </div>
        </d.Content>
      </Drawer>
    </div>
  </template>
}
