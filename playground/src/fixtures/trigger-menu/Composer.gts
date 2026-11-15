import Component from "@glimmer/component"
import { Textarea } from "ember-ui-sdk/textarea"
import { TriggerMenu } from "ember-ui-sdk/trigger-menu"
import {
  fixtureTriggers,
  selectAction,
  triggerMenuFixture as f,
  triggerMenuOptions,
} from "tests/fixtures/trigger-menu.ts"

let count = 0

export default class Composer extends Component<{
  Args: {
    name: string
    onAction: (value: string) => void
    onOpen: (value: string) => void
  }
}> {
  f = f
  options = triggerMenuOptions()
  triggers = fixtureTriggers()
  id = `composer-${++count}`

  get custom() {
    return this.options.input || this.options.textarea
  }

  onOpenChange = (open: boolean, details: { reason: string }) =>
    this.args.onOpen(`${open}:${details.reason}`)

  onSelect = (value: unknown, details: { arguments: Record<string, string> }) =>
    this.args.onAction(selectAction(value, details.arguments))

  <template>
    <TriggerMenu
      @triggers={{this.triggers}}
      @autoHighlight={{this.options.autoHighlight}}
      @onOpenChange={{this.onOpenChange}}
      @onSelect={{this.onSelect}}
      as |t|
    >
      <label class="label" for={{this.id}}>{{@name}}</label>
      {{#if this.custom}}
        <t.Input @render={{true}} as |i|>
          {{#if this.options.input}}
            <input id={{this.id}} name="message" class="input" {{i.part}} />
          {{else}}
            <Textarea id={{this.id}} name="message" class="input" {{i.part}} />
          {{/if}}
        </t.Input>
      {{else}}
        <t.Input id={{this.id}} name="message" class="input" />
      {{/if}}
      <t.Hint class="hint" />
      <t.Status class="status" />
      <t.Content class="popup list-popup">
        {{#if this.options.empty}}<t.Empty
            class="empty"
          >{{f.empty}}</t.Empty>{{/if}}
        <t.List as |list|>
          {{#each list.state.items key="value" as |item|}}
            <t.Item
              class="item"
              @value={{item.value}}
              @label={{item.label}}
              @disabled={{item.disabled}}
            >{{item.label}}</t.Item>
          {{/each}}
        </t.List>
      </t.Content>
    </TriggerMenu>
  </template>
}
