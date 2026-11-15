import { on } from "@ember/modifier"
import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { Timeline, createTimelineController } from "ember-ui-sdk/timeline"
import {
  advance,
  timelineFixture as f,
  timelineOptions,
  type TimelineFixtureEvent,
} from "tests/fixtures/timeline.ts"

export default class TimelineFixture extends Component {
  f = f
  options = timelineOptions()
  controller = createTimelineController()
  @tracked events: readonly TimelineFixtureEvent[] = f.events

  add = () => (this.events = [f.added, ...this.events])
  reverse = () => (this.events = [...this.events].reverse())
  focusCurrent = () => this.controller.focus("shipped")
  advance = () => (this.events = advance(this.events))

  <template>
    <div class="fixture">
      <button>Before</button>
      <Timeline
        class="timeline"
        aria-label={{this.f.label}}
        @controller={{this.controller}}
        @orientation={{this.options.orientation}}
        @loop={{this.options.loop}}
        @feed={{this.options.feed}}
        @busy={{this.options.busy}}
        as |t|
      >
        {{#each this.events key="value" as |event|}}
          <t.Item @value={{event.value}} @status={{event.status}} as |item|>
            <item.Marker />
            <item.Connector />
            <item.Title>{{event.title}}</item.Title>
            <item.Time datetime={{event.dateTime}}>{{event.time}}</item.Time>
            <item.Description>{{event.description}}</item.Description>
            {{#if event.link}}
              <a href={{event.link.href}}>{{event.link.label}}</a>
            {{/if}}
          </t.Item>
        {{/each}}
      </Timeline>
      <button>After</button>
      <button {{on "click" this.add}}>Add Event</button>
      <button {{on "click" this.reverse}}>Reverse</button>
      <button {{on "click" this.focusCurrent}}>Focus Current</button>
      <button {{on "click" this.advance}}>Advance</button>
    </div>
  </template>
}
