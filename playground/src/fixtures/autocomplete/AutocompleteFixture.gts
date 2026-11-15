import { element } from "@ember/helper"
import { on } from "@ember/modifier"
import type { TOC } from "@ember/component/template-only"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Autocomplete, type ListData } from "ember-ui-sdk/autocomplete"
import {
  autocompleteFixture as f,
  autocompleteOptions,
  changedItems,
  searchFruits,
} from "tests/fixtures/autocomplete.ts"
import { onItemsChange } from "tests/fixtures/items.ts"
import { serializeForm } from "tests/fixtures/select.ts"

type Parts = Record<string, unknown>
type Entry = ListData[number]
type Item = {
  value: string
  label: string
  keywords?: string[]
  disabled?: boolean
}

const asItem = (entry: Entry) =>
  (typeof entry === "string" ? { value: entry, label: entry } : entry) as Item
const isItem = (entry: Entry) =>
  typeof entry === "string" || (typeof entry === "object" && "value" in entry)
const isSeparator = (entry: Entry) =>
  typeof entry === "object" && "type" in entry && entry.type === "separator"

const ComposedItem: TOC<{
  Args: { parts: Parts; item: Item; highlight?: boolean }
}> = <template>
  <@parts.Item
    class="item"
    @value={{@item.value}}
    @label={{@item.label}}
    @keywords={{@item.keywords}}
    @disabled={{@item.disabled}}
    as |i|
  >{{#if @highlight}}<i.Text
      >{{@item.label}}</i.Text>{{else}}{{@item.label}}{{/if}}</@parts.Item>
</template>

class DataItems extends Component<{
  Args: { parts: Parts; root: Parts; entries: ListData; highlight?: boolean }
}> {
  asItem = asItem
  isItem = isItem
  isSeparator = isSeparator

  <template>
    {{#each @entries as |entry|}}
      {{#if (this.isItem entry)}}
        <ComposedItem
          @parts={{@parts}}
          @item={{this.asItem entry}}
          @highlight={{@highlight}}
        />
      {{else if (this.isSeparator entry)}}
        <@root.Separator />
      {{else}}
        <@root.Group as |g|>
          <g.Label class="label">{{entry.label}}</g.Label>
          <DataItems
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

export default class AutocompleteFixture extends Component<{
  Args: { data?: boolean }
}> {
  f = f
  options = autocompleteOptions()
  @tracked action = ""
  @tracked submitted = ""
  @tracked list: Item[] = f.items
  remote = useAsyncOptions(this, searchFruits, {
    immediate: this.options.async,
  })

  constructor(owner: Owner, args: AutocompleteFixture["args"]) {
    super(owner, args)
    onItemsChange(changedItems, (next) => (this.list = next))
  }

  get items() {
    if (this.options.async) {
      return this.remote.state.items
    }
    if (this.options.grouped) {
      return f.groups.map((group) => ({
        type: "group" as const,
        label: group.label,
        items: group.items,
      }))
    }
    return this.list
  }

  get dataMode() {
    return this.args.data || this.options.async || this.options.recent
  }

  onValueChange = (value: string, details: { reason: string }) => {
    this.action = `value:${value}:${details.reason}`
    if (this.options.async) {
      this.remote.setQuery(value)
    }
  }

  onAutocompleteSubmit = (value: string) => {
    this.action = `submit:${value}`
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = serializeForm(event.target as HTMLFormElement)
  }

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
            <Autocomplete
              @defaultValue={{this.options.defaultValue}}
              @inlineComplete={{this.options.inlineComplete}}
              @autoHighlight={{this.options.autoHighlight}}
              @openOnFocus={{this.options.openOnFocus}}
              @submitOnSelect={{this.options.submitOnSelect}}
              @required={{this.options.required}}
              @readOnly={{this.options.readOnly}}
              @disabled={{this.options.disabled}}
              @presentation={{this.options.presentation}}
              @name={{f.name}}
              @container={{this.options.container}}
              @items={{if this.dataMode this.items}}
              @emptyItems={{if this.options.recent f.recent}}
              @filter={{if this.options.async false}}
              @status={{if this.options.async this.remote.state.status}}
              @onValueChange={{this.onValueChange}}
              @onSubmit={{this.onAutocompleteSubmit}}
              as |c|
            >
              <c.Label class="label">{{f.label}}</c.Label>
              <c.Input class="input" />
              <c.Trigger aria-label={{f.trigger}}>▾</c.Trigger>
              <c.Clear>{{f.clear}}</c.Clear>
              <c.Content class="popup list-popup">
                {{#unless this.options.nostatus}}
                  <c.Status class="status" as |status|>
                    {{~#if status.state.loading}}Loading…{{/if~}}
                  </c.Status>
                {{/unless}}
                <c.Empty class="empty">{{f.empty}}</c.Empty>
                {{#if this.dataMode}}
                  <c.List as |list|>
                    <DataItems
                      @parts={{c}}
                      @root={{c}}
                      @entries={{list.state.items}}
                      @highlight={{this.options.highlight}}
                    />
                  </c.List>
                {{else}}
                  <c.List>
                    {{#if this.options.grouped}}
                      {{#each f.groups key="label" as |group|}}
                        <c.Group as |g|>
                          <g.Label class="label">{{group.label}}</g.Label>
                          {{#each group.items key="value" as |item|}}
                            <g.Item
                              class="item"
                              @value={{item.value}}
                              @label={{item.label}}
                            >{{item.label}}</g.Item>
                          {{/each}}
                        </c.Group>
                      {{/each}}
                    {{else}}
                      {{#each this.list key="value" as |item|}}
                        <ComposedItem
                          @parts={{c}}
                          @item={{item}}
                          @highlight={{this.options.highlight}}
                        />
                      {{/each}}
                    {{/if}}
                  </c.List>
                {{/if}}
              </c.Content>
            </Autocomplete>
          </Wrapper>
        {{/let}}
        <button type="submit">Submit</button>
        <button type="reset">Reset</button>
      </form>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Submitted">{{this.submitted}}</output>
    </div>
  </template>
}
