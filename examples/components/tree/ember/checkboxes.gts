import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { ChevronRight } from "lucide"
import { Tree } from "ember-ui-sdk/tree"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const items = [
  {
    value: "frontend",
    label: "Frontend",
    children: [
      { value: "react", label: "React" },
      { value: "vue", label: "Vue" },
      { value: "svelte", label: "Svelte" },
    ],
  },
  {
    value: "backend",
    label: "Backend",
    children: [
      { value: "node", label: "Node" },
      {
        value: "databases",
        label: "Databases",
        children: [
          { value: "postgres", label: "Postgres" },
          { value: "sqlite", label: "SQLite" },
        ],
      },
    ],
  },
]

type Node = {
  value: string
  label: string
  children?: Node[]
}

class Nodes extends Component<{
  Args: { parts: Record<string, unknown>; items: Node[] }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} as |i|>
        <i.Label>
          {{#if item.children}}
            <i.Indicator>{{icon ChevronRight}}</i.Indicator>
          {{/if}}
          <i.Checkbox />
          {{item.label}}
        </i.Label>
        {{#if item.children}}
          <i.Group as |g|>
            <Nodes @parts={{g}} @items={{item.children}} />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class Checkboxes extends Component {
  log = useLog(this)
  items = items

  onCheckedChange = (checked: string[]) => {
    this.log(`Checked ${checked.join(", ") || "nothing"}`)
  }

  <template>
    <Tree
      aria-label="Stack"
      @items={{this.items}}
      @checkable={{true}}
      @mode="none"
      @checkStrategy="trunk"
      @defaultChecked={{array "react" "postgres"}}
      @onCheckedChange={{this.onCheckedChange}}
      @defaultExpanded={{array "frontend" "backend" "databases"}}
      as |t|
    >
      <Nodes @parts={{t}} @items={{this.items}} />
    </Tree>
  </template>
}
