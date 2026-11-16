import { Menu } from "ember-ui-sdk/menu"
import { useLog } from "../../../shared/ember/log"
import Component from "@glimmer/component"

export default class ContextMenu extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <Menu @onAction={{this.onAction}} as |m|>
      <m.ContextTrigger tabindex="0">Right-click or long-press here</m.ContextTrigger>
      <m.Content>
        <m.Item @value="back">Back</m.Item>
        <m.Item @value="forward" @disabled={{true}}>Forward</m.Item>
        <m.Item @value="reload">Reload</m.Item>
        <m.Separator />
        <m.Item @value="save">Save page as…</m.Item>
        <m.Item @value="print">Print…</m.Item>
      </m.Content>
    </Menu>
  </template>
}
