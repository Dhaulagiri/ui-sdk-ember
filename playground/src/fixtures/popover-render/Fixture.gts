import { Popover } from "ember-ui-sdk/popover"

<template>
  <div class="fixture">
    <button>Before</button>
    <Popover as |p|>
      <p.Trigger @render={{true}} as |trigger|>
        <button
          class={{if trigger.state.open "is-open" "is-closed"}}
          {{trigger.part}}
        >
          Details
          <span aria-hidden="true">{{if trigger.state.open "▲" "▼"}}</span>
        </button>
      </p.Trigger>
      <p.Content class="popup">
        <p.Title @render={{true}} as |title|>
          <h3 {{title.part}}>Shipping</h3>
        </p.Title>
        <p.Close @render={{true}} as |close|>
          <a href="#done" {{close.part}}>Done</a>
        </p.Close>
      </p.Content>
    </Popover>
    <button>After</button>
  </div>
</template>
