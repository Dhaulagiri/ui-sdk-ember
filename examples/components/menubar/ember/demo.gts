import Component from "@glimmer/component"
import { Check, ChevronRight } from "lucide"
import { Menu } from "ember-ui-sdk/menu"
import { Menubar } from "ember-ui-sdk/menubar"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const recent = ["Q3 roadmap", "Launch checklist", "Offsite notes"]
const formats = ["PDF", "Markdown", "HTML"]
const appearances = ["Light", "Dark", "System"]

export default class Demo extends Component {
  log = useLog(this)
  recent = recent
  formats = formats
  appearances = appearances

  chose = (value: string) => {
    this.log(`Chose ${value}`)
  }

  onCheckedChange = (checked: boolean, details: { value: string }) => {
    this.log(`${details.value} ${checked ? "on" : "off"}`)
  }

  onAppearance = (value: string) => {
    this.log(`${value} appearance`)
  }

  <template>
    <Menubar as |mb|>
      <mb.Menu @onAction={{this.chose}} as |m|>
        <m.Trigger>File</m.Trigger>
        <m.Content>
          <m.Item @value="New document" @shortcut="mod+n">New Document</m.Item>
          <m.Item @value="Open" @shortcut="mod+o">Open…</m.Item>
          <m.Sub as |s|>
            <s.Trigger>
              Open Recent
              {{icon ChevronRight}}
            </s.Trigger>
            <s.Content>
              {{#each this.recent key="@identity" as |name|}}
                <s.Item @value={{name}}>{{name}}</s.Item>
              {{/each}}
            </s.Content>
          </m.Sub>
          <m.Separator />
          <m.Sub as |s|>
            <s.Trigger>
              Export
              {{icon ChevronRight}}
            </s.Trigger>
            <s.Content>
              {{#each this.formats key="@identity" as |format|}}
                <s.Item @value="Export as {{format}}">{{format}}</s.Item>
              {{/each}}
            </s.Content>
          </m.Sub>
          <m.Item @value="Print" @shortcut="mod+p">Print…</m.Item>
        </m.Content>
      </mb.Menu>
      <mb.Menu @onAction={{this.chose}} as |m|>
        <m.Trigger>Edit</m.Trigger>
        <m.Content>
          <m.Item
            @value="Undo"
            @shortcut="mod+z"
            @disabled={{true}}
          >Undo</m.Item>
          <m.Item @value="Redo" @shortcut="mod+shift+z">Redo</m.Item>
          <m.Separator />
          <m.Item @value="Cut" @shortcut="mod+x">Cut</m.Item>
          <m.Item @value="Copy" @shortcut="mod+c">Copy</m.Item>
          <m.Item @value="Paste" @shortcut="mod+v">Paste</m.Item>
          <m.Separator />
          <m.Item @value="Find" @shortcut="mod+f">Find…</m.Item>
        </m.Content>
      </mb.Menu>
      <mb.Menu
        @onCheckedChange={{this.onCheckedChange}}
        @onValueChange={{this.onAppearance}}
        as |m|
      >
        <m.Trigger>View</m.Trigger>
        <m.Content>
          <m.CheckboxItem @value="Ruler" as |item|>
            <item.Indicator>{{icon Check}}</item.Indicator>
            Show Ruler
          </m.CheckboxItem>
          <m.CheckboxItem
            @value="Word count"
            @defaultChecked={{true}}
            as |item|
          >
            <item.Indicator>{{icon Check}}</item.Indicator>
            Show Word Count
          </m.CheckboxItem>
          <m.Separator />
          <m.RadioGroup @defaultValue="System" as |r|>
            <r.Label>Appearance</r.Label>
            {{#each this.appearances key="@identity" as |appearance|}}
              <r.Item @value={{appearance}} as |item|>
                <item.Indicator />
                {{appearance}}
              </r.Item>
            {{/each}}
          </m.RadioGroup>
        </m.Content>
      </mb.Menu>
    </Menubar>
  </template>
}
