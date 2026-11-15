import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  createDrawerController,
  Drawer,
  DrawerOutlet,
  DrawerTrigger,
} from "ember-ui-sdk/drawer"
import {
  drawerFixture,
  drawerOptions,
  drawerParts,
  exposeDrawerFixture,
  recordDrawer,
} from "tests/fixtures/drawer.ts"

export default class DrawerFixture extends Component {
  controller = createDrawerController()
  options = drawerOptions()
  parts = drawerParts()
  f = drawerFixture
  @tracked action = ""
  @tracked more = false

  constructor(owner: Owner, args: object) {
    super(owner, args)
    exposeDrawerFixture(this.controller)
  }

  onOpenChange = (open: boolean, details: { reason: string }) =>
    recordDrawer(`drawer:${open}:${details.reason}`)
  onSnapPointChange = (snapPoint: unknown, details: { reason: string }) =>
    recordDrawer(`${snapPoint}:${details.reason}`)
  onDismissAttempt = (details: { reason: string }) =>
    recordDrawer(`attempt:${details.reason}`)
  onNestedOpenChange = (open: boolean, details: { reason: string }) =>
    recordDrawer(`nested:${open}:${details.reason}`)
  setAction = (action: string) => (this.action = action)
  showMore = () => (this.more = true)
  openWithController = () => this.controller.open()

  <template>
    <div class="fixture">
      <button>Before</button>
      <Drawer
        @controller={{this.controller}}
        @defaultOpen={{this.options.defaultOpen}}
        @snapPoints={{this.options.snapPoints}}
        @defaultSnapPoint={{this.options.defaultSnapPoint}}
        @side={{this.options.side}}
        @modalAbove={{this.options.modalAbove}}
        @dismissible={{this.options.dismissible}}
        @expandOnScroll={{this.options.expandOnScroll}}
        @driver={{this.options.driver}}
        @modal={{this.options.modal}}
        @container={{this.options.container}}
        @themeColor={{this.options.themeColor}}
        @onOpenChange={{this.onOpenChange}}
        @onSnapPointChange={{this.onSnapPointChange}}
        @onDismissAttempt={{this.onDismissAttempt}}
        as |d|
      >
        <d.Trigger>{{this.f.trigger}}</d.Trigger>
        {{#if this.parts.backdrop}}<d.Backdrop class="drawer-backdrop" />{{/if}}
        <d.Content class="drawer">
          <d.Handle class="handle" aria-label={{this.f.handle}} />
          <d.Title class="title">{{this.f.title}}</d.Title>
          <d.Description
            class="description"
          >{{this.f.description}}</d.Description>
          {{#if this.parts.field}}
            <label class="field">
              {{this.f.field}}
              <input />
            </label>
          {{/if}}
          {{#if this.parts.scroll}}
            <ul class="scroll" aria-label={{this.f.scroll.label}} tabindex="0">
              {{#each this.f.scroll.items key="@identity" as |item|}}<li>
                  {{item}}
                </li>{{/each}}
            </ul>
          {{/if}}
          {{#if this.parts.grow}}
            <button {{on "click" this.showMore}}>{{this.f.grow.button}}</button>
            {{#if this.more}}<p class="more">{{this.f.grow.text}}</p>{{/if}}
          {{/if}}
          <div class="actions">
            <button
              {{on "click" (fn this.setAction "submit")}}
            >{{this.f.action}}</button>
            <d.Close>{{this.f.close}}</d.Close>
          </div>
          {{#if this.parts.nested}}
            <Drawer @onOpenChange={{this.onNestedOpenChange}} as |n|>
              <n.Trigger>{{this.f.nested.trigger}}</n.Trigger>
              {{#if this.parts.backdrop}}<n.Backdrop
                  class="drawer-backdrop"
                />{{/if}}
              <n.Content class="drawer">
                <n.Title class="title">{{this.f.nested.title}}</n.Title>
                <n.Close>{{this.f.nested.close}}</n.Close>
              </n.Content>
            </Drawer>
          {{/if}}
        </d.Content>
      </Drawer>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <button
        {{on "click" this.openWithController}}
      >{{this.f.controller}}</button>
      <button {{on "click" (fn this.setAction "page")}}>{{this.f.page}}</button>
      {{#if this.parts.shortcut}}
        <DrawerTrigger
          @controller={{this.controller}}
          @shortcut={{this.f.shortcut.keys}}
          as |trigger|
        >
          {{this.f.shortcut.trigger}}
          <trigger.Shortcut />
        </DrawerTrigger>
      {{/if}}
      {{#if this.parts.outlet}}
        <DrawerOutlet
          @controller={{this.controller}}
          class="outlet"
          role="region"
          aria-label={{this.f.outlet.label}}
          @keyframes={{this.f.outlet.keyframes}}
        />
      {{/if}}
    </div>
  </template>
}
