import { element, hash } from "@ember/helper"
import { on } from "@ember/modifier"
import type { TOC } from "@ember/component/template-only"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { createSelectController, type ListData } from "@ui-sdk/core/select"
import { Field } from "ember-ui-sdk/field"
import { Select, SelectTrigger } from "ember-ui-sdk/select"
import { onItemsChange } from "tests/fixtures/items.ts"
import {
  changedItems,
  longItems,
  selectFixture as f,
  selectOptions,
  serializeForm,
} from "tests/fixtures/select.ts"

type Parts = Record<string, unknown>
type Entry = ListData[number]

const FixtureItem: TOC<{
  Args: { parts: Parts; value: string; label: string; disabled?: boolean }
}> = <template>
  <@parts.Item class="item" @value={{@value}} @disabled={{@disabled}} as |item|>
    {{~! Svelte drops the whitespace between elements, which the specs' text reads. ~}}
    <item.Text>{{@label}}</item.Text>
    {{~!~}}
    <item.Indicator class="indicator">✓</item.Indicator>
    {{~!~}}
  </@parts.Item>
</template>

const isString = (entry: Entry) => typeof entry === "string"
const isItem = (entry: Entry) => typeof entry === "object" && "value" in entry
const isSeparator = (entry: Entry) =>
  typeof entry === "object" && "type" in entry && entry.type === "separator"

class DataItems extends Component<{
  Args: { parts: Parts; select: Parts; entries: ListData }
}> {
  isString = isString
  isItem = isItem
  isSeparator = isSeparator

  <template>
    {{#each @entries as |entry|}}
      {{#if (this.isString entry)}}
        <FixtureItem @parts={{@parts}} @value={{entry}} @label={{entry}} />
      {{else if (this.isItem entry)}}
        <FixtureItem
          @parts={{@parts}}
          @value={{entry.value}}
          @label={{entry.label}}
          @disabled={{entry.disabled}}
        />
      {{else if (this.isSeparator entry)}}
        <@select.Separator class="separator" />
      {{else}}
        <@select.Group as |g|>
          <g.Label class="label">{{entry.label}}</g.Label>
          <DataItems
            @parts={{g}}
            @select={{@select}}
            @entries={{entry.items}}
          />
        </@select.Group>
      {{/if}}
    {{/each}}
  </template>
}

type Listed = {
  separator?: boolean
  group?: boolean
  value: string
  label: string
  disabled?: boolean
  items?: { value: string; label: string }[]
}

const Composed: TOC<{
  Args: { s: Parts; listed: Listed[]; selectAll: boolean }
}> = <template>
  {{#each @listed as |item|}}
    {{#if item.separator}}
      <@s.Separator class="separator" />
    {{else if item.group}}
      <@s.Group as |g|>
        <g.Label class="label">{{item.label}}</g.Label>
        {{#if @selectAll}}<g.SelectAll class="item">{{f.selectAll}}
            {{item.label}}</g.SelectAll>{{/if}}
        {{#each item.items key="value" as |child|}}
          <FixtureItem
            @parts={{g}}
            @value={{child.value}}
            @label={{child.label}}
          />
        {{/each}}
      </@s.Group>
    {{else}}
      <FixtureItem
        @parts={{@s}}
        @value={{item.value}}
        @label={{item.label}}
        @disabled={{item.disabled}}
      />
    {{/if}}
  {{/each}}
</template>

export default class SelectFixture extends Component<{
  Args: { data?: boolean }
}> {
  f = f
  controller = createSelectController<string, boolean>()
  options = selectOptions()
  @tracked action = ""
  @tracked submitted = ""
  @tracked list: { value: string; label: string; disabled?: boolean }[] =
    f.items

  constructor(owner: Owner, args: SelectFixture["args"]) {
    super(owner, args)
    onItemsChange(changedItems, (next) => (this.list = next))
  }

  get fromData() {
    return this.args.data || this.options.long || this.options.recent
  }

  get items() {
    if (this.options.long) {
      return longItems()
    }
    if (this.options.grouped) {
      return [
        {
          type: "group" as const,
          label: f.groups[0].label,
          items: f.groups[0].items,
        },
        { type: "separator" as const },
        {
          type: "group" as const,
          label: f.groups[1].label,
          items: f.groups[1].items,
        },
      ]
    }
    return this.list
  }

  get listed() {
    if (this.options.grouped) {
      return f.groups.flatMap((group, index) => [
        ...(index ? [{ separator: true }] : []),
        { group: true, label: group.label, items: group.items },
      ]) as Listed[]
    }
    return this.list as Listed[]
  }

  get showSelectAll() {
    return this.options.selectAll && !this.options.grouped
  }

  onValueChange = (value: unknown, details: { cancel: () => void }) => {
    if (this.options.cancel) {
      return details.cancel()
    }
    this.action = `value:${Array.isArray(value) ? value.join(",") : String(value)}`
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = serializeForm(event.target as HTMLFormElement)
  }

  openWithController = () => this.controller.open()

  get wrapperTag() {
    return this.options.fieldset ? "fieldset" : "div"
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <form
        class="select-form"
        aria-label={{f.formLabel}}
        {{on "submit" this.onSubmit}}
      >
        {{! @glint-expect-error the element helper types lack a call signature }}
        {{#let (element this.wrapperTag) as |Wrapper|}}
          <Wrapper
            disabled={{if this.options.fieldset true}}
            style="display: contents"
          >
            {{#if this.options.field}}
              <Field as |field|>
                <field.Label class="label">{{f.label}}</field.Label>
                <SelectTrigger
                  class="trigger"
                  @controller={{this.controller}}
                  @field={{field.field}}
                  as |trigger|
                >
                  <trigger.Value
                    class="value"
                    @maxLabels={{this.options.max}}
                  />
                  <span aria-hidden="true">▾</span>
                </SelectTrigger>
              </Field>
            {{/if}}
            <Select
              @multiple={{this.options.multiple}}
              @defaultValue={{this.options.defaultValue}}
              @required={{this.options.required}}
              @readOnly={{this.options.readOnly}}
              @disabled={{this.options.disabled}}
              @virtualFocus={{this.options.virtualFocus}}
              @defaultOpen={{this.options.defaultOpen}}
              @modal={{this.options.modal}}
              @presentation={{this.options.presentation}}
              @name={{f.name}}
              @placeholder={{f.placeholder}}
              @controller={{this.controller}}
              @container={{this.options.container}}
              @items={{if this.fromData this.items}}
              @emptyItems={{if this.options.recent f.recent}}
              @onValueChange={{this.onValueChange}}
              as |s|
            >
              {{#unless this.options.field}}
                <s.Label class="label">{{f.label}}</s.Label>
                <s.Trigger class="trigger" as |trigger|>
                  <trigger.Value
                    class="value"
                    @maxLabels={{this.options.max}}
                  />
                  <span aria-hidden="true">▾</span>
                </s.Trigger>
              {{/unless}}
              <s.Clear>{{f.clear}}</s.Clear>
              {{#if this.options.search}}
                <s.Content
                  class="popup list-popup"
                  @alignItemWithTrigger={{this.options.align}}
                >
                  <s.Input class="input" aria-label={{f.search}} />
                  <s.Empty class="empty">{{f.empty}}</s.Empty>
                  <s.List as |list|>
                    {{#if this.showSelectAll}}<s.SelectAll
                        class="item"
                      >{{f.selectAll}}</s.SelectAll>{{/if}}
                    {{#if this.fromData}}
                      <DataItems
                        @parts={{s}}
                        @select={{s}}
                        @entries={{list.state.items}}
                      />
                    {{else}}
                      <Composed
                        @s={{s}}
                        @listed={{this.listed}}
                        @selectAll={{this.options.selectAll}}
                      />
                    {{/if}}
                  </s.List>
                </s.Content>
              {{else if this.fromData}}
                <s.Content class="popup list-popup" as |content|>
                  {{#if this.options.selectAll}}<s.SelectAll
                      class="item"
                    >{{f.selectAll}}</s.SelectAll>{{/if}}
                  <DataItems
                    @parts={{s}}
                    @select={{s}}
                    @entries={{content.state.items}}
                  />
                </s.Content>
              {{else}}
                <s.Content
                  class="popup list-popup"
                  @alignItemWithTrigger={{this.options.align}}
                >
                  {{#if this.showSelectAll}}<s.SelectAll
                      class="item"
                    >{{f.selectAll}}</s.SelectAll>{{/if}}
                  <Composed
                    @s={{s}}
                    @listed={{this.listed}}
                    @selectAll={{this.options.selectAll}}
                  />
                </s.Content>
              {{/if}}
            </Select>
          </Wrapper>
        {{/let}}
        <button type="submit">Submit</button>
        <button type="reset">Reset</button>
      </form>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Submitted">{{this.submitted}}</output>
      <button {{on "click" this.openWithController}}>Open with controller</button>
    </div>
  </template>
}
