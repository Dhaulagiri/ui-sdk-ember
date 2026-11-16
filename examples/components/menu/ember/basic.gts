import Component from "@glimmer/component"
import { Menu } from "ember-ui-sdk/menu"
import { useLog } from "../../../shared/ember/log"

export default class Basic extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <Menu @onAction={{this.onAction}} as |m|>
      <m.Trigger>Open Menu</m.Trigger>
      <m.Content>
        <m.Group as |g|>
          <g.Label>Project</g.Label>
          <m.Item @value="overview">Overview</m.Item>
          <m.Item @value="members">Members</m.Item>
          <m.Item @value="settings">Settings</m.Item>
        </m.Group>
        <m.Separator />
        <m.Group as |g|>
          <g.Label>Help</g.Label>
          <m.Item @value="docs">Documentation</m.Item>
          <m.Item @value="feedback">Send feedback</m.Item>
        </m.Group>
      </m.Content>
    </Menu>
  </template>
}
