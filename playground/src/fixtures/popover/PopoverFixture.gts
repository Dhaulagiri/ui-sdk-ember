import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { createPopoverController } from "@ui-sdk/core/popover"
import { Menu } from "ember-ui-sdk/menu"
import { Popover, PopoverTrigger } from "ember-ui-sdk/popover"
import {
  popoverContentOptions,
  popoverFixture,
  popoverOptions,
  popoverParts,
} from "tests/fixtures/popover.ts"

export default class PopoverFixture extends Component {
  controller = createPopoverController()
  options = popoverOptions()
  content = popoverContentOptions()
  parts = popoverParts()
  f = popoverFixture
  @tracked action = ""
  @tracked triggerShown = true

  setAction = (action: string) => (this.action = action)
  removeTrigger = () => (this.triggerShown = false)
  openWithController = () => this.controller.open()

  <template>
    <div class="fixture">
      <button>Before</button>
      <Popover
        @defaultOpen={{this.options.defaultOpen}}
        @modal={{this.options.modal}}
        @openOnHover={{this.options.openOnHover}}
        @delay={{this.options.delay}}
        @closeDelay={{this.options.closeDelay}}
        @container={{this.options.container}}
        @dismissible={{this.options.dismissible}}
        @onDismissAttempt={{this.options.onDismissAttempt}}
        @presentation={{this.options.presentation}}
        @controller={{this.controller}}
        as |p|
      >
        {{#if this.triggerShown}}
          <p.Trigger
            @shortcut={{if this.parts.shortcut this.f.shortcut.trigger}}
            as |trigger|
          >
            {{this.f.trigger}}
            {{#if this.parts.shortcut}}<trigger.Shortcut />{{/if}}
          </p.Trigger>
        {{/if}}
        <p.Content
          class="popup"
          @sideOffset={{8}}
          @side={{this.content.side}}
          @align={{this.content.align}}
          @initialFocus={{this.content.initialFocus}}
          @inline={{this.content.inline}}
        >
          <p.Arrow class="arrow" />
          {{#if this.parts.title}}<p.Title
              class="title"
            >{{this.f.title}}</p.Title>{{/if}}
          <p.Description
            class="description"
          >{{this.f.description}}</p.Description>
          <label class="field">
            {{this.f.field}}
            <input value={{this.f.defaultValue}} />
          </label>
          <div class="actions">
            <button {{on "click" (fn this.setAction "save")}}>
              {{this.f.action}}
              {{#if this.parts.shortcut}}<p.Shortcut
                  @shortcut={{this.f.shortcut.save}}
                />{{/if}}
            </button>
            <p.Close>{{this.f.close}}</p.Close>
            {{#if this.parts.removable}}
              <button
                {{on "click" this.removeTrigger}}
              >{{this.f.remove}}</button>
            {{/if}}
          </div>
          {{#if this.parts.menu}}
            <Menu
              @container={{this.options.container}}
              @onAction={{this.setAction}}
              as |m|
            >
              <m.Trigger>{{this.f.menu.trigger}}</m.Trigger>
              <m.Content class="popup">
                {{#each this.f.menu.items key="value" as |item|}}
                  <m.Item
                    @value={{item.value}}
                    class="item"
                  >{{item.label}}</m.Item>
                {{/each}}
              </m.Content>
            </Menu>
          {{/if}}
          {{#if this.parts.nested}}
            <Popover as |n|>
              <n.Trigger>{{this.f.nested.trigger}}</n.Trigger>
              <n.Content class="popup">
                <n.Title class="title">{{this.f.nested.title}}</n.Title>
                <button
                  {{on "click" (fn this.setAction "archive")}}
                >{{this.f.nested.action}}</button>
              </n.Content>
            </Popover>
          {{/if}}
        </p.Content>
      </Popover>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <button {{on "click" this.openWithController}}>Open with controller</button>
      {{#if this.parts.shortcut}}
        <PopoverTrigger
          @controller={{this.controller}}
          @shortcut={{this.f.shortcut.remote.keys}}
          as |trigger|
        >
          {{this.f.shortcut.remote.trigger}}
          <trigger.Shortcut />
        </PopoverTrigger>
      {{/if}}
    </div>
  </template>
}
