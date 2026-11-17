import { element } from "@ember/helper"
import { on } from "@ember/modifier"
import type Owner from "@ember/owner"
import type { TOC } from "@ember/component/template-only"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { useAsyncOptions } from "ember-ui-sdk/async-options"
import { Combobox, type ListData } from "ember-ui-sdk/combobox"
import {
  cancelsValue,
  changedItems,
  comboboxFixture as f,
  comboboxOptions,
  createDelay,
  searchCountries,
  searchCountryPages,
} from "tests/fixtures/combobox.ts"
import { onItemsChange } from "tests/fixtures/items.ts"
import { longItems, serializeForm } from "tests/fixtures/select.ts"

type Parts = Record<string, unknown>
type Entry = ListData<unknown>[number]
type Item = {
  value: string
  label: string
  keywords?: string[]
  disabled?: boolean
}

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
      >{{@item.label}}</i.Text>{{else}}{{@item.label}}{{/if}}<i.Indicator
      class="indicator"
    >✓</i.Indicator></@parts.Item>
</template>

const asItem = (entry: Entry): Item => {
  if (typeof entry === "string") {
    return { value: entry, label: entry }
  }
  if (!("value" in entry) || typeof entry.value !== "string") {
    throw new Error("This fixture expects items with string values")
  }
  return { ...entry, value: entry.value }
}
const isItem = (entry: Entry) =>
  typeof entry === "string" || (typeof entry === "object" && "value" in entry)
const isSeparator = (entry: Entry) =>
  typeof entry === "object" && "type" in entry && entry.type === "separator"

