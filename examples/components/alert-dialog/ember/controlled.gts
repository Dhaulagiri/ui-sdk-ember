import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { AlertDialog } from "ember-ui-sdk/alert-dialog"

export default class Controlled extends Component {
  @tracked open = false

  onOpenChange = (next: boolean) => {
    this.open = next
  }

  <template>
    <div data-slot="stack">
      <AlertDialog
        @open={{this.open}}
        @onOpenChange={{this.onOpenChange}}
        as |d|
      >
        <d.Trigger>Review Changes</d.Trigger>
        <d.Backdrop />
        <d.Content>
          <div data-slot="stack">
            <d.Title>Discard unsaved changes?</d.Title>
            <d.Description>Your edits will be lost if you leave without saving.</d.Description>
          </div>
          <div data-slot="row">
            <d.Close>Keep Editing</d.Close>
            <d.Close data-variant="solid" @value="confirm">Discard</d.Close>
          </div>
        </d.Content>
      </AlertDialog>
    </div>
  </template>
}
