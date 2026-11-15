import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { HoverCard } from "ember-ui-sdk/hover-card"
import {
  hoverCardContentOptions,
  hoverCardFixture,
  hoverCardOptions,
} from "tests/fixtures/hover-card.ts"

export default class HoverCardFixture extends Component {
  options = hoverCardOptions()
  content = hoverCardContentOptions()
  fixture = hoverCardFixture
  @tracked action = ""

  report = (open: boolean, { reason }: { reason: string }) => {
    this.action = `${open ? "open" : "close"}: ${reason}`
  }

  <template>
    <div class="fixture">
      <button>Before</button>
      <HoverCard
        @delay={{this.options.delay}}
        @closeDelay={{this.options.closeDelay}}
        @defaultOpen={{this.options.defaultOpen}}
        @container={{this.options.container}}
        @onOpenChange={{this.report}}
        as |h|
      >
        <h.Trigger
          href={{this.fixture.href}}
        >{{this.fixture.trigger}}</h.Trigger>
        <h.Content
          class="hover-card"
          @side={{this.content.side}}
          @align={{this.content.align}}
        >
          <h.Arrow class="arrow" />
          <p>
            <strong>{{this.fixture.name}}</strong>
          </p>
          <p>{{this.fixture.bio}}</p>
          <a href={{this.fixture.linkHref}}>{{this.fixture.link}}</a>
        </h.Content>
      </HoverCard>
      <button>After</button>
      <output role="status" aria-label="Last action">{{this.action}}</output>
    </div>
  </template>
}
