import Component from "@glimmer/component"
import type { TreeFixtureItem } from "tests/fixtures/tree.ts"

type Parts = Record<string, unknown>

export default class TreeFixtureItems extends Component<{
  Args: { parts: Parts; items: TreeFixtureItem[]; checkable: boolean }
}> {
  <template>
    {{#each @items key="value" as |item|}}
      <@parts.Item
        class="tree-item"
        @value={{item.value}}
        @disabled={{item.disabled}}
        as |i|
      >
        {{#if item.children}}<i.Indicator
            class="tree-indicator"
          >▸</i.Indicator>{{/if}}
        {{#if @checkable}}<i.Checkbox class="tree-checkbox" />{{/if}}
        {{#if item.href}}
          <i.Label @render={{true}} as |l|><a
              class="tree-label"
              href={{item.href}}
              {{l.part}}
            >{{item.label}}</a></i.Label>
        {{else}}
          <i.Label class="tree-label">{{item.label}}</i.Label>
        {{/if}}
        {{#if item.children}}
          <i.Group class="tree-group" as |g|>
            <TreeFixtureItems
              @parts={{g}}
              @items={{item.children}}
              @checkable={{@checkable}}
            />
          </i.Group>
        {{/if}}
      </@parts.Item>
    {{/each}}
  </template>
}
