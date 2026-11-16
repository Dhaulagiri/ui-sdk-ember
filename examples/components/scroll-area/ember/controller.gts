import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { tracked } from "@glimmer/tracking"
import {
  ScrollArea,
  createScrollAreaController,
} from "ember-ui-sdk/scroll-area"
import { useLog } from "../../../shared/ember/log"

const tags = Array.from(
  { length: 50 },
  (_, index) => `v1.2.0-beta.${50 - index}`
)

export default class Controller extends Component {
  log = useLog(this)
  controller = createScrollAreaController()
  @tracked edge: string | null = "start"

  toStart = () => this.controller.scrollToStart({ behavior: "smooth" })
  toEnd = () => this.controller.scrollToEnd({ behavior: "instant" })

  read = () => {
    const next = this.controller.isAtEnd()
      ? "end"
      : this.controller.isAtStart()
        ? "start"
        : null
    if (next && next !== this.edge) {
      this.log(`At the ${next}`)
    }
    this.edge = next
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.toStart}}>Back to Top</button>
        <button type="button" {{on "click" this.toEnd}}>Jump to the End</button>
      </div>
      <ScrollArea @controller={{this.controller}} as |s|>
        <s.Viewport role="region" aria-label="Tags" {{on "scroll" this.read}}>
          <s.Content>
            <h3>Tags</h3>
            <ul>
              {{#each tags as |tag|}}
                <li>{{tag}}</li>
              {{/each}}
            </ul>
          </s.Content>
        </s.Viewport>
        <s.Scrollbar as |sb|>
          <sb.Thumb />
        </s.Scrollbar>
      </ScrollArea>
    </div>
  </template>
}
