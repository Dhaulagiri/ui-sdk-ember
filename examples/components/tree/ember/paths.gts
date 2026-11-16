import Component from "@glimmer/component"
import { array } from "@ember/helper"
import { ChevronRight, LoaderCircle } from "lucide"
import { Tree, treeFromPaths } from "ember-ui-sdk/tree"
import { icon } from "../../../shared/ember/icon"
import { useLog } from "../../../shared/ember/log"

const paths = [
  "src/index.ts",
  "src/lib/format.ts",
  "src/lib/parse.ts",
  "src/routes/home.tsx",
  "src/routes/about.tsx",
  "tests/",
  "package.json",
  "tsconfig.json",
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
        <i.Label as |l|>
          {{#if item.children}}
            <i.Indicator>{{icon ChevronRight}}</i.Indicator>
          {{/if}}
          <span>{{item.label}}</span>
          {{#if l.state.pending}}
            {{icon LoaderCircle}}
          {{/if}}
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

export default class Paths extends Component {
  log = useLog(this)
  items = treeFromPaths(paths)
  files = new Set(paths.filter((path) => !path.endsWith("/")))
  paths = paths

  onAction = async (value: string) => {
    if (!this.files.has(value)) {
      return
    }
    await new Promise((resolve) => setTimeout(resolve, 600))
    this.log(`Opened ${value}`)
  }

  <template>
    <Tree
      aria-label="Project"
      @paths={{this.paths}}
      @defaultExpanded={{array "src"}}
      @defaultValue="src/index.ts"
      @activation="automatic"
      @onAction={{this.onAction}}
      as |t|
    >
      <Nodes @parts={{t}} @items={{this.items}} />
    </Tree>
  </template>
}
