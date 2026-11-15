import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Accordion } from "ember-ui-sdk/accordion"
import { Autocomplete } from "ember-ui-sdk/autocomplete"
import { Collapsible } from "ember-ui-sdk/collapsible"
import { Combobox } from "ember-ui-sdk/combobox"
import { Dialog } from "ember-ui-sdk/dialog"
import { Drawer } from "ember-ui-sdk/drawer"
import { HoverCard } from "ember-ui-sdk/hover-card"
import { Menu } from "ember-ui-sdk/menu"
import { Popover } from "ember-ui-sdk/popover"
import { Resizable } from "ember-ui-sdk/resizable"
import { ScrollArea } from "ember-ui-sdk/scroll-area"
import { Select } from "ember-ui-sdk/select"
import { Slider } from "ember-ui-sdk/slider"
import { Tabs } from "ember-ui-sdk/tabs"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { Tree } from "ember-ui-sdk/tree"
import { Waterfall } from "ember-ui-sdk/waterfall"
import {
  leakComponent,
  leakTreeItems,
  leakWaterfallItems,
  perfItems,
} from "tests/fixtures/perf.ts"

export default class LeaksFixture extends Component {
  items = perfItems(3)
  lines = perfItems(30)
  component = leakComponent()
  treeItems = leakTreeItems()
  waterfallItems = leakWaterfallItems()
  @tracked mounted = true

  is = (name: string) => this.component === name
  toggle = () => (this.mounted = !this.mounted)

