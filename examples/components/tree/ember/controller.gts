import Component from "@glimmer/component"
import { on } from "@ember/modifier"
import { ChevronRight } from "lucide"
import { createTreeController, Tree } from "ember-ui-sdk/tree"
import { icon } from "../../../shared/ember/icon"

const sections = [
  {
    value: "account",
    label: "Account",
    children: [
      { value: "profile", label: "Profile" },
      {
        value: "security",
        label: "Security",
        children: [
          { value: "password", label: "Password" },
          { value: "two-factor", label: "Two-factor authentication" },
        ],
      },
    ],
  },
  {
    value: "workspace",
    label: "Workspace",
    children: [
      { value: "members", label: "Members" },
      { value: "billing", label: "Billing" },
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

export default class Controller extends Component {
  settings = createTreeController()
  sections = sections

  expandAll = () => {
    this.settings.expandAll()
  }

  collapseAll = () => {
    this.settings.collapseAll()
  }

  findTwoFactor = () => {
    this.settings.setValue("two-factor")
    this.settings.reveal("two-factor")
  }

  <template>
    <div data-slot="stack">
      <div data-slot="controls">
        <button type="button" {{on "click" this.expandAll}}>Expand All</button>
        <button type="button" {{on "click" this.collapseAll}}>Collapse All</button>
        <button type="button" {{on "click" this.findTwoFactor}}>
          Find Two-Factor
        </button>
      </div>
      <Tree
        aria-label="Settings"
        @items={{this.sections}}
        @controller={{this.settings}}
        as |t|
      >
        <Nodes @parts={{t}} @items={{this.sections}} />
      </Tree>
    </div>
  </template>
}
