import Component from "@glimmer/component"
import { ChevronRight } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Submenu extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <Menu @onAction={{this.onAction}} as |m|>
      <m.Trigger>Edit</m.Trigger>
      <m.Content>
        <m.Item @value="undo" @shortcut="mod+z">Undo</m.Item>
        <m.Item @value="redo" @shortcut="mod+shift+z">Redo</m.Item>
        <m.Separator />
        <m.Sub as |s|>
          <s.Trigger>
            Find
            {{icon ChevronRight}}
          </s.Trigger>
          <s.Content>
            <s.Item @value="find" @shortcut="mod+f">Find…</s.Item>
            <s.Item @value="find-next" @shortcut="mod+g">Find next</s.Item>
            <s.Item @value="find-previous" @shortcut="mod+shift+g">Find previous</s.Item>
          </s.Content>
        </m.Sub>
        <m.Sub as |s|>
          <s.Trigger>
            Transform
            {{icon ChevronRight}}
          </s.Trigger>
          <s.Content>
            <s.Sub as |s2|>
              <s2.Trigger>
                Case
                {{icon ChevronRight}}
              </s2.Trigger>
              <s2.Content>
                <s2.Item @value="uppercase">Uppercase</s2.Item>
                <s2.Item @value="lowercase">Lowercase</s2.Item>
              </s2.Content>
            </s.Sub>
            <s.Item @value="trim">Trim whitespace</s.Item>
          </s.Content>
        </m.Sub>
      </m.Content>
    </Menu>
  </template>
}
