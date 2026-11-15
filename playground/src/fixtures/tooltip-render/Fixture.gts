import { Tooltip } from "ember-ui-sdk/tooltip"

<template>
  <div class="fixture tooltip-page">
    <button>Before</button>
    <Tooltip @delay={{100}} as |t|>
      <t.Trigger @render={{true}} as |trigger|>
        <a href="#docs" {{trigger.part}}>Docs</a>
      </t.Trigger>
      <t.Content class="tooltip">Read the docs</t.Content>
    </Tooltip>
    <Tooltip @delay={{100}} as |t|>
      <t.Trigger @render={{true}} as |trigger|>
        <button
          class={{if trigger.state.open "is-open" "is-closed"}}
          {{trigger.part}}
        >
          Status
          <span aria-hidden="true">{{if trigger.state.open "●" "○"}}</span>
        </button>
      </t.Trigger>
      <t.Content @render={{true}} as |content|>
        <div
          class={{if content.state.open "tooltip is-open" "tooltip"}}
          {{content.part}}
        >
          All systems normal
        </div>
      </t.Content>
    </Tooltip>
    <button>After</button>
  </div>
</template>
