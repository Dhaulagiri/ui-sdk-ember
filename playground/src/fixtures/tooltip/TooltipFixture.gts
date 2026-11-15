import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { createTooltipController } from "@ui-sdk/core/tooltip"
import { Popover } from "ember-ui-sdk/popover"
import { Tooltip, TooltipTrigger } from "ember-ui-sdk/tooltip"
import {
  tooltipContentOptions,
  tooltipFixture,
  tooltipOptions,
  tooltipParts,
} from "tests/fixtures/tooltip.ts"

export default class TooltipFixture extends Component {
  controller = createTooltipController()
  o = tooltipOptions()
  content = tooltipContentOptions()
  parts = tooltipParts()
  f = tooltipFixture
  @tracked action = ""

  save = () => (this.action = "save")
  openWithController = () => this.controller.open()
  publishPress = (event: MouseEvent) => {
    if (
      (event.currentTarget as HTMLElement).getAttribute("aria-disabled") !==
      "true"
    ) {
      this.action = this.f.publish.action
    }
  }

  get nativeDisabled() {
    return this.parts.nativeDisabled || undefined
  }

  <template>
    <div class="fixture tooltip-page">
      <button>Before</button>
      <Tooltip
        @delay={{this.o.delay}}
        @closeDelay={{this.o.closeDelay}}
        @toggleable={{this.o.toggleable}}
        @closeOnPress={{this.o.closeOnPress}}
        @type={{this.o.type}}
        @disabled={{this.o.disabled}}
        @container={{this.o.container}}
        @controller={{this.controller}}
        @defaultOpen={{this.parts.open}}
        @shortcut={{this.f.save.shortcut}}
        as |t|
      >
        <t.Trigger disabled={{this.nativeDisabled}} {{on "click" this.save}}>
          {{this.f.save.trigger}}
        </t.Trigger>
        <t.Content
          class="tooltip"
          @side={{this.content.side}}
          @align={{this.content.align}}
        >
          <t.Arrow class="arrow" />
          {{this.f.save.content}}
          <t.Shortcut />
        </t.Content>
      </Tooltip>
      <div class="toolbar" role="group" aria-label="Formatting">
        {{#each this.f.toolbar key="content" as |item|}}
          <Tooltip
            @delay={{this.o.delay}}
            @closeDelay={{this.o.closeDelay}}
            @toggleable={{this.o.toggleable}}
            @closeOnPress={{this.o.closeOnPress}}
            @type={{this.o.type}}
            @disabled={{this.o.disabled}}
            @container={{this.o.container}}
            as |t|
          >
            <t.Trigger>
              <span aria-hidden="true">{{item.icon}}</span>
            </t.Trigger>
            <t.Content class="tooltip">{{item.content}}</t.Content>
          </Tooltip>
        {{/each}}
      </div>
      <Popover @container={{this.o.container}} as |p|>
        <Tooltip
          @delay={{this.o.delay}}
          @closeDelay={{this.o.closeDelay}}
          @toggleable={{this.o.toggleable}}
          @closeOnPress={{this.o.closeOnPress}}
          @type={{this.o.type}}
          @disabled={{this.o.disabled}}
          @container={{this.o.container}}
          as |t|
        >
          <t.Trigger @render={{true}} as |trigger|>
            <p.Trigger {{trigger.part}}>{{this.f.profile.trigger}}</p.Trigger>
          </t.Trigger>
          <t.Content class="tooltip">{{this.f.profile.content}}</t.Content>
        </Tooltip>
        <p.Content class="popup" @sideOffset={{8}}>
          <p.Title class="title">{{this.f.profile.popover}}</p.Title>
          <div class="actions">
            <Tooltip
              @delay={{this.o.delay}}
              @closeDelay={{this.o.closeDelay}}
              @toggleable={{this.o.toggleable}}
              @closeOnPress={{this.o.closeOnPress}}
              @type={{this.o.type}}
              @disabled={{this.o.disabled}}
              @container={{this.o.container}}
              as |t|
            >
              <t.Trigger>{{this.f.profile.help.trigger}}</t.Trigger>
              <t.Content
                class="tooltip"
              >{{this.f.profile.help.content}}</t.Content>
            </Tooltip>
            <p.Close>{{this.f.profile.close}}</p.Close>
          </div>
        </p.Content>
      </Popover>
      <Tooltip
        @delay={{this.o.delay}}
        @closeDelay={{this.o.closeDelay}}
        @closeOnPress={{this.o.closeOnPress}}
        @type={{this.o.type}}
        @disabled={{this.o.disabled}}
        @container={{this.o.container}}
        @toggleable={{true}}
        as |t|
      >
        <t.Trigger aria-label={{this.f.info.trigger}}>
          <span aria-hidden="true">i</span>
        </t.Trigger>
        <t.Content class="tooltip">{{this.f.info.content}}</t.Content>
      </Tooltip>
      {{#if this.parts.disabled}}
        <Tooltip
          @delay={{this.o.delay}}
          @closeDelay={{this.o.closeDelay}}
          @toggleable={{this.o.toggleable}}
          @closeOnPress={{this.o.closeOnPress}}
          @type={{this.o.type}}
          @disabled={{this.o.disabled}}
          @container={{this.o.container}}
          as |t|
        >
          <t.Trigger
            aria-disabled="true"
            {{on "click" this.publishPress}}
          >{{this.f.publish.trigger}}</t.Trigger>
          <t.Content class="tooltip">{{this.f.publish.content}}</t.Content>
        </Tooltip>
      {{/if}}
      {{#if this.parts.iconPopover}}
        <Popover @container={{this.o.container}} as |p|>
          <Tooltip
            @delay={{this.o.delay}}
            @closeDelay={{this.o.closeDelay}}
            @toggleable={{this.o.toggleable}}
            @closeOnPress={{this.o.closeOnPress}}
            @type={{this.o.type}}
            @disabled={{this.o.disabled}}
            @container={{this.o.container}}
            as |t|
          >
            <t.Trigger @render={{true}} as |trigger|>
              <p.Trigger {{trigger.part}}>
                <span aria-hidden="true">{{this.f.iconPopover.icon}}</span>
              </p.Trigger>
            </t.Trigger>
            <t.Content
              class="tooltip"
            >{{this.f.iconPopover.content}}</t.Content>
          </Tooltip>
          <p.Content class="popup">{{this.f.iconPopover.popover}}</p.Content>
        </Popover>
        <Popover @container={{this.o.container}} as |p|>
          <p.Trigger>
            <span aria-hidden="true">{{this.f.iconPopover.unnamed}}</span>
          </p.Trigger>
          <p.Content class="popup">{{this.f.iconPopover.popover}}</p.Content>
        </Popover>
      {{/if}}
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <button {{on "click" this.openWithController}}>Open with controller</button>
      {{#if this.parts.shortcut}}
        <TooltipTrigger @controller={{this.controller}} as |trigger|>
          {{this.f.shortcut.trigger}}
          <trigger.Shortcut />
        </TooltipTrigger>
      {{/if}}
    </div>
  </template>
}
