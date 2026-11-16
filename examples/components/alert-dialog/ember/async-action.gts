import Component from "@glimmer/component"
import { AlertDialog } from "ember-ui-sdk/alert-dialog"

export default class AsyncAction extends Component {
  attempts = 0

  deleteProject = async () => {
    await new Promise((resolve) => setTimeout(resolve, 1200))
    if (this.attempts++ === 0) {
      throw new Error("Couldn't delete the project.")
    }
  }

  <template>
    <div data-slot="stack">
      <AlertDialog @pendingAnnouncement="Deleting project" as |d|>
        <d.Trigger>Delete Project</d.Trigger>
        <d.Backdrop />
        <d.Content>
          <div data-slot="stack">
            <d.Title>Delete project?</d.Title>
            <d.Description>
              This permanently deletes the project, its files and its deployment
              history for everyone on your team.
            </d.Description>
          </div>
          <d.Close
            data-variant="solid"
            @value="confirm"
            @action={{this.deleteProject}}
            @render={{true}}
            as |c|
          >
            <div data-slot="stack">
              <p data-slot="hint" role="alert">
                {{#if c.state.error}}{{c.state.error.message}}{{/if}}
              </p>
              <div data-slot="row">
                <d.Close>Cancel</d.Close>
                <button {{c.part}} type="button">
                  {{#if c.state.pending}}
                    Deleting…
                  {{else if c.state.error}}
                    Try Again
                  {{else}}
                    Delete
                  {{/if}}
                </button>
              </div>
            </div>
          </d.Close>
        </d.Content>
      </AlertDialog>
    </div>
  </template>
}
