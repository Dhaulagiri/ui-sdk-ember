import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { createMenuController } from "@ui-sdk/core/menu"
import { Menu } from "ember-ui-sdk/menu"
import { menuOptions } from "tests/fixtures/page.ts"
import { menuData } from "../../../../vendor/ui/apps/playground/src/fixtures/menu/data.ts"

export default class MenuFixture extends Component<{
  Args: { data?: boolean }
}> {
  controller = createMenuController()
  options = menuOptions()
  @tracked action = ""

  get items() {
    return this.args.data ? menuData : undefined
  }

  setAction = (value: string) => (this.action = value)
  openWithController = () => this.controller.open({ focus: "first" })

  <template>
    <div class="fixture">
      <button>Before</button>
      <Menu
        @defaultOpen={{this.options.defaultOpen}}
        @container={{this.options.container}}
        @modal={{this.options.modal}}
        @presentation={{this.options.presentation}}
        @controller={{this.controller}}
        @items={{this.items}}
        @onAction={{this.setAction}}
        as |m|
      >
        <m.Trigger>File</m.Trigger>
        {{#unless @data}}
          <m.Content class="popup">
            <m.Item class="item" @value="new" @shortcut="mod+n">New file</m.Item>
            <m.Item class="item" @value="open" @shortcut="mod+o">Open…</m.Item>
            <m.Item class="item" @value="save" @disabled={{true}}>Save</m.Item>
            <m.Separator class="separator" />
            <m.Group as |g|>
              <g.Label class="label">View</g.Label>
              <m.CheckboxItem
                class="item"
                @value="sidebar"
                @defaultChecked={{true}}
              >Show sidebar</m.CheckboxItem>
              <m.CheckboxItem class="item" @value="statusbar">Show status bar</m.CheckboxItem>
            </m.Group>
            <m.Separator class="separator" />
            <m.RadioGroup @defaultValue="name" as |r|>
              <r.Label class="label">Sort by</r.Label>
              <r.Item class="item" @value="name">Name</r.Item>
              <r.Item class="item" @value="date">Date</r.Item>
              <r.Item class="item" @value="size">Size</r.Item>
            </m.RadioGroup>
            <m.Separator class="separator" />
            <m.Sub as |s|>
              <s.Trigger class="item">Share</s.Trigger>
              <s.Content class="popup">
                <s.Item class="item" @value="email">Email</s.Item>
                <s.Item class="item" @value="link">Copy link</s.Item>
                <s.Sub as |s2|>
                  <s2.Trigger class="item">More</s2.Trigger>
                  <s2.Content class="popup">
                    <s2.Item class="item" @value="embed">Embed</s2.Item>
                  </s2.Content>
                </s.Sub>
              </s.Content>
            </m.Sub>
            <m.Item class="item" @value="delete">Delete</m.Item>
          </m.Content>
        {{/unless}}
      </Menu>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <button {{on "click" this.openWithController}}>Open with controller</button>
    </div>
  </template>
}