  <template>
    <div class="fixture">
      <button>Before</button>
      {{#if this.mounted}}
        {{#if (this.is "menu")}}
          <Menu as |m|>
            <m.Trigger>Open</m.Trigger>
            <m.Content class="popup">
              {{#each this.items key="value" as |item|}}
                <m.Item
                  class="item"
                  @value={{item.value}}
                >{{item.label}}</m.Item>
              {{/each}}
            </m.Content>
          </Menu>
        {{else if (this.is "select")}}
          <Select @defaultValue={{this.items.[0].value}} as |s|>
            <s.Trigger aria-label="Open" class="trigger">
              <s.Value />
            </s.Trigger>
            <s.Content class="popup list-popup">
              {{#each this.items key="value" as |item|}}
                <s.Item
                  class="item"
                  @value={{item.value}}
                  @label={{item.label}}
                >{{item.label}}</s.Item>
              {{/each}}
            </s.Content>
          </Select>
        {{else if (this.is "combobox")}}
          <Combobox as |c|>
            <c.Input aria-label="Open" class="input" />
            <c.Content class="popup list-popup">
              <c.List>
                {{#each this.items key="value" as |item|}}
                  <c.Item
                    class="item"
                    @value={{item.value}}
                    @label={{item.label}}
                  >{{item.label}}</c.Item>
                {{/each}}
              </c.List>
            </c.Content>
          </Combobox>
        {{else if (this.is "autocomplete")}}
          <Autocomplete as |a|>
            <a.Input aria-label="Open" class="input" />
            <a.Content class="popup list-popup">
              <a.List>
                {{#each this.items key="value" as |item|}}
                  <a.Item
                    class="item"
                    @value={{item.label}}
                  >{{item.label}}</a.Item>
                {{/each}}
              </a.List>
            </a.Content>
          </Autocomplete>
        {{else if (this.is "popover")}}
          <Popover as |p|>
            <p.Trigger>Open</p.Trigger>
            <p.Content class="popup" aria-label="Details">
              Details.
              <p.Close>Close</p.Close>
            </p.Content>
          </Popover>
        {{else if (this.is "dialog")}}
          <Dialog as |d|>
            <d.Trigger>Open</d.Trigger>
            <d.Content class="dialog">
              <d.Title class="title">Delete it?</d.Title>
              <d.Description class="description">This can't be undone.</d.Description>
              <d.Close>Cancel</d.Close>
            </d.Content>
          </Dialog>
        {{else if (this.is "drawer")}}
          <Drawer as |d|>
            <d.Trigger>Open</d.Trigger>
            <d.Backdrop class="backdrop" />
            <d.Content class="dialog">
              <d.Title class="title">Move goal</d.Title>
              <d.Description class="description">Set your daily goal.</d.Description>
              <d.Close>Cancel</d.Close>
            </d.Content>
          </Drawer>
        {{else if (this.is "hover-card")}}
          <HoverCard @delay={{0}} as |h|>
            <h.Trigger href="#profile">Open</h.Trigger>
            <h.Content class="hover-card-content">A profile.</h.Content>
          </HoverCard>
        {{else if (this.is "slider")}}
          <Slider @name="volume" @defaultValue={{50}} as |s|>
            <s.Control class="slider-control">
              <s.Track class="slider-track">
                <s.Indicator class="slider-indicator" />
                <s.Thumb class="slider-thumb" @ariaLabel="Volume" />
              </s.Track>
            </s.Control>
          </Slider>
        {{else if (this.is "accordion")}}
          <Accordion as |a|>
            <a.Item @value="first" as |i|>
              <i.Header>
                <i.Trigger class="accordion-trigger">Open</i.Trigger>
              </i.Header>
              <i.Panel class="accordion-panel">An answer.</i.Panel>
            </a.Item>
            <a.Item @value="second" as |i|>
              <i.Header>
                <i.Trigger class="accordion-trigger">Second</i.Trigger>
              </i.Header>
              <i.Panel class="accordion-panel">Another answer.</i.Panel>
            </a.Item>
          </Accordion>
        {{else if (this.is "collapsible")}}
          <Collapsible as |c|>
            <c.Trigger>Open</c.Trigger>
            <c.Panel class="collapsible-panel">Details.</c.Panel>
          </Collapsible>
        {{else if (this.is "tabs")}}
          <Tabs class="tabs" @defaultValue={{this.items.[0].value}} as |t|>
            <t.List class="tablist" aria-label="Pages">
              {{#each this.items key="value" as |item|}}
                <t.Tab class="tab" @value={{item.value}}>{{item.label}}</t.Tab>
              {{/each}}
              <t.Indicator class="indicator" />
            </t.List>
            {{#each this.items key="value" as |item|}}
              <t.Panel class="panel" @value={{item.value}}>{{item.label}}
                content.</t.Panel>
            {{/each}}
          </Tabs>
        {{else if (this.is "toolbar")}}
          <Toolbar class="toolbar" aria-label="Formatting" as |t|>
            {{#each this.items key="value" as |item|}}
              <t.Button>{{item.label}}</t.Button>
            {{/each}}
          </Toolbar>
        {{else if (this.is "tree")}}
          <Tree class="tree" aria-label="Files" @items={{this.treeItems}} />
        {{else if (this.is "waterfall")}}
          <Waterfall
            class="waterfall"
            aria-label="Trace"
            @items={{this.waterfallItems}}
          />
        {{else if (this.is "resizable")}}
          <Resizable class="resizable" as |r|>
            <r.Panel @id="first" @defaultSize={{50}} class="resizable-panel" />
            <r.Handle class="resizable-handle" aria-label="Handle" />
            <r.Panel @id="second" @defaultSize={{50}} class="resizable-panel" />
          </Resizable>
        {{else if (this.is "scroll-area")}}
          <ScrollArea class="scroll-area" @scrollHideDelay={{50}} as |s|>
            <s.Viewport
              class="scroll-area-viewport"
              role="region"
              aria-label="Items"
            >
              <s.Content>
                {{#each this.lines key="value" as |line|}}
                  <p class="scroll-area-item">{{line.label}}</p>
                {{/each}}
              </s.Content>
            </s.Viewport>
            <s.Scrollbar class="scroll-area-scrollbar" as |b|>
              <b.Thumb class="scroll-area-thumb" />
            </s.Scrollbar>
          </ScrollArea>
        {{else}}
          <Tooltip as |t|>
            <t.Trigger>Open</t.Trigger>
            <t.Content class="tooltip">A hint.</t.Content>
          </Tooltip>
        {{/if}}
      {{/if}}
      <button {{on "click" this.toggle}}>Toggle</button>
    </div>
  </template>
}
