import { fn } from "@ember/helper"
import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { createAccordionController } from "@ui-sdk/core/accordion"
import { Accordion } from "ember-ui-sdk/accordion"
import { accordionFixture, describeValue } from "tests/fixtures/accordion.ts"
import { accordionOptions } from "tests/fixtures/page.ts"

const isDisabled = (disabled: boolean | undefined, enabled: boolean) =>
  !!disabled && !enabled

export default class AccordionFixture extends Component {
  fixture = accordionFixture
  controller = createAccordionController()
  options = accordionOptions()
  @tracked action = ""
  @tracked complete = ""
  @tracked warrantyEnabled = false

  onValueChange = (value: string[], details: { cancel: () => void }) => {
    const { cancel } = this.options
    if (
      cancel &&
      value.includes(cancel) &&
      !this.controller.getValue().includes(cancel)
    ) {
      return details.cancel()
    }
    this.action = describeValue(value)
  }

  onComplete = (item: string, open: boolean) =>
    (this.complete = `${item} ${open ? "open" : "closed"}`)
  closeItem = (value: string) => this.controller.close(value)
  showSupport = () => this.controller.open("support")
  toggleWarranty = () => (this.warrantyEnabled = !this.warrantyEnabled)

  <template>
    <div class="fixture">
      <button>Before</button>
      <Accordion
        class="accordion"
        @defaultValue={{this.options.defaultValue}}
        @multiple={{this.options.multiple}}
        @disabled={{this.options.disabled}}
        @keepMounted={{this.options.keepMounted}}
        @hiddenUntilFound={{this.options.hiddenUntilFound}}
        @collapsible={{this.options.collapsible}}
        @controller={{this.controller}}
        @onValueChange={{this.onValueChange}}
        as |a|
      >
        {{#each this.fixture.items key="value" as |item|}}
          <a.Item
            class="accordion-item"
            @value={{item.value}}
            @disabled={{isDisabled item.disabled this.warrantyEnabled}}
            @onOpenChangeComplete={{fn this.onComplete item.value}}
            as |i|
          >
            <i.Header class="accordion-header">
              <i.Trigger class="accordion-trigger">{{item.label}}</i.Trigger>
            </i.Header>
            <i.Panel class="accordion-panel">
              {{item.content}}
              {{#if item.field}}
                <label> {{item.field}} <input /></label>
              {{/if}}
              {{#if item.close}}
                <button
                  {{on "click" (fn this.closeItem item.value)}}
                >{{item.close}}</button>
              {{/if}}
            </i.Panel>
          </a.Item>
        {{/each}}
      </Accordion>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output aria-label="Last completed">{{this.complete}}</output>
      <button {{on "click" this.showSupport}}>Show support</button>
      <button {{on "click" this.toggleWarranty}}>Toggle warranty</button>
    </div>
  </template>
}
