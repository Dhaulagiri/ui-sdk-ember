import Component from "@glimmer/component"
import { Code, Download, Link, Mail, Reply, Share } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Icons extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <Menu @onAction={{this.onAction}} as |m|>
      <m.Trigger>
        {{icon Share}}
        Share
      </m.Trigger>
      <m.Content>
        <m.Item @value="copy-link">
          <m.ItemIcon>{{icon Link}}</m.ItemIcon>
          Copy link
        </m.Item>
        <m.Item @value="email">
          <m.ItemIcon>{{icon Mail}}</m.ItemIcon>
          Email
        </m.Item>
        <m.Item @value="reply">
          <m.ItemIcon @mirror={{true}}>{{icon Reply}}</m.ItemIcon>
          Reply
        </m.Item>
        <m.Separator />
        <m.Item @value="download">
          <m.ItemIcon>{{icon Download}}</m.ItemIcon>
          Download
        </m.Item>
        <m.Item @value="embed">
          <m.ItemIcon>{{icon Code}}</m.ItemIcon>
          Embed
        </m.Item>
      </m.Content>
    </Menu>
  </template>
}
