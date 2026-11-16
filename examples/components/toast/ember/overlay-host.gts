import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { fn } from "@ember/helper"
import { AlertDialog, createConfirm } from "ember-ui-sdk/alert-dialog"
import { createOverlays, OverlayHost } from "ember-ui-sdk/overlays"
import { createToaster } from "ember-ui-sdk/toast"
import { icon } from "../../../shared/ember/icon"
import { CircleCheck } from "lucide"

const initial = ["Acme", "Globex", "Initech"]

export default class OverlayHostExample extends Component {
  overlays = createOverlays()
  toast = createToaster({ overlays: this.overlays })
  confirm = createConfirm({ overlays: this.overlays })
  @tracked projects = initial

  willDestroy() {
    super.willDestroy()
    this.toast.dismiss()
  }

  remove = async (name: string, event: Event) => {
    const button = event.currentTarget as HTMLButtonElement
    const confirmed = await this.confirm({
      title: `Delete ${name}?`,
      description:
        "The project and its files will be deleted for everyone on your team.",
      confirmLabel: "Delete",
      cancelLabel: "Cancel",
    })
    if (!confirmed) {
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
    this.toast.success(`${name} deleted`, { priority: "assertive" })
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
      <OverlayHost @overlays={{this.overlays}} as |toast item t|>
        <t.Toast>
          <span data-show="success">{{icon CircleCheck}}</span>
          <t.Title />
        </t.Toast>
      </OverlayHost>
      <AlertDialog @controller={{this.confirm.controller}} as |d|>
        <d.Backdrop />
        <d.Content as |content|>
          <div data-slot="stack">
            <d.Title>{{content.state.payload.title}}</d.Title>
            <d.Description>{{content.state.payload.description}}</d.Description>
          </div>
          <div data-slot="row">
            <d.Close>{{content.state.payload.cancelLabel}}</d.Close>
            <d.Close data-variant="solid" @value="confirm">
              {{content.state.payload.confirmLabel}}
            </d.Close>
          </div>
        </d.Content>
      </AlertDialog>
    </div>
  </template>
}
