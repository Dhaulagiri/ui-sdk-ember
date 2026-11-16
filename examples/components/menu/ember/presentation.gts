import Component from "@glimmer/component"
import { ChevronRight, Download, Link, Share, Trash } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Presentation extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <Menu @presentation="sheet" @onAction={{this.onAction}} as |m|>
      <m.Trigger>Options</m.Trigger>
      <m.Content>
        <m.Item @value="share">
          {{icon Share}}
          Share
        </m.Item>
        <m.Item @value="copy-link">
          {{icon Link}}
          Copy link
        </m.Item>
        <m.Sub as |s|>
          <s.Trigger>
            {{icon Download}}
            Move to
            {{icon ChevronRight}}
          </s.Trigger>
          <s.Content>
            <s.Item @value="inbox">Inbox</s.Item>
            <s.Item @value="archive">Archive</s.Item>
          </s.Content>
        </m.Sub>
        <m.Separator />
        <m.Item @value="delete" @destructive={{true}}>
          {{icon Trash}}
          Delete
        </m.Item>
      </m.Content>
    </Menu>
  </template>
}
