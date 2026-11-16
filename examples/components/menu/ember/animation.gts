import Component from "@glimmer/component"
import { ChevronRight } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Animation extends Component {
  log = useLog(this)

  onOpenChange = (open: boolean) => {
    this.log(open ? "Opening" : "Closing")
  }

  onOpenChangeComplete = (open: boolean) => {
    this.log(open ? "Finished opening" : "Finished closing")
  }

  <template>
    <Menu
      @onOpenChange={{this.onOpenChange}}
      @onOpenChangeComplete={{this.onOpenChangeComplete}}
      as |m|
    >
      <m.Trigger>Animated</m.Trigger>
      <m.Content @keepMounted={{true}}>
        <m.Item>Back</m.Item>
        <m.Item>Forward</m.Item>
        <m.Item>Reload</m.Item>
        <m.Separator />
        <m.Sub as |s|>
          <s.Trigger>
            More tools
            {{icon ChevronRight}}
          </s.Trigger>
          <s.Content>
            <s.Item>Save page as…</s.Item>
            <s.Item>Developer tools</s.Item>
          </s.Content>
        </m.Sub>
      </m.Content>
    </Menu>
  </template>
}
