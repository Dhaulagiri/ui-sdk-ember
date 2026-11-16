import type { TOC } from "@ember/component/template-only"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Command, type CommandData } from "ember-ui-sdk/command"
import {
  commandData,
  commandFixture as f,
  commandOptions,
  runAction,
} from "tests/fixtures/command.ts"
import { longItems } from "tests/fixtures/select.ts"

type Parts = Record<string, unknown>
type Entry = CommandData[number]
type Cmd = {
  value: string
  label: string
  keywords?: string[]
  disabled?: boolean
  page?: string
  shortcut?: string
}

const asItem = (entry: Entry) =>
  (typeof entry === "string" ? { value: entry, label: entry } : entry) as Cmd
const isItem = (entry: Entry) =>
  typeof entry === "string" || (typeof entry === "object" && "value" in entry)
const isSeparator = (entry: Entry) =>
  typeof entry === "object" && "type" in entry && entry.type === "separator"
const hasShortcut = (item: object) => "shortcut" in item

const DataCommand: TOC<{
  Args: { parts: Parts; command: Cmd; highlight?: boolean }
}> = <template>
  <@parts.Item
    class="item"
    @value={{@command.value}}
    @label={{@command.label}}
    @keywords={{@command.keywords}}
    @disabled={{@command.disabled}}
    @shortcut={{@command.shortcut}}
    as |i|
  >{{#if @highlight}}<i.Text
      >{{@command.label}}</i.Text>{{else}}{{@command.label}}{{/if}}{{#if
      @command.shortcut
    }}<i.Shortcut class="shortcut" />{{/if}}</@parts.Item>
</template>

class DataCommands extends Component<{
  Args: { parts: Parts; root: Parts; entries: CommandData; highlight?: boolean }
}> {
  asItem = asItem
  isItem = isItem
  isSeparator = isSeparator

  <template>
    {{#each @entries as |entry|}}
      {{#if (this.isItem entry)}}
        <DataCommand
          @parts={{@parts}}
          @command={{this.asItem entry}}
          @highlight={{@highlight}}
        />
      {{else if (this.isSeparator entry)}}
        <@root.Separator class="separator" />
      {{else}}
        <@root.Group as |g|>
          {{#if entry.label}}<g.Label
              class="label"
            >{{entry.label}}</g.Label>{{/if}}
          <DataCommands
            @parts={{g}}
            @root={{@root}}
            @entries={{entry.items}}
            @highlight={{@highlight}}
          />
        </@root.Group>
      {{/if}}
    {{/each}}
  </template>
}

export default class CommandFixture extends Component<{
  Args: { data?: boolean }
}> {
  f: { groups: { label: string; items: Cmd[] }[] } & Omit<typeof f, "groups"> =
    f
  options = commandOptions()
  hasShortcut = hasShortcut
  @tracked action = ""
  @tracked lastHighlight = ""

  get items() {
    return this.options.long
      ? longItems()
      : this.args.data
        ? commandData()
        : undefined
  }

  onAction = (value: string) => {
    this.action = `action:${value}`
    return runAction(this.options.slow, this.options.fail)
  }

  onValueChange = (value: string | null, details: { reason: string }) => {
    this.lastHighlight = `${value}:${details.reason}`
  }

  value = (item: { value: string }) =>
    this.options.unvalued ? undefined : item.value

  <template>
    <div class="fixture">
      <button>Before</button>
      <Command
        class="command"
        @defaultValue={{this.options.defaultValue}}
        @defaultPages={{this.options.defaultPages}}
        @autoHighlight={{this.options.autoHighlight}}
        @filter={{this.options.filter}}
        @status={{this.options.status}}
        @items={{this.items}}
        @onAction={{this.onAction}}
        @onValueChange={{this.onValueChange}}
        as |c|
      >
        <c.Input class="input" aria-label={{f.input}} />
        <c.Empty class="empty">{{f.empty}}</c.Empty>
        <c.Status class="status" as |status|>
          {{~#if status.state.loading}}Loading…{{/if~}}
        </c.Status>
        {{#if this.items}}
          <c.List class="command-list" as |list|>
            <DataCommands
              @parts={{c}}
              @root={{c}}
              @entries={{list.state.items}}
              @highlight={{this.options.highlight}}
            />
          </c.List>
        {{else}}
          <c.List class="command-list">
            <c.Page as |p|>
              {{#each this.f.groups key="label" as |group index|}}
                {{#if index}}<p.Separator class="separator" />{{/if}}
                <p.Group as |g|>
                  <g.Label class="label">{{group.label}}</g.Label>
                  {{#each group.items key="value" as |item|}}
                    <g.Item
                      class="item"
                      @value={{this.value item}}
                      @keywords={{item.keywords}}
                      @disabled={{item.disabled}}
                      @shortcut={{item.shortcut}}
                      @page={{item.page}}
                      as |i|
                    >{{#if this.options.highlight}}<i.Text
                        >{{item.label}}</i.Text>{{else}}{{item.label}}{{/if}}{{#if
                        item.shortcut
                      }}<i.Shortcut class="shortcut" />{{/if}}</g.Item>
                  {{/each}}
                </p.Group>
              {{/each}}
            </c.Page>
            <c.Page @value="theme" as |p|>
              {{#each f.theme key="value" as |item|}}
                <p.Item
                  class="item"
                  @value={{item.value}}
                >{{item.label}}</p.Item>
              {{/each}}
            </c.Page>
          </c.List>
        {{/if}}
      </Command>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output
        role="status"
        aria-label="Last highlight"
      >{{this.lastHighlight}}</output>
    </div>
  </template>
}
