import Component from "@glimmer/component"
import { tracked } from "@glimmer/tracking"
import { ChevronRight } from "lucide"
import { Tree } from "ember-ui-sdk/tree"
import { icon } from "../../../shared/ember/icon"

const pages = [
  {
    value: "getting-started",
    label: "Getting started",
    children: [
      { value: "introduction", label: "Introduction", href: "#introduction" },
      { value: "installation", label: "Installation", href: "#installation" },
    ],
  },
  {
    value: "components",
    label: "Components",
    children: [
      { value: "accordion", label: "Accordion", href: "#accordion" },
      { value: "dialog", label: "Dialog", href: "#dialog" },
      { value: "tree", label: "Tree", href: "#tree" },
    ],
  },
  { value: "changelog", label: "Changelog", href: "#changelog" },
]

const links = new Set(
  pages
    .flatMap((page) => [page, ...(page.children ?? [])])
    .filter((page) => page.href)
    .map((page) => page.value)
)

type Node = {
  value: string
  label: string
  children?: Node[]
  href?: string
}

class Nodes extends Component<{
  Args: { parts: Record<string, unknown>; items: Node[] }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} as |i|>
        {{#if item.href}}
          <i.Label @render={{true}} as |l|>
            <a href={{item.href}} {{l.part}}>{{item.label}}</a>
          </i.Label>
        {{else}}
          <i.Label>
            {{#if item.children}}
              <i.Indicator>{{icon ChevronRight}}</i.Indicator>
            {{/if}}
            {{item.label}}
          </i.Label>
        {{/if}}
        {{#if item.children}}
          <i.Group as |g|>
            <Nodes @parts={{g}} @items={{item.children}} />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class Links extends Component {
  pages = pages
  @tracked current = "tree"

  onAction = (value: string, { event }: { event?: Event }) => {
    if (!links.has(value)) {
      return
    }
    event?.preventDefault()
    this.current = value
  }

  <template>
    <Tree
      aria-label="Docs"
      @items={{this.pages}}
      @mode="none"
      @current={{this.current}}
      @onAction={{this.onAction}}
      as |t|
    >
      <Nodes @parts={{t}} @items={{this.pages}} />
    </Tree>
  </template>
}
