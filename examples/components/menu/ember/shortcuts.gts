import Component from "@glimmer/component"
import { Menu } from "ember-ui-sdk/menu"
import { useLog } from "../../../shared/ember/log"

export default class Shortcuts extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <Menu @onAction={{this.onAction}} as |m|>
      <m.Trigger>File</m.Trigger>
      <m.Content>
        <m.Item @value="new-tab" @shortcut="mod+t">New tab</m.Item>
        <m.Item @value="new-window" @shortcut="mod+n">New window</m.Item>
        <m.Item @value="open" @shortcut="mod+o">Open…</m.Item>
        <m.Separator />
        <m.Item @value="save" @shortcut="mod+s">Save</m.Item>
        <m.Item @value="save-as" @shortcut="mod+shift+s">Save as…</m.Item>
        <m.Separator />
        <m.Item @value="print" @shortcut="mod+p">Print…</m.Item>
      </m.Content>
    </Menu>
  </template>
}
