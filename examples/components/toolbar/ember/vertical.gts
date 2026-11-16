import Component from "@glimmer/component"
import { array, fn } from "@ember/helper"
import { on } from "@ember/modifier"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { MousePointer2, Pencil, Square, Trash2, Type } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const tools = [
  { value: "select", label: "Select", icon: MousePointer2 },
  { value: "draw", label: "Draw", icon: Pencil },
  { value: "shape", label: "Shape", icon: Square },
  { value: "text", label: "Text", icon: Type },
]

export default class Vertical extends Component {
  log = useLog(this)

  onTool = (values: string[]) => {
    this.log(`${tools.find((tool) => tool.value === values[0])?.label} tool`)
  }

  <template>
    <Toolbar @orientation="vertical" aria-label="Canvas" as |t|>
      <t.ToggleGroup
        @defaultValue={{array "select"}}
        @deselectable={{false}}
        @orientation="vertical"
        @onValueChange={{this.onTool}}
        aria-label="Tool"
        as |g|
      >
        {{#each tools key="value" as |item|}}
          <g.Toggle @value={{item.value}} aria-label={{item.label}} as |p|>
            <p.Icon>{{icon item.icon}}</p.Icon>
          </g.Toggle>
        {{/each}}
      </t.ToggleGroup>
      <t.Separator />
      <t.Button
        aria-label="Delete"
        {{on "click" (fn this.log "Deleted selection")}}
      >{{icon Trash2}}</t.Button>
    </Toolbar>
  </template>
}
