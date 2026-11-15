import type { TOC } from "@ember/component/template-only"
import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Menu } from "ember-ui-sdk/menu"
import { NumberInput } from "ember-ui-sdk/number-input"
import { createToolbarController, Toolbar } from "ember-ui-sdk/toolbar"
import {
  toolbarFixture as f,
  toolbarLocked,
  toolbarOptions,
} from "tests/fixtures/toolbar.ts"

type Group = {
  label: string
  multiple: boolean
  defaultValue: string[]
  items: { value: string; label: string; disabled?: boolean }[]
}

const Toggles: TOC<{
  Args: {
    group: Group
    ToggleGroup: unknown
    Toggle: unknown
    onValueChange: (value: string[]) => void
  }
}> = <template>
  <@ToggleGroup
    class="toggle-group"
    aria-label={{@group.label}}
    @multiple={{@group.multiple}}
    @defaultValue={{@group.defaultValue}}
    @onValueChange={{@onValueChange}}
    as |g|
  >
    {{#each @group.items key="value" as |item|}}
      <g.Toggle
        class="toggle"
        @value={{item.value}}
        @disabled={{item.disabled}}
      >
        {{item.label}}
      </g.Toggle>
    {{/each}}
  </@ToggleGroup>
</template>

export default class ToolbarFixture extends Component {
  f = f
  controller = createToolbarController()
  options = toolbarOptions()
  lockable = toolbarLocked()
  groups = [
    { ...f.style, multiple: true },
    { ...f.alignment, multiple: false },
  ].map((group, index) => ({
    ...group,
    locked: toolbarLocked() && index === 0,
    separated: index < 2,
  }))
  @tracked action = ""
  @tracked locked = toolbarLocked()

  onGroup = (label: string, value: string[]) => {
    this.action = `${label}: ${value.join(", ") || "none"}`
  }
  onSpellcheck = (pressed: boolean) => {
    this.action = `spellcheck: ${pressed ? "on" : "off"}`
  }
  onFont = (value: string) => (this.action = `font: ${value}`)
  onSize = (value: number | null) => (this.action = `size: ${value}`)
  history = (label: string) => (this.action = label.toLowerCase())
  focus = () => this.controller.focus()
  unlock = () => (this.locked = false)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Toolbar
        class="toolbar"
        aria-label={{this.f.label}}
        @controller={{this.controller}}
        @orientation={{this.options.orientation}}
        @loop={{this.options.loop}}
        @disabled={{this.options.disabled}}
        as |t|
      >
        {{#each this.groups key="label" as |group|}}
          {{#if group.locked}}
            <t.Group
              aria-label="Locked style"
              @disabled={{this.locked}}
              as |tg|
            >
              <Toggles
                @group={{group}}
                @ToggleGroup={{tg.ToggleGroup}}
                @Toggle={{tg.Toggle}}
                @onValueChange={{fn this.onGroup group.label}}
              />
            </t.Group>
          {{else}}
            <Toggles
              @group={{group}}
              @ToggleGroup={{t.ToggleGroup}}
              @Toggle={{t.Toggle}}
              @onValueChange={{fn this.onGroup group.label}}
            />
          {{/if}}
          {{#if group.separated}}
            <t.Separator />
          {{/if}}
        {{/each}}
        <Menu @onAction={{this.onFont}} as |m|>
          <t.Button @render={{true}} as |b|>
            <m.Trigger {{b.part}}>{{this.f.font.trigger}}</m.Trigger>
          </t.Button>
          <m.Content class="popup">
            {{#each this.f.font.items key="@identity" as |item|}}
              <m.Item class="item" @value={{item}}>{{item}}</m.Item>
            {{/each}}
          </m.Content>
        </Menu>
        <NumberInput
          @defaultValue={{this.f.size.defaultValue}}
          @onValueChange={{this.onSize}}
          as |n|
        >
          <t.Input @render={{true}} as |i|>
            <n.Control {{i.part}} aria-label={{this.f.size.label}} />
          </t.Input>
        </NumberInput>
        <t.Input
          aria-label={{this.f.comment.label}}
          value={{this.f.comment.defaultValue}}
        />
        <t.Group
          class="toolbar-group"
          aria-label={{this.f.history.label}}
          @disabled={{if this.lockable this.locked}}
          as |tg|
        >
          {{#each this.f.history.items key="label" as |item|}}
            <tg.Button
              @disabled={{item.disabled}}
              {{on "click" (fn this.history item.label)}}
            >
              {{item.label}}
            </tg.Button>
          {{/each}}
        </t.Group>
        {{#if this.lockable}}
          <t.Group
            aria-label="Locked proofing"
            @disabled={{this.locked}}
            as |tg|
          >
            <tg.Toggle class="toggle" @onPressedChange={{this.onSpellcheck}}>
              {{this.f.spellcheck.label}}
            </tg.Toggle>
          </t.Group>
          <t.Group aria-label="Locked help" @disabled={{this.locked}} as |tg|>
            <tg.Link href={{this.f.help.href}}>{{this.f.help.label}}</tg.Link>
          </t.Group>
        {{else}}
          <t.Toggle class="toggle" @onPressedChange={{this.onSpellcheck}}>
            {{this.f.spellcheck.label}}
          </t.Toggle>
          <t.Link href={{this.f.help.href}}>{{this.f.help.label}}</t.Link>
        {{/if}}
      </Toolbar>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <button {{on "click" this.focus}}>Focus toolbar</button>
      <button {{on "click" this.unlock}}>Unlock</button>
    </div>
  </template>
}
