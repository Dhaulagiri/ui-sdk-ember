import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Popover } from "ember-ui-sdk/popover"
import { useLog } from "../../../shared/ember/log"

export default class Form extends Component {
  log = useLog(this)
  @tracked open = false

  onOpenChange = (open: boolean) => {
    this.open = open
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    const form = event.currentTarget as HTMLFormElement
    this.log(`Saved ${new FormData(form).get("name")}`)
    this.open = false
  }

  <template>
    <Popover @open={{this.open}} @onOpenChange={{this.onOpenChange}} as |p|>
      <p.Trigger>Edit Profile</p.Trigger>
      <p.Content>
        <p.Title>Edit profile</p.Title>
        <p.Description>Your name shows on your posts.</p.Description>
        <form data-slot="stack" {{on "submit" this.onSubmit}}>
          <Field as |f|>
            <f.Label>Name</f.Label>
            <Input
              @field={{f.field}}
              name="name"
              required
              @defaultValue="Hollis Grant"
            />
          </Field>
          <div data-slot="row">
            <p.Close>Cancel</p.Close>
            <button type="submit" data-variant="solid">Save</button>
          </div>
        </form>
      </p.Content>
    </Popover>
  </template>
}
