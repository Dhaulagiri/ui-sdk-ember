import Component from "@glimmer/component"
import { Check } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Checkboxes extends Component {
  log = useLog(this)

  onCheckedChange = (checked: boolean, details: { value: string }) => {
    this.log(`${details.value} ${checked ? "on" : "off"}`)
  }

  <template>
    <Menu @onCheckedChange={{this.onCheckedChange}} as |m|>
      <m.Trigger>View</m.Trigger>
      <m.Content>
        <m.Group as |g|>
          <g.Label>Appearance</g.Label>
          <m.CheckboxItem
            @value="status-bar"
            @defaultChecked={{true}}
            as |item|
          >
            <item.Indicator @keepMounted={{true}}>{{icon
                Check
              }}</item.Indicator>
            Status bar
          </m.CheckboxItem>
          <m.CheckboxItem @value="minimap" as |item|>
            <item.Indicator @keepMounted={{true}}>{{icon
                Check
              }}</item.Indicator>
            Minimap
          </m.CheckboxItem>
        </m.Group>
        <m.Separator />
        <m.CheckboxItem
          @value="line-numbers"
          @defaultChecked={{true}}
          as |item|
        >
          <item.Indicator @keepMounted={{true}}>{{icon Check}}</item.Indicator>
          Line numbers
        </m.CheckboxItem>
        <m.CheckboxItem @value="word-wrap" as |item|>
          <item.Indicator @keepMounted={{true}}>{{icon Check}}</item.Indicator>
          Word wrap
        </m.CheckboxItem>
      </m.Content>
    </Menu>
  </template>
}
