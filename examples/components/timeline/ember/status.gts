import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { Check } from "lucide"
import {
  createTimelineController,
  Timeline,
  TimelineItem,
} from "ember-ui-sdk/timeline"
import { icon } from "../../../shared/ember/icon"

const steps = [
  {
    value: "placed",
    title: "Order placed",
    dateTime: "2026-11-01",
    time: "Nov 1",
    description: "We received your order.",
    status: "complete",
    done: true,
  },
  {
    value: "packed",
    title: "Packed",
    dateTime: "2026-11-02",
    time: "Nov 2",
    description: "Your items left the shelf.",
    status: "complete",
    done: true,
  },
  {
    value: "shipped",
    title: "Shipped",
    dateTime: "2026-11-03",
    time: "Nov 3",
    description: "On its way with the carrier.",
    status: "current",
    done: false,
  },
  {
    value: "delivered",
    title: "Delivered",
    dateTime: "2026-11-05",
    time: "Nov 5",
    description: "Expected by Thursday.",
    status: "upcoming",
    done: false,
  },
]

export default class Status extends Component {
  steps = steps
  controller = createTimelineController()

  goToCurrent = () => {
    this.controller.focus("shipped")
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.goToCurrent}}>Go to Current Step</button>
      </div>
      <Timeline
        aria-label="Order status"
        @controller={{this.controller}}
        as |t|
      >
        {{#each this.steps key="value" as |step|}}
          <t.Item @value={{step.value}} @status={{step.status}} as |item|>
            <item.Marker>
              {{#if step.done}}
                {{icon Check}}
              {{/if}}
            </item.Marker>
            <item.Connector />
            <item.Title>{{step.title}}</item.Title>
            <item.Time datetime={{step.dateTime}}>{{step.time}}</item.Time>
            <item.Description>{{step.description}}</item.Description>
          </t.Item>
        {{/each}}
      </Timeline>
    </div>
  </template>
}
