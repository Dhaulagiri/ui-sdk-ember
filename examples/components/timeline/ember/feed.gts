import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { on } from "@ember/modifier"
import { Timeline } from "ember-ui-sdk/timeline"
import { useLog } from "../../../shared/ember/log"

const updates = [
  {
    id: 1,
    author: "Ada",
    date: "2026-11-10",
    time: "Nov 10",
    text: "Shipped the new onboarding flow.",
  },
  {
    id: 2,
    author: "Grace",
    date: "2026-11-10",
    time: "Nov 10",
    text: "Fixed the flaky upload test.",
  },
  {
    id: 3,
    author: "Linus",
    date: "2026-11-09",
    time: "Nov 9",
    text: "Moved the docs to the new theme.",
  },
  {
    id: 4,
    author: "Margaret",
    date: "2026-11-09",
    time: "Nov 9",
    text: "Wrote the launch checklist.",
  },
  {
    id: 5,
    author: "Ada",
    date: "2026-11-08",
    time: "Nov 8",
    text: "Cut search latency in half.",
  },
  {
    id: 6,
    author: "Grace",
    date: "2026-11-07",
    time: "Nov 7",
    text: "Added keyboard shortcuts to the editor.",
  },
  {
    id: 7,
    author: "Linus",
    date: "2026-11-06",
    time: "Nov 6",
    text: "Cleaned up the old billing code.",
  },
  {
    id: 8,
    author: "Margaret",
    date: "2026-11-05",
    time: "Nov 5",
    text: "Ran the accessibility review.",
  },
  {
    id: 9,
    author: "Ada",
    date: "2026-11-04",
    time: "Nov 4",
    text: "Started the mobile layout.",
  },
]

const pageSize = 3

export default class Feed extends Component {
  log = useLog(this)
  updates = updates
  @tracked count = pageSize
  @tracked busy = false

  get visible() {
    return this.updates.slice(0, this.count)
  }

  get exhausted() {
    return this.count >= this.updates.length
  }

  get busyOrDone() {
    return this.busy || this.exhausted
  }

  get label() {
    return this.busy ? "Loading…" : "Load More"
  }

  loadMore = () => {
    this.busy = true
    setTimeout(() => {
      this.count += pageSize
      this.busy = false
      this.log(`Loaded ${pageSize} more updates`)
    }, 600)
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button
          type="button"
          disabled={{this.busyOrDone}}
          {{on "click" this.loadMore}}
        >
          {{this.label}}
        </button>
      </div>
      <Timeline
        @feed={{true}}
        @busy={{this.busy}}
        aria-label="Team updates"
        as |t|
      >
        {{#each this.visible key="id" as |update|}}
          <t.Item as |item|>
            <item.Marker />
            <item.Connector />
            <item.Title>{{update.author}}</item.Title>
            <item.Time datetime={{update.date}}>{{update.time}}</item.Time>
            <item.Description>{{update.text}}</item.Description>
          </t.Item>
        {{/each}}
      </Timeline>
    </div>
  </template>
}
