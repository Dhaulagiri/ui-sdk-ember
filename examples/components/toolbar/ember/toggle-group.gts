import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { Toolbar } from "ember-ui-sdk/toolbar"
import { AlignCenter, AlignLeft, AlignRight, List, ListOrdered } from "lucide"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const alignments = [
  { value: "left", label: "Align left", icon: AlignLeft },
  { value: "center", label: "Align center", icon: AlignCenter },
  { value: "right", label: "Align right", icon: AlignRight },
]

const lists = [
  { value: "bulleted", label: "Bulleted list", icon: List },
  { value: "numbered", label: "Numbered list", icon: ListOrdered },
]

export default class ToggleGroupExample extends Component {
  log = useLog(this)

  onAlign = (values: string[]) => {
    this.log(`Align ${values[0]}`)
  }

  onList = (values: string[]) => {
    this.log(lists.find((list) => list.value === values[0])?.label ?? "No list")
  }

  <template>
    <Toolbar aria-label="Paragraph" as |t|>
      <t.ToggleGroup
        @defaultValue={{array "left"}}
        @deselectable={{false}}
        @onValueChange={{this.onAlign}}
        aria-label="Alignment"
        as |g|
      >
        {{#each alignments key="value" as |item|}}
          <g.Toggle @value={{item.value}} aria-label={{item.label}} as |p|>
            <p.Icon>{{icon item.icon}}</p.Icon>
          </g.Toggle>
        {{/each}}
      </t.ToggleGroup>
      <t.Separator />
      <t.ToggleGroup @onValueChange={{this.onList}} aria-label="List" as |g|>
        {{#each lists key="value" as |item|}}
          <g.Toggle @value={{item.value}} aria-label={{item.label}} as |p|>
            <p.Icon>{{icon item.icon}}</p.Icon>
          </g.Toggle>
        {{/each}}
      </t.ToggleGroup>
    </Toolbar>
  </template>
}