class DataItems extends Component<{
  Args: {
    parts: Parts
    root: Parts
    entries: ListData<unknown>
    highlight?: boolean
  }
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

export default class ComboboxFixture extends Component<{
  Args: { data?: boolean }
}> {
  selectedValues = (value: unknown): string[] => {
    if (!Array.isArray(value)) {
      return []
    }
    return value.filter((item): item is string => typeof item === "string")
  }
  f = f
  options = comboboxOptions()
  @tracked action = ""
  @tracked submitted = ""
  @tracked created: { value: string; label: string }[] = []
  @tracked list: Item[] = f.items
  remoteMode = this.options.async || this.options.pages
  remote = useAsyncOptions(
    this,
    this.options.pages ? searchCountryPages : searchCountries,
    { immediate: this.remoteMode }
  )

  constructor(owner: Owner, args: ComboboxFixture["args"]) {
    super(owner, args)
    onItemsChange(changedItems, (next) => (this.list = next))
  }

  get all() {
    return [...this.list, ...this.created]
  }

  get labels() {
    return new Map(
      [...f.items, ...this.all].map((item) => [item.value, item.label])
    )
  }

  get items() {
    if (this.remoteMode) {
      return this.remote.state.items
    }
    if (this.options.long) {
      return longItems()
    }
    if (this.options.grouped) {
      return f.groups.map((group) => ({
        type: "group" as const,
        label: group.label,
        items: group.items,
      }))
    }
    return this.all
  }

  get dataMode() {
    return (
      this.args.data ||
      this.remoteMode ||
      this.options.long ||
      this.options.recent
    )
  }

  get chipsClass() {
    return this.options.overflow ? "chips chips-line" : "chips"
  }

  get contentClass() {
    return this.options.pages
      ? "popup list-popup list-short"
      : "popup list-popup"
  }

  labelOf = (value: string) => this.labels.get(value) ?? value
  removeLabel = (value: string) => `Remove ${this.labelOf(value)}`

  get itemToLabel() {
    return this.options.labelsFromItems ? undefined : this.labelOf
  }

  onValueChange = (value: unknown, details: { cancel: () => void }) => {
    if (cancelsValue(value, this.options.cancel)) {
      return details.cancel()
    }
    this.action = `value:${Array.isArray(value) ? value.join(",") : String(value)}`
  }

  onQueryChange = (query: string) => {
    if (this.remoteMode) {
      this.remote.setQuery(query)
    }
  }

  onLoadMore = () => {
    if (this.options.pages) {
      this.remote.loadMore()
    }
  }

  onCreate = async (query: string) => {
    this.action = `create:${query}`
    await createDelay(this.options.slow)
    this.created = [
      ...this.created,
      { value: query.toLowerCase(), label: query },
    ]
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
            <Combobox
              @multiple={{this.options.multiple}}
              @defaultValue={{this.options.defaultValue}}
              @maxSelected={{this.options.maxSelected}}
              @required={{this.options.required}}
              @readOnly={{this.options.readOnly}}
              @disabled={{this.options.disabled}}
              @autoHighlight={{this.options.autoHighlight}}
              @modal={{this.options.modal}}
              @presentation={{this.options.presentation}}
              @name={{f.name}}
              @container={{this.options.container}}
              @items={{if this.dataMode this.items}}
              @emptyItems={{if this.options.recent f.recent}}
              @filter={{if this.remoteMode false}}
              @status={{if this.remoteMode this.remote.state.status}}
              @itemToLabel={{this.itemToLabel}}
              @onValueChange={{this.onValueChange}}
              @onQueryChange={{this.onQueryChange}}
              @onLoadMore={{this.onLoadMore}}
              as |c|
            >
              <c.Label class="label">{{f.label}}</c.Label>
              {{#if this.options.multiple}}
                <c.Chips class={{this.chipsClass}}>
                  <c.Value as |state|>
                    {{#each
                      (this.selectedValues state.value) key="@identity"
                      as |item|
                    }}
                      <c.Chip class="chip" @value={{item}} as |chip|>
                        {{this.labelOf item}}
                        <chip.Remove
                          aria-label={{this.removeLabel item}}
                        >×</chip.Remove>
                      </c.Chip>
                    {{/each}}
                  </c.Value>
                  {{#if this.options.overflow}}<c.ChipsOverflow
                      class="chips-overflow"
                    />{{/if}}
                  <c.Input class="input" />
                </c.Chips>
              {{else}}
                <c.Input class="input" />
              {{/if}}
              {{#if this.options.summary}}<output
                  aria-label={{f.summary}}
                ><c.Value @maxLabels={{this.options.summary}} /></output>{{/if}}
              <c.Trigger aria-label={{f.trigger}}>▾</c.Trigger>
              <c.Clear>{{f.clear}}</c.Clear>
              <c.Content class={{this.contentClass}}>
                {{#unless this.options.nostatus}}
                  <c.Status class="status" as |status|>
                    {{~#if status.state.loading}}{{if
                        this.options.pages
                        "Loading more…"
                        "Loading…"
                      }}{{/if~}}
                  </c.Status>
                {{/unless}}
                <c.Empty class="empty">{{f.empty}}</c.Empty>
                {{#if this.dataMode}}
                  <c.List as |list|>
                    {{#if this.options.selectAll}}<c.SelectAll
                        class="item"
                      >{{f.selectAll}}</c.SelectAll>{{/if}}
                    <DataItems
                      @parts={{c}}
                      @root={{c}}
                      @entries={{list.state.items}}
                      @highlight={{this.options.highlight}}
                    />
                    {{#if this.options.create}}<c.Create
                        class="item"
                        @onCreate={{this.onCreate}}
                      />{{/if}}
                  </c.List>
                {{else}}
                  <c.List>
                    {{#if this.options.grouped}}
                      {{#each f.groups key="label" as |group|}}
                        <c.Group as |g|>
                          <g.Label class="label">{{group.label}}</g.Label>
                          {{#if this.options.selectAll}}<g.SelectAll
                              class="item"
                            >{{f.selectAll}}
                              {{group.label}}</g.SelectAll>{{/if}}
                          {{#each group.items key="value" as |item|}}
                            <ComposedItem
                              @parts={{g}}
                              @item={{item}}
                              @highlight={{this.options.highlight}}
                            />
                          {{/each}}
                        </c.Group>
                      {{/each}}
                    {{else}}
                      {{#if this.options.selectAll}}<c.SelectAll
                          class="item"
                        >{{f.selectAll}}</c.SelectAll>{{/if}}
                      {{#each this.all key="value" as |item|}}
                        <ComposedItem
                          @parts={{c}}
                          @item={{item}}
                          @highlight={{this.options.highlight}}
                        />
                      {{/each}}
                    {{/if}}
                    {{#if this.options.create}}<c.Create
                        class="item"
                        @onCreate={{this.onCreate}}
                      />{{/if}}
                  </c.List>
                {{/if}}
              </c.Content>
            </Combobox>
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
