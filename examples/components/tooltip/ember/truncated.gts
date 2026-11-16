import Component from "@glimmer/component"
import { File } from "lucide"
import { Tooltip } from "ember-ui-sdk/tooltip"
import { icon } from "../../../shared/ember/icon"

const files = [
  "Quarterly report, final revised version for the board.pdf",
  "Notes.txt",
  "Design review recording, October 2nd.mp4",
  "Budget.xlsx",
]

export default class Truncated extends Component {
  files = files

  fitsOnOpen = (
    open: boolean,
    details: { event?: Event; cancel: () => void }
  ) => {
    const row = (details.event?.target as Element | undefined)?.closest("li")
    const span = row?.querySelector("span:not([data-slot])") as
      HTMLSpanElement | null | undefined
    if (open && span && span.scrollWidth <= span.clientWidth) {
      details.cancel()
    }
  }

  <template>
    <ul>
      {{#each this.files key="@identity" as |file|}}
        <li>
          <Tooltip @type="label" @onOpenChange={{this.fitsOnOpen}} as |t|>
            <t.Trigger>
              {{icon File}}
              <span>{{file}}</span>
            </t.Trigger>
            <t.Content>{{file}}</t.Content>
          </Tooltip>
        </li>
      {{/each}}
    </ul>
  </template>
}
