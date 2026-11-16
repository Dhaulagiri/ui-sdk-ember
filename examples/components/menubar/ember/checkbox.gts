import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Check } from "lucide"
import { Menu, MenuCheckboxItem } from "ember-ui-sdk/menu"
import { Menubar } from "ember-ui-sdk/menubar"
import { icon } from "../../../shared/ember/icon"

export default class Checkbox extends Component {
  @tracked statusBar = true

  onStatusBarChange = (next: boolean) => {
    this.statusBar = next
  }

  <template>
    <div data-slot="stack">
      <Menubar as |mb|>
        <mb.Menu as |m|>
          <m.Trigger>View</m.Trigger>
          <m.Content>
            <m.CheckboxItem
              @value="status-bar"
              @checked={{this.statusBar}}
              @onCheckedChange={{this.onStatusBarChange}}
              as |item|
            >
              <item.Indicator>{{icon Check}}</item.Indicator>
              Status Bar
            </m.CheckboxItem>
            <m.CheckboxItem
              @value="activity-bar"
              @defaultChecked={{true}}
              as |item|
            >
              <item.Indicator>{{icon Check}}</item.Indicator>
              Activity Bar
            </m.CheckboxItem>
          </m.Content>
        </mb.Menu>
        <mb.Menu as |m|>
          <m.Trigger>Format</m.Trigger>
          <m.Content>
            <m.CheckboxItem @value="strikethrough" as |item|>
              <item.Indicator>{{icon Check}}</item.Indicator>
              Strikethrough
            </m.CheckboxItem>
            <m.CheckboxItem @value="code" as |item|>
              <item.Indicator>{{icon Check}}</item.Indicator>
              Code
            </m.CheckboxItem>
          </m.Content>
        </mb.Menu>
      </Menubar>
      <output data-slot="output">Status bar
        {{if this.statusBar "shown" "hidden"}}</output>
    </div>
  </template>
}
