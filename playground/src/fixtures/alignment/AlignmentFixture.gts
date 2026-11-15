import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import {
  createMenuController,
  Menu,
  MenuTrigger,
  type MenuData,
} from "ember-ui-sdk/menu"
import { createPopoverController, Popover } from "ember-ui-sdk/popover"
import { createTabsController, Tabs } from "ember-ui-sdk/tabs"
import { alignmentFixture, alignmentOptions } from "tests/fixtures/alignment.ts"

const dataItems = [
  { type: "checkbox", value: "grid", label: "Grid" },
  {
    type: "radio-group",
    name: "sort",
    items: [
      { value: "name", label: "Name" },
      { value: "date", label: "Date" },
    ],
  },
]

const isCheckbox = (entry: { type: string }) => entry.type === "checkbox"
const isRadioGroup = (entry: { type: string }) => entry.type === "radio-group"
const lower = (value: string) => value.toLowerCase()

export default class AlignmentFixture extends Component {
  f = alignmentFixture
  rowMenu = createMenuController<string>()
  details = createPopoverController<string>()
  sections = createTabsController()
  keepMounted = alignmentOptions().keepMounted
  dataItems = dataItems
  menuData = dataItems as MenuData
  isCheckbox = isCheckbox
  isRadioGroup = isRadioGroup
  lower = lower
  ruler = ["ruler", "guides"]
  @tracked action = ""
  @tracked result = ""
  @tracked complete = ""
  @tracked change = ""
  @tracked tabChanges = 0

  label = (row: string) => `Actions for ${row}`
  rulerLabel = (value: string) => (value === "ruler" ? "Ruler" : "Guides")

  showDetails = (payload: string) => {
    this.details.open({ payload }).then((closed) => {
      this.result = `${closed.reason}:${closed.returnValue ?? ""}`
    })
  }

  showButton = () => this.showDetails("button")
  onSelect = (value: string) => () => {
    if (value === "details") {
      this.showDetails(String(this.rowMenu.getPayload()))
    }
  }

  onRowAction = (value: string) => {
    this.action = `${value}:${this.rowMenu.getPayload()}`
  }
  onRowComplete = (open: boolean) => (this.complete = open ? "open" : "closed")
  setAction = (value: string) => (this.action = value)
  onChecked = (checked: boolean, details: { value: string }) => {
    this.change = `checked:${details.value}:${checked}`
  }
  onValue = (value: string, details: { group: string }) => {
    this.change = `value:${details.group}:${value}`
  }
  onTabChange = () => this.tabChanges++
  showLast = () => this.sections.select("hotel")

  <template>
    <div class="fixture">
      <button>Before</button>

      <ul class="rows">
        {{#each this.f.rows key="@identity" as |row|}}
          <li>
            Row
            {{row}}
            <MenuTrigger
              @controller={{this.rowMenu}}
              @payload={{row}}
              aria-label={{this.label row}}
            >…</MenuTrigger>
          </li>
        {{/each}}
      </ul>
      <Menu
        @controller={{this.rowMenu}}
        @onAction={{this.onRowAction}}
        @onOpenChangeComplete={{this.onRowComplete}}
        as |m|
      >
        <m.Content class="popup" @keepMounted={{this.keepMounted}} as |c|>
          <div class="payload">Row {{c.state.payload}}</div>
          {{#each this.f.rowActions key="value" as |item|}}
            <m.Item
              class="item"
              @value={{item.value}}
              @onSelect={{this.onSelect item.value}}
            >
              {{item.label}}
            </m.Item>
          {{/each}}
        </m.Content>
      </Menu>

      <Popover @controller={{this.details}} @modal="trap-focus" as |pop|>
        <pop.Content class="popup" as |c|>
          <form method="dialog">
            <pop.Title class="title">Details</pop.Title>
            <p class="payload">Details for {{c.state.payload}}</p>
            <button value="save">Save</button>
            <button value="cancel">Cancel</button>
          </form>
        </pop.Content>
      </Popover>
      <button {{on "click" this.showButton}}>Show details</button>

      <Menu @onAction={{this.setAction}} as |m|>
        <m.ContextTrigger class="canvas">Canvas</m.ContextTrigger>
        <m.Content class="popup">
          {{#each this.f.canvasActions key="value" as |item|}}
            <m.Item class="item" @value={{item.value}}>{{item.label}}</m.Item>
          {{/each}}
        </m.Content>
      </Menu>

      <Menu
        @items={{this.menuData}}
        @onCheckedChange={{this.onChecked}}
        @onValueChange={{this.onValue}}
        as |m|
      >
        <m.Trigger>Data</m.Trigger>
        <m.Content class="popup">
          {{#each this.dataItems key="@index" as |entry|}}
            {{#if (this.isCheckbox entry)}}
              <m.CheckboxItem class="item" @value={{entry.value}} as |i|>
                <i.Indicator class="indicator">✓</i.Indicator>
                {{entry.label}}
              </m.CheckboxItem>
            {{else if (this.isRadioGroup entry)}}
              <m.RadioGroup @name={{entry.name}} as |r|>
                {{#each entry.items key="value" as |radio|}}
                  <r.Item class="item" @value={{radio.value}} as |i|>
                    <i.Indicator class="indicator">•</i.Indicator>
                    {{radio.label}}
                  </r.Item>
                {{/each}}
              </m.RadioGroup>
            {{/if}}
          {{/each}}
        </m.Content>
      </Menu>

      <Menu as |m|>
        <m.Trigger>View</m.Trigger>
        <m.Content class="popup">
          {{#each this.ruler key="@identity" as |value|}}
            <m.CheckboxItem class="item" @value={{value}} as |i|>
              <i.Indicator class="indicator">✓</i.Indicator>
              {{this.rulerLabel value}}
            </m.CheckboxItem>
          {{/each}}
        </m.Content>
      </Menu>

      <Tabs
        class="tabs"
        @controller={{this.sections}}
        @hiddenUntilFound={{true}}
        @onValueChange={{this.onTabChange}}
        as |t|
      >
        <t.List class="tablist scrolling" aria-label="Sections">
          {{#each this.f.sections key="@identity" as |section|}}
            <t.Tab class="tab" @value={{this.lower section}}>{{section}}</t.Tab>
          {{/each}}
        </t.List>
        {{#each this.f.sections key="@identity" as |section|}}
          <t.Panel class="panel" @value={{this.lower section}}>The
            {{section}}
            section</t.Panel>
        {{/each}}
      </Tabs>
      <button {{on "click" this.showLast}}>Show the last section</button>

      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output aria-label="Last result">{{this.result}}</output>
      <output aria-label="Last complete">{{this.complete}}</output>
      <output aria-label="Last change">{{this.change}}</output>
      <output aria-label="Tab changes">{{this.tabChanges}}</output>
    </div>
  </template>
}
