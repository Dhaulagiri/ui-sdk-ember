import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { fn } from "@ember/helper"
import { AlertDialog, createConfirm } from "ember-ui-sdk/alert-dialog"

const initial = ["Acme", "Globex", "Initech"]

export default class Confirm extends Component {
  confirm = createConfirm<{ name: string }>()
  @tracked projects = initial

  remove = async (name: string, event: Event) => {
    const button = event.currentTarget as HTMLButtonElement
    if (!(await this.confirm({ name }))) {
      return
    }
    const row = button.closest("li")
    const next = (
      row?.nextElementSibling ?? row?.previousElementSibling
    )?.querySelector("button")
    const target =
      next ?? document.querySelector<HTMLButtonElement>("#reset-projects")
    target?.focus()
    this.projects = this.projects.filter((project) => project !== name)
  }

  reset = () => {
    this.projects = initial
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" id="reset-projects" {{on "click" this.reset}}>
          Reset Projects
        </button>
      </div>
      <ul data-slot="list" aria-label="Projects">
        {{#each this.projects key="@identity" as |name|}}
          <li data-slot="row">
            {{name}}
            <button
              type="button"
              data-size="sm"
              aria-label="Delete {{name}}"
              {{on "click" (fn this.remove name)}}
            >
              Delete
            </button>
          </li>
        {{else}}
          <li data-slot="row">All projects deleted.</li>
        {{/each}}
      </ul>
      <AlertDialog @controller={{this.confirm.controller}} as |d|>
        <d.Backdrop />
        <d.Content as |content|>
          <div data-slot="stack">
            <d.Title>Delete {{content.state.payload.name}}?</d.Title>
            <d.Description>
              The project and its files will be deleted for everyone on your
              team.
            </d.Description>
          </div>
          <div data-slot="row">
            <d.Close>Cancel</d.Close>
            <d.Close data-variant="solid" @value="confirm">Delete</d.Close>
          </div>
        </d.Content>
      </AlertDialog>
    </div>
  </template>
}
