import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { AlertDialog } from "ember-ui-sdk/alert-dialog"

export default class Nested extends Component {
  @tracked open = false

  onOpenChange = (next: boolean) => {
    this.open = next
  }

  onNestedOpenChange = (next: boolean, details: { returnValue?: string }) => {
    if (!next && details.returnValue === "confirm") {
      this.open = false
    }
  }

  <template>
    <AlertDialog @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |d|>
      <d.Trigger>Delete Workspace</d.Trigger>
      <d.Backdrop />
      <d.Content>
        <div data-slot="stack">
          <d.Title>Delete this workspace?</d.Title>
          <d.Description>
            All 12 projects and their deployments will be deleted for everyone
            on your team.
          </d.Description>
        </div>
        <div data-slot="row">
          <d.Close>Cancel</d.Close>
          <AlertDialog @onOpenChange={{this.onNestedOpenChange}} as |inner|>
            <inner.Trigger data-variant="solid">Delete</inner.Trigger>
            <inner.Backdrop />
            <inner.Content>
              <div data-slot="stack">
                <inner.Title>Are you absolutely sure?</inner.Title>
                <inner.Description>There's no way to get the workspace back.</inner.Description>
              </div>
              <div data-slot="row">
                <inner.Close>Go Back</inner.Close>
                <inner.Close data-variant="solid" @value="confirm">Delete
                  Workspace</inner.Close>
              </div>
            </inner.Content>
          </AlertDialog>
        </div>
      </d.Content>
    </AlertDialog>
  </template>
}
