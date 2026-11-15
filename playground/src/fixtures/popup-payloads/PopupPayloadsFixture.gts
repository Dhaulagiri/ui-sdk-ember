import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Dialog } from "ember-ui-sdk/dialog"
import { Drawer } from "ember-ui-sdk/drawer"
import { Menu } from "ember-ui-sdk/menu"
import { createPopoverController, Popover } from "ember-ui-sdk/popover"
import {
  contentFor,
  describeChange,
  payloadOf,
  popupPayloadsFixture as fixture,
} from "tests/fixtures/popup-payloads.ts"

export default class PopupPayloadsFixture extends Component {
  fixture = fixture
  people = createPopoverController<string>()
  contentFor = contentFor
  payloadOf = payloadOf
  @tracked lastOpen = ""
  @tracked lastPayload = ""

  opened = (name: string, open: boolean, { event }: { event?: Event }) => {
    if (open) {
      this.lastOpen = describeChange(name, "open", event)
    }
  }

  payloadChanged = (
    name: string,
    payload: unknown,
    { event }: { event?: Event }
  ) => {
    this.lastPayload = describeChange(name, `payload ${payload}`, event)
  }

  menuOpen = (open: boolean, d: { event?: Event }) =>
    this.opened("menu", open, d)
  menuPayload = (p: unknown, d: { event?: Event }) =>
    this.payloadChanged("menu", p, d)
  popoverOpen = (open: boolean, d: { event?: Event }) =>
    this.opened("popover", open, d)
  popoverPayload = (p: unknown, d: { event?: Event }) =>
    this.payloadChanged("popover", p, d)
  dialogOpen = (open: boolean, d: { event?: Event }) =>
    this.opened("dialog", open, d)
  dialogPayload = (p: unknown, d: { event?: Event }) =>
    this.payloadChanged("dialog", p, d)
  drawerOpen = (open: boolean, d: { event?: Event }) =>
    this.opened("drawer", open, d)
  drawerPayload = (p: unknown, d: { event?: Event }) =>
    this.payloadChanged("drawer", p, d)

  showPerson = () => this.people.open({ payload: fixture.popover.show.payload })

  <template>
    <div class="fixture">
      <button>Before</button>
      <Menu
        @onOpenChange={{this.menuOpen}}
        @onPayloadChange={{this.menuPayload}}
        as |m|
      >
        {{#each this.fixture.menu.triggers key="@identity" as |label|}}
          <m.Trigger @payload={{this.payloadOf label}}>{{label}}</m.Trigger>
        {{/each}}
        <m.Content class="popup" as |c|>
          <m.Group as |g|>
            <g.Label>{{this.contentFor c.state.payload}}</g.Label>
            <m.Item
              class="item"
              @value="open"
            >{{this.fixture.menu.item}}</m.Item>
          </m.Group>
        </m.Content>
      </Menu>
      <Popover
        @controller={{this.people}}
        @onOpenChange={{this.popoverOpen}}
        @onPayloadChange={{this.popoverPayload}}
        as |p|
      >
        {{#each this.fixture.popover.triggers key="@identity" as |label|}}
          <p.Trigger @payload={{this.payloadOf label}}>{{label}}</p.Trigger>
        {{/each}}
        <p.Content class="popup" as |c|>
          {{this.contentFor c.state.payload}}
          <button
            {{on "click" this.showPerson}}
          >{{this.fixture.popover.show.label}}</button>
        </p.Content>
      </Popover>
      <Dialog
        @modal={{false}}
        @onOpenChange={{this.dialogOpen}}
        @onPayloadChange={{this.dialogPayload}}
        as |d|
      >
        {{#each this.fixture.dialog.triggers key="@identity" as |label|}}
          <d.Trigger @payload={{this.payloadOf label}}>{{label}}</d.Trigger>
        {{/each}}
        <d.Content class="dialog" as |c|>{{this.contentFor
            c.state.payload
          }}</d.Content>
      </Dialog>
      <Drawer
        @modal={{false}}
        @onOpenChange={{this.drawerOpen}}
        @onPayloadChange={{this.drawerPayload}}
        as |d|
      >
        {{#each this.fixture.drawer.triggers key="@identity" as |label|}}
          <d.Trigger @payload={{this.payloadOf label}}>{{label}}</d.Trigger>
        {{/each}}
        <d.Content class="drawer" as |c|>{{this.contentFor
            c.state.payload
          }}</d.Content>
      </Drawer>
      <output role="status" aria-label="Last open">{{this.lastOpen}}</output>
      <output
        role="status"
        aria-label="Last payload"
      >{{this.lastPayload}}</output>
    </div>
  </template>
}
