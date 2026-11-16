import Component from "@glimmer/component"
import { Bold, Italic, Underline } from "lucide"
import {
  Tooltip,
  TooltipTrigger,
  createTooltipController,
} from "ember-ui-sdk/tooltip"
import { icon } from "../../../shared/ember/icon"

const formats = [
  { icon: Bold, label: "Bold" },
  { icon: Italic, label: "Italic" },
  { icon: Underline, label: "Underline" },
]

export default class Shared extends Component {
  formats = formats
  tooltip = createTooltipController<string>()

  <template>
    <div data-slot="row" role="group" aria-label="Formatting">
      {{#each this.formats key="label" as |format|}}
        <TooltipTrigger
          @controller={{this.tooltip}}
          @payload={{format.label}}
          aria-label={{format.label}}
        >
          {{icon format.icon}}
        </TooltipTrigger>
      {{/each}}
      <Tooltip @controller={{this.tooltip}} as |t|>
        <t.Content as |c|>{{c.state.payload}}</t.Content>
      </Tooltip>
    </div>
  </template>
}
