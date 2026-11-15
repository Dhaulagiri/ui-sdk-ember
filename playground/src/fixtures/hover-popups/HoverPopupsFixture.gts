import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { HoverCard } from "ember-ui-sdk/hover-card"
import { Popover } from "ember-ui-sdk/popover"
import { Tooltip } from "ember-ui-sdk/tooltip"
import {
  describeChange,
  hoverPopupsFixture as fixture,
} from "tests/fixtures/hover-popups.ts"

export default class HoverPopupsFixture extends Component {
  fixture = fixture
  @tracked change = ""

  opened = (component: string, open: boolean, { event }: { event?: Event }) => {
    if (open) {
      this.change = describeChange(component, "open", event)
    }
  }

  payloadChanged = (
    component: string,
    payload: unknown,
    { event }: { event?: Event }
  ) => {
    this.change = describeChange(component, `payload ${payload}`, event)
  }

  tooltipOpen = (open: boolean, details: { event?: Event }) =>
    this.opened("tooltip", open, details)
  tooltipPayload = (payload: unknown, details: { event?: Event }) =>
    this.payloadChanged("tooltip", payload, details)
  cardOpen = (open: boolean, details: { event?: Event }) =>
    this.opened("hover card", open, details)
  cardPayload = (payload: unknown, details: { event?: Event }) =>
    this.payloadChanged("hover card", payload, details)
  popoverOpen = (open: boolean, details: { event?: Event }) =>
    this.opened("popover", open, details)

  lower = (value: string) => value.toLowerCase()
  hash = (person: string) => `#${person}`

  <template>
    <div class="fixture">
      <button>Before</button>
      <Tooltip
        @delay={{0}}
        @onOpenChange={{this.tooltipOpen}}
        @onPayloadChange={{this.tooltipPayload}}
        as |t|
      >
        {{#each this.fixture.days key="@identity" as |day|}}
          <t.Trigger @payload={{this.lower day}}>{{day}}</t.Trigger>
        {{/each}}
        <t.Content class="tooltip" as |c|>Tip for
          {{c.state.payload}}</t.Content>
      </Tooltip>
      <HoverCard
        @delay={{0}}
        @closeDelay={{0}}
        @onOpenChange={{this.cardOpen}}
        @onPayloadChange={{this.cardPayload}}
        as |h|
      >
        {{#each this.fixture.people key="@identity" as |person|}}
          <h.Trigger
            href={{this.hash person}}
            @payload={{this.lower person}}
          >{{person}}</h.Trigger>
        {{/each}}
        <h.Content class="hover-card" as |c|>Card for
          {{c.state.payload}}</h.Content>
      </HoverCard>
      <Popover
        @openOnHover={{true}}
        @delay={{0}}
        @closeDelay={{0}}
        @onOpenChange={{this.popoverOpen}}
        as |p|
      >
        <p.Trigger>{{this.fixture.popover.trigger}}</p.Trigger>
        <p.Content class="popup">{{this.fixture.popover.content}}</p.Content>
      </Popover>
      <output role="status" aria-label="Last change">{{this.change}}</output>
    </div>
  </template>
}
