import Component from "@glimmer/component"
import { Dialog } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { useLog } from "../../../shared/ember/log"

export default class Form extends Component {
  log = useLog(this)

  onOpenChange = (
    open: boolean,
    details: { reason: string; returnValue?: string }
  ) => {
    if (!open) {
      this.log(
        details.returnValue
          ? `Saved as ${details.returnValue}`
          : `Closed (${details.reason})`
      )
    }
  }

  <template>
    <Dialog @onOpenChange={{this.onOpenChange}} as |d|>
      <d.Trigger>New Article</d.Trigger>
      <d.Backdrop />
      <d.Content>
        <div data-slot="stack">
          <d.Title>New article</d.Title>
          <d.Description>Save it as a draft or publish it now.</d.Description>
        </div>
        <form data-slot="stack" method="dialog">
          <Field as |f|>
            <f.Label>Title</f.Label>
            <Input
              required
              @defaultValue="Shipping updates for spring"
              @field={{f.field}}
            />
          </Field>
          <div data-slot="row">
            <button type="submit" value="draft">Save Draft</button>
            <button
              data-variant="solid"
              type="submit"
              value="published"
            >Publish</button>
          </div>
        </form>
      </d.Content>
    </Dialog>
  </template>
}
