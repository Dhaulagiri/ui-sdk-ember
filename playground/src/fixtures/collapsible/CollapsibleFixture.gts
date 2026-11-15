import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { createCollapsibleController } from "@ui-sdk/core/collapsible"
import {
  Collapsible,
  CollapsiblePanel,
  CollapsibleTrigger,
} from "ember-ui-sdk/collapsible"
import { collapsibleFixture as fixture } from "tests/fixtures/collapsible.ts"
import { collapsibleOptions } from "tests/fixtures/page.ts"

export default class CollapsibleFixture extends Component {
  fixture = fixture
  controller = createCollapsibleController()
  options = collapsibleOptions()
  @tracked action = ""
  @tracked reason = ""
  @tracked source = ""
  @tracked complete = ""

  onOpenChange = (
    open: boolean,
    details: { reason: string; source: string; cancel: () => void }
  ) => {
    if (this.options.cancel === (open ? "open" : "close")) {
      return details.cancel()
    }
    this.action = open ? "open" : "closed"
    this.reason = details.reason
    this.source = details.source
  }

  onComplete = (open: boolean) => (this.complete = open ? "open" : "closed")
  close = () => this.controller.close()
  toggle = () => this.controller.toggle()

  <template>
    <div class="fixture">
      <button>Before</button>
      <Collapsible
        class="collapsible"
        @defaultOpen={{this.options.defaultOpen}}
        @disabled={{this.options.disabled}}
        @controller={{this.controller}}
        @onOpenChange={{this.onOpenChange}}
        @onOpenChangeComplete={{this.onComplete}}
        as |c|
      >
        <c.Trigger
          class="collapsible-trigger"
        >{{this.fixture.trigger}}</c.Trigger>
        <c.Panel
          class="collapsible-panel"
          @keepMounted={{this.options.keepMounted}}
          @hiddenUntilFound={{this.options.hiddenUntilFound}}
        >
          <p>{{this.fixture.content}}</p>
          <label>{{this.fixture.field}} <input /></label>
          <button {{on "click" this.close}}>{{this.fixture.close}}</button>
        </c.Panel>
      </Collapsible>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
      <output aria-label="Last reason">{{this.reason}}</output>
      <output aria-label="Last source">{{this.source}}</output>
      <output aria-label="Last completed">{{this.complete}}</output>
      <button {{on "click" this.toggle}}>{{this.fixture.controller}}</button>
    </div>
  </template>
}
