import Component from "@glimmer/component"
import { Copy, Ellipsis, Pencil } from "lucide"
import { Dialog, createDialogController } from "ember-ui-sdk/dialog"
import { Field } from "ember-ui-sdk/field"
import { Input } from "ember-ui-sdk/input"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "../../../shared/ember/icon"

export default class FromMenu extends Component {
  rename = createDialogController()

  openRename = () => {
    this.rename.open()
  }

  <template>
    <Menu as |m|>
      <m.Trigger aria-label="File actions">{{icon Ellipsis}}</m.Trigger>
      <m.Content>
        <m.Item @onSelect={{this.openRename}}>
          {{icon Pencil}}
          Rename…
        </m.Item>
        <m.Item>
          {{icon Copy}}
          Duplicate
        </m.Item>
      </m.Content>
    </Menu>
    <Dialog @controller={{this.rename}} as |d|>
      <d.Backdrop />
      <d.Content>
        <div data-slot="stack">
          <d.Title>Rename file</d.Title>
          <d.Description>Names must be unique in a folder.</d.Description>
        </div>
        <Field as |f|>
          <f.Label>Name</f.Label>
          <Input @defaultValue="report.pdf" @field={{f.field}} />
        </Field>
        <div data-slot="row">
          <d.Close>Cancel</d.Close>
          <d.Close data-variant="solid" @value="rename">Rename</d.Close>
        </div>
      </d.Content>
    </Dialog>
  </template>
}
