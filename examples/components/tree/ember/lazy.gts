import Component from "@glimmer/component"
import { get } from "@ember/helper"
import { tracked } from "@glimmer/tracking"
import { ChevronRight, LoaderCircle, RotateCw } from "lucide"
import { Tree } from "ember-ui-sdk/tree"
import { icon } from "../../../shared/ember/icon"

const top = [
  { value: "users", label: "users", branch: true },
  { value: "orders", label: "orders", branch: true },
  { value: "archive", label: "archive", branch: true },
]

const announcement = ({ type, label }: { type: string; label: string }) =>
  (
    ({
      expanded: "Expanded",
      collapsed: "Collapsed",
      loading: `Loading ${label}`,
      "load-failed": `${label} didn't load. Try again.`,
    }) as Record<string, string>
  )[type]

type Node = { value: string; label: string; branch?: boolean }

class Nodes extends Component<{
  Args: {
    parts: Record<string, unknown>
    items: Node[]
    loaded: Record<string, Node[]>
  }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item @value={{item.value}} @branch={{item.branch}} as |i|>
        <i.Label>
          {{#if item.branch}}
            <i.Indicator as |s|>
              {{#if s.state.loading}}
                {{icon LoaderCircle}}
              {{else if s.state.failed}}
                {{icon RotateCw}}
              {{else}}
                {{icon ChevronRight}}
              {{/if}}
            </i.Indicator>
          {{/if}}
          {{item.label}}
        </i.Label>
        {{#let (get @loaded item.value) as |children|}}
          {{#if children}}
            <i.Group as |g|>
              <Nodes @parts={{g}} @items={{children}} @loaded={{@loaded}} />
            </i.Group>
          {{/if}}
        {{/let}}
      </@parts.Item>
    {{/each}}
  </template>
}

export default class Lazy extends Component {
  archiveAsked = false
  top = top
  @tracked loaded: Record<string, Node[]> = {}

  fetchChildren = async (value: string, signal: AbortSignal) => {
    await new Promise((resolve, reject) => {
      const timer = setTimeout(resolve, 800)
      signal.addEventListener(
        "abort",
        () => (clearTimeout(timer), reject(signal.reason))
      )
    })
    if (value === "archive" && !this.archiveAsked) {
      this.archiveAsked = true
      throw new Error("Network error")
    }
    return Array.from({ length: 3 }, (_, index) => ({
      value: `${value}/${index + 1}`,
      label: `${value.slice(0, -1)}_${index + 1}.json`,
    }))
  }

  loadChildren = async (value: string, { signal }: { signal: AbortSignal }) => {
    const children = await this.fetchChildren(value, signal)
    this.loaded = { ...this.loaded, [value]: children }
  }

  announcement = announcement

  <template>
    <Tree
      aria-label="Database"
      @loadChildren={{this.loadChildren}}
      @announcement={{this.announcement}}
      as |t|
    >
      <Nodes @parts={{t}} @items={{this.top}} @loaded={{this.loaded}} />
    </Tree>
  </template>
}
