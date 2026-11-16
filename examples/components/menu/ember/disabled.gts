import Component from "@glimmer/component"
import { Check, ChevronRight } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

export default class Disabled extends Component {
  log = useLog(this)

  onAction = (value: string) => {
    this.log(`Chose ${value}`)
  }

  <template>
    <div data-slot="row">
      <Menu @onAction={{this.onAction}} as |m|>
        <m.Trigger>Document</m.Trigger>
        <m.Content>
          <m.Item
            @value="undo"
            @shortcut="mod+z"
            @disabled={{true}}
          >Undo</m.Item>
          <m.Item @value="redo" @shortcut="mod+shift+z">Redo</m.Item>
          <m.Separator />
          <m.CheckboxItem
            @value="autosave"
            @defaultChecked={{true}}
            @disabled={{true}}
            as |item|
          >
            <item.Indicator>{{icon Check}}</item.Indicator>
            Autosave
          </m.CheckboxItem>
          <m.Separator />
          <m.RadioGroup @defaultValue="pdf" as |r|>
            <r.Label>Export as</r.Label>
            <r.Item @value="pdf" as |item|>
              <item.Indicator>{{icon Check}}</item.Indicator>
              PDF
            </r.Item>
            <r.Item @value="docx" @disabled={{true}} as |item|>
              <item.Indicator>{{icon Check}}</item.Indicator>
              Word
            </r.Item>
            <r.Item @value="markdown" as |item|>
              <item.Indicator>{{icon Check}}</item.Indicator>
              Markdown
            </r.Item>
          </m.RadioGroup>
          <m.Separator />
          <m.Sub as |s|>
            <s.Trigger @disabled={{true}}>
              Move to
              {{icon ChevronRight}}
            </s.Trigger>
            <s.Content>
              <s.Item>Archive</s.Item>
            </s.Content>
          </m.Sub>
        </m.Content>
      </Menu>
      <Menu as |m|>
        <m.Trigger @disabled={{true}}>Locked</m.Trigger>
        <m.Content>
          <m.Item>Unlock</m.Item>
        </m.Content>
      </Menu>
    </div>
  </template>
}
