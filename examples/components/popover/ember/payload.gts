import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import {
  Popover,
  PopoverTrigger,
  createPopoverController,
} from "ember-ui-sdk/popover"
import { useLog } from "../../../shared/ember/log"

type Member = { name: string; role: string }

const roles = ["Admin", "Editor", "Viewer"]

export default class Payload extends Component {
  log = useLog(this)
  popover = createPopoverController<Member>()
  @tracked members: Member[] = [
    { name: "Hollis Grant", role: "Owner" },
    { name: "Inès Moreau", role: "Editor" },
    { name: "Kofi Mensah", role: "Viewer" },
    { name: "Wren Takahashi", role: "Viewer" },
  ]

  get newest() {
    return this.members[this.members.length - 1]
  }

  isOwner = (member: Member) => member.role === "Owner"

  isRole = (role: string, member: Member | undefined) => member?.role === role

  editNewest = async (event: MouseEvent) => {
    const result = await this.popover.open({
      payload: this.newest,
      anchor: event.currentTarget as HTMLElement,
    })
    this.log(
      `Closed (${result.reason}), returned ${result.returnValue ?? "nothing"}`
    )
  }

  onPayloadChange = (payload: unknown) => {
    const member = payload as Member | undefined
    if (member) {
      this.log(`Editing ${member.name}`)
    }
  }

  save = (member: Member | undefined, event: SubmitEvent) => {
    if ((event.submitter as HTMLButtonElement).value !== "save" || !member) {
      return
    }
    const form = event.currentTarget as HTMLFormElement
    const role = String(new FormData(form).get("role"))
    this.members = this.members.map((entry) =>
      entry.name === member.name ? { ...entry, role } : entry
    )
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.editNewest}}>
          Edit Newest Member
        </button>
      </div>
      <ul data-slot="list">
        {{#each this.members key="name" as |member|}}
          <li data-slot="row">
            {{member.name}}
            <span data-slot="hint">{{member.role}}</span>
            <PopoverTrigger
              @controller={{this.popover}}
              @payload={{member}}
              @disabled={{this.isOwner member}}
              data-size="sm"
              data-variant="ghost"
              aria-label="Edit {{member.name}}"
            >
              Edit
            </PopoverTrigger>
          </li>
        {{/each}}
      </ul>
      <Popover
        @controller={{this.popover}}
        @onPayloadChange={{this.onPayloadChange}}
        as |p|
      >
        <p.Content @align="end" @sideOffset={{8}} as |content|>
          <p.Title>{{content.state.payload.name}}</p.Title>
          <p.Description>Roles decide what they can change.</p.Description>
          <form
            data-slot="stack"
            method="dialog"
            {{on "submit" (fn this.save content.state.payload)}}
          >
            <Field as |f|>
              <f.Label>Role</f.Label>
              <f.Control @render={{true}} as |control|>
                <select name="role" {{control.part}}>
                  {{#each roles key="@identity" as |role|}}
                    <option
                      selected={{this.isRole role content.state.payload}}
                    >{{role}}</option>
                  {{/each}}
                </select>
              </f.Control>
            </Field>
            <div data-slot="row">
              <button type="submit" value="cancel" formnovalidate>
                Cancel
              </button>
              <button type="submit" value="save" data-variant="solid">
                Save
              </button>
            </div>
          </form>
        </p.Content>
      </Popover>
    </div>
  </template>
}
