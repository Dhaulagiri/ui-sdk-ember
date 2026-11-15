import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Menu } from "ember-ui-sdk/menu"

export default class Cases extends Component {
  @tracked action = ""
  @tracked selections = 0
  @tracked align = "left"
  @tracked open = false

  constructor(owner: Owner, args: object) {
    super(owner, args)
    ;(
      window as unknown as { __closeControlled: () => void }
    ).__closeControlled = () => (this.open = false)
  }

  setAction = (value: string) => (this.action = value)
  setAlign = (value: string) => (this.align = value)
  setOpen = (open: boolean) => (this.open = open)
  noop = () => {}

  closeFromState = (event: Event) => {
    event.preventDefault()
    this.open = false
  }

  keepOpen = (event: Event) => {
    event.preventDefault()
    this.selections++
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <Menu @onAction={{this.setAction}} as |m|>
        <m.Trigger>Edit</m.Trigger>
        <m.Content class="popup">
          <m.Item
            class="item"
            @value="pin"
            @onSelect={{this.keepOpen}}
          >Pin</m.Item>
          <m.Item class="item" @value="zoom" @closeOnSelect={{false}}>Zoom in</m.Item>
          <m.Item
            class="item"
            @value="erase"
            @shortcut="mod+backspace"
          >Erase</m.Item>
          <m.Item class="item" @value="window" @shortcut="alt+n">New window</m.Item>
          <m.Separator class="separator" />
          <m.CheckboxItem
            class="item"
            @value="autosave"
            @closeOnSelect={{true}}
          >Autosave</m.CheckboxItem>
          <m.CheckboxItem
            class="item"
            @value="pinned"
            @checked={{true}}
            @onCheckedChange={{this.noop}}
          >Pinned</m.CheckboxItem>
          <m.RadioGroup
            @value={{this.align}}
            @onValueChange={{this.setAlign}}
            as |r|
          >
            <r.Label class="label">Align</r.Label>
            <r.Item class="item" @value="left">Left</r.Item>
            <r.Item class="item" @value="right">Right</r.Item>
          </m.RadioGroup>
          <m.Sub as |s|>
            <s.Trigger class="item" @disabled={{true}}>Share</s.Trigger>
            <s.Content class="popup">
              <s.Item class="item" @value="email">Email</s.Item>
            </s.Content>
          </m.Sub>
          <m.Sub @loop={{false}} as |s|>
            <s.Trigger class="item">More</s.Trigger>
            <s.Content class="popup">
              <s.Item class="item" @value="first">First</s.Item>
              <s.Item class="item" @value="last">Last</s.Item>
            </s.Content>
          </m.Sub>
        </m.Content>
      </Menu>
      <Menu as |m|>
        <m.Trigger>Offsets</m.Trigger>
        <m.Content
          class="popup"
          @sideOffset={{8}}
          @alignOffset={{-4}}
          @collisionPadding={{24}}
        >
          <m.Item class="item" @value="one">One</m.Item>
          <m.Item class="item" @value="two">Two</m.Item>
        </m.Content>
      </Menu>
      <Menu @open={{this.open}} @onOpenChange={{this.setOpen}} as |m|>
        <m.Trigger>Controlled</m.Trigger>
        <m.Content class="popup">
          <m.Item
            class="item"
            @value="done"
            @onSelect={{this.closeFromState}}
          >Done</m.Item>
          <m.Item class="item" @value="later">Later</m.Item>
        </m.Content>
      </Menu>
      <button {{on "click" (fn this.setAlign "right")}}>Align right</button>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Selections">{{this.selections}}</output>
    </div>
  </template>
}
