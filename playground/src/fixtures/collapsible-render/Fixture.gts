import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Collapsible } from "ember-ui-sdk/collapsible"

const sign = (open: boolean) => (open ? "−" : "+")
const stateClass = (open: boolean) => (open ? "is-open" : "is-closed")

export default class CollapsibleRenderFixture extends Component {
  @tracked action = ""

  onOpenChange = (open: boolean) => (this.action = open ? "open" : "closed")

  <template>
    <div class="fixture">
      <button>Before</button>
      <Collapsible
        class="collapsible"
        @onOpenChange={{this.onOpenChange}}
        as |c|
      >
        <span class={{stateClass c.state.open}} hidden></span>
        <c.Trigger @render={{true}} as |t|>
          <div {{t.part}} class="collapsible-trigger">
            Files<span aria-hidden="true"> {{sign t.state.open}}</span>
          </div>
        </c.Trigger>
        <c.Panel @render={{true}} as |p|>
          <section {{p.part}} class="collapsible-panel">The files panel.</section>
        </c.Panel>
      </Collapsible>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
