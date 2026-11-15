import { array } from "@ember/helper"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Accordion } from "ember-ui-sdk/accordion"
import { describeValue } from "tests/fixtures/accordion.ts"

const sign = (open: boolean) => (open ? "−" : "+")
const stateClass = (open: boolean) => (open ? "is-open" : "is-closed")

export default class AccordionRenderFixture extends Component {
  @tracked action = ""

  onValueChange = (value: string[]) => (this.action = describeValue(value))

  <template>
    <div class="fixture">
      <button>Before</button>
      <Accordion
        class="accordion"
        @defaultValue={{array "overview"}}
        @onValueChange={{this.onValueChange}}
        as |a|
      >
        <a.Item class="accordion-item" @value="overview" as |i|>
          <span class={{stateClass i.state.open}} hidden></span>
          <i.Header @render={{true}} as |h|>
            <h2 {{h.part}} class="accordion-header">
              <i.Trigger @render={{true}} as |t|>
                <button {{t.part}} class="accordion-trigger">
                  Overview<span aria-hidden="true"> {{sign t.state.open}}</span>
                  <span class="index" hidden>{{t.state.index}}</span>
                </button>
              </i.Trigger>
            </h2>
          </i.Header>
          <i.Panel @render={{true}} as |p|>
            <section {{p.part}} class="accordion-panel">The overview panel.</section>
          </i.Panel>
        </a.Item>
        <a.Item class="accordion-item" @value="details" as |i|>
          <i.Header class="accordion-header">
            <i.Trigger @render={{true}} as |t|>
              <div {{t.part}} class="accordion-trigger">Details</div>
            </i.Trigger>
          </i.Header>
          <i.Panel class="accordion-panel">The details panel.</i.Panel>
        </a.Item>
      </Accordion>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
