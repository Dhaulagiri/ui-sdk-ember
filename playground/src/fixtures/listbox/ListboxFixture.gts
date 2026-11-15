import { element } from "@ember/helper"
import { on } from "@ember/modifier"
import type Owner from "@ember/owner"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { createListboxController, Listbox } from "ember-ui-sdk/listbox"
import { onItemsChange } from "tests/fixtures/items.ts"
import {
  changedToppings,
  listboxAction,
  listboxData,
  listboxFixture as f,
  listboxOptions,
  longToppings,
} from "tests/fixtures/listbox.ts"
import { serializeForm } from "tests/fixtures/select.ts"

type Listed =
  | {
      type: "item"
      key: string
      value: string
      label: string
      disabled?: boolean
    }
  | {
      type: "group"
      key: string
      label: string
      items: { value: string; label: string }[]
    }
  | { type: "separator"; key: string }

const isSeparator = (item: Listed) => item.type === "separator"
const isGroup = (item: Listed) => item.type === "group"

export default class ListboxFixture extends Component<{
  Args: { data?: boolean }
}> {
  f = f
  isSeparator = isSeparator
  isGroup = isGroup
  controller = createListboxController<string, boolean>()
  options = listboxOptions()
  @tracked action = ""
  @tracked reason = ""
  @tracked submitted = ""
  @tracked value: unknown =
    this.options.defaultValue ?? (this.options.multiple ? [] : null)
  @tracked list = f.items

  constructor(owner: Owner, args: ListboxFixture["args"]) {
    super(owner, args)
    onItemsChange(changedToppings, (next) => (this.list = next))
  }

  get items() {
    const { long, grouped } = this.options
    return long ? longToppings() : grouped ? listboxData(true) : this.list
  }

  get listed(): Listed[] {
    if (this.options.grouped) {
      return f.groups.flatMap((group, index): Listed[] => [
        ...(index
          ? [{ type: "separator" as const, key: `separator-${index}` }]
          : []),
        {
          type: "group",
          key: group.label,
          label: group.label,
          items: group.items,
        },
      ])
    }
    return (this.options.long ? longToppings() : this.list).map((item) => ({
      type: "item",
      key: item.value,
      ...item,
    }))
  }

  get controlledValue() {
    return this.options.controlled ? this.value : undefined
  }

  get defaultValue() {
    return this.options.controlled ? undefined : this.options.defaultValue
  }

  onValueChange = (
    next: unknown,
    details: { reason: string; cancel: () => void }
  ) => {
    this.reason = details.reason
    if (this.options.cancel) {
      return details.cancel()
    }
    this.value = next
    this.action = listboxAction(next)
  }

  onSubmit = (event: SubmitEvent) => {
    event.preventDefault()
    this.submitted = serializeForm(event.target as HTMLFormElement)
  }

  clear = () => this.controller.clear()
  selectAll = () => this.controller.selectAll()

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
            <Listbox
              class="listbox"
              aria-label={{f.label}}
              @multiple={{this.options.multiple}}
              @activation={{this.options.activation}}
              @orientation={{this.options.orientation}}
              @loop={{this.options.loop}}
              @deselectable={{this.options.deselectable}}
              @required={{this.options.required}}
              @readOnly={{this.options.readOnly}}
              @disabled={{this.options.disabled}}
              @value={{this.controlledValue}}
              @defaultValue={{this.defaultValue}}
              @name={{f.name}}
              @controller={{this.controller}}
              @items={{if @data this.items}}
              @onValueChange={{this.onValueChange}}
              as |l|
            >
              {{#each this.listed key="key" as |item|}}
                {{#if (this.isSeparator item)}}
                  <l.Separator class="separator" />
                {{else if (this.isGroup item)}}
                  <l.Group class="group" as |g|>
                    <g.Label class="label">{{item.label}}</g.Label>
                    {{#each item.items key="value" as |child|}}
                      <g.Item class="item" @value={{child.value}} as |i|>
                        <i.Icon class="icon" />
                        {{child.label}}
                        <i.Indicator class="indicator">✓</i.Indicator>
                      </g.Item>
                    {{/each}}
                  </l.Group>
                {{else}}
                  <l.Item
                    class="item"
                    @value={{item.value}}
                    @disabled={{item.disabled}}
                    as |i|
                  >
                    <i.Icon class="icon" />
                    {{item.label}}
                    <i.Indicator class="indicator">✓</i.Indicator>
                  </l.Item>
                {{/if}}
              {{/each}}
            </Listbox>
          </Wrapper>
        {{/let}}
        <button type="submit">Submit</button>
        <button type="reset">Reset</button>
      </form>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output role="status" aria-label="Reason">{{this.reason}}</output>
      <output role="status" aria-label="Submitted">{{this.submitted}}</output>
      <button {{on "click" this.clear}}>{{f.clear}}</button>
      <button {{on "click" this.selectAll}}>{{f.selectAll}}</button>
    </div>
  </template>
}
