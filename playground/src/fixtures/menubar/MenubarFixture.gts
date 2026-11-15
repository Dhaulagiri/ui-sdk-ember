import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Menubar, createMenubarController } from "ember-ui-sdk/menubar"
import { menubarFixture, menubarOptions } from "tests/fixtures/menubar.ts"

export default class MenubarFixture extends Component {
  f = menubarFixture
  options = menubarOptions()
  controller = createMenubarController()
  @tracked action = ""

  constructor(owner: Owner, args: object) {
    super(owner, args)
    ;(window as unknown as { __menubar: unknown }).__menubar = this.controller
  }

  run = (value: string) => (this.action = value)
  onCheckedChange = (checked: boolean, details: { value: string }) =>
    this.run(`${details.value}: ${checked ? "on" : "off"}`)
  onProfileChange = (value: string) => this.run(`profile: ${value}`)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Menubar
        class="menubar"
        aria-label={{this.f.label}}
        @controller={{this.controller}}
        @orientation={{this.options.orientation}}
        @loop={{this.options.loop}}
        @disabled={{this.options.disabled}}
        @modal={{this.options.modal}}
        as |bar|
      >
        <bar.Menu @onAction={{this.run}} as |m|>
          <m.Trigger>{{this.f.file.trigger}}</m.Trigger>
          <m.Content class="popup">
            {{#each this.f.file.items key="value" as |item|}}
              <m.Item
                class="item"
                @value={{item.value}}
                @shortcut={{item.shortcut}}
              >{{item.label}}</m.Item>
            {{/each}}
            <m.Sub as |s|>
              <s.Trigger class="item">{{this.f.file.share.trigger}}</s.Trigger>
              <s.Content class="popup">
                {{#each this.f.file.share.items key="value" as |item|}}
                  <s.Item
                    class="item"
                    @value={{item.value}}
                  >{{item.label}}</s.Item>
                {{/each}}
              </s.Content>
            </m.Sub>
            <m.Separator class="separator" />
            <m.Item
              class="item"
              @value={{this.f.file.print.value}}
            >{{this.f.file.print.label}}</m.Item>
          </m.Content>
        </bar.Menu>
        <bar.Menu @onAction={{this.run}} as |m|>
          <m.Trigger>{{this.f.edit.trigger}}</m.Trigger>
          <m.Content class="popup">
            {{#each this.f.edit.items key="value" as |item|}}
              <m.Item
                class="item"
                @value={{item.value}}
                @disabled={{item.disabled}}
              >{{item.label}}</m.Item>
            {{/each}}
          </m.Content>
        </bar.Menu>
        <bar.Menu @onCheckedChange={{this.onCheckedChange}} as |m|>
          <m.Trigger
            @shortcut={{this.f.view.shortcut}}
          >{{this.f.view.trigger}}</m.Trigger>
          <m.Content class="popup">
            {{#each this.f.view.checkboxes key="value" as |item|}}
              <m.CheckboxItem
                class="item"
                @value={{item.value}}
                @defaultChecked={{item.defaultChecked}}
              >
                {{item.label}}
              </m.CheckboxItem>
            {{/each}}
          </m.Content>
        </bar.Menu>
        <bar.Menu as |m|>
          <m.Trigger>{{this.f.profiles.trigger}}</m.Trigger>
          <m.Content class="popup">
            <m.RadioGroup
              @defaultValue={{this.f.profiles.defaultValue}}
              @onValueChange={{this.onProfileChange}}
              as |r|
            >
              {{#each this.f.profiles.items key="value" as |item|}}
                <r.Item
                  class="item"
                  @value={{item.value}}
                >{{item.label}}</r.Item>
              {{/each}}
            </m.RadioGroup>
          </m.Content>
        </bar.Menu>
        <bar.Menu @onAction={{this.run}} as |m|>
          <m.Trigger @disabled={{true}}>{{this.f.help.trigger}}</m.Trigger>
          <m.Content class="popup">
            {{#each this.f.help.items key="value" as |item|}}
              <m.Item class="item" @value={{item.value}}>{{item.label}}</m.Item>
            {{/each}}
          </m.Content>
        </bar.Menu>
      </Menubar>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
