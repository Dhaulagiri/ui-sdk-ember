import Component from "@glimmer/component"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Menu } from "ember-ui-sdk/menu"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { ChevronDown } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class MenuExample extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Shared by ${value}`)
  }

  <template>
    <Toolbar aria-label="Document" as |t|>
      <t.Button {{on "click" (fn this.log "Saved")}}>Save</t.Button>
      <Menu @onAction={{this.onAction}} as |m|>
        <t.Button @render={{true}} as |b|>
          <m.Trigger @render={{true}} as |tr|>
            <button {{b.part}} {{tr.part}}>
              Share
              {{icon ChevronDown}}
            </button>
          </m.Trigger>
        </t.Button>
        <m.Content>
          <m.Item @value="email">Email</m.Item>
          <m.Item @value="link">Copy Link</m.Item>
        </m.Content>
      </Menu>
      <t.Button {{on "click" (fn this.log "Printed")}}>Print</t.Button>
    </Toolbar>
  </template>
}
