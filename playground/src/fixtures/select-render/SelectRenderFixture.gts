import { Select } from "ember-ui-sdk/select"
import { selectFixture as f } from "tests/fixtures/select.ts"

const items = f.items.slice(0, 3)

<template>
  <div class="fixture">
    <button>Before</button>
    <Select @name={{f.name}} @placeholder={{f.placeholder}} as |s|>
      <s.Label class="label">{{f.label}}</s.Label>
      <s.Trigger @render={{true}} as |trigger|>
        <button
          class="trigger {{if trigger.state.open 'is-open' 'is-closed'}}"
          {{trigger.part}}
        >
          <trigger.Value />
          <span aria-hidden="true">{{if trigger.state.open "▲" "▼"}}</span>
        </button>
      </s.Trigger>
      <s.Content class="popup list-popup">
        <s.Item @value="docs" @render={{true}} as |item|>
          <a class="item" href="#docs" {{item.part}}>Docs</a>
        </s.Item>
        {{#each items key="value" as |item|}}
          <s.Item class="item" @value={{item.value}}>{{item.label}}</s.Item>
        {{/each}}
      </s.Content>
    </Select>
    <button>After</button>
  </div>
</template>
