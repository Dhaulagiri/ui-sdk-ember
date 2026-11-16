import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { ChevronRight } from "lucide"
import { Tree } from "ember-ui-sdk/tree"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const items = [
  {
    value: "inbox",
    label: "Inbox",
    children: [
      { value: "updates", label: "Updates" },
      { value: "forums", label: "Forums" },
      { value: "promotions", label: "Promotions" },
    ],
  },
  {
    value: "projects",
    label: "Projects",
    children: [
      { value: "website", label: "Website" },
      { value: "mobile", label: "Mobile app" },
    ],
  },
  { value: "archive", label: "Archive" },
  { value: "trash", label: "Trash" },
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

export default class Multiple extends Component {
  log = useLog(this)
  items = items

  onValueChange = (value: string[]) => {
    this.log(`${value.length} selected: ${value.join(", ")}`)
  }

  <template>
    <Tree
      aria-label="Folders"
      @items={{this.items}}
      @mode="multiple"
      @defaultValue={{array "updates" "website"}}
      @onValueChange={{this.onValueChange}}
      @expandOnPress={{false}}
      @defaultExpanded={{array "inbox" "projects"}}
      as |t|
    >
      <Nodes @parts={{t}} @items={{this.items}} />
    </Tree>
  </template>
}
